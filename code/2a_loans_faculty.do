// make sure to run runme.do to generate global paths before running this script

cd $data
use loans_merged.dta, clear

//save years and types for looping
levelsof year_loaned, local(years)

//book-year-type matrix (balanced panel of unique bookid_borrowertypes)
//this collapse and reshape pipeline will get us:
//a matrix with each unique book for each year 03-11
collapse (count) year_loaned, by(bib_doc_id)
local c = 1
foreach y in `years' {
	gen t`y' = `c'
	local c = t`y' + 1
}
// get rid of useless "count" summary, (we only want the unique book ids from this collapse)
keep t* bib_doc_id
//after this reshape, now you have a balanced panel of unique bookids
reshape long t, i(bib_doc_id) j(year_loaned)

//gen the groups you want to look at
//call them "type" for merging later
gen _faculty = 1
gen _nonfaculty = 2
//after this reshape, now you have a balance panel of unique "bookid/borrowertype" panel units
reshape long _, i(bib_doc_id year_loaned t) j(type, string) 
drop _

//put it in the fridge
save unique_faculty.dta, replace

//start fresh
use loans_merged.dta, clear

//gen "type" to distinguish between types of borrowers
//as you defined in the unique_[TYPES].dta
gen type = "faculty" if borrower_status == 1
replace type = "nonfaculty" if type == ""

//merging the raw data back onto the book-year matrix
merge m:1 year_loaned bib_doc_id type using unique_faculty.dta

// gen a loans variable to sum up by book-year
gen loans = 1 if date_loaned != ""
replace loans = 0 if loans == .

// sum by book-year to obtain number of loans for each book in each year
// we also want to preserve location and year scanned
collapse (sum) loans (firstnm) location (firstnm) year_scanned, by(bib_doc_id year_loaned t type)

// this loop sets year_scanned and location equal within each xsectional unit
// for this method to produce accurate results, it must be that:
// location and year_scanned do not change over time with xsectional units
// almost certainly true for year_scanned
// but perhaps books move location?
	// perhaps requires a double check from colleagues 
sort bib_doc_id type t
forvalues i = 1/9 {
	replace year_scanned = year_scanned[_n+1] if year_scanned ==. & t[_n+1] != 1
	replace year_scanned = year_scanned[_n-1] if year_scanned ==. & t[_n-1] != 9
	replace location = location[_n+1] if location =="" & t[_n+1] != 1
	replace location = location[_n-1] if location =="" & t[_n-1] != 9
}

// some obs are missing location
// this adds a none category to avoid issues with xtreg
replace location = "none" if location ==""

// gen a scanned variable where units are scanned after year_scanned
gen scanned = 1 if year_scanned < year_loaned
replace scanned = 0 if scanned ==.

tostring year_scanned, replace
replace year_scanned = "never_treated" if year_scanned == "."
replace year_scanned = "treated_" + year_scanned if year_scanned != "never_treated"

order t bib_doc_id type loans location year_loaned

cd "$panel_data"
save faculty.dta, replace 
cd "$code"
