import SwiftUI

struct NewsViewCard: View {
    let article: Article
    @Environment(\.modelContext) private var modelContext
    let isInSavedArticles: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .center, spacing: 8) {
                    // Image section
                    if let imageUrl = article.urlToImage,
                       let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width - 10, height: 95)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            default:
                                placeholderImage(geometry: geometry)
                            }
                        }
                    } else {
                        placeholderImage(geometry: geometry)
                    }
                    
                    // Title
                    Text(article.title)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    // Description
                    if let description = article.articleDescription {
                        Text(description)
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                    }
                    
                    Spacer()
                    
                    // Read more button
                    HStack {
                        if isInSavedArticles {
                            Button(action: deleteArticle) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .font(.system(size: 12))
                            }
                        }
                        Spacer()
                        Text("Read more")
                            .font(.system(size: 8))
                            .foregroundColor(.blue)
                    }
                }
                .padding(.vertical, 4)
            }
            .frame(width: geometry.size.width - 20, height: 269)
            .padding(8)
            .background(colorScheme == .dark ? Color(.systemGray6) : Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(colorScheme == .dark ? Color.gray.opacity(0.3) : Color.gray.opacity(0.5),
                            lineWidth: 1)
            )
        }
        .frame(height: 285)
    }
    
    private func deleteArticle() {
        modelContext.delete(article)
        try? modelContext.save()
    }
    
    private func placeholderImage(geometry: GeometryProxy) -> some View {
        Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: geometry.size.width - 20, height: 95)
            .foregroundColor(.gray)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
