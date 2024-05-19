//
//  ExistingSchedules.swift
//  GeneticScheduler
//
//  Created by Zeynep Yılmaz on 18.05.2024.
//

import SwiftUI

struct ExistingSchedules: View {
    @State private var searchText: String = ""
    @EnvironmentObject var sharedData: SharedDataModel

    var body: some View {
        VStack {
            TextField("Enter instructor name", text: $searchText, onCommit: {
                loadSchedules()
            })
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())

            List(sharedData.schedules) { schedule in
                VStack(alignment: .leading) {
                    Text("Course ID: \(schedule.courseID)")
                    Text("Teacher: \(schedule.teacher)")
                    Text("Room: \(schedule.room)")
                    Text("Block: \(schedule.blockPosition)")
                    Text("Beginning: \(schedule.beginningPoint)")
                    Text("Hours: \(schedule.numberOfHours)")
                    Text("Student Class: \(schedule.studentClass)")
                    Text("Course Name: \(schedule.courseName)")
                    Text("Room Type: \(schedule.roomType)")
                }
                .padding()
            }
        }
        .onAppear {
            loadCSVData()
        }
    }

    func loadCSVData() {
        do {
            let path = Bundle.main.path(forResource: "output", ofType: "csv") ?? ""
            try sharedData.loadSchedules(from: path)
        } catch {
            print("Error reading CSV file: \(error)")
        }
    }

    func loadSchedules() {
        sharedData.schedules = sharedData.schedules.filter { $0.teacher.contains(searchText) }
    }
}

struct ExistingSchedules_Previews: PreviewProvider {
    static var previews: some View {
        ExistingSchedules().environmentObject(SharedDataModel())
    }
}
