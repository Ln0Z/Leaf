import SwiftUI

struct BookNotesView: View {
    @Binding var book: Book
    @State private var newNote: String = ""
    @State private var selectedTag = "Thought"

    let tags = ["Thought", "Quote", "Reminder"]

    var body: some View {
        VStack {
            Text("Notes for \(book.title)")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .leading)

            if book.notes.isEmpty {
                Text("No notes yet. Start by adding one below!")
                    .foregroundColor(.gray)
                    .padding(.top, 20)
            } else {
                List {
                    ForEach(book.notes.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(book.notes[index].tag)
                                    .font(.caption)
                                    .padding(5)
                                    .background(Color.orange.opacity(0.2))
                                    .cornerRadius(5)
                                Spacer()
                                Text(formattedDate(book.notes[index].date))
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }

                            TextEditor(text: Binding(
                                get: { book.notes[index].content },
                                set: { book.notes[index].content = $0 }
                            ))
                            .frame(minHeight: 80)
                            .padding(6)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { indexSet in
                        book.notes.remove(atOffsets: indexSet)
                    }
                }
            }

            Divider().padding(.vertical)

            VStack {
                TextField("Type a new note...", text: $newNote)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                Picker("Tag", selection: $selectedTag) {
                    ForEach(tags, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.vertical)
            }

            Button(action: addNote) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Note")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(newNote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
    }

    private func addNote() {
        let trimmed = newNote.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let note = BookNote(content: trimmed, date: Date(), tag: selectedTag)
        book.notes.append(note)
        newNote = ""
        selectedTag = "Thought"
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


