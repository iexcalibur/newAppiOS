import SwiftUI
import SwiftData

struct ArticleDetailView: View {
    let article: Article
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var newsService: NewsService
    
    init(article: Article) {
        self.article = article
        _newsService = StateObject(wrappedValue: NewsService(modelContext: ModelContext(try! ModelContainer(for: Article.self))))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    // Image with floating title
                    ZStack(alignment: .bottomLeading) {
                        if let imageUrl = article.urlToImage,
                           let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: geometry.size.width - 32)
                                        .frame(height: 252)
                                        .clipShape(RoundedRectangle(cornerRadius: 14))
                                default:
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: geometry.size.width - 32)
                                        .frame(height: 250)
                                }
                            }
                        }
                        
                        // Floating title with gradient
                        Text(article.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    .frame(width: geometry.size.width - 32)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    
                    VStack(alignment: .leading, spacing: 12) {
                        // Description
                        if let description = article.articleDescription {
                            Text(description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        // Content
                        if let content = article.content {
                            Text(content)
                                .font(.body)
                                .padding(.top)
                        }
                        
                        // Source and date
                        HStack {
                            Text(article.sourceName)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(article.publishedAt)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top)
                    }
                    .frame(width: geometry.size.width - 32)
                    .padding(16)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: toggleSaved) {
                    Image(systemName: article.isSaved || newsService.isArticleSaved(article.url) ? "bookmark.fill" : "bookmark")
                }
                .disabled(newsService.isArticleSaved(article.url))
            }
        }
        .onAppear {
            // Check if article is already saved
        }
    }
    
    private func toggleSaved() {
        guard !newsService.isArticleSaved(article.url) else { return }
        article.isSaved = true
        try? modelContext.save()
    }
}

struct TabBarVisibilityKey: EnvironmentKey {
    static let defaultValue: TabBarVisibility? = nil
}

class TabBarVisibility: ObservableObject {
    @Published var visibility: Visibility = .visible
}

extension EnvironmentValues {
    var tabBarVisibility: TabBarVisibility? {
        get { self[TabBarVisibilityKey.self] }
        set { self[TabBarVisibilityKey.self] = newValue }
    }
}
