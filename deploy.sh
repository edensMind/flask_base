#!/bin/bash

# Get APP name from user
echo -n "Enter application name and press [ENTER]: "
read APP_NAME


#install os dependencies
sudo apt update
sudo apt install -y python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools python3-venv nginx sqlite3 sqlitebrowser

#make and enter flask dir
mkdir ~/$APP_NAME
cd ~/$APP_NAME


#create python 3 virtual environment
ENV_DIR=$APP_NAME"_env"
python3.6 -m venv $ENV_DIR

#copy requirements file
cp ~/flask_base/requirements.txt requirements.txt

#enter env
source $ENV_DIR/bin/activate

#install requirements
pip3 install wheel
#python3 setup.py bdist_wheel 
pip3 install uwsgi
pip3 install -r requirements.txt

#leave env
deactivate

#create sock file
touch $APP_NAME.sock

#make needed folders
mkdir log
mkdir templates
mkdir static

#move over needed files
cp ~/flask_base/errorLog.log log/errorLog.log
cp ~/flask_base/logError.py logError.py
cp ~/flask_base/index.html templates/index.html
cp ~/flask_base/index.py index.py
cp ~/flask_base/wsgi.py wsgi.py
cp ~/flask_base/app.ini app.ini
cp ~/flask_base/flask.service $APP_NAME.service
cp ~/flask_base/app.conf $APP_NAME.conf

#EDIT FILES...

#edit ini file
sed -i "/socket = flask_base.sock/c\socket = $APP_NAME.sock" app.ini

#edit serivce file
sed -i "/User=/c\User=$USER" $APP_NAME.service
sed -i "/WorkingDirectory=/c\WorkingDirectory=/home/$USER/$APP_NAME" $APP_NAME.service
sed -i "/Environment=/c\Environment='PATH=/home/$USER/$APP_NAME/$ENV_DIR/bin'" $APP_NAME.service
sed -i "/ExecStart=/c\ExecStart=/home/$USER/$APP_NAME/$ENV_DIR/bin/uwsgi -- app.ini" $APP_NAME.service

#edit web server
sed -i "/uwsgi_pass/c\uwsgi_pass unix:/home/$USER/$APP_NAME/$APP_NAME.sock;" $APP_NAME.conf

#move service file to /etc/systemd/system/
sudo cp $APP_NAME.service /etc/systemd/system/$APP_NAME.service

#start and enalbe service
sudo systemctl daemon-reload
sudo systemctl restart $APP_NAME
sudo systemctl enable $APP_NAME

#remove default nginx site
sudo rm /etc/nginx/sites-available/default
sudo rm /etc/nginx/sites-enabled/default

#move nginx web server file to /etc/nginx/conf.d/
sudo cp $APP_NAME.conf /etc/nginx/conf.d/$APP_NAME.conf

#start and enalbe nginx
sudo chmod 660 $APP_NAME.sock
sudo systemctl restart nginx
sudo systemctl enable nginx


# sudo rm -Rf /etc/systemd/system/test* && sudo rm -Rf /etc/nginx/conf.d/test* && sudo rm -Rf test*





