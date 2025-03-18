import SwiftUI
import SwiftData
import Network

struct NewsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject private var newsModel: NewsModel
    @StateObject private var networkMonitor = NetworkMonitor()
    @State private var showError = false
    @State private var errorMessage = ""
    
    init(modelContext: ModelContext) {
        _newsModel = StateObject(wrappedValue: NewsModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if !networkMonitor.isConnected {
                    ContentUnavailableView(
                        "No Internet Connection",
                        systemImage: "wifi.slash",
                        description: Text("Please check your internet connection and try again")
                    )
                } else {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        if newsModel.isLoading {
                            // Show shimmer placeholders while loading
                            ForEach(0..<6, id: \.self) { _ in
                                ShimmerView()
                                    .frame(height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        } else {
                            ForEach(newsModel.articles) { article in
                                NavigationLink(destination: ArticleDetailView(article: article)) {
                                    NewsViewCard(article: article, isInSavedArticles: false)
                                }
                            }
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle("News Feed")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isDarkMode.toggle()
                    }) {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .foregroundColor(isDarkMode ? .yellow : .primary)
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .task {
            guard networkMonitor.isConnected else { return }
            do {
                try await newsModel.fetchNews()
            } catch {
                showError = true
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    NewsView(modelContext: try! ModelContainer(for: Article.self).mainContext)
}
