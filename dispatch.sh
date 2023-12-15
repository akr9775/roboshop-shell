script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_root_password=$1

if [ -z "$rabbitmq_root_password" ]; then
  echo input rabbitmq_root_password is missing
  exit 1
fi

component=dispatch
func_golang
