source common.sh
if [ -z "${root_mysql_password}" ]; then
  echo "variable root_mysql_password is missing"
  exit
  fi

print_head "Disable dnf module"
dnf module disable mysql -y &>>${LOG}
STATUS_CHECK

print_head "copy MYSQL Repo file"
cp ${script_location}/files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${LOG}
STATUS_CHECK

print_head "Install MYSQL Community server"
yum install mysql-community-server -y &>>${LOG}
STATUS_CHECK

print_head "Enable MYSQL"
systemctl enable mysqld &>>$"LOG"
STATUS_CHECK

print_head "start MYSQL"
systemctl start mysqld &>>$"LOG"
STATUS_CHECK

print_head "Reset Default Database Password"
mysql_secure_installation --set-root-pass ${root_mysql_password} &>>${LOG}
STATUS_CHECK