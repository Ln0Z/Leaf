import SwiftUI
import UIKit

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showReadingSession = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
            VStack {
                LibraryView()
            }
            .tabItem {
                Image(systemName: selectedTab == 1 ? "book.fill" : "book")
                Text("Library")
            }
            .tag(1)
            
            StatsView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "chart.bar.fill" : "chart.bar")
                    Text("Stats")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(Color.green)
        .onAppear() {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = .white
            
            UITabBar.appearance().standardAppearance = appearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}
