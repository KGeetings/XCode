import SwiftUI

struct ContentView: View {
  var body: some View {
      TabView {
          Text("Welcome")
          Text("Exercise 1")
          Text("Exercise 2")
      }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
