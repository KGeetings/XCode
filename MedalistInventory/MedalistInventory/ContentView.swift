import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .sheetMetal
    @ObservedObject var tableData: TableData
    
    enum Tab {
        case sheetMetal
        case extraParts
    }
    
    var body: some View {
        TabView(selection: $selection) {
            SheetMetalView(tableData: tableData)
                .tabItem {
                    Label("Sheet Metal", systemImage: "square.stack.3d.up.fill")
                }
                .tag(Tab.sheetMetal)
            ExtraPartsView(tableData: tableData)
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
        ContentView(tableData: TableData())
    }
}
