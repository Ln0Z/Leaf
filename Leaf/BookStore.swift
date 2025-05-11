import Foundation

class BookStore: ObservableObject {
    @Published var books: [Book] = [] {
        didSet {
            saveBooks()
        }
    }

    private let key = "savedBooks"

    init() {
        loadBooks()
    }

    private func saveBooks() {
        if let encoded = try? JSONEncoder().encode(books) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    private func loadBooks() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Book].self, from: data) {
            books = decoded
        }
    }
}
