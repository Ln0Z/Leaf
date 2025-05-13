import SwiftUI

struct ReadingSessionView: View {
    @ObservedObject var bookStore: BookStore
    let bookIndex: Int

    @Environment(\.presentationMode) var presentationMode
    @State private var sessionNotes: String = "Reading notes here..."
    @State private var currentPage: Int

    init(bookStore: BookStore, bookIndex: Int) {
        self.bookStore = bookStore
        self.bookIndex = bookIndex
        let book = bookStore.books[bookIndex]
        self._currentPage = State(initialValue: Int(book.progress * Double(bookStore.books[bookIndex].totalPages)))
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
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

            ScrollView {
                VStack(spacing: 20) {
                    // Book info
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

                            Text("May 11, 2025")
                                .foregroundColor(.gray)
                        }

                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal)

                    // Page tracking
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

                        Slider(value: .constant(Float(currentPage) / Float(bookStore.books[bookIndex].totalPages)))
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

                    // Daily target (placeholder UI)
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Pages read today").font(.subheadline).foregroundColor(.gray)
                            Text("15 pages").font(.title).foregroundColor(.orange).fontWeight(.bold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Divider().background(Color.gray.opacity(0.3)).frame(height: 60)

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Daily target: 10 pages").font(.subheadline).foregroundColor(.gray)
                            Text("3 pages ahead").font(.headline).foregroundColor(.orange)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .background(Color.orange.opacity(0.15))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    // Notes
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Session Notes").font(.headline)

                        TextEditor(text: $sessionNotes)
                            .frame(height: 150)
                            .padding(4)
                            .background(Color.white)
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGray6))

            Button(action: {
                var updatedBook = bookStore.books[bookIndex]
                let previousPage = Int(updatedBook.progress * Double(updatedBook.totalPages))
                let pagesRead = max(currentPage - previousPage, 0)
                updatedBook.progress = Double(currentPage) / Double(updatedBook.totalPages)

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
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

extension Notification.Name {
    static let didLogReading = Notification.Name("didLogReading")
}
