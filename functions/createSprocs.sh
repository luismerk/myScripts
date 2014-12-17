function createSprocs {

    #GetMultiple Sproc
    filename='outputFiles/dbo.'${lines[0]}'GetMultiple.sql'
    filename=${filename//[[:space:]]/}
    echo "Creating... "$filename

    echo "SET ANSI_NULLS ON" > $filename
    echo "GO" >> $filename
    echo "SET QUOTED_IDENTIFIER ON" >> $filename
    echo "GO" >> $filename
    sproc=${lines[0]}'GetMultiple'
    sproc=${sproc//[[:space:]]/}
    echo "ALTER PROCEDURE [dbo].["${sproc//[[:space:]]/}"]" >> $filename
    echo "AS" >> $filename
    echo "SELECT" >> $filename

    lastLine=`expr $numberOfLines - 1`

    for (( i = 1 ; i < numberOfLines; i++ ))
    do
        set -- ${lines[$i]}
        first=$1
        second=$2
        if [ $i -eq $lastLine ]; then
            echo "    "$first >> $filename
        else
            echo "    "$first"," >> $filename
        fi
    done

    echo "FROM" >> $filename
    echo "    dbo."${lines[0]}" WITH (NOLOCK)" >> $filename
    echo "" >> $filename
    echo "GO" >> $filename

    #GetDetail Sproc
    filename='outputFiles/dbo.'${lines[0]}'GetDetail.sql'
    filename=${filename//[[:space:]]/}
    echo "Creating... "$filename

    echo "SET ANSI_NULLS ON" > $filename
    echo "GO" >> $filename
    echo "SET QUOTED_IDENTIFIER ON" >> $filename
    echo "GO" >> $filename
    sproc=${lines[0]}'GetDetail'
    sproc=${sproc//[[:space:]]/}
    echo "ALTER PROCEDURE [dbo].["${sproc//[[:space:]]/}"] (" >> $filename
    echo "    @"${lines[1]//,/} >> $filename
    echo ")" >> $filename
    echo "AS" >> $filename
    echo "SELECT" >> $filename

    for (( i = 1 ; i < numberOfLines; i++ ))
    do
        set -- ${lines[$i]}
        first=$1
        second=$2
        if [ $i -eq $lastLine ]; then
            echo "    "$first >> $filename
        else
            echo "    "$first"," >> $filename
        fi
    done

    echo "FROM" >> $filename
    echo "    dbo."${lines[0]}" WITH (NOLOCK)" >> $filename
    echo "WHERE" >> $filename
    set -- ${lines[1]}
    first=$1
    echo "    "$first" = @"$first >> $filename
    echo "" >> $filename
    echo "GO" >> $filename


    #Insert Sproc
    filename='outputFiles/dbo.'${lines[0]}'Insert.sql'
    filename=${filename//[[:space:]]/}
    echo "Creating... "$filename

    echo "SET ANSI_NULLS ON" > $filename
    echo "GO" >> $filename
    echo "SET QUOTED_IDENTIFIER ON" >> $filename
    echo "GO" >> $filename
    sproc=${lines[0]}'Insert'
    sproc=${sproc//[[:space:]]/}
    echo "ALTER PROCEDURE [dbo].["${sproc//[[:space:]]/}"] (" >> $filename
    for (( i = 2 ; i < numberOfLines; i++ ))
    do
        if [ $i -eq $lastLine ]; then
            echo "    @"${lines[$i]//,/} >> $filename
        else
            echo "    @"${lines[$i]} >> $filename
        fi
    done
    echo ")" >> $filename
    echo "AS" >> $filename
    echo "INSERT INTO "${lines[0]} >> $filename
    echo "(" >> $filename
    for (( i = 1 ; i < numberOfLines; i++ ))
    do
        set -- ${lines[$i]}
        first=$1
        second=$2
        if [ $i -eq $lastLine ]; then
            echo "    "$first >> $filename
        else
            echo "    "$first"," >> $filename
        fi
    done
    echo ")" >> $filename
    echo "SELECT" >> $filename
    for (( i = 1 ; i < numberOfLines; i++ ))
    do
        set -- ${lines[$i]}
        first=$1
        second=$2
        if [ $i -eq $lastLine ]; then
            echo "    @"$first >> $filename
        else
            echo "    @"$first"," >> $filename
        fi
    done
    echo "" >> $filename
    echo "GO" >> $filename


    #Update Sproc
    filename='outputFiles/dbo.'${lines[0]}'Update.sql'
    filename=${filename//[[:space:]]/}
    echo "Creating... "$filename

    echo "SET ANSI_NULLS ON" > $filename
    echo "GO" >> $filename
    echo "SET QUOTED_IDENTIFIER ON" >> $filename
    echo "GO" >> $filename
    sproc=${lines[0]}'Update'
    sproc=${sproc//[[:space:]]/}
    echo "ALTER PROCEDURE [dbo].["${sproc//[[:space:]]/}"] (" >> $filename
    for (( i = 1 ; i < numberOfLines; i++ ))
    do
        if [ $i -eq $lastLine ]; then
            echo "    @"${lines[$i]//,/} >> $filename
        else
            echo "    @"${lines[$i]} >> $filename
        fi
    done
    echo ")" >> $filename
    echo "AS" >> $filename
    echo "UPDATE "${lines[0]} >> $filename
    echo "SET" >> $filename
    for (( i = 1 ; i < numberOfLines; i++ ))
    do
        set -- ${lines[$i]}
        first=$1
        second=$2
        if [ $i -eq $lastLine ]; then
            echo "    "$first" = @"$first >> $filename
        else
            echo "    "$first" = @"$first"," >> $filename
        fi
    done
    echo "" >> $filename
    echo "GO" >> $filename

}