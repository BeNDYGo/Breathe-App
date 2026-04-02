import SwiftUI

struct FeelView: View {
    var body: some View {
        ZStack(alignment: .top) {
            MyRectangle(width: 350, height: 170)
            VStack(spacing: 15){
                HStack{
                    Image("Градусник")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text("Как вы себя чувствуете?")
                        .foregroundStyle(Color(hex: "37475a"))
                    Spacer()
                    ZStack{
                        MiniRectangle(width: 70, height: 30, color: "dcfcdc")
                        HStack(spacing: 1){
                            Image(systemName: "tree.circle.fill")
                                .font(.system(size: 21))
                                .foregroundStyle(.black)
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
}

// MARK: - feelButton
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
                .clipShape(RoundedRectangle(cornerRadius: 35))
                .foregroundStyle(.green)
            }
            
        }
    }
}
