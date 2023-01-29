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
echo -e "\e[33m configuring node js repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
STATUS_CHECK
echo -e "\e[32m install nodejs\e[0m"
yum install nodejs -y &>>${LOG}
STATUS_CHECK
    echo -e "\e[33m Add application user\e[0m"
useradd roboshop &>>${LOG}
STATUS_CHECK
mkdir -p /app &>>${LOG}
echo -e "\e[33m downloading catalogue files\e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
STATUS_CHECK
    echo -e "\e[34m removing old content\e[0m"
rm -rf /app/* &>>${LOG}
STATUS_CHECK

cd /app &>>${LOG}
echo -e "\e[33m extracting catalogue file\e[0m"
unzip /tmp/catalogue.zip &>>${LOG}
STATUS_CHECK

cd /app &>>${LOG}
echo -e "\e[34m installing npm\e[0m"

npm install &>>${LOG}
STATUS_CHECK
    echo -e "\e[34m confguring node js repos\e[0m"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service
STATUS_CHECK
echo -e "\e[33m starting catalogue service\e[0m"
systemctl daemon-reload &>>${LOG}
STATUS_CHECK
echo -e "\e[33m enabling catalogue service\e[0m"
systemctl enable catalogue &>>${LOG}
STATUS_CHECK
echo -e "\e[33m starting catalogue service\e[0m"
systemctl start catalogue &>>${LOG}
STATUS_CHECK
echo -e "\e[33m confguring mongodb service\e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
STATUS_CHECK
echo -e "\e[33m INSTALLING mongodb client\e[0m"

yum install mongodb-org-shell -y &>>${LOG}
STATUS_CHECK

echo -e "\e[33m loading mongodb schema\e[0m"
mongo --host 172.31.6.119 </app/schema/catalogue.js &>>${LOG}

STATUS_CHECK
