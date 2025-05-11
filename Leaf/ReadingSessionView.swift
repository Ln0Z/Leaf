import SwiftUI

struct ReadingSessionView: View {
    @State private var currentPage: Int = 102
    @State private var sessionNotes: String = "Reading notes here..."
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.white)
                }

                Spacer()

                Text("Log Reading Session")
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()

                Color.clear.frame(width: 60)
            }
            .padding()
            .background(Color.orange)

            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(.systemGray5))
                            .frame(width: 65, height: 90)
                            .overlay(
                                Image(systemName: "book.closed")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30)
                                    .foregroundColor(.orange)
                            )

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Atomic Habits")
                                .font(.headline)

                            Text("James Clear")
                                .foregroundColor(.gray)

                            Text("May 2, 2025")
                                .foregroundColor(.gray)
                        }

                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 15) {
                        Text("Current Page")
                            .font(.headline)

                        HStack {
                            TextField("", value: $currentPage, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.orange, lineWidth: 2)
                                )

                            VStack {
                                Button(action: { currentPage += 1 }) {
                                    Image(systemName: "chevron.up").padding(5)
                                }

                                Button(action: {
                                    if currentPage > 1 { currentPage -= 1 }
                                }) {
                                    Image(systemName: "chevron.down").padding(5)
                                }
                            }
                            .foregroundColor(.orange)
                            .background(Color.white)
                            .cornerRadius(6)
                        }

                        Slider(value: .constant(Float(currentPage) / 320))
                            .accentColor(.orange)

                        HStack {
                            Text("Last: pg 67").foregroundColor(.gray)
                            Spacer()
                            Text("Total: 320 pgs").foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal)

                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Pages read today").font(.subheadline).foregroundColor(.gray)
                            Text("15 pages").font(.title).foregroundColor(.orange).fontWeight(.bold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Divider().background(Color.gray.opacity(0.3)).frame(height: 60)

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Daily target: 10 pages").font(.subheadline).foregroundColor(.gray)
                            Text("3 pages ahead").font(.headline).foregroundColor(.orange)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .background(Color.orange.opacity(0.15))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 15) {
                        Text("Session Notes").font(.headline)

                        TextEditor(text: $sessionNotes)
                            .frame(height: 150)
                            .padding(4)
                            .background(Color.white)
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGray6))

            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "bookmark.fill")
                    Text("Save Reading Session").fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(0)
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}
