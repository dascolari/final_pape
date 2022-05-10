// make sure to run runme.do to generate global paths before running this script

cd "$panel_data"
use faculty.dta, clear

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

cd "$panel_data"
use students.dta, clear

// gen outcomes: 
// 0 inflated log loans = ln(loans+1) and... 
// loaned/not-loaned binary
gen loginfl_loans = ln(loans+1)
gen loaned = 1 if loans !=0
replace loaned = 0 if loaned ==.

gen master = 1 if type == "master"
replace master = 0 if master ==.
gen doctor = 1 if type == "doctor"
replace doctor = 0 if doctor ==.
gen masterXscanned = master*scanned
gen doctorXscanned = doctor*scanned

// set up panel for TWFE by:
// book and...
// year-location
egen year_loc = group(t location)
egen year_borrower = group(t type)

// egen book_borrower = group(bib_doc_id type)
// xtset book_borrower t

// this might be the same as twfe where the panel units are book_borrower
// xtreg loginfl_loans faculty scanned facultyXscanned i.year_loc, r
eststo: reg loginfl_loans scanned doctor master doctorXscanned masterXscanned i.year_loc c.bib_doc_id, r
estadd local book_fe "Yes"
estadd local yearloc_fe "Yes"

cd "$panel_data"
use inbuilding.dta, clear

// gen outcomes: 
// 0 inflated log loans = ln(loans+1) and... 
// loaned/not-loaned binary
gen loginfl_loans = ln(loans+1)
gen loaned = 1 if loans !=0
replace loaned = 0 if loaned ==.

gen inbuilding = 1 if type == "inbuilding"
replace inbuilding = 0 if inbuilding ==.
gen inbuildingXscanned = inbuilding*scanned

// set up panel for TWFE by:
// book and...
// year-location
egen year_loc = group(t location)
egen year_borrower = group(t type)

// egen book_borrower = group(bib_doc_id type)
// xtset book_borrower t

// this might be the same as twfe where the panel units are book_borrower
// xtreg loginfl_loans faculty scanned facultyXscanned i.year_loc, r
eststo: reg loginfl_loans scanned inbuilding inbuildingXscanned i.year_loc c.bib_doc_id, r
estadd local book_fe "Yes"
estadd local yearloc_fe "Yes"

cd "$output"
esttab using key_results.tex, se obslast replace ///
	keep(scanned faculty doctor master inbuilding facultyXscanned doctorXscanned masterXscanned inbuildingXscanned) ///
	coeflabels(scanned "Post-Scanned" ///
	faculty "Faculty" ///
	doctor "Doctorate Student" master "Masters Student" inbuilding "In-Building" ///
	facultyXscanned "Faculty $\times$ Scanned" doctorXscanned "Doctorate $\times$ Scanned" ///
	masterXscanned "Masters $\times$  Scanned" inbuildingXscanned "In-Building $\times$ Scanned") ///
	mtitles("log-OLS" "log-OLS" "log-OLS") ///
	scalars("book_fe Book FE" "yearloc_fe Year-Location FE")

cd "$code"