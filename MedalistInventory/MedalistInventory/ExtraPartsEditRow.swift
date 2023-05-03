import SwiftUI

struct ExtraPartsEditRow: View {
    @ObservedObject var tableData: TableData
    @Binding var selectedTableData: ExtraPartsData?
    @State var tableDataToEdit: ExtraPartsData
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Company: \(selectedTableData?.company ?? "")")) {
                    Picker("Company", selection: $tableDataToEdit.company) {
                        ForEach(Filter.Company.allCases) { company in
                            Text(company.rawValue).tag(company)
                        }
                    }
                }
                
                Section(header: Text("Material: \(selectedTableData?.material ?? "")")) {
                    Picker("Material", selection: $tableDataToEdit.material) {
                        ForEach(Filter.Material.allCases) { material in
                            Text(material.rawValue).tag(material)
                        }
                    }
                }

                Section(header: Text("Thickness: \(selectedTableData?.thickness ?? "")")) {
                    Picker("Thickness", selection: $tableDataToEdit.thickness) {
                        ForEach(Filter.Thickness.allCases) { thickness in
                            Text(thickness.rawValue).tag(thickness)
                        }
                    }
                }
                
                Section(header: Text("Part Name: \(selectedTableData?.partname ?? "")")) {
                    TextField("Part Name", text: $tableDataToEdit.partname)
                }

                Section(header: Text("Quantity Exists: \(selectedTableData?.quantityexists ?? 0)")) {
                    TextField("Quantity Exists", value: $tableDataToEdit.quantityexists, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Quantity Max: \(selectedTableData?.quantitymax ?? 0)")) {
                    TextField("Quantity Max", value: $tableDataToEdit.quantitymax, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }

                Button(action: {
                    guard tableDataToEdit.quantityexists >= 0 || tableDataToEdit.quantitymax >= 0 else {
                        return
                    }

                    // Check if partname is empty
                    guard !tableDataToEdit.partname.isEmpty else {
                        return
                    }

                    let url = URL(string: "http://10.0.2.3/database_query_mobileapps.php")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    let postString = "task=update&schema=extra_parts_inventory&id=\(tableDataToEdit.id)&company=\(tableDataToEdit.company)&material=\(tableDataToEdit.material)&thickness=\(tableDataToEdit.thickness)&partname=\(tableDataToEdit.partname)&quantityexists=\(tableDataToEdit.quantityexists)&quantitymax=\(tableDataToEdit.quantitymax)"
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
                    
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save Changes")
                })
            }
            .navigationBarTitle("Edit Row")
        }
    }
}

struct ExtraPartsEditRow_Previews: PreviewProvider {
    static var previews: some View {
        let selectedTableData = ExtraPartsData(id: 1, company: "John Deere", material: "Aluminum Expanded Metal", thickness: "0.02 (SHIM)", partname: "TEST", quantityexists: 5, quantitymax: 10)
        ExtraPartsEditRow(tableData: TableData(), selectedTableData: .constant(selectedTableData), tableDataToEdit: selectedTableData)
    }
}
