echo "Starting the FastAPI application..."

cd ~/AFDF
#check if venv exists or not
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    sleep 1
    source venv/bin/activate
    pip install -r requirements.txt
    echo "Virtual environment created and dependencies installed."
else
    echo "Virtual environment already exists."
    source venv/bin/activate
fi
echo "Virtual environment activated..."

# Start the FastAPI application using uvicorn
python3 main.py