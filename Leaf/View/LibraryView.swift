import SwiftUI

struct LibraryView: View {
    @State private var selectedTab = 2
    @State private var searchText = ""
    @ObservedObject var bookStore = BookStore()
    @State private var showAddBook = false

    var body: some View {
        VStack(spacing: 10) {
            NavigationStack {
                VStack(spacing: 0) {
                    pickerView
                    searchBar
                    bookList
                    Spacer()
                    addButton
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(Color(.systemGray6))
                .navigationTitle("My Library")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack(spacing: 6) {
                            Image(systemName: "book")
                                .foregroundColor(.orange)
                            Text("My Library")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Extracted Subviews

    private var pickerView: some View {
        Picker("Library Selection", selection: $selectedTab) {
            Text("Reading").tag(0)
            Text("Finished").tag(1)
            Text("Want to Read").tag(2)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        .background(Color.white)
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search books...", text: $searchText)
                .foregroundColor(.primary)
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
        .padding(.bottom)
        .background(Color.white)
    }

    private var bookList: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(filteredBooks().indices, id: \.self) { index in
                    LibraryBookRow(book: $bookStore.books[index])
                    Divider().padding(.leading, 95)
                }
            }
            .background(Color.white)
        }
    }

    private var addButton: some View {
        Button(action: {
            showAddBook = true
        }) {
            HStack {
                Image(systemName: "plus")
                Text("Add New Book")
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding()
        }
        .sheet(isPresented: $showAddBook) {
            AddBookView(books: $bookStore.books)
        }
    }

    // MARK: - Book Filtering

    func filteredBooks() -> [Book] {
        let statusMap = ["Reading", "Finished", "Want to Read"]
        let filteredByStatus = bookStore.books.filter { $0.status == statusMap[selectedTab] }

        if searchText.isEmpty {
            return filteredByStatus
        } else {
            return filteredByStatus.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.author.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

// MARK: - Book Row View

struct LibraryBookRow: View {
    @Binding var book: Book

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray5))
                .frame(width: 65, height: 90)
                .overlay(
                    Image(systemName: "book.closed")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .foregroundColor(.gray)
                )

            VStack(alignment: .leading, spacing: 6) {
                Text(book.title)
                    .font(.headline)

                Text(book.author)
                    .foregroundColor(.gray)

                Text(book.category)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.orange.opacity(0.2))
                    .foregroundColor(.orange)
                    .cornerRadius(4)

                ProgressView(value: book.progress)
                    .tint(Color.orange)

                NavigationLink(destination: BookNotesView(book: $book)) {
                    Text("Notes")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }

            Spacer()

            Text("\(Int(book.progress * 100))%")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview{
    LibraryView()
}
