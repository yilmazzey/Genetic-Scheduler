//
//  CsvHandler.swift
//  GeneticScheduler
//
//  Created by Zeynep Yılmaz on 19.05.2024.
//

import Foundation
import SwiftCSV

class CSVHandler {
    // Function to read CSV from a file URL
    func readCSV(from fileURL: URL) throws -> CSV {
        do {
            let csv = try CSV(url: fileURL)
            return csv
        } catch {
            throw error
        }
    }
    
    // Function to write data to a CSV file
    func writeCSV(to fileURL: URL, with rows: [[String]], headers: [String]) throws {
        var csvText = headers.joined(separator: ",") + "\n"
        
        for row in rows {
            let rowString = row.map { String(describing: $0) }.joined(separator: ",")
            csvText += rowString + "\n"
        }
        
        do {
            try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            throw error
        }
    }
}
