import SwiftUI

struct User: Identifiable {
    let id: Int
    var name: String
    var score: Int
}

struct Test: View {
    @State private var users = [
        User(id: 1, name: "Taylor Swift", score: 90),
        User(id: 2, name: "Justin Bieber", score: 80),
        User(id: 3, name: "Adele Adkins", score: 85)
    ]

    @State private var sortOrder = [KeyPathComparator(\User.name)]
    @State private var selection: User.ID?

    var body: some View {
        Table(selection: $selection, sortOrder: $sortOrder) {
            TableColumn("Name", value: \.name)
            TableColumn("Score", value: \.score) { user in
                Text(String(user.score))
            }
            .width(min: 50, max: 100)
        } rows: {
            TableRow(User(id: 0, name: "First", score: 0))
            ForEach(users, content: TableRow.init)
            TableRow(User(id: 4, name: "Last", score: 100))
        }
        .onChange(of: sortOrder) { newOrder in
            users.sort(using: newOrder)
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
