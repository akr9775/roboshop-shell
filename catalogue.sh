echo -e '\e[32m >>>>>>>>>>>>> disable nodejs default version <<<<<<<<<<<<\e[0m'
dnf module disable nodejs -y

echo -e '\e[32m >>>>>>>>>>>>> install nodejs <<<<<<<<<<<<\e[0m'
dnf module enable nodejs:18 -y
dnf install nodejs -y

echo -e '\e[32m >>>>>>>>>>>>> copy catalogue service file <<<<<<<<<<<<\e[0m'
cp catalogue.service /etc/systemd/system/catalogue.service

echo -e '\e[32m >>>>>>>>>>>>> copy mongo repo <<<<<<<<<<<<\e[0m'
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e '\e[32m >>>>>>>>>>>>> add application user <<<<<<<<<<<<\e[0m'
useradd roboshop

echo -e '\e[32m >>>>>>>>>>>>> create app directory <<<<<<<<<<<<\e[0m'
mkdir /app

echo -e '\e[32m >>>>>>>>>>>>> download catalogue content <<<<<<<<<<<<\e[0m'
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo -e '\e[32m >>>>>>>>>>>>> unzip app content <<<<<<<<<<<<\e[0m'
cd /app
unzip /tmp/catalogue.zip

echo -e '\e[32m >>>>>>>>>>>>> download dependencies <<<<<<<<<<<<\e[0m'
npm install

echo -e '\e[32m >>>>>>>>>>>>> install mongo client <<<<<<<<<<<<\e[0m'
dnf install mongodb-org-shell -y

echo -e '\e[32m >>>>>>>>>>>>> load schema <<<<<<<<<<<<\e[0m'
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js

echo -e '\e[32m >>>>>>>>>>>>> start catalogue service <<<<<<<<<<<<\e[0m'
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue