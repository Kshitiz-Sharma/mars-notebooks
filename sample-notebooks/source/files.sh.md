<!-- MarkdownTOC -->

- About
- Dependencies
- Temp files
    - Name generation

<!-- /MarkdownTOC -->

# About
- This notebook defines utility functions to work with files.

# Dependencies
- Load the dependencies for this notebook.

```shell
mars-load-dep datetime
```

# Temp files
### Name generation
- Function to generate a filename for the current date.
- Uses random alphanumeric characters if filename not specified.

>**Usage**: random-filename myfile <br>
Output: myfile.18Sep19.log

>**Usage**: random-filename <br>
Output: d945b250.18Sep19.log

```shell
files-random-name() {
    local randomAlphaNum=`cat /dev/urandom | tr -cd 'a-f0-9' | head -c 8`

    if [[ -z $1 ]]; then
        echo $randomAlphaNum.`date-current-short`.log
    else
        echo $1.`date-current-short`.log
    fi
}
```
