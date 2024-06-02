import pandas

# output: ["Room", "RoomType"]
def readRoom(fileDir):
    inputRoom = pandas.read_csv(fileDir)

    Room = inputRoom[inputRoom.columns[0]].values.tolist()
    RoomType = inputRoom[inputRoom.columns[1]].values.tolist()

    result = []
    for i in range(len(Room)):
        for j in range(11):
            room = [Room[i], j+1, 6, RoomType[i]]
            result.append(room)

    return result

# output: ["CourseID", "Instructor", "Class", "Number of Sessions"]
def read_ML(fileDir):
    inputML = pandas.read_csv(fileDir).sort_values(by = 'Number of Sessions', ascending = False)
    return inputML.values.tolist()

# print: ['CourseID', 'Instructor', 'Number of Sessions', 'Room', 'Day', 'Starting Block', 'Fit of Instructor', 'Class', 'Fit of Class', 'Credit', 'RoomType']
def write_file(data, outputFile):
    columns = ['CourseID', 'Instructor', 'Number of Sessions', 'Room', 'Day', 'Starting Block', 'Fit of Instructor', 'Class', 'Fit of Class', 'Credit', 'RoomType']
    df = pandas.DataFrame(data, columns=columns)
    df.to_csv(outputFile)

if __name__ == "__main__":
    result = readRoom("file/inputRoom.csv")
    print(result)

