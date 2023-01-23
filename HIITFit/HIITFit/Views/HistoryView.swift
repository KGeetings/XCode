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
            
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
