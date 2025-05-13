import SwiftUI

struct BookNotesView: View {
    @Binding var book: Book
    @State private var newNote: String = ""
    @State private var selectedTag = "Thought"
    @State private var selectedFilter = "All"

    @Environment(\.dismiss) var dismiss

    let tags = ["All", "Thought", "Quote", "Reminder"]

    var body: some View {
        VStack {
            Text("Notes for \(book.title)")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Tag filter control
            Picker("Filter", selection: $selectedFilter) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom)

            // Notes list
            if filteredNotes().isEmpty {
                Text("No notes for selected tag.")
                    .foregroundColor(.gray)
                    .padding(.top, 20)
            } else {
                List {
                    ForEach(filteredNotes().indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(filteredNotes()[index].tag)
                                    .font(.caption)
                                    .padding(5)
                                    .background(tagColor(for: filteredNotes()[index].tag).opacity(0.2))
                                    .foregroundColor(tagColor(for: filteredNotes()[index].tag))
                                    .cornerRadius(5)
                                Spacer()
                                Text(formattedDate(filteredNotes()[index].date))
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }

                            TextEditor(text: Binding(
                                get: {
                                    if let originalIndex = book.notes.firstIndex(where: { $0.id == filteredNotes()[index].id }) {
                                        return book.notes[originalIndex].content
                                    }
                                    return ""
                                },
                                set: {
                                    if let originalIndex = book.notes.firstIndex(where: { $0.id == filteredNotes()[index].id }) {
                                        book.notes[originalIndex].content = $0
                                    }
                                }
                            ))
                            .frame(minHeight: 80)
                            .padding(6)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { indexSet in
                        let notesToDelete = indexSet.map { filteredNotes()[$0] }
                        book.notes.removeAll { notesToDelete.contains($0) }
                    }
                }
            }

            Divider().padding(.vertical)

            // Add new note section
            VStack(alignment: .leading) {
                TextField("Type a new note...", text: $newNote, onCommit: {
                    addNote()
                })
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)

                // Capsule-style tag picker
                HStack {
                    ForEach(tags.dropFirst(), id: \.self) { tag in
                        Text(tag)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(selectedTag == tag ? tagColor(for: tag) : Color(.systemGray5))
                            .foregroundColor(selectedTag == tag ? .white : .primary)
                            .cornerRadius(20)
                            .onTapGesture {
                                withAnimation { selectedTag = tag }
                            }
                    }
                }
                .padding(.vertical)
            }

            Button(action: addNote) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add \(selectedTag)")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(tagColor(for: selectedTag))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(newNote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
        }
    }

    // MARK: - Helpers

    private func addNote() {
        let trimmed = newNote.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let note = BookNote(id: UUID(), content: trimmed, date: Date(), tag: selectedTag)
        book.notes.append(note)
        newNote = ""
        selectedTag = "Thought"
    }

    private func filteredNotes() -> [BookNote] {
        if selectedFilter == "All" {
            return book.notes
        }
        return book.notes.filter { $0.tag == selectedFilter }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func tagColor(for tag: String) -> Color {
        switch tag {
        case "Quote":
            return .purple
        case "Thought":
            return .blue
        case "Reminder":
            return .green
        default:
            return .gray
        }
    }
}



