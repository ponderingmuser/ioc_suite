#!/bin/bash



DIR_PATH="/home/bsand/secure_backups/old"  # Adjust this path accordingly



# If scan7 exists, delete it

if [ -e "${DIR_PATH}/scan7" ]; then

    rm "${DIR_PATH}/scan7"

fi



# Rename files, starting from the oldest

for i in 6 5 4 3 2 1; do

    next=$((i+1))

    if [ -e "${DIR_PATH}/scan${i}" ]; then

        mv "${DIR_PATH}/scan${i}" "${DIR_PATH}/scan${next}"

    fi

done



# Rename the newest and second newest files

if [ -e "${DIR_PATH}/scan" ]; then

    mv "${DIR_PATH}/scan" "${DIR_PATH}/oldscan"

fi



# At this point, you can go ahead and create your new "scan" file.

