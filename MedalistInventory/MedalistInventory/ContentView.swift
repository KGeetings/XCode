//
//  ContentView.swift
//  MedalistInventory
//
//  Created by Kenyon on 3/5/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            NavigationLink(destination: TableView()) {
                Text("Load Table Data")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
