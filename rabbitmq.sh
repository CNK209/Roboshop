source common.sh
if [ -z "${roboshop_rabbitmq_password}" ]; then
echo "variable robpshop_rabbitmq_password s missing"
exit
fi

print_head "configuring erlang YUM repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${LOG}
STATUS_CHECK

print_head "configuring rabbitmq YUM repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
STATUS_CHECK

print_head "install rabbitmq "
yum install erlang rabbitmq-server -y &>>${LOG}
STATUS_CHECK

print_head "Enable rabbitmq"
systemctl enable rabbitmq-server &>>${LOG}
STATUS_CHECK

print_head "start rabbitmq server"
systemctl start rabbitmq-server &>>${LOG}
STATUS_CHECK

print_head "Add Application User"
rabbitmqctl add_user roboshop ${roboshop_rabbitmq_password} &>>${LOG}
STATUS_CHECK

print_head "Add tags to Application user"
rabbitmqctl set_user_tags roboshop administrator &>>${LOG}
STATUS_CHECK

print_head "Add permissions to Application user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
STATUS_CHECK
