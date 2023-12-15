mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo input mysql appuser password is missing
  exit 1
fi

echo -e '\e[32m >>>>>>>>>>>>> disable mysql default version <<<<<<<<<<<<\e[0m'
dnf module disable mysql -y

echo -e '\e[32m >>>>>>>>>>>>> install mysql <<<<<<<<<<<<\e[0m'
dnf install mysql-community-server -y

echo -e '\e[32m >>>>>>>>>>>>> add mysql user <<<<<<<<<<<<\e[0m'
mysql_secure_installation --set-root-pass ${mysql_root_password}


echo -e '\e[32m >>>>>>>>>>>>> start mysql service <<<<<<<<<<<<\e[0m'
systemctl enable mysqld
systemctl restart mysqld
