import SwiftUI
import SwiftData

@MainActor
class NewsFeedViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let newsService: NewsService
    
    init(newsService: NewsService) {
        self.newsService = newsService
    }
    
    func fetchNews() async {
        isLoading = true
        do {
            try await newsService.fetchNews()
            articles = newsService.articles
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
}
