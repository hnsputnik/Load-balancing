#!/bin/bash -x
PWD=`pwd`
/usr/local/bin/virtualenv --python=python3 venv
echo $PWD
activate () {
    . $PWD/venv/bin/activate
}

activate
deployDir="/opt/ekycpeopleid/"
cd $deployDir
ulimit -n 65535

export FLASK_APP=ocr_api

export FLASK_ENV=production
export LOG_DIR=/var/log/ekycpeopleid
export DATA_TRAINING_DIR=/opt/ekycpeopleid/data/
export SERVER_NAME=0.0.0.0:5000
export VND_ID_DOMAIN=https://vndid-int-api.vndirect.com.vn/


test=`ps aux | grep gunicorn | grep -v grep -c`

/usr/bin/pip3 install -r requirements.txt

if [ $test == 0 ]; then
        #python3 main.py > /dev/null &
        gunicorn --workers=10 --timeout=60 -b $SERVER_NAME 'ocr_api:create_app()' --daemon
        echo "[INFO] Service is starting"
        exit
else
        echo "[WARN] Service is already running"
        exit
fi
deactivate
