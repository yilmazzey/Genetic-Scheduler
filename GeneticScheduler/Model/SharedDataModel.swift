//
//  SharedDataModel.swift
//  GeneticScheduler
//
//  Created by Zeynep Yılmaz on 19.05.2024.
//

import Foundation
import SwiftUI
import Combine

class SharedDataModel: ObservableObject {
    @Published var instructors: [ReadInstructor.Instructor] = []
    @Published var rooms: [ReadRoom.Room] = []
    @Published var schedules: [OutputReader.Course] = []

    private var instructorReader = ReadInstructor()
    private var roomReader = ReadRoom()
    private var outputReader = OutputReader()

    func loadInstructors(from path: String) throws {
        try instructorReader.readFromFile(path: path)
        self.instructors = instructorReader.data
    }

    func loadRooms(from path: String) throws {
        try roomReader.readFromFile(path: path)
        self.rooms = roomReader.data
    }

    func loadSchedules(from path: String) throws {
        try outputReader.readFromFile(path: path)
        self.schedules = outputReader.data
    }
}
