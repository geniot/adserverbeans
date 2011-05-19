 ant ^
    -Ddatabase.db=%1 ^
    -Ddatabase.driver=com.mysql.jdbc.Driver ^
    -Ddatabase.url=jdbc:mysql://127.0.0.1:3306/%1 ^
    -Ddb.changelog.file=changelog/db.changelog-master.xml ^
    -Ddatabase.username=banner ^
    -Ddatabase.password=banner123 ^
    update-database ^
    && For %%x In (procs/*.sql) do Mysql -ubanner -pbanner123 %1 < procs/%%x