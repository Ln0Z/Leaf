//
//  ContinueReadingListView.swift
//  Leaf
//
//  Created by Rianna Libdy on 13/5/2025.
//
import SwiftUI

struct ContinueReadingListView: View {
    let books: [Book]
    let onContinue: (Book) -> Void

    var body: some View {
        List {
            ForEach(books) { book in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(book.title)
                                .font(.headline)

                            Text(book.author)
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            Text("Page \(Int(book.progress * Double(book.totalPages))) of \(book.totalPages)")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }

                        Spacer()

                        Button(action: {
                            onContinue(book)
                        }) {
                            Text("Continue")
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }

                    ProgressView(value: book.progress)
                        .tint(.orange)
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Continue Reading")
    }
}


