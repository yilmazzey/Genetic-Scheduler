import Foundation
import SwiftCSV

class ReadInstructor {
    struct Instructor: Identifiable {
        let id: UUID = UUID() // UUID for unique identification
        var courseID: String
        var teacher: String
        var numberOfHours: Int
        var studentClass: String
        var courseName: String
        var roomType: String
        
        var courseIDProperty: String {
            get { return courseID }
            set { courseID = newValue }
        }
    }

    private(set) var data: [Instructor] = []

    // Method to read CSV file and parse data using column indices
    func readFromFile(path: String) throws {
        let csv = try CSV<Enumerated>(url: URL(fileURLWithPath: path)) // Create CSV object
        self.data = csv.rows.map { row in
            Instructor(
                courseID: row[0], // First column
                teacher: row[1], // Second column
                numberOfHours: Int(row[2]) ?? 0, // Third column
                studentClass: row[3], // Fourth column
                courseName: row[4], // Fifth column
                roomType: row[5] // Sixth column
            )
        }
    }

    // Method to write data to a CSV file
    func writeToFile(path: String) throws {
        let csvString = "Course ID,Teacher,The number of hour of class,Student class,Course name,The room type need to use\n" +
            data.map { instructor in
                "\(instructor.courseID),\(instructor.teacher),\(instructor.numberOfHours),\(instructor.studentClass),\(instructor.courseName),\(instructor.roomType)"
            }.joined(separator: "\n")

        try csvString.write(to: URL(fileURLWithPath: path), atomically: true, encoding: .utf8)
    }
}
