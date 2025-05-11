import SwiftUI

struct LibraryView: View {
    @State private var selectedTab = 0
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Picker("Library Selection", selection: $selectedTab) {
                    Text("Reading").tag(0)
                    Text("Finished").tag(1)
                    Text("Want to Read").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(Color.white)

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("Search books...", text: $searchText)
                        .foregroundColor(.primary)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.bottom)
                .background(Color.white)

                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(0..<3) { _ in
                            LibraryBookRow()
                            Divider()
                                .padding(.leading, 95)
                        }
                    }
                    .background(Color.white)
                }

                Spacer()

                Button(action: {}) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add New Book")
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
                }
            }
            .background(Color(.systemGray6))
            .navigationTitle("My Library")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("My Library")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct LibraryBookRow: View {
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray5))
                .frame(width: 65, height: 90)
                .overlay(
                    Image(systemName: "book.closed")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .foregroundColor(.gray)
                )

            VStack(alignment: .leading, spacing: 6) {
                Text("Atomic Habits")
                    .font(.headline)

                Text("James Clear")
                    .foregroundColor(.gray)

                Text("Self-Development")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.orange.opacity(0.2))
                    .foregroundColor(.orange)
                    .cornerRadius(4)

                Text("Page 67 of 320")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 4)

                ProgressView(value: 0.21)
                    .tint(Color.orange)
                    .padding(.top, 2)
            }

            Spacer()

            Text("21%")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
    }
}
