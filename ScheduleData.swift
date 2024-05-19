//
//  ScheduleData.swift
//  GeneticScheduler
//
//  Created by Zeynep Yılmaz on 19.05.2024.
//

import Foundation


class ScheduleData: ObservableObject {
    @Published var instructors: [ReadInstructor.Instructor] = []
    @Published var rooms: [ReadRoom.Room] = []
}
