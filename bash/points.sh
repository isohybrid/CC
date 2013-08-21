[[ -r /etc/passwd]] && REPLY=$(echo $(wc -l < /etc/passwd)) 
#echo的作用是删除输出中的多余空白字符


month_length(){
  monthD="31 28 31 30 31 30 31 31 30 31 30 31"
  echo "$monthD" | awk '{ print $'"${1}"'}'
}
#先将参数传递到函数中（$1----月份号），然后就到awk脚本了

if [ ! -z "$1"] && echo "Argument #1 =$1" && echo "Argument #2 =$2"

#注意"if [! -z $1]"可以工作，但是它是有所假定的等价物
#if [ -n $1]不会工作
#但是加引用可以工作
#if [-n "$1"]


cat /dev/null > /var/log/messages
# : > /var/log/messages 有同样的效果，但是不会产生新的进程（因为：是内建的）


sed -n '1p' testa|diff - testb
1c1
< aaaaaaaa
---
> aaaaabbb
这“-“就代表标准输入了

a=3.14
echo $((${a//.*/+1}))
4

${a//.*/}去掉小数点后面的数
$(())算数运算


sed '
/^$/!{
H
d
}
/^$/{
x
s/^\n/<p>/
s/$/<\/p>/
G
}
'
$匹配模式空间结尾末端换行符
Ｈｏｌｄ命令在保持空间中在模式空间放入之前放置换行符

checkbook.awk
BEGIN{FS=''}
NR == 1{ print "bneginning balance \t" $1
balance = $1
next  #取得下一条记录并结束
}
} 
