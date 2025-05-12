import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 15) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.orange)

                    Text("Reader Name")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Reading since April 2024")
                        .foregroundColor(.gray)
                }
                .padding()

                List {
                    Section(header: Text("Account")) {
                        SettingsRow(icon: "person.fill", title: "Profile Settings")
                        SettingsRow(icon: "bell.fill", title: "Notifications")
                        SettingsRow(icon: "gear", title: "Preferences")
                    }

                    Section(header: Text("Reading")) {
                        SettingsRow(icon: "target", title: "Reading Goals")
                        SettingsRow(icon: "chart.bar.fill", title: "Reading Reports")
                        SettingsRow(icon: "book.closed", title: "Book Collections")
                    }

                    Section(header: Text("Other")) {
                        SettingsRow(icon: "questionmark.circle", title: "Help & Support")
                        SettingsRow(icon: "info.circle", title: "About Leaf")
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Profile")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24, height: 24)
                .foregroundColor(.orange)

            Text(title)
                .padding(.leading, 8)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
    }
}
