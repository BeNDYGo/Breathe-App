import SwiftUI

struct AiChatView: View {
    let remainingRequests: Int

    @State private var messageText = ""
    @State private var messages: [AiChatMessage] = []
    @State private var isShowingAttachSheet = false
    @FocusState private var isMessageFocused: Bool
    @State private var isGenerating = false
    

    var body: some View {
        ZStack {
            Color(hex: "ede2d1").ignoresSafeArea()

            VStack(spacing: 0) {
                AiChatHeader(remainingRequests: remainingRequests)

                if messages.isEmpty {
                    Spacer()
                    AiChatEmptyState()
                    Spacer()
                    AiChatSuggestions { suggestion in
                        messageText = suggestion
                        isMessageFocused = true
                    }
                } else {
                    ScrollViewReader { proxy in
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 12) {
                                ForEach(messages) { message in
                                    AiChatMessageBubble(message: message)
                                        .id(message.id)
                                }
                                
                                // Если ИИ генерирует ответ — показываем крутилку
                                if isGenerating {
                                    HStack {
                                        ProgressView()
                                            .padding()
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 24)
                            .padding(.bottom, 12)
                        }
                        .onChange(of: messages.count) {
                            guard let lastId = messages.last?.id else { return }
                            withAnimation(.easeOut(duration: 0.2)) {
                                proxy.scrollTo(lastId, anchor: .bottom)
                            }
                        }
                    }
                    
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            AiChatInputBar(
                messageText: $messageText,
                isMessageFocused: $isMessageFocused,
                onAttach: {
                    isShowingAttachSheet = true
                },
                onSend: sendMessage
            )
            .background(Color.clear)
        }
        .sheet(isPresented: $isShowingAttachSheet) {
            AttachDataSheet()
                .presentationDetents([.fraction(0.5), .large])
                .presentationDragIndicator(.visible)
        }
    }

    private func sendMessage() {
        let trimmedMessage = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else { return }

        // 1. Добавляем твоё сообщение в список (структура AiChatMessage)
        messages.append(AiChatMessage(text: trimmedMessage, isUser: true))
        
        let textToSend = trimmedMessage
        messageText = ""
        isMessageFocused = false
        
        // 2. Включаем индикатор загрузки
        isGenerating = true

        Task {
            if let aiResponse = await sendChatMessage(text: textToSend) {
                
                await MainActor.run {
                    messages.append(AiChatMessage(text: aiResponse, isUser: false))
                    isGenerating = false
                }
            } else {
                await MainActor.run {
                    messages.append(AiChatMessage(text: "Ошибка связи с сервером.", isUser: false))
                    isGenerating = false
                }
            }
        }
    }
}

private struct AiChatMessage: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

private struct AiChatMessageBubble: View {
    let message: AiChatMessage

    var body: some View {
        HStack {
            if message.isUser { Spacer(minLength: 40) }

            Text(message.text)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(Color.black)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            if !message.isUser { Spacer(minLength: 40) }
        }
    }
}
