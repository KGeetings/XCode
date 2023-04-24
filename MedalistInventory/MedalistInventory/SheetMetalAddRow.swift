//
//  SheetMetalAddRow.swift
//  Medalist
//
//  Created by Kenyon on 4/24/23.
//

import SwiftUI

struct SheetMetalAddRow: View {
    @ObservedObject var tableData: TableData = TableData()
    @Binding var isPresented: Bool
    @State var id: Int = 0
    @State var material: String = "All"
    @State var thickness: String = "All"
    @State var length: Double = 0
    @State var width: Double = 0
    @State var quantity: Int = 0

    var body: some View {
        NavigationView {
            Form {
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
                Section(header: Text("Length")) {
                    TextField("Length", value: $length, formatter: numberFormatter)
                }
                Section(header: Text("Width")) {
                    TextField("Width", value: $width, formatter: numberFormatter)
                }
                Section(header: Text("Quantity")) {
                    TextField("Quantity", value: $quantity, formatter: NumberFormatter())
                }
                Button(action: {
                    // Check if Length, Width, Quantity are all positive numbers
                    guard length > 0 && width > 0 && quantity > 0 else {
                        print("Length, Width, Quantity must all be positive numbers")
                        return
                    }

                    // Check if Material and Thickness are not empty
                    guard !material.isEmpty && !thickness.isEmpty else {
                        print("Material and Thickness must not be empty")
                        return
                    }

                    // Check if length is greater or equal to width
                    guard length >= width else {
                        print("Length must be greater than or equal to Width")
                        return
                    }

                    // Use database_query.php to add a new row to the database
                    let url = URL(string: "http://10.0.2.3/database_query_mobileapps.php")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    let postString = "task=insert&schema=sheet_metal_inventory&material=\(material)&thickness=\(thickness)&length=\(length)&width=\(width)&quantity=\(quantity)"
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
                    
                    isPresented = false
                }, label: {
                    Text("Add Row")
                })
            }
            .navigationBarTitle("Add Row")
        }
    }
}

//struct SheetMetalAddRow_Previews: PreviewProvider {
//    static var previews: some View {
//        SheetMetalAddRow(isPresented: Binding<Bool>:true)
//    }
//}
