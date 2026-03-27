
import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color(hex: "F9F8F6")
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Блок с датой
                    ZStack {
                        MyRectangle(width: 350, height: 100)
                        HStack{
                            Text("20")
                        }
                    }
                    // Блок с баллами и погодой
                    ZStack {
                        MyRectangle(width: 350, height: 170)
                    }
                    // Блок с баллами и погодой
                    HStack(spacing: 20) {
                        Text("Основные аллегены:")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.black)
                            .padding(.leading, -130)
                    }

                    ZStack(alignment: .leading) {
                        MyRectangle(width: 350, height: 200)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .top){
                                Text("Береза")
                            }
                            HStack{
                                Text("Орешник")
                            }
                            HStack{
                                Text("Ольха")
                            }
                        }
                        .padding(.top, 20)
                        .padding(.leading, 20)
                    }

                    ZStack(alignment: .top) {
                        MyRectangle(width: 350, height: 170)
                        Text("Как вы себя чувствуете?")
                            .foregroundStyle(.black)
                            .padding(.top, 20)
                    }
                }
                .padding(.top, 15)
            }
        }
    }
}

struct MyRectangle: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .frame(width: width, height: height)
            .foregroundStyle(Color(hex: "cfcfcf"))
    }
}

struct MyButton: View {
    let text: String
    var body: some View {
        Button {
            //
        } label: {
            HStack{
                Text("\(text)")
            }
            .padding(4)
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    HomeView()
}
