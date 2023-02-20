import SwiftUI

struct AddThingView: View {
  @Environment(\.presentationMode) var presentationMode
  @State private var thing = ""
  @ObservedObject var someThings: ThingStore

  var body: some View {
    VStack {
      TextField("Thing I Learned", text: $thing)
        .disableAutocorrection(true)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
      Button("Done") {
        if !thing.isEmpty {
          someThings.things.append(thing)
        }
        presentationMode.wrappedValue.dismiss()
      }
      Spacer()
    }
    .environment(\.textCase, nil)
  }
}

struct AddThingView_Previews: PreviewProvider {
  static var previews: some View {
    AddThingView(someThings: ThingStore())
  }
}
