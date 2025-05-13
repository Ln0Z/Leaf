import Foundation

struct Book: Identifiable, Codable, Equatable {
    let id = UUID()
    var title: String
    var author: String
    var category: String
    var progress: Double
    var totalPages: Int
    var status: String = "Want to Read"
    var notes: [String] = []
    let dateAdded: Date = Date()
    var lastUpdated: Date = Date()
}
