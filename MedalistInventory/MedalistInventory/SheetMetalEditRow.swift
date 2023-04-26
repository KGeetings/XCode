import SwiftUI

struct SheetMetalEditRow: View {
    //@Binding var tableData: [SheetMetalData]?
    @Binding var selectedTableData: SheetMetalData?
    // Store the new values in a temporary variable
    @Binding var tableDataToEdit: SheetMetalData
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Material: \(selectedTableData?.material ?? "")")) {
                    Picker("Material", selection: $tableDataToEdit.material) {
                        ForEach(Filter.Material.allCases, id: \.self) { material in
                            Text(material.rawValue).tag(material)
                        }
                    }
                }

                Section(header: Text("Thickness: \(selectedTableData?.thickness ?? "")")) {
                    Picker("Thickness", selection: $tableDataToEdit.thickness) {
                        ForEach(Filter.Thickness.allCases, id: \.self) { thickness in
                            Text(thickness.rawValue).tag(thickness)
                        }
                    }
                }

                Section(header: Text("Length: \(selectedTableData?.length ?? "")")) {
                    TextField("Length", value: $tableDataToEdit.length, formatter: numberFormatter)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Width: \(selectedTableData?.width ?? "")")) {
                    TextField("Width", value: $tableDataToEdit.width, formatter: numberFormatter)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Quantity: \(selectedTableData?.quantity ?? "")")) {
                    TextField("Quantity", value: $tableDataToEdit.quantity, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Allocated: \(selectedTableData?.allocated ?? "")")) {
                    TextField("Allocated", value: $tableDataToEdit.allocated, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }

                Button(action: {
                    guard tableDataToEdit.length > 0 && tableDataToEdit.width > 0 else {
                        return
                    }
                    guard tableDataToEdit.length < 125 && tableDataToEdit.width < 125 else {
                        return
                    }
                    guard tableDataToEdit.quantity >= 0 else {
                        return
                    }
                    guard tableDataToEdit.length >= tableDataToEdit.width else {
                        return
                    }

                    let url = URL(string: "http://10.0.2.3/database_query_mobileapps.php")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    let postString = "task=update&schema=sheet_metal_inventory&id=\(tableDataToEdit.id)&material=\(tableDataToEdit.material)&thickness=\(tableDataToEdit.thickness)&length=\(tableDataToEdit.length)&width=\(tableDataToEdit.width)&quantity=\(tableDataToEdit.quantity)&allocated=\(tableDataToEdit.allocated)"
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

                }, label: {
                    Text("Save Changes")
                })
            }
            .navigationBarTitle("Edit Row")
        }
    }
}

//struct SheetMetalEditRow_Previews: PreviewProvider {
//    static var previews: some View {
//        SheetMetalEditRow(tableData: .constant([SheetMetalData]()), selectedTableData: .constant(SheetMetalData()), tableDataToEdit: SheetMetalData())
//    }
//}
