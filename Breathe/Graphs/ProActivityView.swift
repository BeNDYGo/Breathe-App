import SwiftUI
import Charts

struct ProActivityView: View {
    let data: ProData
    @Binding var activeInfo: InfoPopupData?
    
    private var healthColor: Color {
        if data.activity < 100 { return .green }
        if data.activity < 500 { return .orange }
        return .red
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                // Заголовок
                HStack(spacing: 6) {
                    Image(systemName: "app.background.dotted")
                        .foregroundStyle(.orange)
                    
                    Text("Количество пыльцы")
                        .foregroundStyle(Color(hex: "37475a"))

                    Button {
                        activeInfo = InfoPopupData(
                            title: "Концентрация",
                            description: "Этот показатель отражает реальное количество микрочастиц пыльцы в одном кубическом метре воздуха."
                            
                        )
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.system(size: 14))
                            .foregroundStyle(.gray.opacity(0.6))
                    }
                    Spacer()
                }
                .padding(.bottom, 10)
                // Данные
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: -5) {
                        Text(String(format: "%.1f", data.activity))
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                            .minimumScaleFactor(0.4)
                            .lineLimit(1)
                            .foregroundStyle(.black)
                        
                        HStack(alignment: .top, spacing: 0) {
                            Text("г/м")
                                .font(.system(size: 15, weight: .medium))
                            Text("3")
                                .font(.system(size: 12, weight: .bold))
                                .baselineOffset(8)
                        }
                        .foregroundStyle(Color(hex: "37475a"))
                        .padding(.leading, 4)
                    }
                    
                    Spacer()

                    // Кольцевой график
                    ZStack {
                        // Фоновое кольцо
                        Circle()
                            .stroke(Color.gray.opacity(0.1), lineWidth: 10)
                        
                        // Кольцо прогресса (на 100 единиц)
                        Circle()
                            .trim(from: 0, to: CGFloat(min(data.activity / 100.0, 1.0)))
                            .stroke(
                                healthColor,
                                style: StrokeStyle(lineWidth: 10, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .animation(.easeOut(duration: 1.0), value: data.activity)
                        
                        // Маленькая иконка внутри круга для ламповости
                        Image(systemName: "aqi.medium")
                            .font(.system(size: 20))
                            .foregroundStyle(healthColor.opacity(0.8))
                    }
                    .frame(width: 90, height: 90)
                }
                
                Spacer(minLength: 0)

                // примечание
                VStack(alignment: .leading, spacing: 8) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 1)
                    
                    Text("*при значениях выше 100 вы почувствовать симптомы")
                        .font(.system(size: 10))
                        .italic()
                        .foregroundStyle(.gray)
                        .lineLimit(1)
                }
            }
            .padding(25)
        }
        .frame(width: 350, height: 210)
    }
}
