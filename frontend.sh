source common.sh
print_head "Install Nginx"
yum install nginx -y &>>${LOG}
STATUS_CHECK

print_head "Remove nginx old content"
rm -rf /usr/share/nginx/html/* &>>${LOG}
STATUS_CHECK
print_head "download frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
STATUS_CHECK
cd /usr/share/nginx/html &>>${LOG}

print_head "Extract frontend content"
unzip /tmp/frontend.zip &>>${LOG}
STATUS_CHECK

print_head "copy roboshop nginx config file"
cp ${script_location}/files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}

STATUS_CHECK
print_head "Enable Nginx"
systemctl enable nginx &>>${LOG}
STATUS_CHECK
print_head "start nginx"
systemctl restart nginx &>>${LOG}
STATUS_CHECK
