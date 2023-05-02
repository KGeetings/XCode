import SwiftUI

struct ExtraPartsView: View {
    @State var filterSearchText: String = ""
    @State var filterMaterial: Filter.Material.RawValue = "All"
    @State var filterThickness: Filter.Thickness.RawValue = "All"
    @State var filterCompany: Filter.Company.RawValue = "All"
    @State var showAddRowModal: Bool = false
    @State var selectedTableData: ExtraPartsData?
    @ObservedObject var tableData: TableData = TableData()
    
    var filteredTableData: [ExtraPartsData] {
        var result = tableData.extraPartsData
        
        // Filter by material
        if !filterMaterial.isEmpty && filterMaterial != "All" {
            result = result.filter { $0.material == filterMaterial }
        }
        
        // Filter by thickness
        if !filterThickness.isEmpty && filterThickness != "All" {
            result = result.filter { $0.thickness == filterThickness }
        }

        // Filter by Company
        if !filterCompany.isEmpty && filterCompany != "All" {
            result = result.filter { $0.company == filterCompany }
        }
        
        // Filter by search text
        if !filterSearchText.isEmpty {
            result = result.filter {
                $0.material.localizedCaseInsensitiveContains(filterSearchText) ||
                $0.thickness.localizedCaseInsensitiveContains(filterSearchText) ||
                $0.company.localizedCaseInsensitiveContains(filterSearchText) ||
                $0.partname.localizedCaseInsensitiveContains(filterSearchText)
            }
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
                        Text("Company")
                        Picker("Company", selection: $filterCompany) {
                            ForEach(Filter.Company.allCases) { company in
                                Text(company.rawValue).tag(company)
                            }
                        }
                    }
                    Spacer()
                }

                List(filteredTableData, id: \.id) { data in
                    Button(action: {
                        selectedTableData = data
                    }, label: {
                        HStack(alignment: .top){
                            // With number formatter
                            VStack(alignment: .leading) {
                                Text("\(data.partname)")
                                Text("Qty: \(data.quantityexists) / Max: \(data.quantitymax)")
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("\(data.company)")
                                Text("\(data.material) x \(data.thickness)")
                            }
                        }
                    })
                }
            }
            .navigationBarTitle("Extra Parts Inv.")
            .sheet(isPresented: $showAddRowModal, content: {
                // Present Add Row Modal
                //ExtraPartsAddRow(isPresented: $showAddRowModal)
            })
            .sheet(item: $selectedTableData) { data in
                // Present Edit Row Modal
                ExtraPartsEditRow(selectedTableData: $selectedTableData, tableDataToEdit: data)
            }
        }
        .onAppear { tableData.load() }
    }
}

struct ExtraPartsView_Previews: PreviewProvider {
    static var previews: some View {
        ExtraPartsView()
    }
}
