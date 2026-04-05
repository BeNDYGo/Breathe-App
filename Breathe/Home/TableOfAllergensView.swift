import SwiftUI

struct TableOfAllergens: View {
    let fixedAllergens = [
        ("Ольха", "Ольха"),
        ("Орешник", "Орешник"),
        ("Берёза", "Береза"),
        ("Дуб", "Дуб"),
        ("Злаки", "Злаки"),
        ("Полынь", "Полынь"),
        ("Маревые", "Маревые"),
        ("Амброзия", "Амброзия")
    ]
    
    let columns = [
        GridItem(.fixed(120), spacing: 40),
        GridItem(.fixed(120))
    ]
    
    var homeData: HeadActivity?
    @Binding var activeInfo: InfoPopupData?
    
    var body: some View {
        ZStack(alignment: .center) {
            MyRectangle(width: 350, height: 340)
            VStack{
                HStack{
                    Image(systemName: "list.bullet")
                        .foregroundStyle(.orange)
                    Text("Таблица аллергенов")
                        .foregroundStyle(Color(hex: "37475a"))
                    Button {
                        activeInfo = InfoPopupData(
                            title: "Таблица аллергенов",
                            img: "info.circle.fill",
                            description: """
                                    Таблица показывает растения, которые цветут в вашем регионе прямо сейчас, согласно ботаническому календарю.

                                    🌳 Ольха и Орешник: Конец марта — Апрель
                                    🌳 Берёза: Конец апреля — Май
                                    🌳 Дуб: Май — Начало июня
                                    🌾 Злаковые травы: Июнь — Июль
                                    🌿 Сорные травы (Полынь, Маревые, Амброзия): Середина июля — Сентябрь
                                    """
                        )
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundStyle(.gray.opacity(0.6))
                    }
                    Spacer()
                }
                .frame(width: 300)
                
                // Сетка
                LazyVGrid(columns: columns, spacing: 18) {
                    ForEach(fixedAllergens, id: \.0) { item in
                        let name = item.0
                        let icon = item.1
                        
                        let backendValue = homeData?.allergens.first(where: { $0.name == name })?.value ?? 0
                        
                        // Рисуем твою ячейку
                        AllergenCell(
                            name: name,
                            iconName: icon,
                            value: backendValue
                        )
                    }
                }
            }
        }
    }
}


// MARK: - Ячейка Аллергена
struct AllergenCell: View {
    let name: String
    let iconName: String
    let value: Int
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image(iconName)
                        .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    Text(name)
                        .foregroundStyle(Color(hex: "37475a"))
                        .lineLimit(1)
                        .font(.system(size: 15))
                    Spacer()
                }
                .padding(.leading, 10)
                
                ProgressView(value: Double(value), total: 1)
                    .frame(width: 110)
                    .tint(.orange)
            }
        }
        // Жестко фиксируем размер, чтобы ничего никуда не уехало!
        .frame(width: 145, height: 55)
    }
}
