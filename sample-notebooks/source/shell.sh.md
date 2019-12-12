<!-- MarkdownTOC -->

- About
    - TODO
    - Dependencies
    - Global settings
- Shortcuts
        - Variable echo
- Pipes/redirection
        - Pipe check
            - Pipe stdin to temp file
        - Buffer pipe data before forwarding
- Export management
        - Show exported functions
        - Show functions defined but not exported
        - Export all currently unexported functions
- Deprecated
        - Number check
        - Dynamically function definition
        - Pipe check

<!-- /MarkdownTOC -->

# About
- General shell related utility functions

## TODO
- Refactor the scripts and delete the deprecated function `shell-is-pipe-input` replacing all occurrences with `shell-is-pipe-input-new`. For now both versions are being maintained as deletion would require extensive refactoring

## Dependencies
```shell
mars-load-dep logging
mars-load-dep files
```

## Global settings
```shell
export SUCCESS=0
export FAILURE=1
```

# Shortcuts
### Variable echo
- Prints a variable by name while ignoring case. Allows for easier variable printing as you can omit `$`  and don't have to upper case variable names

>Usage:
ABC=123
echo $ABC # Prints 123
e abc # Prints 123

```shell
e() {
    ( set -o posix ; set ) | grep --color=never -iE "^$1="
}
```


# Pipes/redirection
### Pipe check
- Lets you see check input is coming from pipe or from keyboard/arguments
- Input coming from pipe does not mean nothing will come from terminal. Function can still have arugments in addition to pipe input `echo a | f 1 2`
- `shell-is-pipe-input` returns TRUE if input is coming from a pipe, FALSE if from a terminal

>**Usage**: shell-is-pipe-input-new && echo YES

```shell
shell-is-pipe-input-new() {
    if [[ `_shell-is-terminal-input` == TRUE ]]; then
        return $FALSE
    else
        return $TRUE
    fi
}

export -f shell-is-pipe-input-new # Export the function so it is available 
```

>**Usage**: echo a | bash-is-pipe-input
TRUE
bash-is-pipe-input
FALSE

```shell
TERMINAL_INPUT=0
TERMINAL_OUTPUT=1

_shell-is-terminal-input() {
    if [[ -t $TERMINAL_INPUT ]]; then
        echo TRUE
    else
        echo FALSE
    fi
}; export -f _shell-is-terminal-input

_shell-is-terminal-output() {
    if [[ -t $TERMINAL_OUTPUT ]]; then
        echo TRUE
    else
        echo FALSE
    fi  
}
```

#### Pipe stdin to temp file
- Returns the name of the temp file

>Usage: echo abc | shell-stdin-to-temp-file 

```shell
shell-stdin-to-temp-file() {
    tempFile=/tmp/`random-filename`
    while read line # Read from stdin
    do
        if [[ -z "$line" ]]; then # Break if stdin is blank
            break
        fi
        echo "$line" > $tempFile
    done
    echo $tempFile
}
```

### Buffer pipe data before forwarding
- Different from sponge in that the data is buffered in a file, whereas sponge buffers it in memory
- Takes an optional filename argument to which to write data after buffering. Redirecting to the file `tmp > myfile.txt` would not work

>Usage: cat myfile.txt | grep -v something | tmp myfile.txt

```shell
TMP_BUFFER_FILE=/tmp/`files-random-name`

tmp() {
    cat > $TMP_BUFFER_FILE

    ifempty "$1" && {
        cat $TMP_BUFFER_FILE
    } || {
        cat $TMP_BUFFER_FILE > "$1"
    }
    rm $TMP_BUFFER_FILE
}
```

# Export management
### Show exported functions
```shell
shell-exported-fn() {
    declare -F | grep " _" -v | grep '\-fx'
}

shell-exported-var() {
    declare -p -x
}
```

### Show functions defined but not exported
```shell
shell-unexported-fn() {
    declare -F | grep -v '\-fx' # -fx means already exported
}

shell-unexported-var() {
    declare -p | grep -v "declare -x" # -x means already exported
}
```

### Export all currently unexported functions
```shell
shell-export-all-fn() {
    unexportedFunctionNames=(`shell-unexported-fn | cut -d ' ' -f 3`)
    for f in "${unexportedFunctionNames[@]}"; do
        export -f "$f"
    done
}

shell-export-all-var() {
    unexportedVarNames=(`shell-unexported-var | grep declare | cut -d ' ' -f 3 | cut -d '=' -f 1`)
    for f in "${unexportedVarNames[@]}"; do
        export "$f"
    done
}

# Export current environment for use by subshells
# Both functions and variables
shell-export-env() {
    shell-export-all-fn
    shell-export-all-var
}
```

# Deprecated
### Number check
- Checks if given input is a valid integer
- **Deprecated because**: use regex matching which is a more generic solution. For example: `input | str-regex-match '\d+'` to test if the given input contains one or more numeric digits

```shell
shell-is-number() {
    re='^[0-9]+$'

    if [[ -z $1 ]]; then
        echo ERROR: no input specified
    fi

    if ! [[ $1 =~ $re ]] ; then
        echo FALSE
    else
        echo TRUE
    fi
}
```

### Dynamically function definition
- Dynamically defines a function with the given name and command
- **Deprecated because**
    + Seems it doesn't get used often 
    + Eval is evil 

>**Usage**: shell-fn-define myfunction 'echo a'

```shell
shell-fn-define() {
    eval "$1() { ${@:2} \"\$@\"; }"
}
```

### Pipe check
- Checks if a pipe is connected via STDIN
- **Deprecated because**: outputs string `"TRUE"` instead of boolean `TRUE`. This was fixed in the new function

>**Usage**: see the new function

``` shell
shell-is-pipe-input() {
    if [[ `_shell-is-terminal-input` == TRUE ]]; then
        echo FALSE
    else
        echo TRUE
    fi
}; export -f shell-is-pipe-input 

shell-is-pipe-output() {
    if [[ -t $TERMINAL_OUTPUT ]]; then
        echo FALSE;
    else
        echo TRUE;
    fi
}
```