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
    init(withChecking: Bool) throws  {
      #if DEBUG
      //createDevData()
      #endif
        print("Initializing HistoryStore")
        do {
            try load()
        } catch {
                throw error
            }
    }
    
    init() {}
    
    func getURL() -> URL? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsURL.appendingPathComponent("history.plist")
    }
    
    func load() throws {}
    
    func save() throws {
        guard let dataURL = getURL() else {
            throw FileError.urlFailure
        }
        var plistData: [[Any]] = []
        for exerciseDay in exerciseDays {
            plistData.append(([
                exerciseDay.id.uuidString,
                exerciseDay.date,
                exerciseDay.exercises
            ]))
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
    }
}
