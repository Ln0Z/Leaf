import SwiftUI

struct EnhancedBookCard: View {
    let title: String
    let author: String
    let progress: Double
    let color: String // still used for local differentiation, but visually just orange

    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.orange.opacity(0.1))
                    .frame(width: 140, height: 180)

                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 135, height: 175)
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 2, y: 2)

                VStack {
                    Image(systemName: "book.closed")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                        .foregroundColor(.orange)

                    Text(title.prefix(1))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.orange)
                }
            }

            HStack {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.orange)

                Spacer()

                Image(systemName: progress > 0.3 ? "star.fill" : "star")
                    .font(.system(size: 10))
                    .foregroundColor(.orange)
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(6)

            Text(title)
                .font(.headline)
                .lineLimit(1)

            Text(author)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(1)
        }
        .frame(width: 140)
        .padding(.vertical)
    }
}
