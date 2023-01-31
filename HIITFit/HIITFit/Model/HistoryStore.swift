import Foundation

struct ExerciseDay: Identifiable {
    let id = UUID()
    let date: Date
    var exercises: [String] = []
}

class HistoryStore: ObservableObject {
  @Published var exerciseDays: [ExerciseDay] = []
    init() {
      #if DEBUG
      //createDevData()
      #endif
    }
    func addDoneExercise(_ exerciseName: String) {
      let today = Date()
        if let firstDate = exerciseDays.first?.date {
            print("Adding \(exerciseName)")
            exerciseDays[0].exercises.append(exerciseName)
      } else {
        exerciseDays.insert( // 2
        ExerciseDay(date: today, exercises: [exerciseName]),
        at: 0)
      }
    }
}
