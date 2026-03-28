
import SwiftUI

struct HomeView: View {
    let headerInfo = HeaderInfo()
    
    @State private var homeData: HeadActivity?
    
    var body: some View {
        ZStack {
            Color(hex: "F9F8F6")
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
// Блок с датой и погодой
                    ZStack {
                        MyRectangle(width: 350, height: 70)

                        HStack(spacing: 60) {
                            VStack(alignment: .leading) {
                                Text("Москва")
                                    .font(.system(size: 20).bold())
                                HStack{
                                    DateText(text: headerInfo.dayNumber)
                                    DateText(text: headerInfo.weekday)
                                }
                                
                            }
                            Image(systemName: homeData?.weatherImage ?? "airplane.up.right")

                            Image(systemName: "aqi.low")
                                .font(.system(size: 48))
                                .foregroundStyle(Color(hex: "15de07"))

                        }
                        .frame(width: 350, height: 70)
                        
                    }
// Блок с баллами
                    ZStack {
                        MyRectangle(width: 350, height: 170)

                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("Активность")

                                HStack(alignment: .bottom, spacing: 4) {
                                    Text("\(homeData?.activity ?? 0)")
                                        .font(.system(size: 100))
                                        //.foregroundStyle(Color(hex: allergenColor(value: homeData?.activity ?? 0)))
                                    Text("/ 10")
                                        .padding(.bottom, 25)
                                }
                            }

                            Spacer()

                            MiniRectangle(width: 170, height: 130, color: "f7f7f7")
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .frame(width: 350, height: 170, alignment: .topLeading)
                    }
                    
/*
 // Заголосов с основными аллергенами
                    HStack {
                        Text("Основные аллегены:")
                            .font(.system(size: 18))
                    }
                    .frame(width: 310, alignment: .leading)
 */
// Блок с основными аллергенами
                    ZStack(alignment: .center) {
                        MyRectangle(width: 350, height: 210)
                        
                        VStack(alignment: .leading, spacing: 18) {
                            ForEach(homeData?.allergens ?? [], id: \.name) {allergen in
                                VStack(alignment: .leading, spacing: 6){
                                    HStack{
                                        Text(allergen.name)
                                        Spacer()
                                        ZStack{
                                            MiniRectangle(width: 37, height: 20, color: allergenColor(value: allergen.value))
                                            Text("\(allergen.value)/10")
                                                .font(.system(size: 13))
                                        }
                                    }
                                    .frame(width: 310, height: 30)
                                    
                                    ProgressView(value: Double(allergen.value), total: 10)
                                        .frame(width: 310)
                                        .tint(Color(hex: allergenColor(value: allergen.value)))
                                }
                            }
                        }
                    }
                    
// Блок как вы себя чувствуете
                    ZStack(alignment: .top) {
                        MyRectangle(width: 350, height: 170)
                        VStack(spacing: 15){
                            HStack{
                                Text("Как вы себя чувствуете?")
                                Spacer()
                                ZStack{
                                    MiniRectangle(width: 70, height: 30, color: "dcfcdc")
                                    HStack(spacing: 1){
                                        Image(systemName: "tree.circle.fill")
                                            .font(.system(size: 21))
                                        Text("+10")
                                            .foregroundStyle(Color(hex: "286127"))
                                    }
                                }
                            }
                            .frame(width: 310, height: 30)
                            HStack(spacing: 40){
                                feelButton(type: "Good")
                                feelButton(type: "Normal")
                                feelButton(type: "Bad")
                            }

                        }
                        .padding(.top, 20)
                    }
                }
                .padding(.top, 15)
            }
        }
        .task {
            homeData = await loadHomeData()
        }
    }
}

struct DateText: View {
    let text: String
    var body: some View {
        Text("\(text)")
            .font(.system(size: 16))
    }
}
struct MyRectangle: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .frame(width: width, height: height)
            .foregroundStyle(Color(hex: "FFFFFF"))
    }
}

struct MiniRectangle: View {
    let width: CGFloat
    let height: CGFloat
    let color: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .frame(width: width, height: height)
            .foregroundStyle(Color(hex: color))
    }
}

struct feelButton: View {
    let type: String
    var body: some View {
        Button {
            //
        } label: {
            if type == "Bad" {
                ZStack{
                    Image(systemName: "heart.badge.bolt.slash")
                        .font(.system(size: 35))
                }
                .frame(width: 40, height: 40)
                .padding(20)
                .background(Color(hex: "f7f7f7"))
                .clipShape(RoundedRectangle(cornerRadius: 35))
                .foregroundStyle(.red)
                
            }
            if type == "Normal"{
                ZStack{
                    Image(systemName: "bolt.heart")
                        .font(.system(size: 35))
                }
                .frame(width: 40, height: 40)
                .padding(20)
                .background(Color(hex: "f7f7f7"))
                .clipShape(RoundedRectangle(cornerRadius: 35))
                .foregroundStyle(.orange)
            }
            if type == "Good"{
                ZStack{
                    Image(systemName: "heart")
                        .font(.system(size: 35))
                }
                .frame(width: 40, height: 40)
                .padding(20)
                .background(Color(hex: "f7f7f7"))
                .clipShape(RoundedRectangle(cornerRadius: 35))
                .foregroundStyle(.green)
            }
            
        }
    }
}

#Preview {
    HomeView()
}
