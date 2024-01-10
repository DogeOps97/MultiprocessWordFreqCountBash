# MultiprocessWordFreqCountBash
This program would count the frequency of words in the given text files concurrently across different process in bash, and output to specified text file (default is `out.txt`) 

A single process would combine all the file together, clean the text, and splits to n number of process specified with `-n` option (default is 4), then each process would seperately count those words in their respective files. Finally, those word count would be added together and saved to specified text file.

### Usage

    Syntax: ./MultiprocessWordFreq.sh [-o|i|n|h|r]
    options:
    -o     (O)utput to specified file
    -i     Use specified files as (i)nput, use double quotes ("") for multiple files
    -n     (N)umber of process to run simultaneously [1<=n<99]
    -h     Print (h)elp
    -r     Prints in (r)everse (ascending) order (default is descending)
    -c     Specify range (not implemented)
    Note: This program creates and deletes files marked with temp_*

### Example usage

`./MultiprocessWordFreq.sh -i "sample_text/t8.shakespeare.txt sample_text/t8.shakespeare.txt sample_text/big.txt"`

Sample text files are provided in `sample_text`.
