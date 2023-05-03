import SwiftUI

@main
struct MedalistInventoryApp: App {
    @StateObject var tableData = TableData()
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(.gray)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(tableData: tableData)
        }
    }
}
