import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .sheetMetal
    @ObservedObject var tableData: TableData = TableData()
    
    enum Tab {
        case sheetMetal
        case extraParts
    }
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(.gray)
    }
    
    var body: some View {
        TabView(selection: $selection) {
            SheetMetalView(tableData: tableData, filter: .constant(Filter(search: "")))
                .tabItem {
                    Label("Sheet Metal", systemImage: "square.stack.3d.up.fill")
                }
                .tag(Tab.sheetMetal)
            ExtraPartsView()
                .tabItem {
                    Label("Extra Parts", systemImage: "cube.fill")
                }
                .tag(Tab.extraParts)
        }
        .onAppear { tableData.load() }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
