import SwiftUI

struct EmbossedButtonStyle: ButtonStyle {
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

struct EmbossedButton_Previews: PreviewProvider {
    static var previews: some View {
        Button (
            action: {},
            label: {
                Text("History")
                    .fontWeight(.bold)
            })
        .buttonStyle(EmbossedButtonStyle())
        .padding(40)
        .previewLayout(.sizeThatFits)
    }
}
