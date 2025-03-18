import Foundation
import SwiftUI
import SwiftData

class NewsService: ObservableObject {
    @Published var articles: [Article] = []
    private let modelContext: ModelContext
    private let apiKey = "8a484105650142a5b58968ab9fbc5a26"
    @Published var isLoading = false
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func isArticleSaved(_ url: String) -> Bool {
        let descriptor = FetchDescriptor<Article>()
        if let existingArticles = try? modelContext.fetch(descriptor) {
            return existingArticles.contains { $0.url == url && $0.isSaved }
        }
        return false
    }
    
    func fetchNews() async throws {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=apple&sortBy=popularity&apiKey=\(apiKey)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
        
        DispatchQueue.main.async {
            // Convert API articles to SwiftData articles and insert them into the context
            self.articles = newsResponse.articles.map { apiArticle in
                let article = Article(
                    sourceName: apiArticle.source.name,
                    title: apiArticle.title,
                    articleDescription: apiArticle.description,
                    url: apiArticle.url,
                    urlToImage: apiArticle.urlToImage,
                    publishedAt: apiArticle.publishedAt,
                    content: apiArticle.content
                )
                self.modelContext.insert(article)
                return article
            }
            try? self.modelContext.save()
        }
    }
}
