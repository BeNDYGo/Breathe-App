import SwiftUI
import Charts

struct ActivityView: View {
    var homeData: HeadActivity?
    @Binding var activeInfo: InfoPopupData?
    @State private var isPro = true
    
    var body: some View {
        ZStack {
            MyRectangle(width: 350, height: 170)

            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    HStack{
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.orange)
                        Text("Активность")
                            .foregroundStyle(Color(hex: "37475a"))
                        Button {
                            activeInfo = InfoPopupData(
                                title: "Активность",
                                img: "info.circle.fill",
                                description: """
                                            Это общий показатель опасности на улице прямо сейчас. Он высчитывается на основе реальных жалоб других пользователей которые находятся рядом с вами
                                            
                                            (В PRO версии доступен грфаик изменения и многое другое)
                                            """
                            )
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundStyle(.gray.opacity(0.6))
                        }
                    }
                    HStack(alignment: .bottom, spacing: 4) {
                        Text("\(homeData?.activity ?? 0)")
                            .font(.system(size: 100, weight: .bold, design: .rounded))
                            .minimumScaleFactor(0.4)
                            .lineLimit(1)
                            .foregroundStyle(.black)
                        
                        Text("/ 10")
                            .padding(.bottom, 25)
                            .foregroundStyle(Color(hex: "37475a"))
                    }
                }
                
                Spacer()
                ZStack{
                    ZStack {
                        
                        // Сам график
                        Chart {
                            let history = homeData?.historyActivity ?? [0, 0, 0, 0, 0]
                            
                            ForEach(Array(history.enumerated()), id: \.offset) { index, value in
                                // Плавная линия
                                LineMark(
                                    x: .value("Время", index),
                                    y: .value("Активность", value)
                                )
                                .interpolationMethod(.catmullRom)
                                .lineStyle(StrokeStyle(lineWidth: 3))
                                .foregroundStyle(Color.orange)
                                
                                // Заливка градиентом под линией
                                AreaMark(
                                    x: .value("Время", index),
                                    y: .value("Активность", value)
                                )
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.orange.opacity(0.3), .clear],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            }
                        }
                        .chartYScale(domain: 0...10)
                        .chartXAxis(.hidden)
                        .chartYAxis(.hidden)
                        .padding(12)
                        
                        // Размытие самого графика
                        if !isPro {
                            Color(hex: "f7f7f7").opacity(0.1)
                                .background(Material.regular)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                            
                            // Поверх блюра вешаем иконку PRO
                            VStack(spacing: 4) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color(hex: "37475a"))
                                Text("PRO")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(Color(hex: "37475a"))
                                
                            }
                        }
                    }
                    .frame(width: 140, height: 100)
                    .frame(maxHeight: .infinity)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .frame(width: 350, height: 170, alignment: .topLeading)
        }
    }
}
