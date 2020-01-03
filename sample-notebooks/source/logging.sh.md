<!-- MarkdownTOC -->

- About
    - Usage example
    - Dependencies
        - Defaults
- Functions
    - Config
        - Settings
        - Switch
    - Loggers
        - Message without timestamp
        - Message with timestamp
        - Header with timestamp
        - Separator

<!-- /MarkdownTOC -->

# About
- This notebook defines functions related to logging on the Shell.
- The notebook has been kept deliberately simple. If you've reached a point where advanced logging, such as DEBUG and INFO levels or multiple appenders are needed, you should ditch the Shell and upgrade your script to Groovy or Golang. Thank me later.
- Provides functionality related to:
    + Logging a message
    + Switch logging on/off
    + Routing log output to a file or console
    + Formatting the log message

## Usage example
- Following set of statements
```bash
logh Starting app deployment
logt Retrieving deployment artifacts
log Fetching v6.1.3 release files
logt Retrieval successful
logs
logt Copying to destination directories
```
- Would give following output
```
############################
#  STARTING APP DEPLOYMENT #
############################
[05Mar19-19.24.03] - Retrieving deployment artifacts
Fetching v6.1.3 release files
[05Mar19-19.24.04] - Retrieval successful
________________________________________________
[05Mar19-19.24.06] - Copying to destination directories
```

## Dependencies
```shell
mars-load-dep datetime
```

### Defaults
- By default, file logging is turned off and console log is enabled.
- The default destination is a file called *shell.[currentDate].log* in tmp directory. For example, `/tmp/shell.20Mar20.log` 

# Functions
## Config
### Settings
- Configuration settings related to logging.

```shell
export FILE_LOG=off
export CONSOLE_LOG=on
export DEST_DIR="/tmp"
export LOG_FILENAME="shell"

__log-default-filename() {
    echo "$DEST_DIR/$LOG_FILENAME.`date-current-short`.log"
}; export -f __log-default-filename
```

### Switch
- Switch logging on or off.

>**Usage**: To switch console logging on run
log-on-file
Any statements logged via the log function would then start appearing on console.

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

## Loggers
### Message without timestamp
- Log a given message as is without time or any formatting.

>**Usage**: log "This is my log message" 

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
- Naming: **logt**imed
- Logs the given message with time.

>**Usage**: logt "This is my log message"

```shell
logt() {
    log "[`date-current-full`] - ${@}"
}; export -f logt

__echo-err() {
    >&2 echo "$@"
}
```

### Header with timestamp
- Naming: **logh**eader
- Converts the log message to the upper case and wraps it in special characters to distinguish it from other log entries.

>**Usage**: logh starting server
Would print:

```
#########################
#    STARTING SERVER    #
#########################
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
- Naming: **logs**eparator
- Logs a line separator `________`
- This can be used to group together log entries and separate sections of the log.

>Usage: logs

```shell
logs() {
    local separatorChar='_'
    local length=80
    
    local separator=`printf "$separatorChar%.0s" $(seq 1 $length)`
    log $separator
}; export -f logs
```

