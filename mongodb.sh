script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh


echo -e '\e[32m >>>>>>>>>>>>> copy mongo repo <<<<<<<<<<<<\e[0m'
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log
func_stat_check $?

echo -e '\e[32m >>>>>>>>>>>>> install mongod <<<<<<<<<<<<\e[0m'
dnf install mongodb-org -y &>>/tmp/roboshop.log
func_stat_check $?

echo -e '\e[32m >>>>>>>>>>>>> update listen address <<<<<<<<<<<<\e[0m'
sed -i -e "s|127.0.0.1|0.0.0.0|" /etc/mongod.conf &>>/tmp/roboshop.log
func_stat_check $?

echo -e '\e[32m >>>>>>>>>>>>> start mongod <<<<<<<<<<<<\e[0m'
systemctl enable mongod &>>/tmp/roboshop.log
systemctl restart mongod &>>/tmp/roboshop.log
func_stat_check $?


