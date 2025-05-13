import SwiftUI

struct ReadingSessionView: View {
    @ObservedObject var bookStore: BookStore
    let bookIndex: Int

    @Environment(\.presentationMode) var presentationMode
    @State private var currentPage: Int
    @State private var showNotesSheet = false

    init(bookStore: BookStore, bookIndex: Int) {
        self.bookStore = bookStore
        self.bookIndex = bookIndex
        let book = bookStore.books[bookIndex]
        self._currentPage = State(initialValue: Int(book.progress * Double(book.totalPages)))
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.white)
                }

                Spacer()

                Text("Log Reading Session")
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()
                Color.clear.frame(width: 60)
            }
            .padding()
            .background(Color.orange)

            VStack(spacing: 16) {
                HStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.systemGray5))
                        .frame(width: 65, height: 90)
                        .overlay(
                            Image(systemName: "book.closed")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                                .foregroundColor(.orange)
                        )

                    VStack(alignment: .leading, spacing: 6) {
                        Text(bookStore.books[bookIndex].title)
                            .font(.headline)

                        Text(bookStore.books[bookIndex].author)
                            .foregroundColor(.gray)

                        Text(formattedDate(bookStore.books[bookIndex].dateAdded))
                            .foregroundColor(.gray)
                    }

                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 15) {
                    Text("Current Page").font(.headline)

                    HStack {
                        TextField("", value: $currentPage, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.orange, lineWidth: 2)
                            )

                        VStack {
                            Button(action: { currentPage += 1 }) {
                                Image(systemName: "chevron.up").padding(5)
                            }

                            Button(action: {
                                if currentPage > 1 { currentPage -= 1 }
                            }) {
                                Image(systemName: "chevron.down").padding(5)
                            }
                        }
                        .foregroundColor(.orange)
                        .background(Color.white)
                        .cornerRadius(6)
                    }

                    Slider(
                        value: Binding(
                            get: { Float(currentPage) },
                            set: { currentPage = Int($0) }
                        ),
                        in: 1...Float(bookStore.books[bookIndex].totalPages),
                        step: 1
                    )
                    .accentColor(.orange)

                    HStack {
                        Text("Now: pg \(currentPage)").foregroundColor(.gray)
                        Spacer()
                        Text("Total: \(bookStore.books[bookIndex].totalPages) pgs").foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)

                HStack {
                    Spacer()
                    Button(action: {
                        showNotesSheet = true
                    }) {
                        Text("Notes")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)

                Spacer()

                Button(action: {
                    var updatedBook = bookStore.books[bookIndex]
                    let previousPage = Int(updatedBook.progress * Double(updatedBook.totalPages))
                    let pagesRead = max(currentPage - previousPage, 0)
                    updatedBook.progress = Double(currentPage) / Double(updatedBook.totalPages)
                    updatedBook.lastUpdated = Date()

                    if updatedBook.progress == 1.0 {
                        updatedBook.status = "Finished"
                        updatedBook.completionDate = Date()
                    } else if updatedBook.progress > 0 {
                        updatedBook.status = "Reading"
                    } else {
                        updatedBook.status = "Want to Read"
                    }

                    bookStore.books[bookIndex] = updatedBook

                    let newEntry: [String: Any] = ["date": Date(), "pages": pagesRead]
                    var sessions = UserDefaults.standard.array(forKey: "readingSessions") as? [[String: Any]] ?? []
                    sessions.append(newEntry)
                    UserDefaults.standard.set(sessions, forKey: "readingSessions")

                    NotificationCenter.default.post(name: .didLogReading, object: nil)

                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "bookmark.fill")
                        Text("Save Reading Session").fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            .frame(maxHeight: .infinity)
            .background(Color(.systemGray6))

        }
        .sheet(isPresented: $showNotesSheet) {
            BookNotesView(book: $bookStore.books[bookIndex])
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

extension Notification.Name {
    static let didLogReading = Notification.Name("didLogReading")
}

