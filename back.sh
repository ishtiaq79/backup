#!/bin/bash
# Backup rotation
# Ishtiaq Ahmed 


# Storage folder where to move backup files
# Must contain backup.monthly backup.weekly backup.daily folders
storage=/root/source_folder

# Source folder where files are backed
source=$storage

# Destination file names
date_daily=`date +"%d%m%Y"`
#date_weekly=`date +"%V sav. %m-%Y"`
#date_monthly=`date +"%m-%Y"`

# Get current month and week day number
month_day=`date +"%d"`
week_day=`date +"%u"`

# Optional check if source files exist. Email if failed.
if [ -d $source ]; then
#ls -l $source/ | mail ishtiaq.ciit@hotmail.com -s "[backup script] Daily backup failed! Please check for missing files."
	echo "source folder exist "
else
	echo "source folder doesn't exist"
fi

# It is logical to run this script daily. We take files from source folder and move them to
# appropriate destination folder

# On first of every month
if [ "$month_day" -eq 1 ] ; then
	if [ -d /mnt/test_nas/$(hostname)/backup.monthly/  ]; then
		echo "backup.monthly folder exist"
	else
		echo " From month block: /mnt/test_nas/$(hostname)/backup.monthly/$date_daily"
		mkdir -p /mnt/test_nas/$(hostname)/backup.monthly/$date_daily
        fi
  destination=/mnt/test_nas/$(hostname)/backup.monthly/$date_daily
fi
 
# On every saturdays
if [ "$week_day" -eq 6 ] ; then
	if [ -d /mnt/test_nas/$(hostname)/backup.weekly/  ]; then
		echo "backup.weekly folder exist"
	else
		echo "From saturday: /mnt/test_nas/$(hostname)/backup.weekly/$date_daily"
		mkdir -p /mnt/test_nas/$(hostname)/backup.weekly/$date_daily
        fi
	destination=/mnt/test_nas/$(hostname)/backup.weekly/$date_daily
else
#On every day of a week
	if [ -d /mnt/test_nas/$(hostname)/backup.daily/  ]; then
		echo "backup.daily folder exist"
	else
		echo "From weekday: /mnt/test_nas/$(hostname)/backup.daily/$date_daily"
		mkdir -p /mnt/test_nas/$(hostname)/backup.daily/$date_daily
        fi
    	destination=/mnt/test_nas/$(hostname)/backup.daily/$date_daily
fi

# Move the files
#mkdir $destination
#mv -v $source/* $destination
scp -v $source/* $destination
#/usr/bin/rsync -avpPhh  --no-o --no-g --ignore-errors --inplace  $storage/*  $destination

if [ -d /mnt/test_nas/$(hostname)/backup.monthly/ ]; then
# monthly - keep for 300 days
	ls /mnt/test_nas/$(hostname)/backup.monthly/
	find /mnt/test_nas/$(hostname)/backup.monthly/ -maxdepth 1 -mtime +300 -type d -exec rm -rv {} \;
fi

if [ -d /mnt/test_nas/$(hostname)/backup.weekly/ ]; then
# weekly - keep for 60 days
	ls /mnt/test_nas/$(hostname)/backup.weekly/ 
	find /mnt/test_nas/$(hostname)/backup.weekly/ -maxdepth 1 -mtime +30 -type d -exec rm -rv {} \;
fi

if [ -d /mnt/test_nas/$(hostname)/backup.daily/ ]; then
# daily - keep for 14 days
	ls /mnt/test_nas/$(hostname)/backup.daily/
	find /mnt/test_nas/$(hostname)/backup.daily/ -maxdepth 1 -mtime +3 -type d -exec rm -rv {} \;
fi



