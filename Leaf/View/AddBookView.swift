import SwiftUI

struct AddBookView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var books: [Book]

    @State private var searchText = ""
    @StateObject private var viewModel = AddBookViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Search for a Book")) {
                    TextField("Search by title, author, etc.", text: $viewModel.searchText)
                        .onSubmit {
                            viewModel.searchBooks()
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                if !viewModel.searchResults.isEmpty {
                    Section(header: Text("Results")) {
                        ForEach(viewModel.searchResults) { book in
                            Button(action: {
                                viewModel.autofill(from: book)
                                viewModel.searchResults = []
                                viewModel.searchText = ""
                            }) {
                                VStack(alignment: .leading) {
                                    Text(book.title).bold()
                                    Text(book.authors.joined(separator: ", "))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }

                Section(header: Text("Book Info")) {
                    TextField("Title", text: $viewModel.title)
                    TextField("Author", text: $viewModel.author)
                    TextField("Category", text: $viewModel.category)
                    TextField("Total Pages", text: Binding<String>(
                        get: {
                            self.viewModel.totalPages == 0 ? "" : String(self.viewModel.totalPages)
                        },
                        set: {
                            self.viewModel.totalPages = Int($0) ?? 0
                        }
                    ))
                    .keyboardType(.numberPad)
                }

                Section {
                    Button("Add Book") {
                        let newBook = Book(
                            title: viewModel.title,
                            author: viewModel.author,
                            category: viewModel.category,
                            progress: 0.0,
                            totalPages: viewModel.totalPages,
                            status: "Want to Read"
                        )

                        books.append(newBook)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(viewModel.title.isEmpty || viewModel.author.isEmpty)
                }
            }
            .navigationTitle("New Book")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
