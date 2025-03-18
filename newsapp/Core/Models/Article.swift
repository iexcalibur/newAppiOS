import Foundation
import SwiftData

@Model
class Article: Identifiable {
    var id: String
    var sourceName: String
    var title: String
    var articleDescription: String?
    var url: String
    var urlToImage: String?
    var publishedAt: String
    var content: String?
    var isSaved: Bool
    
    init(id: String = UUID().uuidString,
         sourceName: String,
         title: String,
         articleDescription: String?,
         url: String,
         urlToImage: String?,
         publishedAt: String,
         content: String?,
         isSaved: Bool = false) {
        self.id = id
        self.sourceName = sourceName
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
        self.isSaved = isSaved
    }
    
    static func fromAPI(_ apiArticle: APIArticle) -> Article {
        Article(
            sourceName: apiArticle.source.name,
            title: apiArticle.title,
            articleDescription: apiArticle.description,
            url: apiArticle.url,
            urlToImage: apiArticle.urlToImage,
            publishedAt: apiArticle.publishedAt,
            content: apiArticle.content
        )
    }
    
    static func findExisting(url: String, in context: ModelContext) -> Article? {
        let descriptor = FetchDescriptor<Article>(predicate: #Predicate<Article> { article in
            article.url == url && article.isSaved == true
        })
        return try? context.fetch(descriptor).first
    }
    
    var isDownloaded: Bool {
        guard let modelContext = modelContext else { return false }
        do {
            let url = self.url 
            let descriptor = FetchDescriptor<Article>(predicate: #Predicate<Article> { article in
                article.url == url
            })
            return try modelContext.fetch(descriptor).first != nil
        } catch {
            return false
        }
    }
}

struct APIArticle: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct Source: Codable {
    let name: String
}

struct NewsResponse: Codable {
    let articles: [APIArticle]
}
