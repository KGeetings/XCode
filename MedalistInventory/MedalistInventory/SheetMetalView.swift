import SwiftUI

struct SheetMetalView: View {
    @State var filterSearchText: String = ""
    @State var filterMaterial: String = ""
    @State var filterThickness: String = ""
    @State var filterSheetSize: String = ""
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
                
                // Add a Picker here for filtering by material
                Picker(selection: $filterMaterial, label: HStack {
                    Text("Material")
                    Spacer()
                }) {
                    ForEach(Filter.Material.allCases) { material in
                        Text(material.rawValue).tag(material)
                    }
                }
                
                // Add a Picker here for filtering by thickness
                Picker(selection: $filterThickness, label: HStack {
                    Text("Thickness")
                    Spacer()
                }) {
                    ForEach(Filter.Thickness.allCases) { thickness in
                        Text(thickness.rawValue).tag(thickness)
                    }
                }
                
                // Add a Picker here for filtering by All, Fullsheets, or Remnants
                Picker(selection: $filterSheetSize, label: HStack {
                    Text("Sheet Size")
                    Spacer()
                }) {
                    ForEach(Filter.SheetSize.allCases) { sheetSize in
                        Text(sheetSize.rawValue).tag(sheetSize)
                    }
                }
                List(filteredTableData, id: \.id) { data in
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
                SheetMetalAddRow(isPresented: $showAddRowModal)
            })
            .sheet(item: $selectedTableData) { data in
                // Present Edit Row Modal
                SheetMetalEditRow(selectedTableData: $selectedTableData, tableDataToEdit: selectedTableData!)
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
