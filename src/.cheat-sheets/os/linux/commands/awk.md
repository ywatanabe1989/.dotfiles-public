<!-- ---
!-- title: ./.cheat-sheets/os/linux/commands/awk.md
!-- author: ywatanabe
!-- date: 2024-11-14 16:32:29
!-- --- -->


# `awk.md`

## Basic Operations

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | `awk '{print $1}'` | Print first field |
| [ ] | `awk '{print NR, $0}'` | Print line number and line |
| [ ] | `awk 'NR==1'` | Print first line |
| [ ] | `awk 'length>80'` | Print lines longer than 80 chars |
| [ ] | `awk -F','` | Set field separator |

## Pattern Matching

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | `awk '/pattern/'` | Print lines matching pattern |
| [ ] | `awk '$1 ~ /pattern/'` | Match pattern in first field |
| [ ] | `awk 'BEGIN {}'` | Execute before processing |
| [ ] | `awk 'END {}'` | Execute after processing |
| [ ] | `awk '$1>100'` | Numeric comparison |

## Built-in Variables

| Checkbox | Variable | Description |
|----------|----------|-------------|
| [ ] | `NR` | Current line number |
| [ ] | `NF` | Number of fields |
| [ ] | `FS` | Field separator |
| [ ] | `RS` | Record separator |
| [ ] | `OFS` | Output field separator |

## Tips and Tricks
- [ ] Use `-v var=value` to set variables
- [ ] Arrays are associative by default

## Common Use Cases

| Checkbox | Command | Description |
|----------|---------|-------------|
| [ ] | `awk '{print $5}'` | Print fifth column |
| [ ] | `awk '/foo/ {print $2}'` | Print second column where line contains "foo" |
| [ ] | `awk -F',' '{print $NF}'` | Print last column with comma separator |
| [ ] | `awk '{s+=$1} END {print s}'` | Sum first column values |
| [ ] | `awk 'NR%3==1'` | Print every third line |
| [ ] | `awk '($10 >= min && $10 <= max)'` | Filter by column value range |

## Formatted Output
```awk
# Table with headers and formatted columns
awk 'BEGIN {
    FS=":";
    printf "%-20s %6s %25s\n", "Name", "UID", "Shell"
}
$4 >= 1000 {
    printf "%-20s %6d %25s\n", $1, $4, $7
}' /etc/passwd
```

## Conditional Processing
```awk
awk '{
    if ($1 == "foo") 
        print "Exact match foo"
    else if ($1 ~ "bar") 
        print "Partial match bar"
    else 
        print "Baz"
}'
```

## Practice Exercises

### Basic Operations
1. **Print Specific Columns**
```bash
# Sample data: name,age,city
echo "John,25,NYC" | awk -F',' '{print $1 " is " $2 " years old"}'
```

### Pattern Matching
2. **Filter and Transform**
```bash
# Sample data: logs with timestamps
echo "2024-01-01 ERROR: failed" | awk '/ERROR/ {print "Found error on: " $1}'
```

### Data Processing
3. **Calculate Average**
```bash
# Sample data: numbers.txt
echo -e "10\n20\n30" | awk '{sum+=$1} END {print "Average:", sum/NR}'
```

### Advanced Examples
4. **Custom Field Processing**
```bash
# Process CSV with header
cat << EOF | awk -F',' 'NR==1{header=$0;next} {print $2 ":" $1}'
name,score,grade
John,95,A
Mary,88,B
EOF
```

## Practice Files
Create these files for practice:
```bash
# data.csv
name,age,city
John,25,NYC
Mary,30,LA
Bob,35,CHI

# numbers.txt
10
20
30
40
50
```

## Resources
- [ ] [GNU awk manual](https://www.gnu.org/software/gawk/manual/)
