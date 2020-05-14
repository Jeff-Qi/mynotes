#!/bin/bash
#time.sh --- 3.0
backfile="$1+backup"
echo "change time format!"
echo "backup source file to $backfile ..."
cp -a $1 $backfile
echo "backup successfully! start to change for format ..."
sed -i "s/[ ]\([0-9]:.*\)$/0\1/" $1
sed -i "s/\(# Time: \)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\) \(.\{8\}\)/\120\2-\3-\4T\5\.Z/" $1

#time.sh --- 2.0
#for i in `grep -E '^# Time' $1 | awk -F' ' '{print $3}' | sort | uniq`;
#do
#   sed -i "s/$i/20${i:0:2}-${i:2:2}-${i:4:2}T/g" $1
#done
#sed -i "s/[ ]\{2\}/ 0/g" $1
#sed -i "s/T /T/g" $1
#sed -i "s/$/\.Z/g" $1
#for j in `grep -E '^# Time' $1 | awk -F' ' '{print $4}'`;
#do
#   H=`echo $j | awk -F':' '{print $1}'`
#   M=`echo $j | awk -F':' '{print $2}'`
#   S=`echo $j | awk -F':' '{print $3}'`
#   if [[ $H -lt 10 ]];
#   then
#       H=0$H
#   fi
#   sed -i "s/T[ ]\{1,2\}$j/T$H:$M:$S\.Z/" $1
#done
echo "change successfully! exit!"
exit 0



#!/bin/bash
#time.sh --- 1.0
# tmpfile='/tmp/tmptimefile'
# backfile="$1+backup"
# word='T'
# echo "创建临时文件！路径： $tmpfile"
# sed -n '/# Time/p' $1 | grep -Eo '[0-9]*' > $tmpfile
# echo "备份文件..."
# cp -a $1 $backfile
# echo "备份完成!"
#
# count=1
# Y=0
# M=0
# D=0
# h=0
# m=0
# s=0
#
# for i in `cat $tmpfile`;
# do
#         if [[ $count -eq 1 ]];
#         then
#                 Y=${i:0:2}
#                 M=${i:2:2}
#                 D=${i:4:2}
#                 count=$[count+1]
#         elif [[ $count -eq 2 ]];
#         then
#                 h=$i
#                 count=$[count+1]
#         elif [[ $count -eq 3 ]];
#         then
#                 m=$i
#                 count=$[count+1]
#         elif [[ $count -eq 4 ]];
#         then
#                 s=$i
#                 sed -i "s/# Time: $Y$M$D[ ]\{1,2\}$h:$m:$s/# Time: 20$Y-$M-$D$word$h:$m:$s\.Z/" $1
#                 count=1
#         fi
# done
#
# grep ^'# Time' $1
# echo "替换完成!删除临时文件 $tmpfile"
# rm -rf $tmpfile
#
# echo "退出！"
# exit 0
