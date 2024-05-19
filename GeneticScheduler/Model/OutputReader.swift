//
//  OutputReader.swift
//  GeneticScheduler
//
//  Created by Zeynep Yılmaz on 19.05.2024.
//

import Foundation
import SwiftCSV


class OutputReader {
    struct Course: Identifiable {
        var id = UUID()
        var courseID: String
        var teacher: String
        var room: String
        var blockPosition: String
        var beginningPoint: String
        var numberOfHours: Int
        var studentClass: String
        var courseName: String
        var roomType: String
        
        var courseIDProperty: String {
            get { return courseID }
            set { courseID = newValue }
        }
    }

    private(set) var data: [Course] = []

    // Method to read CSV file and parse data
    func readFromFile(path: String) throws {
        let csv = try CSV<Enumerated>(url: URL(fileURLWithPath: path)) // Create CSV object using CSV<Enumerated>
        self.data = csv.rows.map { row in
            Course(
                courseID: row[0],
                teacher: row[1],
                room: row[2],
                blockPosition: row[3],
                beginningPoint: row[4],
                numberOfHours: Int(row[5]) ?? 0,
                studentClass: row[6],
                courseName: row[7],
                roomType: row[8]
            )
        }
    }

    // Method to get schedules for a specific instructor
    func getSchedules(for instructor: String) -> [Course] {
        return data.filter { $0.teacher.lowercased().contains(instructor.lowercased()) }
    }
}
