import SwiftUI

@main
struct HIITFitApp: App {
    @StateObject private var historyStore: HistoryStore
    @State private var showAlert = false
    
    init() {
        let historyStore: HistoryStore
        do {
            historyStore = try HistoryStore(withChecking: true)
        } catch {
            print("Could not load history data")
            historyStore = HistoryStore()
            showAlert = true
        }
        _historyStore = StateObject(wrappedValue: historyStore)
    }
    
    var body: some Scene {
    WindowGroup {
      ContentView()
            .environmentObject(historyStore)
            .onAppear {
                print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("History"),
                      message: Text(
                        """
                        Unfortunately we can't load your past history.
                        Email support:
                            support @xyz.com
                        """
                      ))
            }
        }
    }
}
