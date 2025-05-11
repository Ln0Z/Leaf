import Foundation

struct Book: Identifiable, Codable {
    let id = UUID()
    var title: String
    var author: String
    var category: String
    var progress: Double
    var totalPages: Int
}
