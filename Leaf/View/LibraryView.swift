import SwiftUI

struct LibraryView: View {
    @State private var selectedTab = 2
    @State private var searchText = ""
    @ObservedObject var bookStore = BookStore()
    @State private var showAddBook = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Picker("Library Selection", selection: $selectedTab) {
                    Text("Reading").tag(0)
                    Text("Finished").tag(1)
                    Text("Want to Read").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(Color.white)

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

                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(filteredBooks()) { book in
                            LibraryBookRow(book: book)
                            Divider().padding(.leading, 95)
                        }
                    }
                    .background(Color.white)
                }

                Spacer()

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
            .background(Color(.systemGray6))
            .navigationTitle("My Library")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("My Library")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
    }

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

struct LibraryBookRow: View {
    let book: Book

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
                Text(book.title).font(.headline)
                Text(book.author).foregroundColor(.gray)
                Text(book.category)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.orange.opacity(0.2))
                    .foregroundColor(.orange)
                    .cornerRadius(4)

                ProgressView(value: book.progress)
                    .tint(Color.orange)
            }

            Spacer()

            Text("\(Int(book.progress * 100))%")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
    }
}
