source common.sh
print_head "configuring node js repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
STATUS_CHECK
print_head "install nodejs"
yum install nodejs -y &>>${LOG}
STATUS_CHECK
print_head "Add application user"
id roboshop &>>${LOG}
if [ $? -ne 0 ];then
useradd roboshop &>>${LOG}
fi
print_head "create a directory"
mkdir -p /app &>>${LOG}
STATUS_CHECK
print_head "downloading catalogue files"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
STATUS_CHECK
print_head "removing old content"
rm -rf /app/* &>>${LOG}
STATUS_CHECK

cd /app &>>${LOG}
print_head "extracting catalogue file"
unzip /tmp/catalogue.zip &>>${LOG}
STATUS_CHECK

cd /app &>>${LOG}
print_head "installing npm"

npm install &>>${LOG}
STATUS_CHECK
 print_head "configuring node js repos"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service
STATUS_CHECK
print_head "starting catalogue service"
systemctl daemon-reload &>>${LOG}
STATUS_CHECK
print_head "enabling catalogue service"
systemctl enable catalogue &>>${LOG}
STATUS_CHECK
print_head "starting catalogue service"
systemctl start catalogue &>>${LOG}
STATUS_CHECK
print_head "configuring mongodb service"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
STATUS_CHECK
print_head "INSTALLING mongodb client"

yum install mongodb-org-shell -y &>>${LOG}
STATUS_CHECK

print_head "loading mongodb schema"
mongo --host mongodb-dev.devops009.online </app/schema/catalogue.js &>>${LOG}

STATUS_CHECK
