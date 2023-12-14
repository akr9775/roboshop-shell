

echo -e '\e[32m >>>>>>>>>>>>> install golang <<<<<<<<<<<<\e[0m'
dnf install golang -y

echo -e '\e[32m >>>>>>>>>>>>> add application user <<<<<<<<<<<<\e[0m'
useradd ${app_user}

echo -e '\e[32m >>>>>>>>>>>>> copy service file <<<<<<<<<<<<\e[0m'
cp /home/centos/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service

echo -e '\e[32m >>>>>>>>>>>>> create app directory <<<<<<<<<<<<\e[0m'
rm -rf /app
mkdir /app

echo -e '\e[32m >>>>>>>>>>>>> download app content <<<<<<<<<<<<\e[0m'
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip

echo -e '\e[32m >>>>>>>>>>>>> unzip app content <<<<<<<<<<<<\e[0m'
cd /app
unzip /tmp/dispatch.zip

echo -e '\e[32m >>>>>>>>>>>>> download dependencies <<<<<<<<<<<<\e[0m'
go mod init dispatch
go get
go build

echo -e '\e[32m >>>>>>>>>>>>> start dispatch service <<<<<<<<<<<<\e[0m'
systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch