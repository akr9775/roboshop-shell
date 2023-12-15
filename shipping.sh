script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_appuser_password=$1


component=shipping
func_java

echo -e '\e[32m >>>>>>>>>>>>> install mysql client <<<<<<<<<<<<\e[0m'
dnf install mysql -y

echo -e '\e[32m >>>>>>>>>>>>> load schema <<<<<<<<<<<<\e[0m'
mysql -h mysql-dev.akrdevopsb72.online -uroot -p${mysql_appuser_password} < /app/schema/shipping.sql
