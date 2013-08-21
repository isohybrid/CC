#!/bin/bash
PWD=/data/from_dq/tickdump/
HOSTNAME="localhost"
USERNAME="root"
PASSWORD="qq"

mysql -h "$HOSTNAME" -u "$USERNAME" -p"$PASSWORD" <<'EOF'
USE tickdump;
CREATE TABLE Index(symbol INT,date DATE,time INT,open INT,high INT,low INT,last INT,totalvolume INT,turnover INT,prevClose INT);
\q
EOF

for dirname in `ls $PWD`
do
  date=`echo $dirname|sed -r 's/([0-9]{4})([0-9]{2})([0-9]{2})/\1-\2-\3/'`
  echo $date
  for file in `ls ${PWD}${dirname}`
  do
     if [ "$file" = "Index.csv" ]
     then
        path=${PWD}${dirname}"/""Index.csv"
        sed -r "1d;/^[0-9]/s/,/,$date,/" $path > /data/Index.csv
        mysql --local-infile=1 -h "$SHOSTNAME" -u "$USERNAME" -p"$PASSWORD" <<'EOF'
USE tickdump;
LOAD DATA LOCAL INFILE '/data/Index.csv'
INTO TABLE Index
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';
\q
EOF
        [ $? -eq 0 ]&&echo "mysql conncet success!-----YoXi!!!O.O.-.-..."
     fi
  done
done
