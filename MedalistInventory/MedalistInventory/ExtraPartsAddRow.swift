import SwiftUI

struct ExtraPartsAddRow: View {
    @ObservedObject var tableData: TableData 
    @Binding var isPresented: Bool
    @State var id: Int = 0
    @State var company: String = "All"
    @State var material: String = "All"
    @State var thickness: String = "All"
    @State var partname: String = ""
    @State var quantityexists: Int = 0
    @State var quantitymax: Int = 0

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Company")) {
                    Picker("Company", selection: $company) {
                        ForEach(Filter.Company.allCases) { company in
                            Text(company.rawValue).tag(company)
                        }
                    }
                }
                Section(header: Text("Material")) {
                    Picker("Material", selection: $material) {
                        ForEach(Filter.Material.allCases) { material in
                            Text(material.rawValue).tag(material)
                        }
                    }
                }
                Section(header: Text("Thickness")) {
                    Picker("Thickness", selection: $thickness) {
                        ForEach(Filter.Thickness.allCases) { thickness in
                            Text(thickness.rawValue).tag(thickness)
                        }
                    }
                }
                Section(header: Text("Part Name")) {
                    TextField("Part Name", text: $partname)
                }
                Section(header: Text("Quantity Exists")) {
                    TextField("Quantity Exists", value: $quantityexists, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Quantity Max")) {
                    TextField("Quantity Max", value: $quantitymax, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                }
                Button(action: {
                    // Check if QuantityExists and QuantityMax are positive numbers
                    guard quantityexists >= 0 && quantitymax >= 0 else {
                        print("Quantity Exists and Quantity Max must be positive numbers")
                        return
                    }

                    // Check if partname is empty
                    guard !partname.isEmpty else {
                        print("Part Name must not be empty")
                        return
                    }

                    // Use database_query.php to add a new row to the database
                    let url = URL(string: "http://10.0.2.3/database_query_mobileapps.php")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    let postString = "task=insert&schema=extra_parts_inventory&company=\(company)&material=\(material)&thickness=\(thickness)&partname=\(partname)&quantityexists=\(quantityexists)&quantitymax=\(quantitymax)"
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
                    tableData.loadExtraParts()
                    
                    isPresented = false
                }, label: {
                    Text("Add Row")
                })
            }
            .navigationBarTitle("Add Extra Part")
        }
    }
}

struct ExtraPartsAddRow_Previews: PreviewProvider {
    static var previews: some View {
        ExtraPartsAddRow(tableData: TableData(), isPresented: .constant(true))
    }
}
