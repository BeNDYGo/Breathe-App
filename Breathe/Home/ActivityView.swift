import SwiftUI

struct ActivityView: View {
    var homeData: HeadActivity?
    
    var body: some View {
        ZStack {
            MyRectangle(width: 350, height: 170)

            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    HStack{
                        Image(systemName:
                                //thermometer.variable
                              "flame.fill").foregroundStyle(.orange)
                        Text("Активность")
                            .foregroundStyle(Color(hex: "37475a"))
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
                    MiniRectangle(width: 170, height: 130, color: "f7f7f7")
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .frame(width: 350, height: 170, alignment: .topLeading)
        }
    }
}
