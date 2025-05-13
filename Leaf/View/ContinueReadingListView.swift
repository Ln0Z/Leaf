import SwiftUI

struct ContinueReadingListView: View {
    @Binding var books: [Book]
    let onContinue: (Book) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var selectedBookForNotes: Book?

    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(book.title)
                                    .font(.headline)

                                Text(book.author)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                Text("Page \(Int(book.progress * Double(book.totalPages))) of \(book.totalPages)")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }

                            Spacer()

                            Button(action: {
                                selectedBookForNotes = book
                            }) {
                                Text("Notes")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }

                        ProgressView(value: book.progress)
                            .tint(.orange)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Continue Reading")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
            .sheet(item: $selectedBookForNotes) { book in
                if let index = books.firstIndex(where: { $0.id == book.id }) {
                    BookNotesView(book: $books[index])
                } else {
                    Text("Book not found")
                }
            }
        }
    }
}
