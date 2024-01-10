# MultiprocessWordFreqCountBash
This script concurrently counts the word frequencies in specified text files using multiple processes in Bash, with the option to output the results to a specified text file (default is `out.txt`).

The process involves aggregating all files into a single stream, cleaning the text, and dividing it into 'n' processes as specified by the `-n` option (default is 4). Each process independently counts the words in its designated portion of the text. Finally, the word counts are combined and saved to the specified text file.

### Usage

    Syntax: ./MultiprocessWordFreq.sh [-o|i|n|h|r|c]"
    options:
    -o      (O)utput to specified file
    -i      Use specified files as (i)nput, use double quotes ("") for multiple files
    -n      (N)umber of process to run simultaneously [1<=n<99]
    -h      Print (h)elp
    -r      Prints in (r)everse (ascending) order (default is descending)
    -c      Specify range for character (c)ounts in words
                Acceptable formats: 1-2, 1-1, -4, 3 (default to min word count)
                Invalid formats: 0-0, 0-, -0, 3-2
    Note: This program creates and deletes files marked with temp_*

### Example usage

`./MultiprocessWordFreq.sh -i "sample_text/t8.shakespeare.txt sample_text/t8.shakespeare.txt sample_text/big.txt"`

Sample text files are provided in `sample_text`.
