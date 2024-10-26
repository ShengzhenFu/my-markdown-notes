## MacOS commands

#### get hostnames
```bash
scutil --get HostName
scutil --get LocalHostName
scutil --get ComputerName
```

#### get Macbook summary
```bash
system_profiler SPHardwareDataType | awk 'BEGIN {print "<Macbook summary>"} /Chip|Cores|Memory|Serial/ {print $0} END {print "</End>"}'
```
