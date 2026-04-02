import SwiftUI

struct NoSityViev: View {
    var body: some View {
        ZStack {
            MyRectangle(width: 350, height: 80)
            
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 24))
                
                VStack(alignment: .leading) {
                    Text("Город не определен")
                        .font(.system(size: 16, weight: .bold))
                    Text("Нажмите на лупу, чтобы выбрать город вручную")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.horizontal, 30)
        }
    }
}
