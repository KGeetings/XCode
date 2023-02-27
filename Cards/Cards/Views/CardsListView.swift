import SwiftUI

struct CardsListView: View {
    @EnvironmentObject var viewState: ViewState
    @EnvironmentObject var store: CardStore
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(store.cards) { card in
                    CardThumbnailView(card: card)
                        .contextMenu {
                            // swiftlint:disable:next multiple_closures_with_trailing_closure
                            Button(action: { store.remove(card) }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .onTapGesture {
                            viewState.showAllCards.toggle()
                            viewState.selectedCard = card
                        }
                }
            }
        }
    }
}

struct CardsListView_Previews: PreviewProvider {
    static var previews: some View {
        CardsListView()
            .environmentObject(ViewState())
            .environmentObject(CardStore(defaultData: true))
    }
}
