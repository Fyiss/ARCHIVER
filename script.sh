#!/bin/bash

BASE="Directory where your script is located"
DAYS=10
DEPTH=1
RUN=0
EMAIL="xyz@gmail.com" # Replace with your email address
SUBJECT="Archived Files and Folders Report"
REPORT="/tmp/archive_report.txt"

if [ ! -d "$BASE" ]; then
    echo "$BASE does not exist"
    exit 1
fi

if [ ! -d "$BASE/archive" ]; then
    mkdir "$BASE/archive"
fi

# Initialize report file
echo "Archive Report - $(date "+%Y-%m-%d %H:%M:%S")" > "$REPORT"
echo "Archived files and folders from $BASE:" >> "$REPORT"
echo "----------------------------------------" >> "$REPORT"

# Function to archive files
archive_file() {
    local file="$1"
    gzip "$file" || { echo "Error compressing $file"; exit 1; }
    mv "$file.gz" "$BASE/archive" || { echo "Error moving $file.gz to $BASE/archive"; exit 1; }
    local file_size
    file_size=$(du -sh "$BASE/archive/$(basename "$file.gz")" | cut -f1)
    echo "$(basename "$file.gz") - $file_size" >> "$REPORT"
}

# Function to archive directories
archive_directory() {
    local dir="$1"
    local tar_file="$BASE/archive/$(basename "$dir").tar.gz"
    tar -czf "$tar_file" -C "$(dirname "$dir")" "$(basename "$dir")" || { echo "Error compressing $dir"; exit 1; }
    local dir_size
    dir_size=$(du -sh "$tar_file" | cut -f1)
    echo "$(basename "$tar_file") - $dir_size" >> "$REPORT"
}

# Using find to handle files larger than 50 MB
find "$BASE" -maxdepth "$DEPTH" -type f -size +50M | while IFS= read -r i; do
    if [ $RUN -eq 0 ]; then
        echo "[$(date "+%Y-%m-%d %H:%M:%S")] archiving file $i to the folder $BASE/archive"
        if [ -f "$i" ]; then
            archive_file "$i"
            # Remove the original file after archiving
            rm "$i" || { echo "Error removing $i"; exit 1; }
        else
            echo "File $i does not exist."
        fi
    fi
done

# Using find to handle directories
find "$BASE" -maxdepth "$DEPTH" -type d ! -path "$BASE/archive" -print0 | while IFS= read -r -d '' dir; do
    if [ $RUN -eq 0 ] && [ "$dir" != "$BASE" ]; then
        echo "[$(date "+%Y-%m-%d %H:%M:%S")] archiving directory $dir to the folder $BASE/archive"
        archive_directory "$dir"
        # Remove the original directory after archiving
        rm -rf "$dir" || { echo "Error removing $dir"; exit 1; }
    fi
done

# Send the report via email with the report attached
echo "Please find the archive report attached." | mail -s "$SUBJECT" -A "$REPORT" "$EMAIL"
