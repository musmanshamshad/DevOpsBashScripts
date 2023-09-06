#!/bin/bash

# Define backup directory and maximum number of backups to retain
backup_dir="/backup/project1/daily/"
max_backups_to_retain=4

# Create a timestamp for the backup filename
current_date=$(date +"%Y%m%d%H%M%S")
backup_filename="backup_${current_date}.zip"

# Create the backup
zip -r "${backup_dir}${backup_filename}" /home/projects/

# List all backup files in the backup directory, sorted by date (oldest first)
backup_files=($(ls -t "${backup_dir}"))

# Calculate the number of backups to delete
num_backups_to_delete=$((${#backup_files[@]} - $max_backups_to_retain))

# Delete older backups if necessary
if [ $num_backups_to_delete -gt 0 ]; then
    for ((i=0; i<$num_backups_to_delete; i++)); do
        file_to_delete="${backup_dir}${backup_files[$i]}"
        rm "$file_to_delete"
        echo "Deleted backup: $file_to_delete"
    done
fi

echo "Backup completed: ${backup_dir}${backup_filename}"

