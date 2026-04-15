import SwiftUI

struct OnboardingLocationView: View {
    var locationManager: LocationManager
    var onDone: () -> Void
    
    var body: some View {
        ZStack {
            Color(hex: "ff893f").ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "location.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                
                Text("Где вы находитесь?")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Нам нужен доступ к геолокации, чтобы показать актуальный уровень пыльцы в вашем городе.")
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 40)
                
                Spacer()
                
                Button {
                    locationManager.requestPermission()
                    onDone()
                } label: {
                    Text("Разрешить")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "ff893f"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
    }
}
