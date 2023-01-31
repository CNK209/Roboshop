source common.sh
print_head "install python36"
yum install python36 gcc python3-devel -y &>>${LOG}
STATUS_CHECK

print_head "Add Application user"
rabbitmqctl list_users | grep roboshop &>>{LOG}
if [ $? -ne 0 ]; then
useradd roboshop ${roboshop_rabbitmq_password} &>>${LOG}
fi
STATUS_CHECK

mkdir /app &>>${LOG}
print_head "Downloading payment repos"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>>${LOG}
STATUS_CHECK

cd /app
print_head "Extracting repos"
unzip /tmp/payment.zip
STATUS_CHECK
cd /app
print_head "install pip3"
pip3.6 install -r requirements.txt
STATUS_CHECK
