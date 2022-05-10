// make sure to run runme.do to generate global paths before running this script

cd "$panel_data"

use base.dta, clear

// gen outcomes: 
// 0 inflated log loans = ln(loans+1) and... 
// loaned/not-loaned binary
gen loginfl_loans = ln(loans+1)
gen loaned = 1 if loans !=0
replace loaned = 0 if loaned ==.

// set up panel for TWFE by:
// book and...
// year-location
egen year_loc = group(t location)
xtset bib_doc_id t

// clear estimates storage
eststo clear

// log-OLS TWFE w/ yearloc fe specification 
eststo: xtreg loginfl_loans scanned i.year_loc, fe vce(r)
estadd local book_fe "Yes"
estadd local yearloc_fe "Yes"

// log-OLS TWFE NO yearloc fe specification 
eststo: xtreg loginfl_loans scanned, fe vce(r)
estadd local book_fe "Yes"
estadd local yearloc_fe "No"

// LPM TWFE w/ yearloc fe fespecification
eststo: xtreg loaned scanned i.year_loc, fe vce(r)
estadd local book_fe "Yes"
estadd local yearloc_fe "Yes"

// LPM TWFE NO yearloc fe fespecification
eststo: xtreg loaned scanned, fe vce(r)
estadd local book_fe "Yes"
estadd local yearloc_fe "No"

cd "$tables"
esttab using table_5.tex, replace ///
	se obslast ///
	keep(scanned) ///
	coeflabels(scanned "Post-Scanned") ///
	mtitles("log-OLS" "log-OLS" "LPM" "LPM") ///
	scalars("book_fe Book FE" "yearloc_fe Year-Location FE")
cd "$code"
