// copy and paste your filepath that points to the scolari_david folder
global path "/Users/davidscolari/Dropbox/grad_school/3_Spring22/causal/final_pape"
global data "$path/data"
globa panel_data "$data/panel_data"
global code "$path/code"
global output "$path/output"

cd $code
do 1_loans_base.do
do 2a_loans_faculty.do
do 2b_loans_student.do
do 2c_loans_inbuilding.do
do 3a_table_5.do
do 3b_table_keyresults.do
