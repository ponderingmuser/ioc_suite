#!/bin/bash


# Directory for the backups

BACKUP_DIR=/home/bsand/secure_backups

OLD_BACKUP_DIR="$BACKUP_DIR/old"


# Generate the hash of all files in the /etc directory

sudo find /etc -type f -exec md5sum {} \; > "$BACKUP_DIR/scan.txt"


# Compare the outputs

DIFFERENCES=$(diff "$BACKUP_DIR/etc_sums"* "$BACKUP_DIR/scan.txt" | grep -vE '\/etc\/.*-')


# Check if differences are found

if [ -z "$DIFFERENCES" ]; then

    echo "$(date +"%Y-%m-%d %H:%M:%S")" > $HOME/secure_backups/report.txt

    echo "No differences have been found." >> $HOME/secure_backups/report.txt

    rm "$BACKUP_DIR/scan.txt"

    exit 0  # Exit gracefully

    

else

    echo "$DIFFERENCES" > "$BACKUP_DIR/differences_$(date +%F_%H-%M-%S).txt"



    # Your further processing ...

fi



# Move the old backup and hashes



mv "$BACKUP_DIR/etc_sums"* "$BACKUP_DIR/old/etc_sums1.txt"

mv "$BACKUP_DIR/etc_backup"* "$BACKUP_DIR/old/etc_backup1.tar.gz"

mv "$BACKUP_DIR/scan.txt" "$BACKUP_DIR/etc_sums_$(date +%F_%H-%M-%S).txt"



# Create a new backup to be used for the following scan



sudo tar cfz "$BACKUP_DIR/etc_backup_$(date +%F_%H-%M-%S).tar.gz" /etc 2>/dev/null



# Redirect all outputs to report.txt

echo "$(date +%F_%H-%M-%S)" > $HOME/secure_backups/report.txt

exec >> $HOME/secure_backups/report.txt 2>&1



DIFF_FILE=$(echo $HOME/secure_backups/differences*)





CHANGED=()

ADDED=()

REMOVED=()



# Read the diff file line by line

while IFS= read -r line; do

    if [[ $line == "< "* ]]; then

        # Capture the removed filepath

        filepath=$(echo "$line" | awk '{print $3}')

        REMOVED+=("$filepath")

    elif [[ $line == "> "* ]]; then

        # Capture the added filepath

        filepath=$(echo "$line" | awk '{print $3}')

        ADDED+=("$filepath")

    fi

done < "$DIFF_FILE"



# Identify changed files (present in both ADDED and REMOVED arrays)

for added_file in "${ADDED[@]}"; do

    for removed_file in "${REMOVED[@]}"; do

        if [ "$added_file" == "$removed_file" ]; then

            CHANGED+=("$added_file")

        fi

    done

done



# Removing duplicates

CHANGED=($(echo "${CHANGED[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))



# Output the results

echo "Changed files:"

printf "%s\n" "${CHANGED[@]}"

echo



echo "Added files:"

for file in "${ADDED[@]}"; do

    if ! [[ " ${CHANGED[@]} " =~ " ${file} " ]]; then

        echo "$file"

    fi

done

echo



echo "Removed files:"

for file in "${REMOVED[@]}"; do

    if ! [[ " ${CHANGED[@]} " =~ " ${file} " ]]; then

        echo "$file"

    fi 

done



rm "$DIFF_FILE"



REPORT_FILE="/home/bsand/secure_backups/report.txt"  # Pass the report filename as an argument to this script

ARCHIVE=$(echo $HOME/secure_backups/old/etc_backup*.tar.gz)  # Modify this path accordingly

DIFF_RESULTS="$HOME/secure_backups/analysis.txt"  # Name for the diff results file



# Get the changed files from the report, strip leading "/", and write to a temporary file



awk '/^Changed files:/,/^$/' "$REPORT_FILE" | sed -e '1d' -e '$d' | sed 's/^\///' > tmp_changed_files.txt



# Extract these files from the archive to a temporary directory

mkdir tmp_etc_files

tar -xzf "$ARCHIVE" -C tmp_etc_files/ -T tmp_changed_files.txt



# Now, diff the extracted files with system files and write the differences to the results file

echo "----" >> "$REPORT_FILE"

while IFS= read -r file; do

    echo "Diff for $file:" >> "$REPORT_FILE"

    sudo diff "/$file" "tmp_etc_files/$file" >> "$REPORT_FILE"

    echo >> "$REPORT_FILE"

    

done < tmp_changed_files.txt





# Cleanup

rm tmp_changed_files.txt

rm -r tmp_etc_files/ 

sudo rm "$HOME/secure_backups/old/etc_backup1.tar.gz"

rm "$HOME/secure_backups/old/etc_sums1.txt"

cp "$HOME/secure_backups/report.txt" "$HOME/secure_backups/old/report_$(date +%F_%H-%M).txt"



REPORTS_DIR="$HOME/secure_backups/old" # Directory where your reports are stored

MAX_REPORTS=7 # Number of reports to retain



# Create an array of report files sorted by modification time (oldest first)

REPORTS=($(ls -t1 "$REPORTS_DIR/report_"*))



# If the number of reports is greater than the maximum allowed, delete the oldest ones

while [ ${#REPORTS[@]} -gt $MAX_REPORTS ]; do

    oldest_report=${REPORTS[0]} # The oldest report is the first one in the array

    rm -f "$oldest_report"

    

    # Remove the oldest report from the reports array

    REPORTS=("${REPORTS[@]:1}")

done



