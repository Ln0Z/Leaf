import SwiftUI

struct HomeView: View {
    @ObservedObject var bookStore = BookStore()
    
    @State private var showReadingSession = false
    @State private var selectedBookIndex: Int?
    @State private var showSeeAll = false

    var body: some View {
        NavigationView {
            ScrollView {
                ZStack(alignment: .top) {
                    Color.orange
                        .ignoresSafeArea()
                        .frame(height: 200)

                    VStack(spacing: 20) {
                        // Header
                        VStack(alignment: .leading, spacing: 5) {
                            Text(Date(), formatter: DateFormatter.fullDate)
                                .font(.subheadline)
                                .foregroundColor(.white)

                            Text("Welcome back to Leaf 🍂")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)

                        // Continue Reading section (all books, most recently updated first)
                        let sortedBooks = bookStore.books
                            .enumerated()
                            .sorted { $0.element.lastUpdated > $1.element.lastUpdated }

                        if !sortedBooks.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(sortedBooks, id: \.element.id) { (index, _) in
                                        EnhancedContinueReadingCard(bookStore: bookStore, bookIndex: index)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            Text("No books yet. Add one in the Library tab!")
                                .padding()
                                .foregroundColor(.gray)
                        }

                        // Bookshelf section
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
                    .padding(.top, 20)
                }
            }
            .background(Color(.systemGray6))
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showReadingSession) {
                if let index = selectedBookIndex {
                    ReadingSessionView(bookStore: bookStore, bookIndex: index)
                }
            }
            .sheet(isPresented: $showSeeAll) {
                let sortedBooks = bookStore.books
                    .sorted { $0.lastUpdated > $1.lastUpdated }
                
                ContinueReadingListView(books: sortedBooks) { selectedBook in
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
                            .foregroundColor(.white)
                        Text("Leaf")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
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
