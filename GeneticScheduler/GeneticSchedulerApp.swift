//
//  GeneticSchedulerApp.swift
//  GeneticScheduler
//
//  Created by Zeynep Yılmaz on 18.05.2024.
//

//
//  GeneticSchedulerApp.swift
//  GeneticScheduler
//
//  Created by Zeynep Yılmaz on 18.05.2024.
//

import SwiftUI

@main
struct GeneticSchedulerApp: App {
    @StateObject private var sharedData = SharedDataModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sharedData)
        }
    }
}
