#!/bin/bash

cd ~/app
echo "$(date '+%Y-%m-%d %H:%M:%S') Starting the FastAPI application..." >> setup.log


#check if venv exists or not
if [ ! -d "venv" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') Creating virtual environment..." >> setup.log
    python3 -m venv venv
    sleep 1
    source venv/bin/activate
    pip install -r requirements.txt
    echo "$(date '+%Y-%m-%d %H:%M:%S') Virtual environment created and dependencies installed." >> setup.log
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') Virtual environment already exists." >> setup.log
    source venv/bin/activate
fi
echo "$(date '+%Y-%m-%d %H:%M:%S') Virtual environment activated..." >> setup.log

python3 main.py