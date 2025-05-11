import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack(alignment: .top) {
                    Color.orange
                        .ignoresSafeArea()
                        .frame(height: 200)

                    VStack {
                        HStack {
                            ForEach(0..<5) { _ in
                                Image(systemName: "leaf.fill")
                                    .foregroundColor(Color.white.opacity(0.2))
                                    .font(.system(size: 20))
                                    .rotationEffect(.degrees(Double.random(in: 0...360)))
                                    .offset(x: CGFloat.random(in: -20...20), y: CGFloat.random(in: -10...10))
                            }
                        }
                        .padding(.top, 40)

                        HStack {
                            ForEach(0..<4) { _ in
                                Image(systemName: "book.fill")
                                    .foregroundColor(Color.white.opacity(0.15))
                                    .font(.system(size: 16))
                                    .rotationEffect(.degrees(Double.random(in: 0...45)))
                                    .offset(x: CGFloat.random(in: -20...20), y: CGFloat.random(in: -10...10))
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Friday, May 2nd")
                                .font(.subheadline)
                                .foregroundColor(.white)

                            Text("Happy Reading!")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)

                        EnhancedContinueReadingCard()

                        HStack {
                            Text("My Bookshelf")
                                .font(.title2)
                                .fontWeight(.bold)

                            Spacer()

                            Button(action: {}) {
                                Text("See All")
                                    .font(.subheadline)
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                EnhancedBookCard(title: "Atomic Habits", author: "James Clear", progress: 0.21, color: "orange")
                                EnhancedBookCard(title: "Deep Work", author: "Cal Newport", progress: 0.34, color: "orange")
                                EnhancedBookCard(title: "Project Hail Mary", author: "Andy Weir", progress: 0.09, color: "orange")
                            }
                            .padding(.horizontal)
                        }

                        VStack(alignment: .leading, spacing: 15) {
                            Text("Reading Challenge")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)

                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("2025 Goal")
                                        .font(.headline)
                                        .foregroundColor(.orange)

                                    Text("24 Books")
                                        .font(.title3)
                                        .fontWeight(.bold)

                                    HStack {
                                        Text("4 completed")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)

                                        Spacer()

                                        Text("On track")
                                            .font(.caption)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.orange.opacity(0.2))
                                            .foregroundColor(.orange)
                                            .cornerRadius(4)
                                    }
                                }

                                Spacer()

                                ZStack {
                                    Circle()
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                                        .frame(width: 70, height: 70)

                                    Circle()
                                        .trim(from: 0, to: 4/24)
                                        .stroke(Color.orange, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                        .frame(width: 70, height: 70)
                                        .rotationEffect(.degrees(-90))

                                    Text("17%")
                                        .font(.system(size: 16, weight: .bold))
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .background(Color(.systemGray6))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.white)
                        Text("Leaf")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}
