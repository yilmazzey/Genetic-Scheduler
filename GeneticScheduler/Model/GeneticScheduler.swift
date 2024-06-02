import SwiftUI
import PythonKit
import UniformTypeIdentifiers

struct GeneticScheduler: View {
    @State private var selectedTab = 0  // 0 for instructors, 1 for rooms
    @State private var showInstructorFileImporter = false
    @State private var showRoomFileImporter = false
    @State private var instructorFilePath: String = ""
    @State private var roomFilePath: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToSchedule = false
    @EnvironmentObject var sharedData: SharedDataModel
    
    @StateObject private var instructorCSVLoader = CSVLoader()
    @StateObject private var roomCSVLoader = CSVLoader()

    static let setupDone: Bool = {
        setupPythonEnvironment()
        return true
    }()

    init() {
        _ = GeneticScheduler.setupDone
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
                .fileImporter(isPresented: $showInstructorFileImporter, allowedContentTypes: [UTType.commaSeparatedText]) { result in
                    handleFileImport(result: result, type: "Instructor")
                }
                
                if !instructorCSVLoader.headers.isEmpty {
                    displayCSVContent(loader: instructorCSVLoader)
                } else {
                    Text("No data to display").foregroundColor(.gray)
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
                .fileImporter(isPresented: $showRoomFileImporter, allowedContentTypes: [UTType.commaSeparatedText]) { result in
                    handleFileImport(result: result, type: "Room")
                }
                
                if !roomCSVLoader.headers.isEmpty {
                    displayCSVContent(loader: roomCSVLoader)
                } else {
                    Text("No data to display").foregroundColor(.gray)
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
            
            NavigationLink(destination: ScheduleView().environmentObject(sharedData), isActive: $navigateToSchedule) {
                EmptyView()
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func displayCSVContent(loader: CSVLoader) -> some View {
        List {
            ForEach(loader.records) { record in
                Text(record.columns.joined(separator: ", "))
            }
        }
    }
    
    private func handleFileImport(result: Result<URL, Error>, type: String) {
        switch result {
        case .success(let url):
            do {
                if type == "Instructor" {
                    try sharedData.loadInstructors(from: url.path)
                    instructorFilePath = url.path // Store file path
                    instructorCSVLoader.loadCSV(from: url) // Load CSV data
                } else if type == "Room" {
                    try sharedData.loadRooms(from: url.path)
                    roomFilePath = url.path // Store file path
                    roomCSVLoader.loadCSV(from: url) // Load CSV data
                }
            } catch {
                alertMessage = "Error processing \(type) CSV: \(error)"
                showAlert = true
            }
        case .failure(let error):
            alertMessage = "Failed to import \(type) CSV: \(error)"
            showAlert = true
        }
    }
    
    private func generateSchedule() {
        guard !sharedData.instructors.isEmpty, !sharedData.rooms.isEmpty else {
            alertMessage = "Please import the data files first."
            showAlert = true
            return
        }
        
        let sys = Python.import("sys")
        sys.path.append("/Users/goknurarican/Downloads/genetic_algorithm_timetable-master/src")  // Adjust to your script directory
        
        do {
            let timetableModule = Python.import("main")
            let outputFile = "/Users/goknurarican/Downloads/genetic_algorithm_timetable-master/file/output.csv"
            
            timetableModule.timetable(instructorFilePath, roomFilePath, outputFile)
            print("Timetable generated successfully.")
            
            // Load the output file into the OutputReader
            try sharedData.loadSchedules(from: outputFile)
            
            // Navigate to the schedule view
            navigateToSchedule = true
        } catch {
            alertMessage = "Failed to generate schedule. Please try again."
            showAlert = true
        }
    }
    
    private static func setupPythonEnvironment() {
        let pythonLibraryPath = "/opt/homebrew/Cellar/python@3.12/3.12.3/Frameworks/Python.framework/Versions/3.12/lib/libpython3.12.dylib"
        PythonLibrary.useLibrary(at: pythonLibraryPath)
    }
}

struct GeneticScheduler_Previews: PreviewProvider {
    static var previews: some View {
        GeneticScheduler().environmentObject(SharedDataModel())
    }
}
