import SwiftUI

struct StatsView: View {
    @StateObject private var viewModel = StatsViewModel()

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                StatsContentView(viewModel: viewModel)
                    .padding(.vertical)
                    .frame(width: geometry.size.width)
                    .background(Color(.systemGray6))
            }
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
            .onAppear {
                viewModel.bookProvider = {
                    BookStore().books
                }
            }
        }
    }
}


struct StatsContentView: View {
    @ObservedObject var viewModel: StatsViewModel
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer()
                StatsSummarySection(viewModel: viewModel)
                Spacer()
                Spacer()
                WeeklyReadingSection(viewModel: viewModel)
            }
            .padding(.vertical)
        }
        .background(Color(.systemGray6))
    }
}

struct StatsSummarySection: View {
    @ObservedObject var viewModel: StatsViewModel
    
    var body: some View {
        HStack(spacing: 10) {
            StatBox(value: "\(viewModel.dayStreak)", label: "day streak")
            StatBox(value: "\(viewModel.pagesThisWeek)", label: "pages this week")
            StatBox(value: "\(viewModel.booksThisYear)", label: "books in 2025")
        }
        .padding(.horizontal)
    }
}

struct WeeklyReadingSection: View {
    @ObservedObject var viewModel: StatsViewModel
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
                ForEach(viewModel.weeklyBarData, id: \.day) { item in
                    BarView(height: item.percent, day: String(item.day.prefix(1)), pages: item.pages)
                }
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
    let pages: Int

    var body: some View {
        VStack(spacing: 4) {
            Text("\(pages)")
                .font(.caption2)
                .foregroundColor(.gray)

            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 150)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.orange)
                    .frame(width: 30, height: max(height * 150, 1))
            }

            Text(day)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

#Preview{
    StatsView()
}
