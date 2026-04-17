import SwiftUI

struct TableOfAllergens: View {
    let columns = [
        GridItem(.fixed(120), spacing: 40),
        GridItem(.fixed(120))
    ]
    
    var homeData: HeadActivity?
    @Binding var activeInfo: InfoPopupData?
    
    var body: some View {
        ZStack(alignment: .top) {
            MyRectangle(width: 350, height: 300)

            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "list.bullet")
                        .foregroundStyle(.orange)

                    Text("Таблица аллергенов")
                        .foregroundStyle(Color(hex: "37475a"))

                    Button {
                        activeInfo = InfoPopupData(
                            title: "Таблица аллергенов",
                            img: "info.circle.fill",
                            description: """
                                    Таблица показывает растения, которые цветут в вашем регионе прямо сейчас.
                                    Данные берутся с метеостанций в радиусе нескольких километров.
                                    """
                        )
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundStyle(.gray.opacity(0.6))
                    }

                    Spacer()
                }
                .frame(width: 320)

                if let allergens = homeData?.allergens {
                    LazyVGrid(columns: columns, spacing: 18) {
                        ForEach(allergens, id: \.name) { allergen in
                            AllergenCell(
                                name: allergen.name,
                                iconName: allergen.img,
                                value: allergen.value
                            )
                        }
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.orange)
                        .frame(width: 300, height: 220)
                }
            }
            .padding(.top, 22)
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
                
                ProgressView(value: Double(value), total: 10)
                    .frame(width: 110)
                    .tint(.orange)
            }
        }
        // Жестко фиксируем размер, чтобы ничего никуда не уехало!
        .frame(width: 145, height: 55)
    }
}
