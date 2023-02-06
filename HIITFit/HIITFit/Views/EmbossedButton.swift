import SwiftUI

struct EmbossedButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    let shadow = Color("drop-shadow")
    let highlight = Color("drop-highlight")
    return configuration.label
      .padding(10)
      .background(
        GeometryReader { geometry in
          shape(size: geometry.size)
            .foregroundColor(Color("background"))
            .shadow(color: shadow, radius: 1, x: 2, y: 2)
            .shadow(color: highlight, radius: 1, x: -2, y: -2)
            .offset(x: -1, y: -1)
        })
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
