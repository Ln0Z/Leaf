import SwiftUI

struct HomeView: View {
    @ObservedObject var bookStore = BookStore()

    var body: some View {
        NavigationView {
            ScrollView {
                ZStack(alignment: .top) {
                    Color.orange
                        .ignoresSafeArea()
                        .frame(height: 200)

                    VStack(spacing: 20) {
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

                        // Show ContinueReadingCard if there's at least 1 book
                        if !bookStore.books.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(bookStore.books.indices, id: \.self) { index in
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

                        HStack {
                            Text("My Bookshelf")
                                .font(.title2)
                                .fontWeight(.bold)

                            Spacer()

                            Button(action: {}) {
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
        formatter.dateStyle = .full // "Tuesday, May 14, 2025"
        return formatter
    }
}

