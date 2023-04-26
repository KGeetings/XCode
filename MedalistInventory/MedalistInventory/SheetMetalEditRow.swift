import SwiftUI

struct SheetMetalEditRow: View {
    @Binding var tableData: [TableData]
    @Binding var selectedTableData: TableData
    // Store the new values in a temporary variable
    @State var tableDataToEdit: TableData
    var body: some View {
        NavigationView {
            Form {
//                Section(header: Text("Material: \(previousTableData.material)")) {
//                    Picker("Material", selection: $tableDataToEdit.material) {
//                        ForEach(Filter.Material.allCases) { material in
//                            Text(material.rawValue).tag(material)
//                        }
//                    }
//                }
//                Section(header: Text("Thickness: \(previousTableData.thickness)")) {
//                    Picker("Thickness", selection: $tableDataToEdit.thickness) {
//                        ForEach(Filter.Thickness.allCases) { thickness in
//                            Text(thickness.rawValue).tag(thickness)
//                        }
//                    }
//                }
//                Section(header: Text("Length: \(previousTableData.length)")) {
//                    TextField("Length", value: $tableDataToEdit.length, formatter: numberFormatter)
//                }
//                Section(header: Text("Width: \(previousTableData.width)")) {
//                    TextField("Width", value: $tableDataToEdit.width, formatter: numberFormatter)
//                }
//                Section(header: Text("Quantity: \(previousTableData.quantity)")) {
//                    TextField("Quantity", value: $tableDataToEdit.quantity, formatter: NumberFormatter())
//                }
//                Section(header: Text("Allocated: \(previousTableData.allocated)")) {
//                    TextField("Allocated", value: $tableDataToEdit.allocated, formatter: NumberFormatter())
//                }
//                Button(action: {
//                    // Check if Length, Width, Quantity, and Allocated are all positive numbers
//                    guard tableDataToEdit.length > 0 && tableDataToEdit.width > 0 else { return }
//                    guard tableDataToEdit.length < 125 && tableDataToEdit.width < 125 else { return }
//                    guard tableDataToEdit.quantity >= 0 else { return }
//
//                    // Check if Lenght is greater than or equal to Width
//                    guard tableDataToEdit.length >= tableDataToEdit.width else { return }
//
//                    // Use database_query.php to update the row in the database
//                    let url = URL(string: "http://10.0.2.3/database_query_mobileapps.php")!
//                    var request = URLRequest(url: url)
//                    request.httpMethod = "POST"
//                    let postString = "task=update&schema=sheet_metal_inventory&id=\(tableDataToEdit.id)&material=\(tableDataToEdit.material)&thickness=\(tableDataToEdit.thickness)&length=\(tableDataToEdit.length)&width=\(tableDataToEdit.width)&quantity=\(tableDataToEdit.quantity)&allocated=\(tableDataToEdit.allocated)"
//                    request.httpBody = postString.data(using: .utf8)
//                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                        guard let data = data, error == nil else {
//                            print(error?.localizedDescription ?? "No data")
//                            return
//                        }
//                        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//                        if let responseJSON = responseJSON as? [String: Any] {
//                            print(responseJSON)
//                        }
//                    }
//                    task.resume()
//
//                    isPresented = nil
//                }, label: {
//                    Text("Save Changes")
//                })
            }
            .navigationBarTitle("Edit Row")
        }
    }
}

struct SheetMetalEditRow_Previews: PreviewProvider {
    static var previews: some View {
        SheetMetalEditRow(tableData: .constant([TableData]()), selectedTableData: .constant(TableData()), tableDataToEdit: TableData())
    }
}
