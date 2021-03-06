# Deploy a Base Python3 Flask App on Ubuntu 18.04

__NOTES:__
* Assumes `python3` and `git` is installed before deployment 
* Binds app to port 80
* configured to use SQLite3 Database

__Guide Source:__

https://www.digitalocean.com/community/tutorials/how-to-serve-flask-applications-with-uswgi-and-nginx-on-ubuntu-18-04

__Deploy With:__

`git clone git@github.com:edensMind/flask_base.git && bash flask_base/deploy.sh`

__Once Deployed, Visit App at:__

`http://<your addres>`

__To install more pip libraries:__
``` bash
source myproject_env/bin/activate
pip3 install -r requirements.txt
deactivate
```
