########
# MARS
# Shell script literate programming and notebook system
# Provides for shell scripts what Jupyter notebooks for python scripts
########

# Overrides the source built-in to add automatic dos2unix conversion under Cygwin
# Also allows sourcing all the files in a directory. Does not recurse into sub directories
# Does not change the builtin signature, so should not break any programs
# Usage: source [file1 or dir1] [file2 or dir2] ...
source() {
	for arg in "$@"; do
		if [[ -d "$arg" ]]; then
			matchingFiles=(`find "$arg" -maxdepth 1 -type f`)
			for file in ${matchingFiles[@]}; do
				source "$file"
			done
		else
            if [[ __is-running-under-cygwin ]] && [[ __is-dos2unix-on-path ]]; then
                command source <(cat "$arg" | dos2unix)
            else
                command source <(cat "$arg")
            fi
		fi
	done
}

export TRUE=0
export FALSE=1

# If the cydrive directory exists, then script is running under cygwin
# Checking output from uname would be another way to do it
__is-running-under-cygwin() {
    if [ -d /cygdrive ]; then
        return $TRUE
    else
        return $FALSE
    fi
}

__is-dos2unix-on-path() {
    type dos2unix > /dev/null 2>&1 && return $TRUE || return $FALSE
}

# Extracts snippets of given type from markdown text
# Usage: cat [markdown-file].md | __mars-extract-code-from-markdown [code-snippet-type]
# Example: cat myfile.md | __mars-extract-code-from-markdown shell
__mars-extract-code-from-markdown() {
	codeType="$1"

	if [[ -z $codeType ]]; then
		echo 'ERROR[__mars-extract-code-from-markdown]: Specify a code type'
		return
	fi

	# Use multiline grep to match all the snippets
	# Use tr to delete null characters from result
	cat | grep -Pzo '(?s)```'$codeType'.*?```' | tr -d '\000' | grep -v '```'
}

#######
# Logging
#######

CONSOLE_LOG=off
export CONSOLE_LOG_LEVEL=OFF

# Function to log a string with timestamp
# Usage: log string1 string2 ...
mars-log() {
    if [[ $CONSOLE_LOG == "on" ]]; then
        >&2 echo "[`date +%d%b%g-%H.%M.%S`] - ${@}"
    fi
}

mars-log-on() {
    export CONSOLE_LOG=on
}

mars-log-on # Switch on the console logging by default

mars-log-off() {
    export CONSOLE_LOG=off
}

### 
# Notebook registry
###

declare -Ag NOTEBOOKS=( )
__DEFAULT_EXTENSION=.sh.md

mars-scan-notebooks() {
    dir=$1
    files=`find $dir -name "*$__DEFAULT_EXTENSION" -type f 2> /dev/null`
    for file in $files; do
        NOTEBOOKS[`basename "$file" .sh.md`]=`readlink -f "$file"`
    done 
}

mars-list-notebooks() {
    for key in "${!NOTEBOOKS[@]}"; do
        echo $key = "${NOTEBOOKS[$key]}"
    done | sort
}

mars-list-loaded() {
    for i in "${LOADED[@]}"; do
        echo $i
    done | sort
}

###
# Compilation
###
__PATH_TO_SELF="$MARS_HOME/mars.sh"

# - Print compiled form of a notebook, with all the transitive dependencies resolved
# - Any environment variables that the code depends on will not get included. This is by design
#       If a variable is external to a module it should be set externally. It likely contains some environment specific details such as file path
# - Instead of manually trying to resolve the imports delegates this to bash. Turns on the export mode which makes the `load` function print the source to stdout 
#       If the imported file contains nested imports those will be imported by bash and printed aswell
# - A dummy load function is prepended to the output so that final flattended code doesn't try to do any imports
mars-print-compiled() {
    if [[ ! -f "$__PATH_TO_SELF" ]]; then
        >&2 echo "Unable to find 'mars.sh'. Has MARS_HOME been set?"
        return
    fi    

    local notebookName=$1

    if [[ -z $notebookName ]]; then
        >&2 echo "Specify the notebook name"
        return
    fi

    if [[ -z "${NOTEBOOKS[$notebookName]}" ]]; then
        >&2 echo "Notebook $notebookName not found. Have you scanned for the notebooks?"
        return
    fi

    cat "$__PATH_TO_SELF" | grep -vE '^#'
    echo 'mars-load() { local a; }'
    echo 'alias mars-load-dep=mars-load'
    
    local moduleName="$1"
    EXPORT_MODE=on
    __mars-load $moduleName | grep -vE '^#'
    EXPORT_MODE=off
}

###
# Loading
###

LOADED=()
EXPORT_MODE=off

TIMEFORMAT='%lR' # Have time measure only real time (wall clock time)

mars-load() {
    mars-log ==================
    __mars-load $1 "Loading notebook $1" 
}

mars-load-dep() {
    __mars-load $1 "Loading dependency $1" 
}

__mars-loadWithTime() {
    time __mars-load "$@"
}

__mars-load() {
    local notebookName=$1
    local logMessage="$2"

    if [[ -z "${NOTEBOOKS[$notebookName]}" ]]; then
        >&2 echo "Notebook $notebookName not found. Have you scanned for the notebooks?"
        return
    fi

    if [[ $EXPORT_MODE == on ]]; then
        echo "`cat "${NOTEBOOKS[$notebookName]}" | __mars-extract-code-from-markdown shell`"
        source <(cat "${NOTEBOOKS[$notebookName]}" | __mars-extract-code-from-markdown shell)
    elif [[ `__isElementInArray $notebookName "${LOADED[@]}"` == FALSE ]]; then
        mars-log "$logMessage"
        source <(cat "${NOTEBOOKS[$notebookName]}" | __mars-extract-code-from-markdown shell)
        LOADED+=($notebookName)        
    else
        mars-log "Skipped $2 as already present"
    fi
}

# Usage: __isElementInArray [element] [all-elements-of-array] 
__isElementInArray() {
    local element
    local searchTerm=$1
    for element in "${@:2}"; do
        if [[ "$element" == "$searchTerm" ]]; then
            echo TRUE
            return
        fi
    done    
    echo FALSE
}
