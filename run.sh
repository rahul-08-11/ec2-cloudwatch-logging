echo "Starting the FastAPI application..."

cd ~/app
#check if venv exists or not
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
fi

source venv/bin/activate

echo "Virtual environment activated..."

# Start the FastAPI application using uvicorn
python3 main.py