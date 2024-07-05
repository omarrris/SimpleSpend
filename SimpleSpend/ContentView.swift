import SwiftUI

struct ContentView: View {
    @StateObject var realmManager = RealmManager()
    @State private var isStarted = false

    var body: some View {
        if isStarted {
            TabView {
                Expenses(expenses: realmManager.expenses)
                    .environmentObject(realmManager)
                    .tabItem {
                        Label("Expenses", systemImage: "tray.and.arrow.up.fill")
                    }
                
                Reports()
                    .environmentObject(realmManager)
                    .tabItem {
                        Label("Reports", systemImage: "chart.bar.fill")
                    }
                
                Add()
                    .environmentObject(realmManager)
                    .tabItem {
                        Label("Add", systemImage: "plus")
                    }
                
                Settings()
                    .environmentObject(realmManager)
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
            .darkMode()
        } else {
            SignIn(isStarted: $isStarted)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .darkMode()
    }
}
