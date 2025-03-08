#!/bin/bash

# Check if path argument is given
if [ -z "$1" ]; then
    echo "Usage: $0 <directory-path>"
    exit 1
fi

# Get disk usage of the provided path
DIR_PATH="$1"
DISK_USAGE=$(du -sh "$DIR_PATH" 2>/dev/null | awk '{print $1}')
DISK_USAGE_MB=$(du -sm "$DIR_PATH" 2>/dev/null | awk '{print $1}')  # Get MB value

# Check if directory exists
if [ -z "$DISK_USAGE" ]; then
    echo "Error: Directory does not exist or cannot be accessed."
    exit 2
fi

# Convert usage to categories using case statement
case $DISK_USAGE_MB in
    [0-100])  # 0-100MB
        STATUS="LOW"
        ;;
    [101-500])  # 101MB - 500MB
        STATUS="MEDIUM"
        ;;
    [501-1000])  # 501MB - 1GB
        STATUS="HIGH"
        ;;
    *)  # More than 1GB
        STATUS="CRITICAL"
        ;;
esac

# Display result
echo "Directory: $DIR_PATH"
echo "Disk Usage: $DISK_USAGE ($DISK_USAGE_MB MB)"
echo "Status: $STATUS"
