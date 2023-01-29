source common.sh
echo -e "\e[35m Install Nginx\e[0m"
yum install nginx -y &>>${LOG}
STATUS_CHECK

echo -e "\e[32m Remove nginx old content\e[0m"
rm -rf /usr/share/nginx/html/* &>>${LOG}
STATUS_CHECK
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
cd /usr/share/nginx/html &>>${LOG}

echo -e "\e[34m Extract frontend content\e[0m"
unzip /tmp/frontend.zip &>>${LOG}
STATUS_CHECK

echo -e "\e[33m copy roboshop nginx config file\e[0m"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}

STATUS_CHECK
echo -e "\e[32m Enable Nginx\e[0m"
systemctl enable nginx &>>${LOG}
STATUS_CHECK
echo -e "\e[35m Restart nginx\e[0m"
systemctl restart nginx &>>${LOG}
STATUS_CHECK