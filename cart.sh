echo -e '\e[32m >>>>>>>>>>>>> disable nodejs default version <<<<<<<<<<<<\e[0m'
dnf module disable nodejs -y

echo -e '\e[32m >>>>>>>>>>>>> install nodejs <<<<<<<<<<<<\e[0m'
dnf module enable nodejs:18 -y
dnf install nodejs -y

echo -e '\e[32m >>>>>>>>>>>>> copy cart service file <<<<<<<<<<<<\e[0m'
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service

echo -e '\e[32m >>>>>>>>>>>>> add application cart <<<<<<<<<<<<\e[0m'
useradd ${app_user}

echo -e '\e[32m >>>>>>>>>>>>> create app directory <<<<<<<<<<<<\e[0m'
rm -rf /app
mkdir /app

echo -e '\e[32m >>>>>>>>>>>>> download cart content <<<<<<<<<<<<\e[0m'
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip

echo -e '\e[32m >>>>>>>>>>>>> unzip app content <<<<<<<<<<<<\e[0m'
cd /app
unzip /tmp/cart.zip

echo -e '\e[32m >>>>>>>>>>>>> download dependencies <<<<<<<<<<<<\e[0m'
npm install

echo -e '\e[32m >>>>>>>>>>>>> start cart service <<<<<<<<<<<<\e[0m'
systemctl daemon-reload
systemctl enable cart
systemctl restart cart