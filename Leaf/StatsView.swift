import SwiftUI

struct StatsView: View {
    var body: some View {
        NavigationView {
            StatsContentView()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Image(systemName: "chart.bar")
                                .foregroundColor(.white)
                            Text("Reading Stats")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                }
        }
    }
}

struct StatsContentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                StatsSummarySection()
                WeeklyReadingSection()
                ReadingGoalsSection()
            }
            .padding(.vertical)
        }
        .background(Color(.systemGray6))
    }
}

struct StatsSummarySection: View {
    var body: some View {
        HStack(spacing: 10) {
            StatBox(value: "3", label: "day streak")
            StatBox(value: "42", label: "pages this week")
            StatBox(value: "4", label: "books in 2025")
        }
        .padding(.horizontal)
    }
}

struct WeeklyReadingSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.orange)
                Text("Weekly Reading Activity")
                    .font(.headline)
            }
            .padding(.horizontal)

            HStack(alignment: .bottom, spacing: 15) {
                BarView(height: 0.8, day: "M")
                BarView(height: 0.5, day: "T")
                BarView(height: 0.2, day: "W")
                BarView(height: 0.7, day: "T")
                BarView(height: 0.4, day: "F")
                BarView(height: 0.6, day: "S")
                BarView(height: 0.5, day: "S")
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
        .padding(.vertical)
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct ReadingGoalsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "target")
                    .foregroundColor(.orange)
                Text("Reading Goals")
                    .font(.headline)
            }
            .padding(.horizontal)

            ReadingChallengeCard()
        }
        .padding(.vertical)
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct ReadingChallengeCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("2025 Reading Challenge")
                .font(.title3)
                .fontWeight(.bold)

            Text("24 books")
                .font(.title2)
                .fontWeight(.bold)

            ProgressWithCountView()

            HStack {
                Text("4 of 24 books completed")
                    .foregroundColor(.gray)

                Spacer()

                Text("On track")
                    .foregroundColor(.orange)
                    .fontWeight(.medium)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct ProgressWithCountView: View {
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(height: 8)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.orange)
                    .frame(width: 100, height: 8)
            }

            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.2))
                    .frame(width: 40, height: 40)

                Text("4")
                    .font(.headline)
                    .foregroundColor(.orange)
            }
        }
    }
}

struct StatBox: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.orange)

            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct BarView: View {
    let height: CGFloat
    let day: String

    var body: some View {
        VStack(spacing: 8) {
            Spacer()

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.orange)
                .frame(width: 30, height: height * 150)

            Text(day)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(height: 180)
    }
}
