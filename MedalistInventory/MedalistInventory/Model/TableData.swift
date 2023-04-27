import Foundation

struct SheetMetalData: Codable, Identifiable {
    var id: Int
    var material: String
    var thickness: String
    var length: Double
    var width: Double
    var quantity: Int
    var allocated: Int
}

struct ExtraPartsData: Codable, Identifiable {
    let id: Int
    let company: String
    let material: String
    let thickness: String
    let partname: String
    let quantity: Int
    let maxquantity: Int
}

let numberFormatter: NumberFormatter = {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 2
    return numberFormatter
}()

class TableData: ObservableObject {
    @Published var sheetMetalData: [SheetMetalData] = []
    @Published var extraPartsData: [ExtraPartsData] = []
    
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
        loadExtraParts()
    }

    func loadExtraParts() {
        guard let url = URL(string: "http://10.0.2.3/table-data.php?table=extra_parts") else {
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
                    let decodedData = try decoder.decode([ExtraPartsData].self, from: data)
                    DispatchQueue.main.async {
                        self.extraPartsData = decodedData
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
        // Load Sheet Metal Data from local JSON file
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

        // Load Extra Parts Data from local JSON file
        if let url = Bundle.main.url(forResource: "table-data-extra-parts", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let extraPartsData = try decoder.decode([ExtraPartsData].self, from: data)
                DispatchQueue.main.async {
                    self.extraPartsData = extraPartsData
                }
            } catch {
                print("Failed to load table data from local JSON file: \(error.localizedDescription)")
            }
        } else {
            print("Failed to locate local JSON file.")
        }
    }
}
