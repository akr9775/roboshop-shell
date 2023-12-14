echo -e '\e[32m >>>>>>>>>>>>> download repos <<<<<<<<<<<<\e[0m'
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e '\e[32m >>>>>>>>>>>>> install rabbitmq <<<<<<<<<<<<\e[0m'
dnf install rabbitmq-server -y

echo -e '\e[32m >>>>>>>>>>>>> add rabbitmq user <<<<<<<<<<<<\e[0m'
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"


echo -e '\e[32m >>>>>>>>>>>>> start rabbitmq <<<<<<<<<<<<\e[0m'
systemctl enable rabbitmq-server
systemctl start rabbitmq-server