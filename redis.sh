source common.sh
print_head "setup redis repo files"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${LOG}
STATUS_CHECK
print_head "enable redis 6.2 dnf module"
dnf module enable redis:remi-6.2 -y &>>${LOG}
STATUS_CHECK
print_head "Install Redis"
yum install redis -y  &>>${LOG}
STATUS_CHECK
print_head "Update Redis listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${LOG}
STATUS_CHECK

print_head "Install Redis"
systemctl enable redis &>>${LOG}
STATUS_CHECK

print_head "install redis"
systemctl restart redis &>>${LOG}
STATUS_CHECK
