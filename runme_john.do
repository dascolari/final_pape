// copy and paste your filepath that points to the scolari_david folder
global path "[JOHNS FILEPATH]/final_pape"
global data "$path/data"
global code "$path/code"
global output "$path/output"

cd $code
do 1_loans_base.do
do 3a_table_5.do
do 3b_table_keyresults.do

