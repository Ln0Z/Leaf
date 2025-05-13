import SwiftUI

struct HomeView: View {
    @ObservedObject var bookStore = BookStore()

    @State private var showReadingSession = false
    @State private var selectedBookIndex: Int?
    @State private var showSeeAll = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 20) {
                        ZStack(alignment: .leading) {
                            Color.orange
                                .frame(height: 200)
                                .edgesIgnoringSafeArea(.top)

                            VStack(alignment: .leading, spacing: 5) {
                                Text(Date(), formatter: DateFormatter.fullDate)
                                    .font(.subheadline)
                                    .foregroundColor(.white)

                                Text("Welcome back to Leaf 🍂")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .padding()
                        }

                        // Continue Reading
                        let sortedBooks = bookStore.books
                            .enumerated()
                            .sorted { $0.element.lastUpdated > $1.element.lastUpdated }

                        if !sortedBooks.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Continue Reading")
                                    .font(.headline)
                                    .padding(.horizontal)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(sortedBooks, id: \.element.id) { (index, _) in
                                            EnhancedContinueReadingCard(bookStore: bookStore, bookIndex: index)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        } else {
                            Text("No books yet. Add one in the Library tab!")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.gray)
                        }

                        // Bookshelf Section
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("My Bookshelf")
                                    .font(.title2)
                                    .fontWeight(.bold)

                                Spacer()

                                Button(action: {
                                    showSeeAll = true
                                }) {
                                    Text("See All")
                                        .font(.subheadline)
                                        .foregroundColor(.orange)
                                }
                            }
                            .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(bookStore.books) { book in
                                        EnhancedBookCard(
                                            title: book.title,
                                            author: book.author,
                                            progress: book.progress,
                                            color: "orange"
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.top)
                    .frame(width: geometry.size.width)
                }
                .background(Color(.systemGray6))
            }
            .sheet(isPresented: $showReadingSession) {
                if let index = selectedBookIndex {
                    ReadingSessionView(bookStore: bookStore, bookIndex: index)
                }
            }
            .sheet(isPresented: $showSeeAll) {
                let sortedBooks = bookStore.books
                    .sorted { $0.lastUpdated > $1.lastUpdated }

                ContinueReadingListView(books: $bookStore.books) { selectedBook in
                    if let index = bookStore.books.firstIndex(where: { $0.id == selectedBook.id }) {
                        selectedBookIndex = index
                        showReadingSession = true
                        showSeeAll = false
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.orange)
                        Text("Leaf")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
    }
}

extension DateFormatter {
    static var fullDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
}
