import SwiftUI
import PythonKit

struct ContentView: View {
    @State private var isAuthenticated = false

    var body: some View {
        NavigationView {
            SidebarView(isAuthenticated: $isAuthenticated)
            WelcomeView(isAuthenticated: $isAuthenticated)
                .navigationTitle("Genetic Scheduler")
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SidebarView: View {
    @Binding var isAuthenticated: Bool

    var body: some View {
        List {
            NavigationLink(destination: WelcomeView(isAuthenticated: $isAuthenticated)) {
                Label("Welcome", systemImage: "star")
            }

            if isAuthenticated {
                Spacer()

                Text("DASHBOARD")
                    .font(.system(size: 10))
                    .fontWeight(.bold)
                Group {
                    NavigationLink(destination: GeneticScheduler()) {
                        Label("Schedule generator", systemImage: "globe")
                    }
                    
                    NavigationLink(destination: ExistingSchedules()) {
                        Label("Existing Schedules", systemImage: "rectangle.stack")
                    }
                }
                
                Spacer()
                
                Divider()
                Button(action: {
                    isAuthenticated = false // Log out
                }) {
                    Label("Sign Out", systemImage: "arrow.backward")
                }
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Explore")
        .frame(minWidth: 150, idealWidth: 250, maxWidth: 300)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar, label: {
                    Image(systemName: "sidebar.left")
                })
            }
        }
    }
}

struct WelcomeView: View {
    @Binding var isAuthenticated: Bool
    @State private var userID: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""

    let correctUserID = "123" // Hardcoded username
    let correctPassword = "123" // Hardcoded password

    var body: some View {
        HStack(spacing: 20) {
            VStack {
                Spacer()
                Spacer()
                Image("Mef") // Make sure the image is in your assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.top, 50)

                Text("Welcome to Class Scheduling System")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .padding()

                Text("Please login to continue")
                    .font(.body)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                Spacer()
                Spacer()
            }
            .background(Color.gray)
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand vertically to full height

            VStack {
                Spacer()
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .padding(.top, 50)

                TextField("User ID", text: $userID)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    login()
                }) {
                    Text("Login")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(minWidth: 50, maxWidth: 150)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(alertMessage))
                }

                Spacer()
            }
            .background(Color.black)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }

    func login() {
        if userID == correctUserID && password == correctPassword {
            isAuthenticated = true
            alertMessage = "Authorization successful"
        } else {
            isAuthenticated = false
            alertMessage = "Authorization unsuccessful, please try again"
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Function to toggle the sidebar
func toggleSidebar() {
    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
}
