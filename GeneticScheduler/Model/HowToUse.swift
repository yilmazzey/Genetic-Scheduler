//
//  HowToUse.swift
//  GeneticScheduler
//
//  Created by goknur arıcan on 22.05.2024.
//
import SwiftUI

struct HowToUse: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("User Guide for Class Scheduler")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 20) {
                    InstructionView(
                        icon: "app.badge",
                        title: "Open the App",
                        description: "Open the app and log in with your credentials."
                    )
                    
                    InstructionView(
                        icon: "calendar.badge.plus",
                        title: "Create a New Schedule",
                        description: "Once logged in, navigate to the 'Schedule Generator' to create a new schedule."
                    )
                    
                    InstructionView(
                        icon: "square.and.arrow.down",
                        title: "Import Files",
                        description: "Import files for instructor and room information in the correct format."
                    )
                    
                    InstructionView(
                        icon: "doc.plaintext",
                        title: "View Existing Schedules",
                        description: "View existing schedules by navigating to 'Existing Schedules'."
                    )
                    
                    InstructionView(
                        icon: "envelope",
                        title: "Contact Support",
                        description: "Contact itoffice@mef.edu.tr in case of need."
                    )
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            .padding()
        }
        .navigationTitle("How to Use")
    }
}

struct InstructionView: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct HowToUse_Previews: PreviewProvider {
    static var previews: some View {
        HowToUse()
    }
}
