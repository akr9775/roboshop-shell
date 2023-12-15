app_user=roboshop

func_printhead() {
  echo -e "\e[32m >>>>>>>>>>>>> $1 <<<<<<<<<<<<\e[0m"
}

func_schema_setup() {
  if [ "$schema_setup" == "mongodb" ]; then
    func_printhead "copy mongo repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

    func_printhead "install mongo client"
    dnf install mongodb-org-shell -y

    func_printhead "load schema"
    mongo --host mongodb-dev.akrdevopsb72.online </app/schema/catalogue.js
  fi
}

func_nodejs() {
  func_printhead "disable nodejs default version"
  dnf module disable nodejs -y

  func_printhead "install nodejs"
  dnf module enable nodejs:18 -y
  dnf install nodejs -y

  func_printhead "copy ${component} service file"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  func_printhead "add application ${component}"
  useradd ${app_user}

  func_printhead "create app directory"
  rm -rf /app
  mkdir /app

  func_printhead "download ${component} content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

  func_printhead "unzip app content"
  cd /app
  unzip /tmp/${component}.zip

  func_printhead "download dependencies"
  npm install

  func_schema_setup

  func_printhead "start ${component} service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}

func_python() {
  func_printhead "install python"
  dnf install python36 gcc python3-devel -y

  func_printhead "add application user"
  useradd ${app_user}

  func_printhead "disable nodejs default version"
  sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/${component}.service
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  func_printheadcarete "app directory"
  rm -rf /app
  mkdir /app

  func_printhead "download ${component} content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

  func_printhead "unzip app content"
  cd /app
  unzip /tmp/${component}.zip

  func_printhead "download dependencies"
  pip3.6 install -r requirements.txt

  func_printhead "start ${component} service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}

func_java() {
  func_printhead install maven
  dnf install maven -y

  func_printhead add application user
  useradd ${app_user}

  func_printhead install nodejs
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  func_printhead create app directory
  mkdir /app

  func_printhead downloadd app content
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

  func_printhead unzip app content
  cd /app
  unzip /tmp/${component}.zip

  func_printhead download dependencies
  mvn clean package
  mv target/${component}-1.0.jar ${component}.jar

  func_printhead install mysql client
  dnf install mysql -y

  func_printhead load schema
  mysql -h mysql-dev.akrdevopsb72.online -uroot -p${mysql_appuser_password} < /app/schema/${component}.sql

  func_printhead start ${component} service
  systemctl daemon-reload
  systemctl enable ${component} &>>/tmp/roboshop.log
  systemctl restart ${component}

}


func_stat_check() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[33mFAILURE\e[0m"
    exit 1
  fi

}


