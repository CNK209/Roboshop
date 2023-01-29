script_location=$(pwd)
LOG=/tmp/roboshop.log

STATUS_CHECK(){
  if [ $? -eq 0 ];then
    echo -e "\e[32m SUCCESS \e[0m"
    else
      echo -e "\e[31m FAILED \e[0m"
      echo "refer log files for more information LOG - ${LOG}"
  exit
      fi
}