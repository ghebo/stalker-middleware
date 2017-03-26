#/bin/bash

##################### Modify only below !!!  #####################
_SERVER=10.10.0.5
_PORT=88
_FILENAME=catchup-list
_LOGFILE=/var/log/catch.log
#################### Do not modify below !!! #####################

_FILEURL=http://${_SERVER}:${_PORT}/${_FILENAME}
_FILE=/tmp/${_FILENAME}
_NOW=$(date +"%d.%m.%Y - %T")

createlogs(){
        case $2 in
                missing) echo "${_NOW} ---> ERROR | $1 missing for ch_id = ${_CHID}. Starting scripts /var/${_FOLDER}/stalker_portal/storage/" >> ${_LOGFILE}
                        ;;
                exist) echo "${_NOW} ---> $1 exist for ch_id = ${_CHID}" >> ${_LOGFILE}
                        ;;
        esac
}

if [[ $1 == "--update" ]]
then
        cd /tmp/
        wget ${_FILEURL}
fi

if [ ! -f "${_FILE}" ]
then
        cd /tmp/
        wget ${_FILEURL}
fi

for _FOLDER in $(ls /var |grep www)
do
        for _SERVER in $(cat ${_FILE} | sed 's/\s\s*/ /g' | cut -d':' -f2)
        do
                _CC=$(cat /var/${_FOLDER}/stalker_portal/storage/config.php |grep "'${_SERVER}');")
                if [[ ${_CC} == *"define"*${_SERVER}* ]]
                then
                        _CHID=`cat ${_FILE} |grep ${_SERVER}$ | sed 's/\s\s*/ /g' | cut -d':' -f1`
                        _PROCESS=$(ps -ef | grep -v grep | grep "/var/${_FOLDER}/stalker_portal/storage/dumpstream" | wc -l)
                        _PROCESSID=$(ps aux | grep "/var/${_FOLDER}/stalker_portal/storage/dumpstream" |grep python |tr -s " " |cut -d " " -f 2)
                        echo procces= ${_PROCESS} folder= ${_FOLDER} server= ${_SERVER} chid= ${_CHID} processid= ${_PROCESSID}
                        if (( ${_PROCESS} > 0 ))
                        then
                                createlogs Process exist
                        else
                                createlogs Procces missing
                                /var/${_FOLDER}/stalker_portal/storage/./install.sh
                                /var/${_FOLDER}/stalker_portal/storage/./tvarchive.sh
                        fi
                        _CHFILE="/var/www/archive/${_CHID}/$(date +"%Y%m%d-%H.mpg")"
                        if [ -f "${_CHFILE}" ]
                        then
                                createlogs ${_CHFILE} exist
                        else
                                createlogs ${_CHFILE} missing
                                kill -9 $_PROCESSID
                                /var/${_FOLDER}/stalker_portal/storage/./install.sh
                                /var/${_FOLDER}/stalker_portal/storage/./tvarchive.sh
                        fi
                fi
        done
done
