// make sure to run runme.do to generate global paths before running this script

cd "$data"
use loans_merged.dta, clear

//save years for looping
levelsof year_loaned, local(years)

//book-year matrix
//this collapse and reshape pipeline will get us:
//a matrix with each unique book for each year 2003-2011
collapse (count) year_loaned, by(bib_doc_id)
local c = 1
foreach y in `years' {
	gen t`y' = `c'
	local c = t`y' + 1
}
keep t* bib_doc_id
reshape long t, i(bib_doc_id) j(year_loaned)

save unique_base.dta, replace

// merging the raw data back onto the book-year matrix
// the result will be the same as the original raw data with...
// the addition of "empty" loan evens so that...
// every unique book is considered in each year, even if not loaned
merge 1:m year_loaned bib_doc_id using loans_merged.dta
sort t year_loaned bib_doc_id

// gen a loans variable to sum up by book-year
gen loans = 1 if date_loaned != ""
replace loans = 0 if loans == .

// sum by book-year to obtain number of loans for each book in each year
// we also want to preserve location and year scanned
collapse (sum) loans (firstnm) location (firstnm) year_scanned, by(bib_doc_id year_loaned t)

// this loop sets year_scanned and location equal within each xsectional unit
// for this method to produce accurate results, it must be that:
// location and year_scanned do not change over time with xsectional units
// almost certainly true for year_scanned
// but perhaps books move location?
	// perhaps requires a double check
forvalues i = 1/9 {
	replace year_scanned = year_scanned[_n+1] if year_scanned ==. & t[_n+1] != 1
	replace year_scanned = year_scanned[_n-1] if year_scanned ==. & t[_n-1] != 9
	replace location = location[_n+1] if location =="" & t[_n+1] != 1
	replace location = location[_n-1] if location =="" & t[_n-1] != 9
}

// some data is missing location
// this adds a none category to avoid issues with xtreg
replace location = "none" if location ==""

// gen a scanned variable where units are scanned after year_scanned
gen scanned = 1 if year_scanned < year_loaned
replace scanned = 0 if scanned ==.
drop year_scanned
order t bib_doc_id loans location year_loaned

cd "$panel_data"
save base.dta, replace 
cd "$code"
