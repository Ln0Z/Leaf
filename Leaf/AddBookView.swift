import SwiftUI

struct AddBookView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var books: [Book]

    @State private var title = ""
    @State private var author = ""
    @State private var category = ""
    @State private var totalPages = 0

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Book Info")) {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)
                    TextField("Category", text: $category)
                    TextField("Total Pages", text: Binding(
                        get: { totalPages == 0 ? "" : String(totalPages) },
                        set: { totalPages = Int($0) ?? 0 }
                    ))
                    .keyboardType(.numberPad)
                }

                Section {
                    Button("Add Book") {
                        let newBook = Book(
                            title: title,
                            author: author,
                            category: category,
                            progress: 0.0,
                            totalPages: totalPages
                        )

                        books.append(newBook)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty || author.isEmpty)
                }
            }
            .navigationTitle("New Book")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
