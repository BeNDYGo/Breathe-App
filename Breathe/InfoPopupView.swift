import SwiftUI


struct InfoPopupData {
    let title: String
    let img: String
    let description: String
}


// MARK: - Универсальное окно подсказки
struct InfoPopupView: View {
    let info: InfoPopupData
    let onClose: () -> Void // Функция закрытия
    
    var body: some View {
        ZStack {
            // 1. Полупрозрачный темный фон (затемняет приложение)
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }
            
            // 2. Сама карточка
            VStack(spacing: 15) {
                /*
                // Иконка для красоты
                Image(systemName: info.img)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.orange)
                */
                // Заголовок (например "Активность")
                Text(info.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color(hex: "37475a"))
                
                // Основной текст
                Text(info.description)
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 10)
                
                // Кнопка закрытия
                Button {
                    onClose()
                } label: {
                    Text("Понятно")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color(hex: "37475a"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(hex: "fff4db")) // Твой теплый желтый
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .padding(.top, 10)
            }
            .padding(20)
            .background(Color(hex: "F9F8F6")) // Цвет фона карточки
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding(.horizontal, 40) // Отступы от краев телефона
        }
    }
}
