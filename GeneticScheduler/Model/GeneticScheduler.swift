import SwiftUI
import PythonKit

struct GeneticScheduler: View {
    @State private var selectedTab = 0  // 0 for instructors, 1 for rooms
    @State private var showInstructorFileImporter = false
    @State private var showRoomFileImporter = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var instructorFilePath: String?
    @State private var roomFilePath: String?
    @EnvironmentObject var sharedData: SharedDataModel
    
    init() {
        let pythonLibrary = "/usr/local/bin/python3" // Adjust this path if needed
        PythonLibrary.useLibrary(at: pythonLibrary)
    }
    
    var body: some View {
        VStack {
            Picker(" ", selection: $selectedTab) {
                Text("Instructors").tag(0)
                Text("Rooms").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if selectedTab == 0 {
                Button(action: {
                    showInstructorFileImporter = true
                }) {
                    Text("Import Instructor CSV")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .fileImporter(isPresented: $showInstructorFileImporter, allowedContentTypes: [.commaSeparatedText]) { result in
                    handleFileImport(result: result, type: "Instructor")
                }
                
                List(sharedData.instructors) { instructor in
                    VStack(alignment: .leading) {
                        Text("Course ID: \(instructor.courseID)")
                        Text("Teacher: \(instructor.teacher)")
                        Text("Hours: \(instructor.numberOfHours)")
                        Text("Class: \(instructor.studentClass)")
                        Text("Course Name: \(instructor.courseName)")
                        Text("Room Type: \(instructor.roomType)")
                    }
                }
            } else {
                Button(action: {
                    showRoomFileImporter = true
                }) {
                    Text("Import Room CSV")
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .fileImporter(isPresented: $showRoomFileImporter, allowedContentTypes: [.commaSeparatedText]) { result in
                    handleFileImport(result: result, type: "Room")
                }
                
                List(sharedData.rooms) { room in
                    VStack(alignment: .leading) {
                        Text("Room: \(room.roomID)")
                        Text("Room Type: \(room.roomType)")
                    }
                }
            }
            
            Spacer()
            
            Button(action: generateSchedule) {
                Text("Generate Schedule")
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func handleFileImport(result: Result<URL, Error>, type: String) {
        switch result {
        case .success(let url):
            do {
                let path = url.path
                print("File path: \(path)")  // Debugging line
                
                if type == "Instructor" {
                    instructorFilePath = path
                    try sharedData.loadInstructors(from: path)
                } else if type == "Room" {
                    roomFilePath = path
                    try sharedData.loadRooms(from: path)
                }
            } catch {
                print("Error processing \(type) CSV: \(error)")
                alertMessage = "Error processing \(type) CSV: \(error.localizedDescription)"
                showAlert = true
            }
        case .failure(let error):
            print("Failed to import \(type) CSV: \(error)")
            alertMessage = "Failed to import \(type) CSV: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    func generateSchedule() {
        guard let inputMLFile = instructorFilePath, let inputRoomFile = roomFilePath else {
            alertMessage = "Please import the data files first."
            showAlert = true
            return
        }
        
        let sys = Python.import("sys")
        sys.path.append("/Users/zeynep_yilmaz/Desktop/genetic_algorithm_timetable-master/src")
        
        do {
            let timetableModule = try Python.attemptImport("main")
            let outputFile = "/Users/zeynep_yilmaz/Desktop/genetic_algorithm_timetable-master/file/output.csv"
            
            timetableModule.timetable(inputMLFile, inputRoomFile, outputFile)
            print("Timetable generated successfully.")
            
            // Load the output file into the OutputReader
            try sharedData.loadSchedules(from: outputFile)
        } catch {
            print("Failed to run Python script: \(error)")
            alertMessage = "Failed to generate schedule. Please try again."
            showAlert = true
        }
    }
}

struct GeneticScheduler_Previews: PreviewProvider {
    static var previews: some View {
        GeneticScheduler().environmentObject(SharedDataModel())
    }
}
