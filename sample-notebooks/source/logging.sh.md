<!-- MarkdownTOC -->

- About
    - Documentation
    - Dependencies
- Defaults
- Switch
- Formatters
        - Message without timestamp
        - Message with timestamp
        - Header with timestamp
        - Separator

<!-- /MarkdownTOC --> 

# About
- Better than using echo because it saves effort spent on
    + Redirecting echo's output to stderr
    + Redirecting echo's output to a file
    + Adding timestamp
- This file is deliberately simple because advanced logging is needed in complex scripts which should be written in kotlin
- Provides functions to:
    + Log a message with different formattings
    + Switch logging on/off
- Does not provide functions to
    + Switch log destination: this is rarely done. To do this change the value of variables
- All functions are exported so that they are available to scripts (executed using `./`)

## Documentation
- Simple usage
```
logh Syncing SVN to git
logt Fetching files
log Entry without time
logt Finished
logs
```
- Output
```
############################
#    SYNCING SVN TO GIT    #
############################
[05Mar19-19.24.03] - Fetching files
Entry without time
[05Mar19-19.24.04] - Finished
________________________________________________
```

## Dependencies
```shell
mars-load-dep datetime
```


# Defaults
- File log is turned off and console log enabled by default
- Kotlin scripts use `FILE_LOG_LEVEL` so there should be no conflicts here
- Default destination is a file called `shell.05Mar19.log` in tmp directory directory. This is defined as a function and not a variable, so that each log function invocation gets today's date and not the date when the function was sourced

```shell
export FILE_LOG=off
export CONSOLE_LOG=on
export DEST_DIR="/tmp"
export LOG_FILENAME="shell"

__log-default-filename() {
    echo "$DEST_DIR/$LOG_FILENAME.`date-current-short`.log"
}; export -f __log-default-filename
```

# Switch
- Switch logging on or off
```shell
log-on-file() {
    log "Sending logs to `__log-default-filename`"
    export FILE_LOG=on
}; export -f log-on-file

log-off-file() {
    export FILE_LOG=off
}; export -f log-off-file

log-on-console() {
    export CONSOLE_LOG=on
}; export -f log-on-console

log-off-console() {
    export CONSOLE_LOG=off
}; export -f log-off-console
```

# Formatters
### Message without timestamp
```shell
log() {
    if [[ $CONSOLE_LOG == "on" ]]; then
        __echo-err "${@}"
    fi
    if [[ $FILE_LOG == "on" ]]; then
        echo "${@}" >> `__log-default-filename`
    fi
}; export -f log
```

### Message with timestamp
> Usage: log string1 string2 ...

```shell
logt() {
    log "[`date-current-full`] - ${@}"
}; export -f logt

__echo-err() {
    >&2 echo "$@"
}
```

### Header with timestamp
- Converts the log message to upper case and wraps it in separator to distinguish it from other log entries

>Usage: logh starting server

```
=========
23Sept17 14:00 - STARTING SERVER
=========
```

```shell
logh() {
    local message=`echo "${@}" | awk '{print toupper($0)}'`
    local length=${#message}
    length=$(($length + 10))
    local separatorChar=#

    local separator=`printf "$separatorChar%.0s" $(seq 1 $length)`
    log "$separator"
    log "$separatorChar    $message    $separatorChar"
    log "$separator"
}; export -f logh
```

### Separator
```shell
logs() {
    local separatorChar='_'
    local length=80
    
    local separator=`printf "$separatorChar%.0s" $(seq 1 $length)`
    log $separator
}; export -f logs
```

