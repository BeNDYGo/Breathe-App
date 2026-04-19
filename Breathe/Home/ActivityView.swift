import Foundation
import SwiftUI

struct ActivityView: View {
    var homeData: HeadActivity?
    @Binding var activeInfo: InfoPopupData?
    
    private var temperatureText: String {
        guard let temperature = homeData?.weather?.temperature else {
            return "--°C"
        }
        return formatWeatherValue(temperature, suffix: "°C")
    }
    
    private var windText: String {
        guard let windSpeed = homeData?.weather?.wind_speed else {
            return "-- м/с"
        }
        return formatWeatherValue(windSpeed, suffix: " м/с")
    }
    
    var body: some View {
        ZStack {
            MyRectangle(width: 350, height: 170)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "flame.fill")
                                .foregroundStyle(.orange)
                            Text("Активность")
                                .foregroundStyle(Color(hex: "37475a"))
                            Button {
                                activeInfo = InfoPopupData(
                                    title: "Активность",
                                    description: """
                                                Это общий показатель опасности на улице прямо сейчас.
                                                
                                                Показатели отражают локальную концентрацию прямо сейчас именно рядом с вами, а не среднюю концентрацию в вашем городе или, хуже того, по стране.
                                                
                                                Справа показывается текущая погода, температура и скорость ветра. Все это влияет на пыльцу.
                                                
                                                Данные собираются из метеорологических моделей, метеорологических станций и из отметкок самочувствия пользователей. 
                                                
                                                В PRO версии доступны прогнозы на много подробнее.
                                                """
                                )
                            } label: {
                                Image(systemName: "info.circle")
                                    .foregroundStyle(.gray.opacity(0.6))
                            }
                        }
                        HStack(alignment: .bottom, spacing: 4) {
                            if let activity = homeData?.activity {
                                Text("\(activity)")
                                    .font(.system(size: 100, weight: .bold, design: .rounded))
                                    .minimumScaleFactor(0.4)
                                    .lineLimit(1)
                                    .foregroundStyle(.black)
                            } else {
                                ProgressView()
                                    .scaleEffect(2)
                                    .frame(width: 80, height: 100)
                                    .tint(Color(hex: Orange))
                            }
                            
                            Text("/ 10")
                                .padding(.bottom, 25)
                                .foregroundStyle(Color(hex: "37475a"))
                        }
                        .padding(.leading, 20)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 10) {
                        if let iconWether = homeData?.weather?.icon {
                            Image(systemName: iconWether)
                                .font(.system(size: 44, weight: .medium))
                                .foregroundStyle(.black)
                                .frame(width: 56, height: 56)
                        } else {
                            ProgressView()
                        }
                        VStack(spacing: 6) {
                            Label(temperatureText, systemImage: "thermometer.medium")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(Color(hex: "37475a"))
                            
                            Label(windText, systemImage: "wind")
                                .font(.system(size: 14))
                                .foregroundStyle(Color(hex: "37475a"))
                        }
                    }
                    .frame(width: 120)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .frame(width: 350, height: 170, alignment: .topLeading)
        }
    }
}

private func formatWeatherValue(_ value: Double, suffix: String) -> String {
    let roundedValue = value.rounded()
    
    if abs(value - roundedValue) < 0.05 {
        return "\(Int(roundedValue))\(suffix)"
    }
    
    return String(format: "%.1f%@", value, suffix)
}
