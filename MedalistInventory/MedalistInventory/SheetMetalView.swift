import SwiftUI

struct SheetMetalView: View {
    @State var filterSearchText: String = ""
    @State var filterMaterial: String = ""
    @State var filterThickness: String = ""
    @State var filterSheetSize: String = ""
    @State var showAddRowModal: Bool = false
    @State var selectedTableData: SheetMetalData?
    @ObservedObject var tableData: TableData = TableData()
    @Binding var filter: Filter

    var filteredTableData: [SheetMetalData] {
        // Filter the data based on the current state of the filter
        tableData.data.filter { data in
            // Filter by search text
            filterSearchText.isEmpty || data.material.localizedCaseInsensitiveContains(filterSearchText)
                || data.thickness.localizedCaseInsensitiveContains(filterSearchText)
                || data.length.description.localizedCaseInsensitiveContains(filterSearchText)
                || data.width.description.localizedCaseInsensitiveContains(filterSearchText)
            // Filter by material
            && (filter.materialFilter == .all || data.material == filter.materialFilter.rawValue)
            // Filter by thickness
            && (filter.thicknessFilter == .all || data.thickness == filter.thicknessFilter.rawValue)
            // Filter by sheet size
            && (filter.sheetSizeFilter == .all || (filter.sheetSizeFilter == .fullsheet && data.isFullSheet) || (filter.sheetSizeFilter == .remnant && !data.isFullSheet))
        }
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
                // TODO
                // Add a Picker here for filtering by material
                Picker("Material", selection: $filter.materialFilter) {
                    ForEach(Filter.Material.allCases) { material in
                        Text(material.rawValue).tag(material)
                    }
                }

                // Add a Picker here for filtering by thickness
                Picker("Thickness", selection: $filter.thicknessFilter) {
                    ForEach(Filter.Thickness.allCases) { thickness in
                        Text(thickness.rawValue).tag(thickness)
                    }
                }
                // Add a Picker here for filtering by All, Fullsheets, or Remnants
                .padding(.horizontal, 10)
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
        SheetMetalView(tableData: TableData(), filter: .constant(Filter(search: "")))
    }
}
