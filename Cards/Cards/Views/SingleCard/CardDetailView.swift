import SwiftUI


struct CardDetailView: View {
  @EnvironmentObject var viewState: ViewState
  @State private var currentModal: CardModal?
  @State private var stickerImage: UIImage?
  @Binding var card: Card

  var body: some View {
    content
      .modifier(CardToolbar(currentModal: $currentModal))
      .sheet(item: $currentModal) { item in
        switch item {
        case .stickerPicker:
          StickerPicker(stickerImage: $stickerImage)
            .onDisappear {
              if let stickerImage = stickerImage {
                card.addElement(uiImage: stickerImage)
              }
              stickerImage = nil
            }
        default:
          EmptyView()
        }
      }
  }

  var content: some View {
    ZStack {
      card.backgroundColor
        .edgesIgnoringSafeArea(.all)
      ForEach(card.elements, id: \.id) { element in
        CardElementView(element: element)
          .contextMenu {
            Button(action: { card.remove(element) }) {
              Label("Delete", systemImage: "trash")
            }
          }
          .resizableView(transform: bindingTransform(for: element))
          .frame(
            width: element.transform.size.width,
            height: element.transform.size.height)
      }
    }
  }

  func bindingTransform(for element: CardElement)
    -> Binding<Transform> {
    guard let index = element.index(in: card.elements) else {
      fatalError("Element does not exist")
    }
    return $card.elements[index].transform
  }
}

struct CardDetailView_Previews: PreviewProvider {
  struct CardDetailPreview: View {
    @State private var card = initialCards[0]
    var body: some View {
      CardDetailView(card: $card)
        .environmentObject(ViewState(card: card))
    }
  }
  static var previews: some View {
    CardDetailPreview()
  }
}
