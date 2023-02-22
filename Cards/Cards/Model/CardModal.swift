import Foundation

enum CardModal: CaseIterable {
    case photoPicker, framePicker, stickerPicker, textPicker
}

extension CardModal: Identifiable {
    var id: String { self }
}