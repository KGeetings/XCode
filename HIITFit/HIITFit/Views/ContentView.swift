// Created by Kenyon Geetings and Brenden Mudd

import SwiftUI

struct ContentView: View {
  var body: some View {
      TabView {
          WelcomeView()
          ForEach(0..<4) {number in 
            ExerciseView(index: number)}
//          init(Data, id: KeyPath<Data.Element, ID>, content: (Data.Element) -> Content)
      }
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
