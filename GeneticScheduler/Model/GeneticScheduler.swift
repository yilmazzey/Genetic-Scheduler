//
//  GeneticScheduler.swift
//  GeneticScheduler
//
//  Created by Zeynep Yılmaz on 19.05.2024.
//
//
//  GeneticScheduler.swift
//  GeneticScheduler
//
//  Created by Zeynep Yılmaz on 19.05.2024.
//

import SwiftUI
import PythonKit

struct GeneticScheduler: View {
    @State private var selectedTab = 0  // 0 for instructors, 1 for rooms
    @State private var showInstructorFileImporter = false
    @State private var showRoomFileImporter = false
    @EnvironmentObject var sharedData: SharedDataModel

    init() {
        let pythonLibrary = " " // Adjust this path
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
    }

    func handleFileImport(result: Result<URL, Error>, type: String) {
        switch result {
        case .success(let url):
            do {
                if type == "Instructor" {
                    try sharedData.loadInstructors(from: url.path)
                } else if type == "Room" {
                    try sharedData.loadRooms(from: url.path)
                }
            } catch {
                print("Error processing \(type) CSV: \(error)")
            }
        case .failure(let error):
            print("Failed to import \(type) CSV: \(error)")
        }
    }

    func generateSchedule() {
        let sys = Python.import("sys")
        sys.path.append("/Users/zeynep_yilmaz/Desktop/GeneticScheduler/genetic_algorithm_timetable-master/src")  // Adjust to your script directory

        do {
            let pandas = try Python.attemptImport("pandas")
            let makeTimetable = try Python.attemptImport("make_timetable")
            let geneticAlgorithm = try Python.attemptImport("genetic_algorithm")

            let inputML = sharedData.instructors.map { $0.courseID }.joined(separator: "\n")
            let inputRoom = sharedData.rooms.map { $0.roomID }.joined(separator: "\n")

            let result = geneticAlgorithm.generic_algorithm(inputML, inputRoom, 100)
            print("Generated schedule:", result)
        } catch {
            print("Failed to run Python script: \(error)")
        }
    }
}

struct GeneticScheduler_Previews: PreviewProvider {
    static var previews: some View {
        GeneticScheduler().environmentObject(SharedDataModel())
    }
}
