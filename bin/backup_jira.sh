#!/bin/bash
rtimestamp=$(date +%d%b%y)
backup_db_dir="/mnt/backups/jira"
backup_log="/mnt/backups/jira/backup.log"
data_dir="/var/atlassian/application-data/jira/data/attachments"
backup_data_dir="${backup_db_dir}"
DBS="jiradb"
db_user="jira"

function zero_log {
>$backup_log
}

function backup_db {
for db in $DBS
do
 echo "Backing up postgres database...${db}"
 /usr/bin/pg_dump -U ${db_user} -d ${db} | gzip > ${backup_db_dir}/${db}_backup_${rtimestamp}.gz 
 echo "done..."
done
}

function backup_fs_data {
echo "Backing up attachments..."
/usr/bin/rsync -avzh ${data_dir} ${backup_data_dir}
echo "done."
}

{
date ;
zero_log ;
backup_db ;
date;
backup_fs_data ;
date ;
} > $backup_log
