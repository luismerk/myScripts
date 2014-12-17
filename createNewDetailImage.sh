#!/bin/bash


filelist=`ls -a *.zoom.*.jpg`

echo 'File Start' > createNewDetail_output.txt
echo ''

for file in $filelist; do

    detailFile=${file/zoom/detail}
    if [ -e ${file/zoom/detail} ]; then
        if [ ! -e old_productDetail/${file/zoom/detail} ]; then
            echo 'About to archive' $detailFile
            mv $detailFile old_productDetail
            echo 'Moved '${file/zoom/detail}' to archive folder'
            echo 'Moved '${file/zoom/detail}' to archive folder' >> createNewDetail_output.txt
        else
            echo 'Skipped '$detailFile' - file already exists';
        fi
    fi

    echo 'Created '${file/zoom/detail}
    echo 'Created '${file/zoom/detail} >> createNewDetail_output.txt
    echo ''

    (/c/Program\ Files/ImageMagick-6.8.7-Q16/convert.exe $file -define jpeg:size=2.5*450x2.5*642 -auto-orient -thumbnail 450x642 -interlace Plane -quality 70 -unsharp 2.166666667x1.471960145+0.5+0.05 $detailFile)
done

echo "Completed"
