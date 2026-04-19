import SwiftUI

struct ProCommunityView: View {
    let stats: Stats // Твоя структура с count и avg
    @Binding var activeInfo: InfoPopupData?
    
    // Функция для перевода средней оценки (1.0 - 3.0) в визуал
    private func getMood(avg: Double) -> (text: String, icon: String, color: Color) {
        if avg < 1.6 {
            return ("В основном хорошее", "heart", .green)
        } else if avg < 2.5 {
            return ("Терпимое", "bolt.heart", .orange)
        } else {
            return ("В основном плохое", "heart.badge.bolt.slash", .red)
        }
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                
                // 1. ЗАГОЛОВОК
                HStack(spacing: 6) {
                    Image(systemName: "person.2.fill")
                        .foregroundStyle(Color(hex: "ff893f"))
                    
                    Text("Самочувствие рядом")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(hex: "37475a"))
                    
                    Button {
                        activeInfo = InfoPopupData(
                            title: "Оценки пользователей",
                            description: "Здесь отображается среднее самочувствие реальных людей в радиусе 50 км от вас за последние 5 часов. Ваш голос на главном экране также учитывается здесь!"
                        )
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.system(size: 14))
                            .foregroundStyle(.gray.opacity(0.6))
                    }
                    Spacer()
                }
                
                // 2. ДАННЫЕ ИЛИ ЗАГЛУШКА
                if stats.count > 0 {
                    let mood = getMood(avg: stats.avg)
                    
                    HStack(spacing: 15) {
                        // Иконка эмоции
                        ZStack {
                            Circle()
                                .fill(Color(hex: "f7f7f7"))
                                .frame(width: 40, height: 40)
                            Image(systemName: mood.icon)
                                .font(.system(size: 20))
                                .foregroundStyle(mood.color)
                        }
                        
                        // Текст
                        VStack(alignment: .leading, spacing: 2) {
                            Text(mood.text)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(hex: "37475a"))
                            
                            Text("На основе \(stats.count) оценок за 5 часов")
                                .font(.system(size: 11))
                                .foregroundStyle(.gray)
                        }
                    }
                } else {
                    // Если оценок пока нет
                    Text("В вашем районе пока нет оценок за сегодня. Вы можете стать первым на главном экране!")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                        .padding(.top, 5)
                        .lineLimit(2)
                }
                
                Spacer(minLength: 0)
            }
            .padding(20)
        }
        .frame(width: 350, height: 110)
    }
}
