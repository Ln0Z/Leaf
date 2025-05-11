import SwiftUI

struct EnhancedContinueReadingCard: View {
    @State private var showReadingSession = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "bookmark.circle.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 20))
                Text("Continue Reading")
                    .font(.headline)
                    .foregroundColor(.orange)

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                    Text("15 min left")
                        .font(.caption)
                }
                .foregroundColor(.gray)
            }
            .padding(.horizontal)
            .padding(.top)

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.orange.opacity(0.15))
                            .frame(width: 80, height: 110)

                        Image(systemName: "book.closed")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                            .foregroundColor(.orange)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Atomic Habits")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("James Clear")
                            .foregroundColor(.gray)

                        Spacer().frame(height: 8)

                        Text("Page 67 of 320")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .frame(height: 6)
                                .foregroundColor(Color.gray.opacity(0.2))

                            RoundedRectangle(cornerRadius: 3)
                                .frame(width: 80, height: 6)
                                .foregroundColor(.orange)
                        }
                        .padding(.top, 2)
                    }

                    Spacer()

                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.15))
                            .frame(width: 50, height: 50)

                        Text("21%")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.orange)
                    }
                }
                .padding(.horizontal)

                HStack {
                    Image(systemName: "quote.bubble")
                        .foregroundColor(.orange.opacity(0.7))

                    Text("Every action you take is a vote for the person you wish to become.")
                        .font(.caption)
                        .italic()
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                .padding(.top, 5)

                Button(action: {
                    showReadingSession = true
                }) {
                    HStack {
                        Image(systemName: "book.fill")
                        Text("Continue Reading")
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
        }
        .sheet(isPresented: $showReadingSession) {
            ReadingSessionView()
        }
    }
}
