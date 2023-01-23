/* Create a new SwiftUI View file named SuccessView.swift.
2. Replace its Text view with a VStack containing the hand.raised.fill SF
Symbol and the text in the screenshot.
3. The SF Symbol is in a 75 by 75 frame and colored purple. Hint: Use the custom
Image modifier.
4. For the large “High Five!” title, you can use the fontWeight modifier to
emphasize it more.
SwiftUI Apprentice Chapter 4: Prototyping Supplementary Views
raywenderlich.com 127
5. For the three small lines of text, you could use three Text views. Or refer to our
Swift Style Guide bit.ly/30cHeeL to see how to create a multi-line string. Text has
a multilineTextAlignment modifier. This text is colored gray.
6. Like HistoryView, SuccessView needs a button to dismiss it. Center a Continue
button at the bottom of the screen. Hint: Use a ZStack so the “High Five!” view
remains vertically centered. */

import SwiftUI

struct SuccessView: View {
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "hand.raised.fill")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .foregroundColor(.purple)
                Text("High Five!")
                    .font(.title)
                    .fontWeight(.bold)
                Text("You did it! You completed your workout.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                Text("You burned 300 calories.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                Text("You burned 300 calories.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }
            VStack {
                Spacer()
                Button("Continue") { }
                    .padding()
            }
        }
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView()
    }
}
