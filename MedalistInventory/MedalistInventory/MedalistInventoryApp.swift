import SwiftUI

//
//  MedalistInventoryApp.swift
//  MedalistInventory
//
//  Created by Kenyon on 3/5/23.
//

@main
struct MedalistInventoryApp: App {
    @StateObject var tableData = TableData()
    var body: some Scene {
        WindowGroup {
            ContentView(tableData: tableData)
        }
    }
}
