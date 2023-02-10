import SwiftUI

struct TimerView: View {
    @State private var timeRemaining = 3 // 1
    @Binding var timerDone: Bool // 2
    let timer = Timer.publish( // 3
        every: 1,
        on: .main,
        in: .common)
        .autoconnect() // 4
    
    var body: some View {
        Text("\(timeRemaining)") // 5
            .font(.system(size: 90, design: .rounded))
            .padding()
            .onReceive(timer) { _ in // 6
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    timerDone = true // 7
                }
            }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timerDone: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}
