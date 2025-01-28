sudo apt update -y
sudo apt install nginx -y
sudo rm -rf /var/www/html/*
sudo git clone https://github.com/RajBDevops/backend-app.git /var/www/html