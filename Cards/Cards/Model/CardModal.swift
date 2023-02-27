import Foundation

enum CardModal: Identifiable {
  var id: Int {
    hashValue
  }
  case photoPicker, framePicker, stickerPicker, textPicker
}