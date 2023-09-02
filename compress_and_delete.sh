#!/bin/bash

# Function to print progress bar
progress_bar() {
    local percentage=$1
    local filled=$((percentage/2))
    local unfilled=$((50-filled))
    printf "["
    printf "%0.s#" $(seq 1 $filled)
    printf "%0.s-" $(seq 1 $unfilled)
    printf "] %s%%" "$percentage"
}

# Ensure a directory is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory_path>"
    exit 1
fi

cd "$1" || exit

# Count the number of directories to process for the progress bar
total_dirs=$(find . -maxdepth 1 -type d | wc -l)
current_dir=0

for dir in */; do
    current_dir=$((current_dir+1))
    
    # Calculate percentage for the progress bar
    percentage=$((current_dir*100/total_dirs))
    
    # Verbose output
    echo "Processing directory: $dir"
    
    tar czf "${dir%/}.tar.gz" "$dir"
    
    if [ $? -eq 0 ]; then
        rm -r "$dir"
        echo "Successfully compressed and deleted $dir"
    else
        echo "Error compressing $dir. Skipping deletion."
    fi

    # Print progress bar
    progress_bar $percentage
    echo "" # Newline for clarity
done

echo "Process complete."
