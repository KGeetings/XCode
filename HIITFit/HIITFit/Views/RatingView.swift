import SwiftUI

struct RatingView: View {
    @Binding var rating: Int // 1
    let maximumRating = 5 // 2
    let onColor = Color.red // 3
    let offColor = Color.gray
    var body: some View {
        HStack {
            ForEach(1 ..< maximumRating + 1) { index in
                Image(systemName: "waveform.path.ecg")
                    .foregroundColor(
                        index > rating ? offColor : onColor) // 4
                    .onTapGesture { // 5
                        rating = index
                    }
            }
        }
        .font(.largeTitle)
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView()
    }
}
