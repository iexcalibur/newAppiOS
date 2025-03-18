import SwiftUI

struct ShimmerView: View {
    @State private var isAnimating = false
    
    var body: some View {
        Rectangle()
            .fill(LinearGradient(
                gradient: Gradient(colors: [.gray.opacity(0.2), .gray.opacity(0.5), .gray.opacity(0.2)]),
                startPoint: .leading,
                endPoint: .trailing
            ))
            .offset(x: isAnimating ? 400 : -400)
            .animation(
                Animation.linear(duration: 1.5).repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}
