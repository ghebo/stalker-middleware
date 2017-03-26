#/bin/bash

##################### Modify only below !!!  #####################
_MYSQLUSER=root
_MYSQLPASS=myrootsuperpass123
_DBNAME=stalker_db
_WEBDIR=/var/www/
_LOGFILE=/var/log/catch.log
#################### Do not modify below !!! #####################

mysql -u${_MYSQLUSER} -p${_MYSQLPASS} -e "SELECT  ch_id ,  storage_name FROM  ${_DBNAME}.tv_archive ORDER BY  storage_name into outfile '/tmp/catchup-list' FIELDS TERMINATED BY ':'"
mv /tmp/catchup-list /var/www
