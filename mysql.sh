echo -e '\e[32m >>>>>>>>>>>>> disable mysql default version <<<<<<<<<<<<\e[0m'
dnf module disable mysql -y

echo -e '\e[32m >>>>>>>>>>>>> install mysql <<<<<<<<<<<<\e[0m'
dnf install mysql-community-server -y

echo -e '\e[32m >>>>>>>>>>>>> add mysql user <<<<<<<<<<<<\e[0m'
mysql_secure_installation --set-root-pass RoboShop@1


echo -e '\e[32m >>>>>>>>>>>>> start mysql service <<<<<<<<<<<<\e[0m'
systemctl enable mysqld
systemctl restart mysqld
