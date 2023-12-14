echo -e '\e[32m >>>>>>>>>>>>> intstall nginx <<<<<<<<<<<<\e[0m'
dnf install nginx -y

echo -e '\e[32m >>>>>>>>>>>>> remove default content <<<<<<<<<<<<\e[0m'
rm -rf /usr/share/nginx/html/*

echo -e '\e[32m >>>>>>>>>>>>> download frontend content <<<<<<<<<<<<\e[0m'
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e '\e[32m >>>>>>>>>>>>> unzip frontend content <<<<<<<<<<<<\e[0m'
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e '\e[32m >>>>>>>>>>>>> Copy roboshop conf <<<<<<<<<<<<\e[0m'
cp roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e '\e[32m >>>>>>>>>>>>> start nginx <<<<<<<<<<<<\e[0m'
systemctl enable nginx
systemctl restart nginx

