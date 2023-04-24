import Foundation

import Foundation

struct SheetMetalData: Codable, Identifiable {
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
        guard let url = URL(string: "http://10.0.2.3/table-data.php?table=sheet_metal") else {
            print("Invalid URL")
            fallbackToLocalJSONFile()
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to load table data from server: \(error.localizedDescription)")
                self.fallbackToLocalJSONFile()
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                self.fallbackToLocalJSONFile()
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP Error: \(httpResponse.statusCode)")
                self.fallbackToLocalJSONFile()
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode([SheetMetalData].self, from: data)
                    DispatchQueue.main.async {
                        self.sheetMetalData = decodedData
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                    self.fallbackToLocalJSONFile()
                }
            } else {
                self.fallbackToLocalJSONFile()
            }
        }
        
        task.resume()
    }

    func fallbackToLocalJSONFile() {
        if let url = Bundle.main.url(forResource: "table-data", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let sheetMetalData = try decoder.decode([SheetMetalData].self, from: data)
                DispatchQueue.main.async {
                    self.sheetMetalData = sheetMetalData
                }
            } catch {
                print("Failed to load table data from local JSON file: \(error.localizedDescription)")
            }
        } else {
            print("Failed to locate local JSON file.")
        }
    }

}
