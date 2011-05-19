#!bin/bash
ant \
        -Ddatabase.db=$1 \
        -Ddatabase.driver=com.mysql.jdbc.Driver \
        -Ddatabase.url=jdbc:mysql://127.0.0.1:3306/$1 \
        -Ddb.changelog.file=changelog/db.changelog-master.xml \
        -Ddatabase.username=banner \
        -Ddatabase.password=banner123 \
        update-database


FILES="procs/*"
for f in $FILES
do
        mysql -ubanner -pbanner123 $1 < $f
done