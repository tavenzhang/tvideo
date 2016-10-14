#!/bin/sh
cd $1
# 1 遍历$1文件夹下的所有文件，即所有图片素材了。
for file in `ls`
do
  #  echo $file
    newfile=`echo $file|sed 's/\(.*\)\(\..*\)/'$2'\1\2/g'`
    echo $file "-->" $newfile
    mv $file $newfile
done
#mv $file `echo $file|sed -r 's/(.*)(\..*)/\1_aaa\2/g'`