//
//  ScheduleView.swift
//  GeneticScheduler
//
//  Created by goknur arıcan on 21.05.2024.
//

import Foundation
import SwiftUI

struct ScheduleView: View {
    @EnvironmentObject var sharedData: SharedDataModel
    @State private var scheduleData: [OutputReader.Course] = []
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            List(scheduleData) { course in
                VStack(alignment: .leading) {
                    Text("Course ID: \(course.courseID)")
                    Text("Teacher: \(course.teacher)")
                    Text("Room: \(course.room)")
                    Text("Block Position: \(course.blockPosition)")
                    Text("Beginning Point: \(course.beginningPoint)")
                    Text("Number of Hours: \(course.numberOfHours)")
                    Text("Student Class: \(course.studentClass)")
                    Text("Course Name: \(course.courseName)")
                    Text("Room Type: \(course.roomType)")
                }
                .padding()
            }
        }
        .onAppear {
            loadSchedule()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func loadSchedule() {
        do {
            // Provide the correct path to your output file
            let outputFilePath = "/Users/goknurarican/Downloads/genetic_algorithm_timetable-master/file/output.csv"
            try sharedData.loadSchedules(from: outputFilePath)
            scheduleData = sharedData.schedules
        } catch {
            print("Failed to load schedule: \(error)")
            alertMessage = "Failed to load schedule. Please try again."
            showAlert = true
        }
    }
}
