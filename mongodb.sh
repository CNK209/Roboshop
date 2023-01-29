script_location=$(pwd)
print_head "copy mongodb repo files"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo
STATUS_CHECK
print_head "Install Mongodb"
yum install mongodb-org -y &>>{$LOG}
STATUS_CHECK
print_head "Update Mongodb listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>{$LOG}
STATUS_CHECK

print_head "Install Mongodb"
systemctl enable mongod &>>{$LOG}
STATUS_CHECK

print_head "install mongodb"
systemctl restart mongod &>>{$LOG}
STATUS_CHECK

