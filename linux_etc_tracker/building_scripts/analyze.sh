#!/bin/bash



REPORT_FILE="/home/bsand/secure_backups/report.txt"  # Pass the report filename as an argument to this script

ARCHIVE=$(echo $HOME/secure_backups/old/etc_backup1.tar.gz)  # Modify this path accordingly

DIFF_RESULTS="$HOME/secure_backups/analysis.txt"  # Name for the diff results file



# Get the changed files from the report, strip leading "/", and write to a temporary file



awk '/^Changed files:/,/^$/' "$REPORT_FILE" | sed -e '1d' -e '$d' | sed 's/^\///' > tmp_changed_files.txt



# Extract these files from the archive to a temporary directory

mkdir tmp_etc_files

tar -xzvf "$ARCHIVE" -C tmp_etc_files/ -T tmp_changed_files.txt



# Now, diff the extracted files with system files and write the differences to the results file

while IFS= read -r file; do

    echo "Diff for $file:" >> "$DIFF_RESULTS"

    sudo diff "/$file" "tmp_etc_files/$file" >> "$DIFF_RESULTS"

    echo >> "$DIFF_RESULTS"

done < tmp_changed_files.txt



# Cleanup

rm tmp_changed_files.txt

rm -r tmp_etc_files/

mv "$REPORT_FILE" "$HOME/secure_backups/old/report1.txt" 

echo "Diff results saved to $DIFF_RESULTS"

