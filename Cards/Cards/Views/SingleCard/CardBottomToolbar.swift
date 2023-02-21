import SwiftUI

struct ToolbarButtonView: View {
    let modal: CardModal
    // swiftlint:disable:next colon
    private let modalButton:
        [CardModal: (text: String, imageName: String)] = [
        .photoPicker: ("Photos", "photo"),
        .framePicker: ("Frames", "square.on.circle"),
        .stickerPicker: ("Stickers", "heart.circle"),
        .textPicker: ("Text", "textformat")
        ]

    var body: some View {
        if let text = modalButton[modal]?.text,
        let imageName = modalButton[modal]?.imageName {
        VStack {
        Image(systemName: imageName)
            .font(.largeTitle)
        Text(text)
        }
        .padding(.top)
        }
    }
}

struct CardBottomToolbar: View {
    @Binding var cardModal: CardModal?

    var body: some View {
        HStack {
        // swiftlint:disable:next multiple_closures_with_trailing_closure
        Button(action: { cardModal = .photoPicker }) {
            ToolbarButtonView(modal: .photoPicker)
        }
        // swiftlint:disable:next multiple_closures_with_trailing_closure
        Button(action: { cardModal = .framePicker }) {
            ToolbarButtonView(modal: .framePicker)
        }
        // swiftlint:disable:next multiple_closures_with_trailing_closure
        Button(action: { cardModal = .stickerPicker }) {
            ToolbarButtonView(modal: .stickerPicker)
        }
        // swiftlint:disable:next multiple_closures_with_trailing_closure
        Button(action: { cardModal = .textPicker }) {
            ToolbarButtonView(modal: .textPicker)
        }
        }
    }
}

struct CardBottomToolbar_Previews: PreviewProvider {
    static var previews: some View {
        CardBottomToolbar(cardModal: .constant(.stickerPicker))
        .previewLayout(.sizeThatFits)
        .padding()
    }
}