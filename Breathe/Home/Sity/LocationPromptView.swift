import SwiftUI

// MARK: - Окно с GPS
struct LocationPromptView: View {
    // Эта переменная будет хранить действие, которое произойдет при нажатии кнопки
    var onNextAction: () -> Void
    
    var body: some View {
        ZStack {
            // 1. Полупрозрачный темный фон на весь экран
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            // 2. Сама карточка по центру
            VStack(spacing: 20) {
                Image(systemName: "location.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.green) // Можете поменять на свой цвет
                
                Text("Нам нужен доступ к геолокации, чтобы узнать ваш город")
                    .font(.system(size: 18, weight: .medium))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                
                Button {
                    // Вызываем переданное действие
                    onNextAction()
                } label: {
                    Text("Далее")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(hex: "15de07")) // Ваш зеленый цвет
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.top, 10)
            }
            .padding(25)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding(.horizontal, 40) // Отступы карточки от краев экрана
        }
    }
}
