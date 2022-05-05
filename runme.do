// copy and paste your filepath that points to the scolari_david folder
global path "[ENTER USER FILEPATH HERE]/scolari_david"
global data "$path/data"
global code "$path/code"
global output "$path/output"

cd $code
do loans.do
do table_5.do
do key_results.do
