//
//  ContentView.swift
//  MedalistInventory
//
//  Created by Kenyon on 3/5/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .sheetMetal
    
    enum Tab {
        case sheetMetal
        case extraParts
    }
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(.gray)
    }
    
    var body: some View {
        TabView(selection: $selection) {
            SheetMetalView()
                .tabItem {
                    Label("Sheet Metal", systemImage: "star")
                }
                .tag(Tab.sheetMetal)
            ExtraPartsView()
                .tabItem {
                    Label("Extra Parts", systemImage: "list.bullet")
                }
                .tag(Tab.extraParts)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
