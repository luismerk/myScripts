#!/bin/bash

source "functions/createSprocs.sh"

IFS=$'\n' read -d '' -r -a lines < inputFiles/variableList.txt

#Up Migration
filename='outputFiles/'${lines[0]}'_up.sql'
filename=${filename//[[:space:]]/}

numberOfLines=${#lines[@]}
lastLine=`expr $numberOfLines - 1`

echo "Creating... "$filename

echo "SET ANSI_NULLS ON" > $filename
echo "GO" >> $filename
echo "SET QUOTED_IDENTIFIER ON" >> $filename
echo "GO" >> $filename
echo "SET ANSI_PADDING ON" >> $filename
echo "GO" >> $filename
echo "CREATE TABLE [dbo].["${lines[0]}"] (" >> $filename

for (( i = 1 ; i < numberOfLines;  i++ ))
do
	#echo "    "${lines[$i]} >> $filename
    if [ $i -eq $lastLine ]; then
        echo "    @"${lines[$i]}"," >> $filename
    else
        echo "    @"${lines[$i]} >> $filename
    fi
done
echo "CONSTRAINT [PK_"${lines[0]}"] PRIMARY KEY CLUSTERED" >> $filename
echo "(" >> $filename
        set -- ${lines[1]}
        first=$1
echo "    "$first" ASC" >> $filename
echo ") WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]" >> $filename
echo "GO" >> $filename


declare -a arr=("GetDetail" "GetMultiple" "Insert" "Update" "Delete")

## now loop through the above array
for i in "${arr[@]}"
do
    echo "" >> $filename
    sproc=${lines[0]}${i}
    sproc=${sproc//[[:space:]]/}
    echo "CREATE PROCEDURE [dbo].["${sproc//[[:space:]]/}"]" >> $filename
    echo "AS" >> $filename
    echo "BEGIN EXEC('');" >> $filename
    echo "END" >> $filename
    echo "" >> $filename
    echo "GO" >> $filename
    echo "" >> $filename
    # or do whatever with individual element of the array
done


#Down Migration
filename='outputFiles/'${lines[0]}'_down.sql'
filename=${filename//[[:space:]]/}
echo "Creating... "$filename

echo "DROP TABLE" ${lines[0]} > $filename
echo "GO" >> $filename

## now loop through the above array
for i in "${arr[@]}"
do
    echo "" >> $filename
    sproc=${lines[0]}${i}
    sproc=${sproc//[[:space:]]/}
    echo "IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].["${sproc//[[:space:]]/}"]') AND type in (N'P', N'PC'))" >> $filename
    echo "DROP PROCEDURE [dbo].["${sproc//[[:space:]]/}"]" >> $filename
    echo "" >> $filename
    echo "GO" >> $filename
    echo "" >> $filename
    # or do whatever with individual element of the array
done

createSprocs


	#echo -e "\t" $first " " $second
	#echo "    "${lines[$i]} > $filename
	#echo "${lines[$i]}"

#printf "%s" "${lines[@]}"

#echo "${lines}" | sed -e 's/^[ \t]*//'
