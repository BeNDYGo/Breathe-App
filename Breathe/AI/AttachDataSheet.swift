import SwiftUI

struct AttachDataSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var isHomeSelected = false
    @State private var isGraphsSelected = false

    var body: some View {
        ZStack {
            Color(hex: "F9F8F6").ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                Text("Какие данные прикрепить?")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(hex: "37475a"))
                    .padding(.bottom, 5)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        AttachOptionRow(
                            isSelected: $isHomeSelected,
                            title: "Текущая ситуация (Home)",
                            description: "Отправит ИИ ваш текущий уровень пыльцы, погоду прямо сейчас и ваше самочувствие. Идеально для вопроса: «Что мне делать сегодня?»",
                            icon: "house.fill"
                        )

                        AttachOptionRow(
                            isSelected: $isGraphsSelected,
                            title: "История и прогноз (Graphs)",
                            description: "Отправит историю пыльцы за 5 дней, прогноз погоды на 10 часов и статистику других пользователей. Идеально для глубокого анализа.",
                            icon: "chart.xyaxis.line"
                        )
                    }
                    .padding(.bottom, 20)
                }

                Spacer(minLength: 0)

                Button {
                    print("Выбрано Home: \(isHomeSelected), Graphs: \(isGraphsSelected)")
                    dismiss()
                } label: {
                    Text(isHomeSelected || isGraphsSelected ? "Прикрепить выбранное" : "Закрыть")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(isHomeSelected || isGraphsSelected ? .white : Color(hex: "37475a"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isHomeSelected || isGraphsSelected ? Color(hex: "ff893f") : Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .padding(25)
            .padding(.top, 10)
        }
    }
}

struct AttachOptionRow: View {
    @Binding var isSelected: Bool
    let title: String
    let description: String
    let icon: String

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isSelected.toggle()
            }
        } label: {
            HStack(alignment: .top, spacing: 15) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color(hex: "ff893f") : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)

                    if isSelected {
                        Circle()
                            .fill(Color(hex: "ff893f"))
                            .frame(width: 12, height: 12)
                    }
                }
                .padding(.top, 2)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: icon)
                            .foregroundStyle(Color(hex: "ff893f"))

                        Text(title)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: "37475a"))
                    }

                    Text(description)
                        .font(.system(size: 13))
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }
            .padding(20)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color(hex: "ff893f").opacity(0.5) : Color.clear, lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
