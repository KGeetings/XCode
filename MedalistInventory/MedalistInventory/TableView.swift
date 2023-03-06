//
//  TableView.swift
//  MedalistInventory
//
//  Created by Kenyon on 3/5/23.
//

import SwiftUI

struct TableView: View {
    @State var tableData = [TableData]()
    @State var searchText = ""
    @State var sortAscending = true
    
    var sortedData: [TableData] {
        tableData.sorted { (data1, data2) -> Bool in
            if sortAscending {
                return data1.material < data2.material
            } else {
                return data1.material > data2.material
            }
        }
    }
    var filteredData: [TableData] {
        if searchText.isEmpty {
            return tableData
        } else {
            return tableData.filter { data in
                data.material.localizedCaseInsensitiveContains(searchText) ||
                data.thickness.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Search")) {
                    TextField("Search", text: $searchText)
                }
                Section(header: Text("Sort")) {
                    Picker("Sort by", selection: $sortAscending) {
                        Text("Material A-Z").tag(true)
                        Text("Material Z-A").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                ForEach(filteredData) { data in
                    NavigationLink(destination: DetailView(tableData: data)) {
                        VStack(alignment: .leading) {
                            Text("\(data.material) - \(data.thickness)")
                                .font(.headline)
                            HStack {
                                Text("Size:")
                                    .font(.subheadline)
                                Text("\(data.length) x \(data.width) in")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            HStack {
                                Text("Qty:")
                                    .font(.subheadline)
                                Text("\(data.quantity)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Table Data")
        }
        .onAppear(perform: loadData)
    }
    
    // http://10.0.2.3/table-data.php
    func loadData() {
        guard let url = URL(string: "http://10.0.2.3/table-data.php") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data found: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP Error: \(httpResponse.statusCode)")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([TableData].self, from: data)
                DispatchQueue.main.async {
                    self.tableData = decodedData
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        TableView()
    }
}

struct DetailView: View {
    let tableData: TableData
    
    var body: some View {
        VStack {
            Text("Material: \(tableData.material)")
                .font(.headline)
            Text("Thickness: \(tableData.thickness)")
                .font(.subheadline)
            Text("Length: \(tableData.length) in")
                .font(.subheadline)
            Text("Width: \(tableData.width) in")
                .font(.subheadline)
            Text("Quantity: \(tableData.quantity)")
                .font(.subheadline)
            Text("Allocated: \(tableData.allocated)")
                .font(.subheadline)
        }
        .navigationBarTitle("\(tableData.material) - \(tableData.thickness)")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(tableData: TableData(id: "1", material: "Aluminum", thickness: "0.12 (11GA)", length: "120", width: "60", quantity: "10", allocated: "1"))
    }
}

struct TableData: Codable, Identifiable {
    let id: String
    let material: String
    let thickness: String
    let length: String
    let width: String
    let quantity: String
    let allocated: String
}
