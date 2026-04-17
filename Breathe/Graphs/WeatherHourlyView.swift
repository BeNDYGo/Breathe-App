import SwiftUI
import Charts

struct WeatherHourlyView: View {
    let data: ProData
    @Binding var activeInfo: InfoPopupData? // Провод для окна подсказки

    // Жестко фиксируем ширину одной колонки (одного часа)
    let columnWidth: CGFloat = 55
    
    // Функция для получения времени (например, "14:00")
    private func getHourString(offset: Int) -> String {
        let currentHour = Calendar.current.component(.hour, from: Date())
        let targetHour = (currentHour + offset) % 24
        return String(format: "%02d:00", targetHour)
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                
                // 1. ЗАГОЛОВОК И КНОПКА (i)
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundStyle(Color(hex: "ff893f"))
                    
                    Text("Условия на 10 часов")
                        // Убрали weight: .bold, оставили просто цвет
                        .font(.system(size: 16, design: .rounded))
                        .foregroundStyle(Color(hex: "37475a"))
                    
                    // Кнопка подсказки
                    Button {
                        activeInfo = InfoPopupData(
                            title: "Погода и Пыльца",
                            img: "",
                            description: """
                        В этом графике собрана вся важная информация.
                        Температура: Тепло ускоряет распускание почек. При резком потеплении случаются "пыльцевые бури".
                        Осадки: Дождь — лучший друг аллергика. Он буквально вымывает пыльцу из воздуха, прибивая её к земле.
                        Ветер: Сильный ветер переносит пыльцу на десятки километров от леса прямо в город.
                        Влажность: При высокой влажности пыльцевые зерна набухают, тяжелеют и оседают вниз.
                        """
                        )
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundStyle(.gray.opacity(0.6))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // 2. ГОРИЗОНТАЛЬНЫЙ СКРОЛЛ
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(spacing: 8) {
                        
                        // РЯД 1: Время
                        HStack(spacing: 0) {
                            ForEach(0..<data.weatherHourly10.count, id: \.self) { i in
                                Text(getHourString(offset: i))
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(.gray)
                                    .frame(width: columnWidth)
                            }
                        }
                        
                        // РЯД 2: Иконки погоды
                        HStack(spacing: 0) {
                            ForEach(0..<data.weatherIconsHourly10.count, id: \.self) { i in
                                Image(systemName: data.weatherIconsHourly10[i])
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color(hex: "37475a"))
                                    .frame(width: columnWidth)
                            }
                        }
                        
                        // РЯД 3: График температуры
                        let count = data.weatherHourly10.count
                        if count > 0 {
                            Chart {
                                ForEach(0..<count, id: \.self) { i in
                                    LineMark(
                                        x: .value("Hour", i),
                                        y: .value("Temp", data.weatherHourly10[i])
                                    )
                                    .interpolationMethod(.catmullRom)
                                    .foregroundStyle(Color(hex: "ff893f"))
                                    .lineStyle(StrokeStyle(lineWidth: 3))
                                    
                                    AreaMark(
                                        x: .value("Hour", i),
                                        y: .value("Temp", data.weatherHourly10[i])
                                    )
                                    .interpolationMethod(.catmullRom)
                                    .foregroundStyle(LinearGradient(
                                        colors:[Color(hex: "ff893f").opacity(0.2), .clear],
                                        startPoint: .top, endPoint: .bottom
                                    ))
                                }
                            }
                            .chartXAxis(.hidden)
                            .chartYAxis(.hidden)
                            // ХАК ДЛЯ ВЫРАВНИВАНИЯ: Ширина графика = (кол-во элементов - 1) * ширина колонки
                            .frame(width: CGFloat(count - 1) * columnWidth, height: 60)
                            // Добавляем отступы по краям, чтобы точки встали РОВНО по центру колонок
                            .padding(.horizontal, columnWidth / 2)
                        }

                        // РЯД 4: Температура цифрами
                        HStack(spacing: 0) {
                            ForEach(0..<data.weatherHourly10.count, id: \.self) { i in
                                Text("\(Int(round(data.weatherHourly10[i])))°")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundStyle(.black)
                                    .frame(width: columnWidth)
                            }
                        }
                        
                        // РЯД 5: Влажность (с микро-иконкой)
                        HStack(spacing: 0) {
                            ForEach(0..<data.precipitationProbabilityHourly10.count, id: \.self) { i in
                                HStack(spacing: 2) {
                                    Image(systemName: "drop.fill").font(.system(size: 8))
                                    Text("\(data.precipitationProbabilityHourly10[i])%")
                                        .font(.system(size: 11, weight: .medium))
                                }
                                .foregroundStyle(.blue)
                                .frame(width: columnWidth)
                            }
                        }
                        
                        // РЯД 6: Ветер (с микро-иконкой)
                        HStack(spacing: 0) {
                            ForEach(0..<data.windHourly10.count, id: \.self) { i in
                                HStack(spacing: 2) {
                                    Image(systemName: "wind").font(.system(size: 10))
                                    Text(String(format: "%.1f", data.windHourly10[i]))
                                        .font(.system(size: 11, weight: .medium))
                                }
                                .foregroundStyle(.gray)
                                .frame(width: columnWidth)
                            }
                        }
                        
                    }
                    // Отступ внутри скролла, чтобы контент не прилипал к левому краю рамки
                    .padding(.horizontal, 20)
                }
                
                Spacer(minLength: 0)
            }
        }
        .frame(width: 350, height: 280)
    }
}
