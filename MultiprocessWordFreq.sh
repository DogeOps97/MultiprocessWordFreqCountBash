#! /bin/bash

usage() {
    # Display Help
    echo "Multiprocess Word Frequency Counter in Bash"
    echo
    echo "Syntax: $0 [-o|i|n|h|r]"
    echo "options:"
    echo "-o     (O)utput to specified file"
    echo "-i     Use specified files as (i)nput, use double quotes (\"\") for multiple files"
    echo "-n     (N)umber of process to run simultaneously [1<n<99]"
    echo "-h     Print (h)elp"
    echo "-r     Prints in (r)everse (ascending) order (default is descending)"
    echo "-c     Specify range (not implemented)"
    echo
    echo "Note: This program creates and deletes files marked with temp_*"
}

get_range() {
    echo "Do nothing"
}

# init
# FILE_IN="sample_text/t8.shakespeare.txt sample_text/t8.shakespeare.txt sample_text/t8.shakespeare.txt sample_text/t8.shakespeare.txt sample_text/t8.shakespeare.txt sample_text/t8.shakespeare.txt"
FILE_IN=""
FILE_OUT="out.txt"

TEMP_CLEANED="temp_cleaned.txt"

FLAG_REVERSE=false
NUM_PROCESS=4

OPTSTRING="c:o:i:n:hr"
while getopts $OPTSTRING opt; do
    case $opt in
    h)
        usage
        exit 0
        ;;
    n)
        if (($OPTARG < 1 || $OPTARG > 99)); then
            echo -e "Error: -n has to be between 1 and 99 (inclusive)\n"
            usage
            exit 1
        fi
        NUM_PROCESS=$OPTARG
        ;;
    i)
        FILE_IN=$OPTARG
        if [ ! -z "$OPTARG" ]; then
            FILE_IN=$OPTARG
        else
            echo -e "Error: No input file specified!\n"
            usage
            exit 1
        fi
        ;;
    o)
        FILE_OUT=$OPTARG
        ;;

    r)
        FLAG_REVERSE=true
        ;;
    c) ;;
    *)
        usage
        exit 1
        ;;
    esac
done

if [ -z "$FILE_IN" ]; then
    echo "Error: Input file cannot be empty"
    usage
    exit 1
fi

# Start timer
echo "Start"
start_time=$(date +%s.%N)

# file cleanup
# | sed -re 's/\b\w{1,1}\b//g' filter word of 1 char length
cat $FILE_IN | sed -e 's/[[:punct:]]//g' -re 's/[0-9]\w+|[0-9]//g' -re 's/[[:space:]]+/\n/g' | grep . | awk '{print tolower($0)}' >$TEMP_CLEANED

# -n l/N divides into N files without spliiting lines/records
split -d -a 2 -n l/$NUM_PROCESS $TEMP_CLEANED temp_

for ((i = 0; i < $NUM_PROCESS; i++)); do
    padded=$(printf "%02d\n" $i)
    cat temp_$padded | sort | uniq -c | sort -nr >temp_out$padded.txt &
done

wait # wait until all processes are done

# merge all the files
echo "" >out_merged.txt
for f in temp_out[0-9]*.txt; do
    cat $f >>out_merged.txt
done

cat out_merged.txt | sort -k2 | awk '
BEGIN {
    TOTAL = 0;
    LAST_ITEM="";
}
{
    if ($2 == ""){

    }
    if ($2 == LAST_ITEM) {
        TOTAL += $1;
    }
    else if ($2 != LAST_ITEM) {
        if (LAST_ITEM != ""){
            printf("%s %d\n", LAST_ITEM, TOTAL);
        }
        TOTAL = $1
        LAST_ITEM = $2
    }
}
END {
    if (LAST_ITEM != "") {
        printf("%s %d\n", LAST_ITEM, TOTAL)
    }
}
' | ([ $FLAG_REVERSE = true ] && sort -n -k2 || sort -nr -k2) >$FILE_OUT

echo "End"
echo "Output saved to "$FILE_OUT
end_time=$(date +%s.%N)

runtime=$(echo "$end_time - $start_time" | bc -l)
echo "execution time was "$runtime" s".

# Cleanup
rm temp_*
