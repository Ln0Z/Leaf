import SwiftUI

struct BookNotesView: View {
    @Binding var book: Book
    @State private var newNote: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("Notes for \(book.title)")
                .font(.title2)
                .padding(.bottom)

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
            .padding(.top)
        }
        .padding()
    }
}

