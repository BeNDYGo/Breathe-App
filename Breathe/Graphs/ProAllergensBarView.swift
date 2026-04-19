import SwiftUI

struct ProAllergensBarView: View {
    let allergens: [AllergensLive]
    @Binding var activeInfo: InfoPopupData?
    
    private var maxAllergenValue: Double {
            let currentMax = allergens.max(by: { $0.value < $1.value })?.value ?? 0
            return max(currentMax, 50.0) 
        }
    
    private func barColor(for value: Double) -> Color {
        if value == 0 { return Color.gray.opacity(0.2) }
        if value < 100 { return .green }
        if value < 500 { return .orange }
        return .red
    }
    
    private func formatValue(_ value: Double) -> String {
        if value == 0 { return "" }
        if value < 10 { return "\(value)" }
        if value >= 1000 { return String(format: "%.1fk", value / 1000.0) }
        return String(format: "%.0f", value)
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                
                // 1. ЗАГОЛОВОК
                HStack(spacing: 6) {
                    Image(systemName: "sparkle.text.clipboard.fill")
                        .foregroundStyle(.orange)
                    Text("Аллергены")
                        .foregroundStyle(Color(hex: "37475a"))

                    Button {
                        activeInfo = InfoPopupData(
                            title: "Состав воздуха",
                            description: "Здесь показано соотношение конкретных аллергенов. Высота столбца указывает на относительную опасность каждого растения в данный момент."
                        )
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.system(size: 14))
                            .foregroundStyle(.gray.opacity(0.6))
                    }
                    Spacer()
                }
                .padding(.bottom, 10)
                
                // 2. ГРАФИК
                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(allergens, id: \.name) { item in
                        VStack(spacing: 4) {
                            Text(formatValue(item.value))
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundStyle(Color(hex: "37475a").opacity(0.6))

                            // Столбик
                            Capsule()
                                .fill(barColor(for: item.value))
                                .frame(width: 12, height: item.value == 0 ? 4 : max(CGFloat((item.value / maxAllergenValue) * 60), 6))
                            // Иконка
                            Image(item.name)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 120, alignment: .bottom)
                
                Spacer()
            }
            .padding(25) // Те же отступы, что и в ProActivityView
        }
        .frame(width: 350, height: 200) // Твой стандартный размер карточки
    }
}
