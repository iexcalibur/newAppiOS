import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // News Feed Tab
            NavigationStack {
                NewsView(modelContext: modelContext)
                    .navigationTitle("News Feed")
            }
            .tabItem {
                VStack {
                    Image(systemName: selectedTab == 0 ? "newspaper.fill" : "newspaper")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                    
                }
            }
            .tag(0)
            
            // Saved Articles Tab
            NavigationStack {
                SavedArticlesView()
                    .navigationTitle("Saved Articles")
            }
            .tabItem {
                VStack {
                    Image(systemName: selectedTab == 1 ? "bookmark.fill" : "bookmark")
                        .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                    
                }
            }
            .tag(1)
        }
        .tint(.green)
    }
}


