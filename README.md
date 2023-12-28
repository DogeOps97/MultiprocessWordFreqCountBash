# MultiprocessWordFreqCountBash
Multiprocess WordFreqCount in Bash

### Usage

    Syntax: ./MultiprocessWordFreq.sh [-o|i|n|h|r]
    options:
    -o     (O)utput to specified file
    -i     Use specified files as (i)nput, use double quotes ("") for multiple files
    -n     (N)umber of process to run simultaneously [1<n<99]
    -h     Print (h)elp
    -r     Prints in (r)everse (ascending) order (default is descending)
    -c     Specify range (not implemented)
    Note: This program creates and deletes files marked with temp_*

### Example usage

`./MultiprocessWordFreq.sh -i "sample_text/t8.shakespeare.txt sample_text/t8.shakespeare.txt sample_text/big.txt"`
