echo -e '\e[32m >>>>>>>>>>>>> install maven <<<<<<<<<<<<\e[0m'
dnf install maven -y

echo -e '\e[32m >>>>>>>>>>>>> add application user <<<<<<<<<<<<\e[0m'
useradd roboshop

echo -e '\e[32m >>>>>>>>>>>>> install nodejs <<<<<<<<<<<<\e[0m'
cp shipping.service /etc/systemd/system/shipping.service

echo -e '\e[32m >>>>>>>>>>>>> create app directory <<<<<<<<<<<<\e[0m'
mkdir /app

echo -e '\e[32m >>>>>>>>>>>>> downloadd app content <<<<<<<<<<<<\e[0m'
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

echo -e '\e[32m >>>>>>>>>>>>> unzip app content <<<<<<<<<<<<\e[0m'
cd /app
unzip /tmp/shipping.zip

echo -e '\e[32m >>>>>>>>>>>>> download dependencies <<<<<<<<<<<<\e[0m'
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e '\e[32m >>>>>>>>>>>>> install mysql client <<<<<<<<<<<<\e[0m'
dnf install mysql -y

echo -e '\e[32m >>>>>>>>>>>>> load schema <<<<<<<<<<<<\e[0m'
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e '\e[32m >>>>>>>>>>>>> start shipping service <<<<<<<<<<<<\e[0m'
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping