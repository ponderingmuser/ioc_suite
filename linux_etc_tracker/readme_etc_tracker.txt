To use this program, first run the etc_backups.sh script. 
This will create an initial md5 hash of your etc directory, create the secure_backups directory, as well as an archive of /etc to pull from for further analysis if changes are found in the /etc directory. 
If no changes are found, the script will generate a report stating that no changes have been found. 
If you wish to be alerted only if changes are found, comment out lines 25/27, 
echo "$(date +"%Y-%m-%d %H:%M:%S")" > $HOME/secure_backups/report.txt
echo "No differences have been found." >> $HOME/secure_backups/report.txt 
This script as configured will generate 7 reports, and then start deleting the older ones, in the $HOME/secure_backups/old directory.

It is recommended that you configure the permissions of secure_backups properly; use sudo chmod 700. 
I have included the scripts that were the building blocks for the final script as well, if you would like to separate the steps, or see the process more clearly. 
These are in a more "raw" form, and do not have the file cleanup functionality, but in some ways that might be helpful, as you can track the generation of the files the script uses to create the final report. 

This program is designed to track line-by-line changes to the /etc directory in Linux over time. 
Many of the main indicators of compromise on Linux machines involve changes to accounts, the hosts file, and various configuration files, all of which can be found in the /etc directory. 
Of course the /etc directory will have normal changes; anytime that a user account is added, removed, or modified, as well as whenever a new program is installed or program settings modified, there will be changes to /etc.
However, these changes should be documented, and so when running this scan one should already know what changes to expect in the change report. If anything else is found, that could be an indicator of a misconfiguration, unauthorized applications being installed, or even an intrusion. 
