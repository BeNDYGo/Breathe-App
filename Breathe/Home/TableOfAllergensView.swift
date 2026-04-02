import SwiftUI

struct TableOfAllergens: View {
    let fixedAllergens = [
        ("Берёза", "Береза"),
        ("Ольха", "Ольха"),
        ("Орешник", "Орешник"),
        ("Дуб", "Дуб"),
        ("Злаки", "Злаки"),
        ("Полынь", "Полынь"),
        ("Маревые", "Маревые"),
        ("Амброзия", "Амброзия")
    ]
    
    let columns = [
        GridItem(.fixed(120), spacing: 40), // 40 - это размер твоего Spacer() посередине
        GridItem(.fixed(120))
    ]
    
    var homeData: HeadActivity?
    
    var body: some View {
        ZStack(alignment: .center) {
            MyRectangle(width: 350, height: 300)
            
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
