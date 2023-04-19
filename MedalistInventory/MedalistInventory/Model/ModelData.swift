/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Storage for model data.
*/

import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var tableData: [TableData] = loadData()
}

// Returns tableData from the database or local JSON file
func loadData() -> [TableData] {
    // Example JSON: {"id":169,"material":"Aluminum 3003","thickness":"0.06 (16GA)","length":85.5,"width":48.25,"quantity":1,"allocated":3}
    guard let url = URL(string: "http://10.0.2.3/table-data.php?table=sheet_metal") else {
        print("Invalid URL")
        fatalError("Invalid URL")
    }
    
    let request = URLRequest(url: url)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        // Check if there is data, if not, use the fallback to local JSON file in Resources/table-data.json
        guard let data = data else {
            print("No data found: \(error?.localizedDescription ?? "Unknown error").")
            // Load local JSON file
            guard let fileURL = Bundle.main.url(forResource: "table-data", withExtension: "json") else {
                print("Error loading local JSON file")
                fatalError("Error loading local JSON file")
            }
            
            do {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([TableData].self, from: data)
                DispatchQueue.main.async {
                    return decodedData
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                fatalError("Error decoding JSON: \(error.localizedDescription)")
            }
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid response")
            fatalError("Invalid response")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("HTTP Error: \(httpResponse.statusCode)")
            fatalError("HTTP Error: \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode([TableData].self, from: data)
            DispatchQueue.main.async {
                return decodedData
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
            fatalError("Error decoding JSON: \(error.localizedDescription)")
        }
    }
}
