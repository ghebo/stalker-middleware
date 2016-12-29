#!/bin/bash
################# Check process #######################
log=/var/log/catchup.log
now=$(date +"%Y%m%d-%H.mpg")
################# Check service #######################
for service in `cat /cs/ch_list.txt |cut -d " " -f 1`;do

        if (( $(ps -ef | grep -v grep | grep $service | wc -l) > 0 ))
        then
                echo "$(date) ----- $service is running!!!"
        else
                echo "---Start Log $service --------------------------------------------------------------------------" >> $log
                echo "$(date) ----- $service is Down!!!" >> $log
                echo "$(date) ----- Start install.sh" >> $log
                /var/www/stalker_portal/storage/./install.sh
                echo "$(date) ----- Start tvarchive.sh" >> $log
                /var/www/stalker_portal/storage/./tvarchive.sh
                echo "---End Log $service ----------------------------------------------------------------------------" >> $log
        fi
done
################# Check file #######################
for id in `cat /cs/ch_list.txt |cut -d " " -f 2`;do
        file="/var/www/archive/$id/$now"
        if [ -f "$file" ]
        then
                echo "$(date) ----- $file found !!!"
        else
                echo "---Start Log $service --------------------------------------------------------------------------" >> $log
                echo "$(date) ----- $file Missing !!!" >> $log
                servicekill=`cat /cs/ch_list.txt |grep $id |cut -d " " -f 1`
                echo "$(date) ----- Will kill $servicekill" >> $log
                pskill=`ps aux |grep $servicekill |grep $id |tr -s " " |cut -d " " -f 2`
                echo "$(date) ----- kill -9 $pskill !!!" >> $log
                kill -9 $pskill
                echo "$(date) ----- Start install.sh" >> $log
                /var/www/stalker_portal/storage/./install.sh
                echo "$(date) ----- Start tvarchive.sh" >> $log
                /var/www/stalker_portal/storage/./tvarchive.sh
                echo "---End Log $service ----------------------------------------------------------------------------" >> $log

        fi

done
