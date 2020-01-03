<!-- MarkdownTOC -->

- About
- Dependencies
- Current time
    - Readable
        - Date
        - Time
        - Datetime
    - Sortable
    - ISO
    - Epoch
- Conversion
    - To Short
    - To ISO
    - To Epoch
    - From Epoch
- Date range

<!-- /MarkdownTOC -->

# About
- This notebook defines utility functions to simplify date handling in shell
- Instead of constructing date pattern strings you can use functions with descriptive names to get dates in various formats

# Dependencies
- Has no external dependencies

# Current time
## Readable
- Short, readable format

```shell
DATE_FORMAT_SHORT=+%d%b%g
DATE_FORMAT_SHORT_TIME=+%H.%M.%S
```

### Date
>**Usage**: date-current-short <br>
04Dec19

```shell
date-current-short() {
    date $DATE_FORMAT_SHORT
}
```

### Time
>**Usage**: date-current-time <br>
13.00.27

```shell
date-current-time() {
    date $DATE_FORMAT_SHORT_TIME
}
```

### Datetime
>**Usage**: date-current-time <br>
04Dec19-13.01.03

```shell
date-current-full() {
    echo "`date-current-short`-`date-current-time`"
}
```

## Sortable
- Date without special separate characters such as `:`
- Year month date format is used to make it sortable
- These properties allow use in filenames for temporary or log files

>**Usage**: date-current-sortable <br>
20191204

```shell
# Format that can be sorted easily and thus usable in filenames
DATE_FORMAT_SORTABLE=+%Y%m%d 

date-current-sortable() {
    date $DATE_FORMAT_SORTABLE
}
```

## ISO
>**Usage**: date-current-time <br>
2019-12-04T13:02:20+0000

```shell
DATE_FORMAT_ISO=+%FT%T%z
date-current-iso() {
    # -u gives UTC time
    date -u $DATE_FORMAT_ISO
}
```

## Epoch
>**Usage**: date-current-epoch <br>
1575464639

```shell
DATE_FORMAT_EPOCH=+%s
date-current-epoch() {
    date $DATE_FORMAT_EPOCH
}
```

# Conversion
## To Short
>**Usage**: date-convert-to-short `date` <br>
04Dec19

```shell
date-convert-to-short() {
    date -d"$1" $DATE_FORMAT_SHORT
}
```

## To ISO
>**Usage**: date-convert-to-iso '10/27/2017' <br>
2017-10-27T00:00:00+0000

```shell
date-convert-to-iso() {
    date -d "$1" -u $DATE_FORMAT_ISO
}
```

## To Epoch
>**Usage**: date-convert-to-epoch '10/27/2017' <br>
1509058800

>date-convert-to-epoch '27Oct17' <br>
1509058800

>date-convert-to-epoch '20171027' <br>
1509058800

```shell
date-convert-to-epoch() {
    date -d "$1" $DATE_FORMAT_EPOCH
}
```


## From Epoch
- Epoch to readable
- **Not yet implemented**

```shell
date-convert-from-epoch() {
    :
}
```

# Date range
- Lists all the dates from the beginning of the calendar year
- To get last 7 says do: `date-list-year $DATE_FORMAT_SHORT | tail -n 7`
- Accepts an optional first argument that specifies the date format

>**Usage**: date-list-year | tail -n 3 <br>
20191202 <br>
20191203 <br>
20191204 <br>

```shell
date-list-year() {
    local dateFormat=$1
    if [[ -z $dateFormat ]]; then
        dateFormat=$DATE_FORMAT_SORTABLE
    fi
    local yearStartDate=`date-convert-to-epoch $(date +%Y0101)`
    local currentDate=`date-convert-to-epoch $(date-current-sortable)`
    local difference=`echo "($currentDate - $yearStartDate)/3600/24" | bc`

    for d in `seq 0 $difference`; do
        echo `date $DATE_FORMAT_SORTABLE --date="$d day ago"`
    done | tac
}
```
