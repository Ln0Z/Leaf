import SwiftUI

struct BookNotesView: View {
    @Binding var book: Book
    @State private var newNote: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(book.notes.indices, id: \.self) { index in
                        HStack {
                            TextEditor(text: Binding(
                                get: { book.notes[index] },
                                set: { book.notes[index] = $0 }
                            ))
                            .frame(minHeight: 40)
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete { indexSet in
                        book.notes.remove(atOffsets: indexSet)
                    }
                }

                HStack {
                    TextField("Add a new note...", text: $newNote)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        if !newNote.trimmingCharacters(in: .whitespaces).isEmpty {
                            book.notes.append(newNote)
                            newNote = ""
                        }
                    }) {
                        Text("Add")
                            .padding(.horizontal)
                    }
                }
                .padding()
            }
            .navigationTitle("Notes for \(book.title)")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
    }
}
