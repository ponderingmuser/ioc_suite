#!/bin/bash



# Directory for the backups

BACKUP_DIR=/home/bsand/secure_backups

OLD_BACKUP_DIR="$BACKUP_DIR/old"



# Generate the hash of all files in the /etc directory

sudo find /etc -type f -exec md5sum {} \; > "$BACKUP_DIR/scan.txt"



# Compare the outputs

DIFFERENCES=$(diff "$BACKUP_DIR/etc_sums"* "$BACKUP_DIR/scan.txt" | grep -vE '\/etc\/.*-')



# Check if differences are found

if [ ! -z "$DIFFERENCES" ]; then

    echo "$DIFFERENCES" | tee "$BACKUP_DIR/differences_$(date +%F_%H-%M-%S).txt"



    # Since differences are found, you can perform the 'diff' on the actual files here



    # Example using the actual files (this is just a placeholder; you'll need to extract and compare):

    # diff old_backup_file current_file > "$BACKUP_DIR/file_diff_$(date +%F_%H-%M-%S).txt"



fi



# Move the old backup and hashes



mv "$BACKUP_DIR/etc_sums"* "$BACKUP_DIR/old/etc_sums1.txt"

mv "$BACKUP_DIR/etc_backup"* "$BACKUP_DIR/old/etc_backup1.tar.gz"

mv "$BACKUP_DIR/scan.txt" "$BACKUP_DIR/etc_sums_$(date +%F_%H-%M-%S).txt"



# Create a new backup to be used for the following scan



sudo tar cfz "$BACKUP_DIR/etc_backup_$(date +%F_%H-%M-%S).tar.gz" /etc
