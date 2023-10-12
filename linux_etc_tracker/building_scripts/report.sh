#!/bin/bash



# Check if a differences file exists

if [[ ! -e $HOME/secure_backups/differences* ]]; then

    echo "No differences file found. Exiting..."

    exit 1

fi



# Redirect all outputs to report.txt

exec > $HOME/secure_backups/report.txt 2>&1



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



mv "$DIFF_FILE" "$HOME/secure_backups/old/differences1.txt"

