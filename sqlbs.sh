#!/bin/bash

# MySQL database credentials
db_user="musmanshamshad"
db_password="laptop"
db_name="fake_data"

# Backup directory
backup_dir="/backup/project1/daily/"

# Create a timestamp for the backup filename
current_date=$(date +"%Y%m%d%H%M%S")
backup_sql_filename="${db_name}_${current_date}.sql"
backup_zip_filename="${db_name}_${current_date}.zip"

# Perform the database backup
mysqldump -u$db_user -p$db_password $db_name > "$backup_dir/$backup_sql_filename"

# Compress the SQL backup into a ZIP file without paths
zip -j "$backup_dir/$backup_zip_filename" "$backup_dir/$backup_sql_filename"

# Remove the original SQL backup
rm "$backup_dir/$backup_sql_filename"

# List all backup files in the backup directory, sorted by date (oldest first)
backup_files=($(ls -t "$backup_dir"))

# Calculate the number of backups to delete
max_backups_to_retain=3
num_backups_to_delete=$((${#backup_files[@]} - $max_backups_to_retain))

# Delete older backups if necessary
if [ $num_backups_to_delete -gt 0 ]; then
    for ((i=0; i<$num_backups_to_delete; i++)); do
        file_to_delete="$backup_dir/${backup_files[$i]}"
        rm "$file_to_delete"
        echo "Deleted backup: $file_to_delete"
    done
fi

echo "Backup completed: $backup_dir/$backup_zip_filename"

