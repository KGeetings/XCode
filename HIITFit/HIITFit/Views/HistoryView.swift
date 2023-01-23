import SwiftUI

struct HistoryView: View {
    let today = Data()
    let yesterday = Date().addingTimeInterval(-86400)
    
    let exercise1 = ["Squat", "Step Up", "Burpee", "Sun Salute"]
    let exercise2 = ["Squat", "Step Up", "Burpee"]
    
    var body: some View {
        VStack {
            Text("History")
                .font(.title)
                .padding()
            Form {
Section(
header:
Text(today.formatted(as: "MMM d"))
.font(.headline)) {
// Section content
}
Section(
header:
Text(yesterday.formatted(as: "MMM d"))
.font(.headline)) {
// Section content
}
}
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
