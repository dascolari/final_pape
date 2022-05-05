// make sure to run runme.do to generate global paths before running this script

cd $data
use loans_merged.dta, clear

//save years and types for looping
levelsof year_loaned, local(years)

//book-year matrix
//this collapse and reshape pipeline will get us:
//a matrix with each unique book for each year 03-11
collapse (count) year_loaned, by(bib_doc_id)
local c = 1

foreach y in `years' {
	gen t`y' = `c'
	local c = t`y' + 1
}
keep t* bib_doc_id
reshape long t, i(bib_doc_id) j(year_loaned)
gen _faculty = 1
gen _nonfaculty = 2
reshape long _, i(bib_doc_id year_loaned t) j(type, string) 
drop _

save unique_faculty.dta, replace

use loans_merged.dta, clear
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
drop year_scanned
order t bib_doc_id type loans location year_loaned

// gen outcomes: 
// 0 inflated log loans = ln(loans+1) and... 
// loaned/not-loaned binary
gen loginfl_loans = ln(loans+1)
gen loaned = 1 if loans !=0
replace loaned = 0 if loaned ==.

gen faculty = 1 if type == "faculty"
replace faculty = 0 if faculty ==.
gen facultyXscanned = faculty*scanned

// set up panel for TWFE by:
// book and...
// year-location
egen year_loc = group(t location)
egen year_borrower = group(t type)

// egen book_borrower = group(bib_doc_id type)
// xtset book_borrower t

// clear estimates storage
eststo clear

// this might be the same as twfe where the panel units are book_borrower
// xtreg loginfl_loans faculty scanned facultyXscanned i.year_loc, r
eststo: reg loginfl_loans scanned faculty facultyXscanned i.year_loc c.bib_doc_id, r
estadd local book_fe "Yes"
estadd local yearloc_fe "Yes"

cd $code
