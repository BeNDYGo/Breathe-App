import SwiftUI

struct HeaderView: View {
    var locationManager: LocationManager
    var headerInfo: HeaderInfo
    var onSearchTap: () -> Void
    
    var body: some View {    
        ZStack {
            MyRectangle(width: 350, height: 70)

            HStack() {
                VStack(alignment: .leading) {
                    HStack{
                        Image("Карта")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        Text("\(locationManager.cityName)")
                            .font(.system(size: 18).bold())
                            .foregroundStyle(Color(hex: "37475a"))
                    }
                    HStack{
                        DateText(text: headerInfo.dayNumber)
                        DateText(text: headerInfo.weekday)
                    }
                    
                }
                Spacer()
                
                Button {
                    onSearchTap()
                } label: {
                    Image("Лупа")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                }

            }
            .padding(.horizontal, 20)
            .frame(width: 350, height: 70)
            
        }
    }
}
