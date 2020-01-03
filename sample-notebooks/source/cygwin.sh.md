<!-- MarkdownTOC -->

- About
        - Dependencies
        - TODO
        - Conventions
- Config
        - Prompt
- Shortcuts
        - Improved clip
- Themes
    - Theme initializer
    - List
        - Pastel
        - Dracula
        - Shapeshifter
        - Monokai
        - Solarized dark
        - Solarized light
    - Auto selection
- Process management
        - Find PID by name
        - Function to kill given list of pids

<!-- /MarkdownTOC -->

# About
- This is a sample notebook that demonstrates
    + The layout of a mars notebook
    + Writing appropriate documentation and usage information
    + Loading other notebooks via dependencies
- It defines various utility functions for working with Cygwin
- General Shell-based functions that aren't specific to Cygwin customization are in a separate notebook **shell.sh.md**.
- For instructions on running the notebook, see the primary documentation

### Dependencies
- Load the dependencies for this notebook

```shell
mars-load-dep shell
mars-load-dep logging
```

### TODO
- Document the elements of the prompt string. What do the various special codes represent?

### Conventions
- The function names are written in a way to aid auto-completion on shell. So `Cygwin-pid-get-by-process-name` is preferred to more grammatically correct `cygwin-get-pid-by-process-name`. This allows typing `cygwin` on the shell and then tabbing to view all the cygwin related functions. Then typing `pid` and tabbing to see PID management functions.

# Config
### Prompt
- Replace the default Cygwin prompt, which looks like `kshar@DESKTOP-9ORBQI8 /cygdrive/c/Windows` with a more concise `kshar /cygdrive/c/Windows`.

```shell
export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u \[\e[33m\]\w\[\e[0m\]\n\$ '
```

# Shortcuts
### Improved clip
- Function to read/write to windows clipboard from CLI
- When used with a pipe directs the input coming on *STDIN* to the windows clip utility
- Otherwise invokes the Cygwin clipboard device to print out clipboard contents to stdout

>**Usage**:
echo 'text to be copied to clipboard' | clip <br>
clip # Outputs 'text to be copied to clipboard' <br>

```shell
clip() {
    __CLIP_PATH=`whereis clip | cut -d' ' -f 2`
    
    if [[ `shell-is-pipe-input` == TRUE ]]; then
        cat /dev/stdin | $__CLIP_PATH
    else
        cat /dev/clipboard
    fi
}
```

# Themes
## Theme initializer
- Function to set custom theme colors based on RGB hex values
- The comments in the code snippet below show what attribute is being changed. So passing `DC322F` (red) as the 4th argument would change all the blacks to red

>**Usage**: cygwin-theme-set 657B83 FDF6E3 DC322F 073642 002B36 DC322F CB4B16 859900 586E75 B58900 657B83 268BD2 839496 D33682 6C71C4 2AA198 93A1A1 EEE8D5 FDF6E3

```shell
cygwin-theme-set() {
    echo -ne "\eP\e]10;#$1\a";    # Foreground
    echo -ne "\eP\e]11;#$2\a";    # Background
    echo -ne "\eP\e]12;#$3\a";    # Cursor
    echo -ne "\eP\e]4;0;#$4\a";   # black
    echo -ne "\eP\e]4;8;#$5\a";   # bold black
    echo -ne "\eP\e]4;1;#$6\a";   # red
    echo -ne "\eP\e]4;9;#$7\a";   # bold red
    echo -ne "\eP\e]4;2;#$8\a";   # green
    echo -ne "\eP\e]4;10;#$9\a";  # bold green
    echo -ne "\eP\e]4;3;#$10\a";  # yellow
    echo -ne "\eP\e]4;11;#$11\a"; # bold yellow
    echo -ne "\eP\e]4;4;#$12\a";  # blue
    echo -ne "\eP\e]4;12;#$13\a"; # bold blue
    echo -ne "\eP\e]4;5;#$14\a";  # magenta
    echo -ne "\eP\e]4;13;#$15\a"; # bold magenta
    echo -ne "\eP\e]4;6;#$16\a";  # cyan
    echo -ne "\eP\e]4;14;#$17\a"; # bold cyan
    echo -ne "\eP\e]4;7;#$18\a";  # white
    echo -ne "\eP\e]4;15;#$19\a"  # bold white
}
```

## List
- A list of predefined themes using the theme set function defined earlier

>**Usage**: invoke the alias by name
cygwin-theme-pastel

### Pastel
```shell
alias cygwin-theme-pastel='cygwin-theme-set d0d0d0 1c1c1c ffaf0 80e0a0 ccc aaa d78787 df8787 afd787 afdf87 f7f7af ffffaf 87afd7 87afdf d7afd7 dfafdf afd7d7 afdfdf e6e6e6 eeeeee'
```

### Dracula
```shell
alias cygwin-theme-dracula='cygwin-theme-set f8f8f2 282a36 000 282a35 ff5555 ff6e67 50fa7b 5af78e f1fa8c f4f99d caa9fa caa9fa ff79c6 ff92d0 8be9fd 9aedfe bfbfbf e6e6e6'
```

### Shapeshifter
```shell
alias cygwin-theme-shapeshifter='cygwin-theme-set ababab 000 fd9d4f 000 343434 e92f2f f07474 ed839 40f366 dddd13 f0f04e 3b48e3 7d87ec f996e2 fddef6 23edda 6bf3e6 ababab f9f9f9'
```

### Monokai
```shell
alias cygwin-theme-monokai='cygwin-theme-set f8f8f2 272822 fd9d4f 272822 75715e f92672 cc64e a6e22e 7aac18 f4bf75 f0a945 66d9ef 21c7e9 ae81ff 7e33ff a1efe4 5fe3d2 f8f8f2 f9f8f5'
```

### Solarized dark
```shell
alias cygwin-theme-solarised-dark='cygwin-theme-set 839496 002B36 DC322F 073642 073642 002B36 DC322F CB4B16 859900 586E75 B58900 657B83 268BD2 839496 D33682 6C71C4 2AA198 93A1A1 EEE8D5 FDF6E3'
```

### Solarized light
- **Credit**: color codes taken from https://github.com/mavnn/mintty-colors-solarized

```shell
alias cygwin-theme-solarised-light='cygwin-theme-set 657B83 FDF6E3 DC322F 073642 002B36 DC322F CB4B16 859900 586E75 B58900 657B83 268BD2 839496 D33682 6C71C4 2AA198 93A1A1 EEE8D5 FDF6E3'
```

## Auto selection
- Automatically select theme based on time of the day
- Selects a light theme during the day and dark on in the evening

>**Usage**: cygwin-theme-auto

```shell
cygwin-theme-auto() {
    H=$(date +%H)
    if (( 6 <= 10#$H && 10#$H < 18 )); then 
        cygwin-theme-solarised-light
    else
        cygwin-theme-monokai
    fi
}
```

# Process management
### Find PID by name
- The `ps` utility doesn't work correctly on Cygwin. It doesn't show the processes launched outside Cygwin
- Windows `wmic` utility is used for this, but it's hard to remember its syntax.
- This function serves as a simplified facade over `wmic`.

>**Usage**: cygwin-pid-get-by-process-name java

```shell
cygwin-pid-get-by-process-name() {
    wmic path win32_process get ProcessID,commandline | grep -i "$1" | str-replace-all ' {3}' '' | str-trim | str-regex-extract '\d*$'
}
```

### Function to kill given list of pids
- On Windows, the `ps` utility does not correctly kill processes
- These functions allow killing a list of processes using the Windows taskkill utility

>**Sytax**: cygwin-pid-kill [pid1] [pid2] <br>
**Usage**: cygwin-pid-kill 1419 2395

```shell
cygwin-pid-kill() {
    for i in "$@"; do
        taskkill /PID $1
    done
}

cygwin-pid-kill-force() {
    for i in "$@"; do
        taskkill /F /PID $1
    done
}
```
