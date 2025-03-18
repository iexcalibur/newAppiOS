import SwiftUI
import SwiftData

@MainActor
class SavedArticlesViewModel: ObservableObject {
    @Published var savedArticles: [Article] = []
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func deleteArticle(_ article: Article) {
        modelContext.delete(article)
        try? modelContext.save()
    }
}

