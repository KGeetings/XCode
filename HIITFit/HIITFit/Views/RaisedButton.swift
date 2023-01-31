import SwiftUI

struct RaisedButton: View {
  var body: some View {
    Button(action: {}, label: {
      Text("Get Started")
            .raisedButtonTextStyle()
    })
  }
}

struct RaisedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
      configuration.label
        .frame(maxWidth: .infinity)
        .padding([.top, .bottom], 12)
        .background(
            Capsule()
                .foregroundColor(Color("background"))
                .shadow(color: Color("drop-shadow"), radius: 4, x: 6, y: 6)
                .shadow(color: Color("drop-highlight"), radius: 4, x: -6, y: -6)
        )
    }
}

struct RaisedButton_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      RaisedButton()
        .padding(20)
        .buttonStyle(RaisedButtonStyle())
    }
    .background(Color("background"))
    .previewLayout(.sizeThatFits)
  }
}

extension Text {
  func raisedButtonTextStyle() -> some View {
self
    .font(.body)
    .fontWeight(.bold)
  }
}
