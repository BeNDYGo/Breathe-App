
import SwiftUI


struct GraphsView: View {
    var body: some View {
        ZStack{
            VStack{
                ZStack{
                    MyRectangle(width: 350, height: 150)
                    HStack{
                        Text("Погода")
                        Spacer()
                    }
                }
                .frame(width: 350, height: 150)
                
                Text("Graph")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
        }
    }
}

#Preview {
    GraphsView()
}
