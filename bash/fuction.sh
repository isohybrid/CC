######################################

传递间接引用给参数
######################################
#! /bin/bash
# ind_func.sh

echo_var(){
echo "$1"
}

message=hello
hello=goodbye

echo_var "$message"        #hello
echo_var "${!message}"     #goodbye

echo "-------------"
hello="Hello,again"

echo_var "$message"        #hello
echo_var "${!message}"     #Hello,again

exit 0

########################################
再次尝试解除传递给函数的参数引用
########################################
dereference(){
  y=\$"$1"
  echo $y
  
  x=`eval "expr \"$y\" "` 
  echo $1=$x
  eval "$1=\"some diffrent text\""
  
}

junk="some text"
echo $junk "before"

deference junk
echo $junk "after"

exit
###########################################
ITERATIONS=3
icount=1

my_read(){
  local local_val
  echo -n "Enter a valaue"
  eval 'echo -n "[$'$1']"'
  
  read local_val
  [-n local_val] && eval $1=\$local_val
}

echo

while ["$icount" -le "$ITERATIONS"]
do
  my_read var
  echo "Enter #$icount = $var"
  let "icount+=1"
  echo
done

exit 0

#######################################################
#! /bin/bash
ARGCOUNT=1
E_WRONGARS=65

file=/etc/passwd
pattern=$1

if [$# -ne "$ARGCOUNT"]
then
  echo "Usage: `basename $0` USERNAME"
  exit $E_WRONGARGS
fi

file_wxcerpt()
{
while read line
do
  echo "$line" | grep $1 | awk -F":" '{print $5}'
done
} < $file

file_excerpt $PATTERN

exit 0
#could be replaced by 
#grep PARTTERN /etc/passwd | awk -F":" '{print $5}' 
#awk -F: '/PARTTERN/ {print $5}'
#awk -F: '($1==USERNAME) {print $5}' --------real name fomr username

function()
{
...
} < file

function()
{
  {
  ...
  } < file
}

function()
{
  {
    echo $*  
  } | tr a b
}
-----------------------------------------work

function()
{
  echo $*
} | tr a b

------------------------------------------not work
