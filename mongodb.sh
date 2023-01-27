script_location=$(pwd)
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo
yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod
sed -i -e '/127.0.0.1/ c 0.0.0.0' /etc/mongod.conf
systemctl restart mongod
