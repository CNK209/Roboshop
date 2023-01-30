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
print_head() {
  echo -e "\e[1m $1 \e[0m"
}
NODE JS(){
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
  STATUS_CHECK
  mkdir -p /app &>>${LOG}

  print_head "downloading ${component} files"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
  STATUS_CHECK
  print_head "removing old content"
  rm -rf /app/* &>>${LOG}
  STATUS_CHECK

  cd /app &>>${LOG}
  print_head "extracting ${component} file"
  unzip /tmp/${component}.zip &>>${LOG}
  STATUS_CHECK

  cd /app &>>${LOG}
  print_head "installing npm"

  npm install &>>${LOG}
  STATUS_CHECK
   print_head "configuring node js repos"
  cp ${script_location}/files/${component}.service /etc/systemd/system/${component}.service
  STATUS_CHECK
  print_head "starting ${component} service"
  systemctl daemon-reload &>>${LOG}
  STATUS_CHECK
  print_head "enabling ${component} service"
  systemctl enable ${component} &>>${LOG}
  STATUS_CHECK
  print_head "starting ${component} service"
  systemctl start ${component} &>>${LOG}
  STATUS_CHECK
  print_head "configuring mongodb service"
  cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
  STATUS_CHECK
  print_head "INSTALLING mongodb client"

  yum install mongodb-org-shell -y &>>${LOG}
  STATUS_CHECK

  print_head "loading mongodb schema"
  mongo --host mongodb-dev.devops009.online </app/schema/${component}.js &>>${LOG}

  STATUS_CHECK
  }