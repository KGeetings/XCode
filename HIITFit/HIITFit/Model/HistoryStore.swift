import Foundation

struct ExerciseDay: Identifiable {
    let id = UUID()
    let date: Date
    var exercises: [String] = []
}
enum FileError: Error {
    case loadFailure
    case saveFailure
    case urlFailure
}

class HistoryStore: ObservableObject {
  @Published var exerciseDays: [ExerciseDay] = []
    init() {
        try? load()
    }
    
    func getURL() -> URL? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsURL.appendingPathComponent("history.plist")
    }
    
    func load() throws {
        guard let dataURL = getURL() else {
            throw FileError.urlFailure
        }
        // Check if file exists, if not, it's probably the first time the app is run
        guard FileManager.default.fileExists(atPath: dataURL.path) else {
            return
        }
        do {
            let data = try Data(contentsOf: dataURL)
            let plistData = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
            let convertedPlistData = plistData as? [[Any]] ?? []
            exerciseDays = convertedPlistData.map {
                ExerciseDay(date: $0[1] as? Date ?? Date(),
                exercises: $0[2] as? [String] ?? [])
            }
        } catch {
            throw FileError.loadFailure
        }
    }
    
    func save() throws {
        guard let dataURL = getURL() else {
            throw FileError.urlFailure
        }
        let plistData = exerciseDays.map {
            [$0.id.uuidString, $0.date, $0.exercises]
        }
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: plistData, format: .binary, options: .zero)
            try data.write(to: dataURL, options: .atomic)
        } catch {
            throw FileError.saveFailure
        }
    }
    
    func addDoneExercise(_ exerciseName: String) {
        let today = Date()
        if let firstDate = exerciseDays.first?.date, today.isSameDay(as: firstDate) {
            print("Adding \(exerciseName)")
            exerciseDays[0].exercises.append(exerciseName)
        } else {
            exerciseDays.insert( // 2
                ExerciseDay(date: today, exercises: [exerciseName]),
                at: 0)
        }
        print("History: ", exerciseDays)
        do {
            try save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
