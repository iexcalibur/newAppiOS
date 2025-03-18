import SwiftUI
import SwiftData

struct SavedArticlesView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<Article> { article in
        article.isSaved == true
    })
    private var savedArticles: [Article]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(savedArticles) { article in
                        NavigationLink(destination: ArticleDetailView(article: article)) {
                            NewsViewCard(article: article, isInSavedArticles: true)
                        }
                    }
                }
                .padding(16)
            }
            .navigationTitle("Saved Articles")
            .overlay {
                if savedArticles.isEmpty {
                    ContentUnavailableView(
                        "No Saved Articles",
                        systemImage: "bookmark",
                        description: Text("Your saved articles will appear here")
                    )
                }
            }
        }
    }
}

#Preview {
    SavedArticlesView()
        .modelContainer(for: Article.self)
}
