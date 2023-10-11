#!/bin/bash



# Directory for the backups

mkdir "$HOME/secure_backups"

BACKUP_DIR=~/secure_backups



# Generate the hash of all files in the /etc directory

sudo find /etc -type f -exec md5sum {} \; > "$BACKUP_DIR/etc_sums_$(date +%F_%H-%M-%S).txt"



# Create a compressed backup of the /etc directory using gzip

sudo tar cfz "$BACKUP_DIR/etc_backup_$(date +%F_%H-%M-%S).tar.gz" /etc



mkdir "$BACKUP_DIR/old"

