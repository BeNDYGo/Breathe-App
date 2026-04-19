import SwiftUI

struct AiChatView: View {
    // Переменная только для того, чтобы клавиатура могла вводить текст
    @State private var messageText: String = ""

    var body: some View {
        ZStack {
            // Твой фирменный бежевый фон
            Color(hex: "F9F8F6").ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // 1. ШАПКА (Стиль как в Аналитике)
                HStack {
                    Text("ИИ-Ассистент")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(hex: "37475a"))
                    Spacer()
                    Image(systemName: "sparkles.2")
                        .font(.system(size: 24))
                        .foregroundStyle(Color(hex: "ff893f"))
                }
                .padding(.horizontal, 25)
                .padding(.top, 10)
                
                Spacer()
                
                // 2. ЦЕНТРАЛЬНАЯ ЧАСТЬ (Бледный текст)
                VStack(spacing: 12) {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.gray.opacity(0.15))
                    
                    Text("Спросите что угодно")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundStyle(.gray.opacity(0.5))
                }
                
                Spacer()
                
                // 3. БЛОК ПОДСКАЗОК (Оранжевые рамочки)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        SuggestionButton(text: "Почему мне плохо?")
                        SuggestionButton(text: "Когда мне полегчает?")
                        SuggestionButton(text: "Как уменьшить симптомы?")
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 15)
                }
                
                // 4. ПАНЕЛЬ ВВОДА И КНОПКА ПРИКРЕПЛЕНИЯ ДАННЫХ
                HStack(spacing: 12) {
                    
                    // Кнопка "Прикрепить данные" (Слева)
                    Button {
                        // Тут потом будет логика прикрепления
                    } label: {
                        Image(systemName: "waveform.path.ecg.text.clipboard.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(Color(hex: "ff893f"))
                            .frame(width: 50, height: 50)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
                    }
                    
                    // Поле ввода текста (Справа)
                    HStack {
                        TextField("Введите сообщение...", text: $messageText)
                            .font(.system(size: 16))
                            .foregroundStyle(Color(hex: "37475a"))
                        
                        // Кнопка отправки (Появляется, если текст не пустой)
                        Button {
                            // Тут потом будет отправка
                        } label: {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(messageText.isEmpty ? Color.gray.opacity(0.3) : Color(hex: "ff893f"))
                        }
                        .disabled(messageText.isEmpty)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20) // Отступ от нижнего TabBar
            }
        }
    }
}

// MARK: - Компонент кнопки-подсказки
struct SuggestionButton: View {
    let text: String
    
    var body: some View {
        Button {
            // Тут потом сделаем подстановку текста в поле ввода
        } label: {
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color(hex: "ff893f"))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                // Делаем прозрачный фон и оранжевую рамку
                .background(Color(hex: "ff893f").opacity(0.05))
                .overlay(
                    Capsule()
                        .stroke(Color(hex: "ff893f").opacity(0.4), lineWidth: 1.5)
                )
                .clipShape(Capsule())
        }
    }
}

#Preview {
    AiChatView()
}
