import SwiftUI

struct AiChatInputBar: View {
    @Binding var messageText: String
    let isMessageFocused: FocusState<Bool>.Binding
    @Binding var isAttachSelected: Bool
    let onSend: () -> Void
    
    private let attachButtonSize: CGFloat = 40
    private let inputHeight: CGFloat = 46

    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            Button {
                isAttachSelected.toggle()
            } label: {
                Image(systemName: "paperclip")
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .frame(width: attachButtonSize, height: attachButtonSize)
                    .background(isAttachSelected ? Color(hex: "ff893f") : Color.gray.opacity(0.55))
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            }

            HStack(alignment: .center) {
                TextField(
                    "",
                    text: $messageText,
                    prompt: Text("Введите сообщение...")
                        .foregroundStyle(Color.gray.opacity(0.75)),
                    axis: .vertical
                )
                    .lineLimit(1...5)
                    .font(.system(size: 16))
                    .foregroundStyle(Color(hex: "37475a"))
                    .padding(.vertical, 12)
                    .focused(isMessageFocused)

                Button {
                    onSend()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(messageText.isEmpty ? Color.gray.opacity(0.3) : Color(hex: "ff893f"))
                }
                .disabled(messageText.isEmpty)
            }
            .padding(.horizontal, 15)
            .frame(minHeight: inputHeight)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
        }
        .padding(.leading, 16)
        .padding(.trailing, 20)
        .padding(.bottom, 20)
    }
}
