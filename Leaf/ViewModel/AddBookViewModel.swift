//
//  AddBookViewModel.swift
//  Leaf
//
//  Created by Ahmed-Zayne El husseini on 12/5/2025.
//
import SwiftUI

class AddBookViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [GoogleBook] = []
    @Published var title: String = ""
    @Published var author: String = ""
    @Published var category: String = ""
    @Published var totalPages: Int = 0

    func searchBooks() {
        guard let encodedQuery = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://books.googleapis.com/books/v1/volumes?q=\(encodedQuery)&maxResults=5") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let decoded = try JSONDecoder().decode(GoogleBooksAPIResponse.self, from: data)
                let books = decoded.items.map {
                    GoogleBook(
                        id: $0.id,
                        title: $0.volumeInfo.title,
                        authors: $0.volumeInfo.authors ?? ["Unknown"],
                        pageCount: $0.volumeInfo.pageCount ?? 0,
                        category: $0.volumeInfo.categories?.first ?? "Unknown"
                    )
                }

                DispatchQueue.main.async {
                    self.searchResults = books
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
    
    func autofill(from book: GoogleBook) {
        self.title = book.title
        self.author = book.authors.first ?? ""
        self.category = book.category
        self.totalPages = book.pageCount
    }
}

struct GoogleBooksAPIResponse: Decodable {
    let items: [GoogleBookItem]
}

struct GoogleBookItem: Decodable {
    let id: String
    let volumeInfo: GoogleBookVolumeInfo
}

struct GoogleBookVolumeInfo: Decodable {
    let title: String
    let authors: [String]?
    let pageCount: Int?
    let categories: [String]?
}
