import Foundation

import Foundation

struct SheetMetalData: Codable {
    let id: Int
    let material: String
    let thickness: String
    let length: Double
    let width: Double
    let quantity: Int
    let allocated: Int
}

class TableData: ObservableObject {
    @Published var sheetMetalData: [SheetMetalData] = []
    
    func load() {
        if let url = Bundle.main.url(forResource: "table-data", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let sheetMetalData = try decoder.decode([SheetMetalData].self, from: data)
                DispatchQueue.main.async {
                    self.sheetMetalData = sheetMetalData
                }
            } catch {
                print("Failed to load table data: \(error.localizedDescription)")
            }
        } else {
            print("Failed to locate example.json file.")
        }
    }

/*     func loadData() {
        // Example JSON: {"id":169,"material":"Aluminum 3003","thickness":"0.06 (16GA)","length":85.5,"width":48.25,"quantity":1,"allocated":3}
        guard let url = URL(string: "http://10.0.2.3/table-data.php?table=sheet_metal") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check if there is data, if not, use the fallback to local JSON file in Resources/table-data.json
            guard let data = data else {
                print("No data found: \(error?.localizedDescription ?? "Unknown error").")
                // Load local JSON file
                guard let fileURL = Bundle.main.url(forResource: "table-data", withExtension: "json") else {
                    print("Error loading local JSON file")
                    return
                }
                
                do {
                    let data = try Data(contentsOf: fileURL)
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode([TableData].self, from: data)
                    DispatchQueue.main.async {
                        tableData = decodedData
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP Error: \(httpResponse.statusCode)")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([TableData].self, from: data)
                DispatchQueue.main.async {
                    tableData = decodedData
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
    } */
}
