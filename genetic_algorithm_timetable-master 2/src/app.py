# app.py
from fastapi import FastAPI, UploadFile, File
import io_excel_file
import generic_algorithm
from datetime import datetime
import shutil
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI()

@app.post("/generate_timetable")
async def generate_timetable(input_ml_file: UploadFile = File(...), input_room_file: UploadFile = File(...)):
    logger.info("Received request for generating timetable")
    input_ml_path = "temp_ml_file.csv"
    input_room_path = "temp_room_file.csv"
    output_file = "output.csv"

    with open(input_ml_path, "wb") as f:
        shutil.copyfileobj(input_ml_file.file, f)

    with open(input_room_path, "wb") as f:
        shutil.copyfileobj(input_room_file.file, f)

    # Run the timetable generation
    inputML = io_excel_file.read_ML(input_ml_path)
    inputRoom = io_excel_file.readRoom(input_room_path)
    NumberOfLoop = 200
    start = datetime.now()
    result_timetable = generic_algorithm.generic_algorithm(inputML, inputRoom, NumberOfLoop)
    io_excel_file.write_file(result_timetable, output_file)
    logger.info("Timetable generated successfully in %s seconds", datetime.now() - start)

    # Return the result file
    return {"output_file": output_file}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
