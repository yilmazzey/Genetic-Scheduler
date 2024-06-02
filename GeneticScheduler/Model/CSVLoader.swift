//
//  CSVLoader.swift
//  GeneticScheduler
//
//  Created by goknur arıcan on 22.05.2024.
//
import Foundation
import Combine

class CSVLoader: ObservableObject {
    @Published var headers: [String] = []
    @Published var records: [CSVRecord] = []

    func loadCSV(from url: URL) {
        do {
            let csvString = try String(contentsOf: url)
            print("CSV Content:\n\(csvString)") // Debug print
            let rows = csvString.components(separatedBy: "\n").filter { !$0.isEmpty }
            if let headerRow = rows.first {
                headers = headerRow.components(separatedBy: ",")
                print("Headers: \(headers)") // Debug print
            }
            records = rows.dropFirst().map { row in
                let columns = row.components(separatedBy: ",")
                return CSVRecord(columns: columns)
            }
            for record in records {
                print("Record: \(record.columns)") // Debug print
            }
        } catch {
            print("Failed to load CSV: \(error)")
        }
    }
    
    func getRecordsAsStringArray() -> [[String]] {
        return records.map { $0.columns }
    }
}

struct CSVRecord: Identifiable {
    let id = UUID()
    let columns: [String]
}
