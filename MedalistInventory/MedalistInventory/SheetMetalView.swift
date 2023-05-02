import SwiftUI

struct SheetMetalView: View {
    @State var filterSearchText: String = ""
    @State var filterMaterial: Filter.Material.RawValue = "All"
    @State var filterThickness: Filter.Thickness.RawValue = "All"
    @State var filterSheetSize: Filter.SheetSize.RawValue = "All"
    @State var showAddRowModal: Bool = false
    @State var selectedTableData: SheetMetalData?
    @ObservedObject var tableData: TableData = TableData()
    
    var filteredTableData: [SheetMetalData] {
        var result = tableData.sheetMetalData
        
        // Filter by material
        if !filterMaterial.isEmpty && filterMaterial != "All" {
            result = result.filter { $0.material == filterMaterial }
        }
        
        // Filter by thickness
        if !filterThickness.isEmpty && filterThickness != "All" {
            result = result.filter { $0.thickness == filterThickness }
        }
        
        // Filter by sheet size
        if !filterSheetSize.isEmpty && filterSheetSize != "All" {
            if filterSheetSize == "Fullsheets" {
                //return (length == 120.0 && width == 60.0) || (length == 120.0 && width == 48.0) || (length == 96.0 && width == 60.0) || (length == 96.0 && width == 48.0);
                result = result.filter {
                    ($0.length == 120.0 && $0.width == 60.0) ||
                    ($0.length == 120.0 && $0.width == 48.0) ||
                    ($0.length == 96.0 && $0.width == 60.0) ||
                    ($0.length == 96.0 && $0.width == 48.0)
                }
            } else if filterSheetSize == "Remnants" {
                //return !(length == 120.0 && width == 60.0) && !(length == 120.0 && width == 48.0) && !(length == 96.0 && width == 60.0) && !(length == 96.0 && width == 48.0);
                result = result.filter {
                    ($0.length != 120.0 && $0.width != 60.0) &&
                    ($0.length != 120.0 && $0.width != 48.0) &&
                    ($0.length != 96.0 && $0.width != 60.0) &&
                    ($0.length != 96.0 && $0.width != 48.0)
                }
            }
        }
        
        // Filter by search text
        if !filterSearchText.isEmpty {
            result = result.filter { $0.material.localizedCaseInsensitiveContains(filterSearchText) || $0.thickness.localizedCaseInsensitiveContains(filterSearchText)}
        }
        
        return result
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Search", text: $filterSearchText)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                    Button(action: { showAddRowModal = true }, label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    })
                    .padding(.horizontal, 20)
                }
                HStack(alignment: .top) {
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Material")
                        Picker("Material", selection: $filterMaterial) {
                            ForEach(Filter.Material.allCases) { material in
                                Text(material.rawValue).tag(material)
                            }
                        }
                    }
                    Spacer()
                    VStack(alignment: .center) {
                        Text("Thickness")
                        Picker("Thickness", selection: $filterThickness) {
                            ForEach(Filter.Thickness.allCases) { thickness in
                                Text(thickness.rawValue).tag(thickness)
                            }
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Sheet Size")
                        Picker("Sheet Size", selection: $filterSheetSize) {
                            ForEach(Filter.SheetSize.allCases) { sheetSize in
                                Text(sheetSize.rawValue).tag(sheetSize)
                            }
                        }
                    }
                    Spacer()
                }
                List(filteredTableData, id: \.id) { data in
                    Button(action: {
                        selectedTableData = data
                    }) {
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
                    }
                    .swipeActions {
                        // Add delete action
                        Button(action: {
                            // Remove row from table data, using id
                            let url = URL(string: "http://10.0.2.3/database_query_mobileapps.php")!
                            var request = URLRequest(url: url)
                            request.httpMethod = "POST"
                            let postString = "task=delete&schema=sheet_metal_inventory&id=\(data.id)"
                            request.httpBody = postString.data(using: .utf8)
                            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                                guard let data = data, error == nil else {
                                    print(error?.localizedDescription ?? "No data")
                                    return
                                }
                                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                                if let responseJSON = responseJSON as? [String: Any] {
                                    print(responseJSON)
                                }
                            }
                            task.resume()
                            
                            // Reload the tableData
                            tableData.load()
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                }
            }
            .navigationBarTitle("Sheet Metal Inv.")
            .sheet(isPresented: $showAddRowModal, content: {
                // Present Add Row Modal
                SheetMetalAddRow(isPresented: $showAddRowModal)
            })
            .sheet(item: $selectedTableData) { data in
                // Present Edit Row Modal
                SheetMetalEditRow(selectedTableData: $selectedTableData, tableDataToEdit: data)
            }
        }
        .onAppear { tableData.load() }
    }
}

struct SheetMetalView_Previews: PreviewProvider {
    static var previews: some View {
        SheetMetalView(tableData: TableData())
    }
}
