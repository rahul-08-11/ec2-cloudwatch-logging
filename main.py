from fastapi import FastAPI
import logging

# Create logger
logger = logging.getLogger("fastapi_app")
logger.setLevel(logging.INFO)

# File handler (saves logs to a file)
file_handler = logging.FileHandler("/home/ubuntu/AFDF/app.log")
file_handler.setLevel(logging.INFO)

# Log format
formatter = logging.Formatter(
    "%(asctime)s - %(levelname)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S"
)
file_handler.setFormatter(formatter)

# Attach handler
logger.addHandler(file_handler)

app = FastAPI()

@app.get("/greet/{name}")
async def greet(name: str):
    logging.info(f"Greeting user: {name}")
    return {"message": f"Hello, {name}! This demonstrate Path Parameter."}

@app.get("/greet")
async def greet_query(name: str):
    logging.info(f"Greeting user: {name}")
    return {"message": f"Hello, {name}! This demonstrate Query Parameter."}

@app.get("/")
async def read_root():
    return {"message": "Welcome to the FastAPI application!"}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)