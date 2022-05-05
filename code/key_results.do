// make sure to run runme.do to generate global paths before running this script

cd $code

do faculty.do
do student.do
do inbuilding.do

cd $output
esttab using key_results.tex, se obslast replace ///
	keep(scanned faculty doctor master inbuilding facultyXscanned doctorXscanned masterXscanned inbuildingXscanned) ///
	coeflabels(scanned "Post-Scanned" ///
	faculty "Faculty" ///
	doctor "Doctorate Student" master "Masters Student" inbuilding "In-Building" ///
	facultyXscanned "Faculty $\times$ Scanned" doctorXscanned "Doctorate $\times$ Scanned" ///
	masterXscanned "Masters $\times$  Scanned" inbuildingXscanned "In-Building $\times$ Scanned") ///
	mtitles("log-OLS" "log-OLS" "log-OLS") ///
	scalars("book_fe Book FE" "yearloc_fe Year-Location FE")

cd $code
