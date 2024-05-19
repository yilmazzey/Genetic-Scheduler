import Foundation
import SwiftCSV

class ReadRoom {
    struct Room: Identifiable {
        let id: UUID = UUID() // UUID for unique identification
        var roomID: String
        var roomType: String
        
        var roomIDProperty: String {
            get { return roomID }
            set { roomID = newValue }
        }
    }

    private(set) var data: [Room] = []

    // Method to read CSV file and parse data using column indices
    func readFromFile(path: String) throws {
        let csv = try CSV<Enumerated>(url: URL(fileURLWithPath: path)) // Create CSV object
        self.data = csv.rows.map { row in
            Room(
                roomID: row[0], // First column
                roomType: row[1] // Second column
            )
        }
    }

    // Method to write data to a CSV file
    func writeToFile(path: String) throws {
        let csvString = "Room ID,Room Type\n" +
            data.map { room in
                "\(room.roomID),\(room.roomType)"
            }.joined(separator: "\n")

        try csvString.write(to: URL(fileURLWithPath: path), atomically: true, encoding: .utf8)
    }
}
