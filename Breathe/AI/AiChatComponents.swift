import SwiftUI

struct AiChatHeader: View {
    let remainingRequests: Int
    let onInfoTap: () -> Void

    var body: some View {
        HStack {
            Text("Breathe AI")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(Color(hex: "37475a"))
            Spacer()
            Button {
                onInfoTap()
            } label: {
                Image(systemName: "info.circle")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color(hex: "37475a"))
            }
            .padding(.trailing, 10)
            HStack(spacing: 6) {
                Image(systemName: "sparkles.2")
                    .font(.system(size: 24))
                    .foregroundStyle(Color(hex: "ff893f"))
                Text("\(remainingRequests)")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(hex: "ff893f"))
            }
        }
        .padding(.horizontal, 25)
        .padding(.top, 10)
    }
}

struct AiChatEmptyState: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 50))
                .foregroundStyle(.gray.opacity(0.15))

            Text("Спросите что угодно")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundStyle(.gray.opacity(0.5))
        }
    }
}

struct AiChatSuggestions: View {
    let onSelect: (String) -> Void

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing, spacing: 12) {
                SuggestionButton(text: "Почему мне плохо?", action: onSelect)
                SuggestionButton(text: "Когда мне полегчает?", action: onSelect)
                SuggestionButton(text: "Как уменьшить симптомы?", action: onSelect)
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 15)
        }
    }
}

struct SuggestionButton: View {
    let text: String
    let action: (String) -> Void

    var body: some View {
        Button {
            action(text)
        } label: {
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color(hex: "A66F00"))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(hex: "ff893f").opacity(0.05))
                .overlay(
                    Capsule().stroke(Color(hex: "ff893f").opacity(0.4), lineWidth: 1.5)
                )
                .clipShape(Capsule())
        }
    }
}
