import SwiftUI
import SwiftData
import Network

@MainActor
class NewsModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    private let newsService: NewsService
    private let networkMonitor = NetworkMonitor()
    
    init(modelContext: ModelContext) {
        self.newsService = NewsService(modelContext: modelContext)
    }
    
    var isConnected: Bool {
        networkMonitor.isConnected
    }
    
    func fetchNews() async {
        guard networkMonitor.isConnected else { return }
        isLoading = true
        do {
            try await newsService.fetchNews()
            articles = newsService.articles
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

