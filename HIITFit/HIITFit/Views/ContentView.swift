// Created by Kenyon Geetings and Brenden Mudd

import SwiftUI

struct ContentView: View {
  var body: some View {
      TabView {
          WelcomeView()
          ForEach(0 ..< Exercise.exercises.count) { number in
            ExerciseView(index: number)}

      }
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
