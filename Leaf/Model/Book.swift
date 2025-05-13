import Foundation

struct BookNote: Codable, Hashable, Identifiable {
    var id: UUID
    var content: String
    var date: Date
    var tag: String
}

struct Book: Identifiable, Codable, Equatable {
    let id = UUID()
    var title: String
    var author: String
    var category: String
    var progress: Double
    var totalPages: Int
    var status: String = "Want to Read"
    var notes: [BookNote] = []

    var completionDate: Date?
    let dateAdded: Date = Date()
    var lastUpdated: Date = Date()
}
