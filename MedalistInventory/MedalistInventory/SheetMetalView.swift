import SwiftUI

struct SheetMetalView: View {
    @State var searchText: String = ""
    @State var showAddRowModal: Bool = false
    @State var selectedTableData: TableData?
    @State var tableData = [TableData]()
    
    func loadData() {
        // Example JSON: {"id":169,"material":"Aluminum 3003","thickness":"0.06 (16GA)","length":85.5,"width":48.25,"quantity":1,"allocated":3}
        guard let url = URL(string: "http://10.0.2.3/table-data.php?table=sheet_metal") else {
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
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([TableData].self, from: data)
                DispatchQueue.main.async {
                    tableData = decodedData
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
        NavigationStack {
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
                // Add a Picker here for filtering by material
                // Add a Picker here for filtering by thickness
                // Add a Picker here for filtering by All, Fullsheets, or Remnants
                .padding(.horizontal, 10)
                List(filteredTableData) { data in
                    Button(action: {
                        selectedTableData = data
                    }, label: {
                        HStack(alignment: .top){
                            // With number formatter
                            VStack(alignment: .leading) {
                                Text("\(data.material)")
                                Text("Qty: \(data.quantity) / Alloc: \(data.allocated)")
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("\(data.thickness)")
                                Text("\(numberFormatter.string(from: NSNumber(value: data.length))!) x \(numberFormatter.string(from: NSNumber(value: data.width))!)")
                            }
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

struct SheetMetalView_Previews: PreviewProvider {
    static var previews: some View {
        SheetMetalView()
    }
}

let numberFormatter: NumberFormatter = {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 2
    return numberFormatter
}()

struct AddTableRowView: View {
    @Binding var tableData: [TableData]
    @Binding var isPresented: Bool
    @State var id: Int = 0
    @State var material: String = ""
    @State var thickness: String = ""
    @State var length: Double = 0
    @State var width: Double = 0
    @State var quantity: Int = 0
    @State var allocated: Int = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Material")) {
                    TextField("Material", text: $material)
                }
                Section(header: Text("Thickness")) {
                    TextField("Thickness", text: $thickness)
                }
                Section(header: Text("Length")) {
                    TextField("Length", value: $length, formatter: numberFormatter)
                }
                Section(header: Text("Width")) {
                    TextField("Width", value: $width, formatter: numberFormatter)
                }
                Section(header: Text("Quantity")) {
                    TextField("Quantity", value: $quantity, formatter: NumberFormatter())
                }
                Section(header: Text("Allocated")) {
                    TextField("Allocated", value: $allocated, formatter: NumberFormatter())
                }
                Button(action: {
                    let newRow = TableData(id: id, material: material, thickness: thickness, length: Double(length), width: Double(width), quantity: quantity, allocated: allocated)
                    tableData.append(newRow)
                    isPresented = false
                }, label: {
                    Text("Add Row")
                })
            }
            .navigationBarTitle("Add Row")
        }
    }
}

struct EditTableRowView: View {
    @Binding var tableData: [TableData]
    @State var previousTableData: TableData
    @State var tableDataToEdit: TableData
    @Binding var isPresented: TableData?
    var body: some View {
        NavigationView {
            Form {
                VStack{
                    Text("Material: \(previousTableData.material)")
                        .font(.title)
                    TextField("Material", text: $tableDataToEdit.material)
                    Text("Thickness: \(previousTableData.thickness)")
                        .font(.title)
                    TextField("Thickness", text: $tableDataToEdit.thickness)
                    TextField("Length", value: $tableDataToEdit.length, formatter: numberFormatter)
                    TextField("Width", value: $tableDataToEdit.width, formatter: numberFormatter)
                    TextField("Quantity", value: $tableDataToEdit.quantity, formatter: NumberFormatter())
                    TextField("Allocated", value: $tableDataToEdit.allocated, formatter: NumberFormatter())
                    Button(action: {
                        if let index = tableData.firstIndex(where: { $0.id == tableDataToEdit.id }) {
                            tableData[index] = tableDataToEdit
                        }
                        isPresented = nil
                    }, label: {
                        Text("Save Changes")
                    })
                }
                .padding()
            }
            //.navigationBarTitle("\(tableDataToEdit.material) - \(tableDataToEdit.thickness)")
        }
    }
}

struct TableData: Codable, Identifiable {
    var id: Int
    var material: String
    var thickness: String
    var length: Double
    var width: Double
    var quantity: Int
    var allocated: Int
}
