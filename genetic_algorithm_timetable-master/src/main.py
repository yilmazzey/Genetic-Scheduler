# Author: Ha
## Module: timetable

# import other files
## Swift adjustments made.
import io_excel_file, generic_algorithm
from datetime import datetime
import argparse

def timetable(inputMLFile, inputRoomFile, outputFile):
    # get the data consisting of Malop and Room
    inputML = io_excel_file.read_ML(inputMLFile)
    inputRoom = io_excel_file.readRoom(inputRoomFile)

    # run GA
    NumberOfLoop = 200
    
    start = datetime.now()
    result_timetable = generic_algorithm.generic_algorithm(inputML, inputRoom, NumberOfLoop)
    print("Running time: ", datetime.now() - start)

    # writing final timetable into file
    io_excel_file.write_file(result_timetable, outputFile)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate timetable using genetic algorithm.")
    parser.add_argument("inputMLFile", type=str, help="Path to the input ML CSV file.")
    parser.add_argument("inputRoomFile", type=str, help="Path to the input Room CSV file.")
    parser.add_argument("outputFile", type=str, help="Path to the output CSV file.")
    
    args = parser.parse_args()
    
    timetable("example.csv","inputRoom.csv", "output.csv")
