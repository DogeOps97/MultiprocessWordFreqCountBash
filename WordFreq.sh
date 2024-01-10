#! /bin/bash

usage() {
    # Display Help
    echo "Word Frequency Counter in Bash"
    echo
    echo "Syntax: $0 [-o|i|h|r|c]"
    echo "options:"
    echo "-o     (O)utput to specified file"
    echo "-i     Use specified files as (i)nput, use double quotes (\"\") for multiple files"
    echo "-h     Print (h)elp"
    echo "-r     Prints in (r)everse (ascending) order (default is descending)"
    echo "-c     Specify range for character (c)ounts in words"
    echo "          Acceptable formats: 1-2, 1-1, -4, 3 (default to min word count)"
    echo "          Invalid formats: 0-0, 0-, -0, 3-2"
    echo
    echo "Note: This program creates and deletes files marked with temp_*"
}

get_range() {
    local range=$1

    local pattern="[^0-9-]"

    if [[ $range =~ $pattern ]]
    then    
        echo "Error: Option -c - Invalid character in the range"
        usage 
        exit 1
    fi
    IFS='-' read -r min_char_count max_char_count <<< $1

    # Error checking
    if [[ -z $min_char_count && -z $max_char_count ]]
    then
        echo "Error: Option -c - No range specified with -c option"
        usage
        exit 1
    elif [[ -n $max_char_count && $max_char_count < 1 ]]
    then
        echo "Error: Option -c - max character count cannot be less than 1"
        usage
        exit 1
    elif [[ -n $min_char_count && $min_char_count < 1 ]]
    then
        echo "Error: Option -c - min character count cannot be less than 1"
        usage
        exit 1
    elif [[ -n $min_char_count && -n $max_char_count && $max_char_count -lt $min_char_count ]]
    then 
        echo "Error: Option -c - Max cannot be less than min character count"
    fi
}

# init
FILE_IN=""
FILE_OUT="out.txt"

TEMP_CLEANED="temp_cleaned.txt"

FLAG_REVERSE=false

OPTSTRING="c:o:i:hr"
while getopts $OPTSTRING opt; do
    case $opt in
    h)
        usage
        exit 0
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
    c) 
        get_range "${OPTARG}"
        ;;
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

cat $FILE_IN | sed -e 's/[[:punct:]]//g' \
    -re 's/[0-9]\w+|[0-9]//g' \
    -re 's/[[:space:]]+/\n/g' | \
    ([[ -n $min_char_count && $min_char_count > 1 ]] && sed -re "s/\b\w{1,$((min_char_count - 1))}\b//g" || cat ) | \
    ([[ -n $max_char_count && $max_char_count > 0 ]] && sed -re "s/\b\w{$((max_char_count + 1)),}\b//g" || cat ) | \
    grep . | awk '{print tolower($0)}' | sort | uniq -c | ([ $FLAG_REVERSE = true ] && sort -n || sort -nr ) | awk '{printf("%s %s\n", $2, $1)}' >$FILE_OUT


echo "End"
echo "Output saved to "$FILE_OUT
end_time=$(date +%s.%N)

runtime=$(echo "$end_time - $start_time" | bc -l)
echo "execution time was "$runtime" s".