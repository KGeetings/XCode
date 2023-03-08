//
//  TableView.swift
//  MedalistInventory
//
//  Created by Kenyon on 3/5/23.
//

import SwiftUI

struct TableView: View {
    @State var searchText: String = ""
    @State var showAddRowModal: Bool = false
    @State var selectedTableData: TableData?
    @State var tableData = [TableData]()
    
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
    
    var filteredTableData: [TableData] {
        if searchText.isEmpty {
            return tableData
        } else {
            return tableData.filter { $0.material.localizedCaseInsensitiveContains(searchText) || $0.thickness.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search", text: $searchText)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                    Button(action: { showAddRowModal = true }, label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    })
                    .padding(.horizontal, 10)
                }
                .padding(.horizontal, 10)
                List(filteredTableData) { data in
                    Button(action: {
                        selectedTableData = data
                    }, label: {
                        HStack {
                            Text("\(data.material) - \(data.thickness) x \(data.length) x \(data.width)")
                            Spacer()
                            Text("\(data.quantity) / \(data.allocated)")
                        }
                    })
                }
            }
            .navigationBarTitle("Sheet Metal Inv.")
            .sheet(isPresented: $showAddRowModal, content: {
                // Present Add Row Modal
                AddTableRowView(tableData: $tableData, isPresented: $showAddRowModal)
            })
            .sheet(item: $selectedTableData) { data in
                // Present Edit Row Modal
                EditTableRowView(tableData: $tableData, tableDataToEdit: data, isPresented: $selectedTableData)
            }
        }
        .onAppear(perform: loadData)
    }
}

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        TableView()
    }
}

struct AddTableRowView: View {
    @Binding var tableData: [TableData]
    @Binding var isPresented: Bool
    @State var material: String = ""
    @State var thickness: String = ""
    @State var length: String = ""
    @State var width: String = ""
    @State var quantity: String = ""
    @State var allocated: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Material Details")) {
                    TextField("Material", text: $material)
                    TextField("Thickness", text: $thickness)
                    TextField("Length", text: $length)
                    TextField("Width", text: $width)
                    TextField("Quantity", text: $quantity)
                    TextField("Allocated", text: $allocated)
                }
                Section {
                    Button(action: {
                        let newId = UUID().uuidString
                        let newRow = TableData(id: newId, material: material, thickness: thickness, length: length, width: width, quantity: quantity, allocated: allocated)
                        tableData.append(newRow)
                        isPresented = false
                    }, label: {
                        Text("Add Row")
                    })
                }
            }
            .navigationBarTitle("Add Row")
        }
    }
}

struct EditTableRowView: View {
    @Binding var tableData: [TableData]
    @State var tableDataToEdit: TableData
    @Binding var isPresented: TableData?
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Material Details")) {
                    TextField("Material", text: $tableDataToEdit.material)
                    TextField("Thickness", text: $tableDataToEdit.thickness)
                    TextField("Length", text: $tableDataToEdit.length)
                    TextField("Width", text: $tableDataToEdit.width)
                    TextField("Quantity", text: $tableDataToEdit.quantity)
                    TextField("Allocated", text: $tableDataToEdit.allocated)
                }
                Section {
                    Button(action: {
                        if let index = tableData.firstIndex(where: { $0.id == tableDataToEdit.id }) {
                            tableData[index] = tableDataToEdit
                        }
                        isPresented = nil
                    }, label: {
                        Text("Save Changes")
                    })
                }
            }
            .navigationBarTitle("\(tableDataToEdit.material) - \(tableDataToEdit.thickness)")
        }
    }
}

struct TableData: Codable, Identifiable {
    let id: String
    var material: String
    var thickness: String
    var length: String
    var width: String
    var quantity: String
    var allocated: String
}
