import SwiftUI

struct EnhancedContinueReadingCard: View {
    @ObservedObject var bookStore: BookStore
    var bookIndex: Int

    @State private var showReadingSession = false

    var body: some View {
        let book = bookStore.books[bookIndex]

        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(book.title)
                        .font(.title3)
                        .fontWeight(.bold)

                    Text(book.author)
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text("Page \(Int(book.progress * Double(book.totalPages))) of \(book.totalPages)")
                        .font(.caption)
                        .foregroundColor(.orange)

                    ProgressView(value: book.progress)
                        .tint(Color.orange)
                }

                Spacer()

                Text("\(Int(book.progress * 100))%")
                    .font(.headline)
                    .padding(8)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
            }

            Text("📖 Every action you take is a vote for the person you wish to become.")
                .font(.footnote)
                .foregroundColor(.gray)

            Button(action: {
                showReadingSession = true
            }) {
                HStack {
                    Image(systemName: "book.fill")
                    Text("Continue Reading")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
        .frame(width: 320) // nice card width for horizontal scroll
        .sheet(isPresented: $showReadingSession) {
            ReadingSessionView(bookStore: bookStore, bookIndex: bookIndex)
        }
    }
}
