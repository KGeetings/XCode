//
//  TableView.swift
//  MedalistInventory
//
//  Created by Kenyon on 3/5/23.
//

import SwiftUI

struct TableView: View {
    @State var tableData = [TableData]()
    
    var body: some View {
        NavigationView {
            List(tableData, id: \.id) { data in
                NavigationLink(destination: DetailView(tableData: data)) {
                    VStack(alignment: .leading) {
                        Text("\(data.material) - \(data.thickness)mm")
                            .font(.headline)
                        Text("\(data.length) x \(data.width) mm")
                            .font(.subheadline)
                        Text("Qty: \(data.quantity)")
                            .font(.subheadline)
                    }
                }
            }
            .navigationBarTitle("Table Data")
        }
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        guard let url = URL(string: "http://localhost/table_data.php") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data found: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let decodedData = try? JSONDecoder().decode([TableData].self, from: data) {
                DispatchQueue.main.async {
                    self.tableData = decodedData
                }
            } else {
                print("Invalid response from server")
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
            Text("Thickness: \(tableData.thickness) mm")
                .font(.subheadline)
            Text("Length: \(tableData.length) mm")
                .font(.subheadline)
            Text("Width: \(tableData.width) mm")
                .font(.subheadline)
            Text("Quantity: \(tableData.quantity)")
                .font(.subheadline)
            Text("Allocated: \(tableData.allocated ? "Yes" : "No")")
                .font(.subheadline)
        }
        .navigationBarTitle("\(tableData.material) - \(tableData.thickness)mm")
    }
}

struct TableData: Codable, Identifiable {
    let id: Int
    let material: String
    let thickness: Double
    let length: Double
    let width: Double
    let quantity: Int
    let allocated: Bool
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(tableData: TableData)
    }
}
