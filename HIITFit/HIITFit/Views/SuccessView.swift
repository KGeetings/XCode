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
                Text("Good job completing all four exercises!")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                Text("Remember tomorrow's another day")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                Text("So eat well and get some rest.")
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
