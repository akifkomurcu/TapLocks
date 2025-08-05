import SwiftUI
import LocalAuthentication

struct PopoverView: View {
    @ObservedObject var blocker: KeyboardBlocker
    @Environment(\.colorScheme) var colorScheme
    @State private var isPressed = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 8)
            // KİLİT BUTTONU
            Button(action: {
                if blocker.isBlocking {
                    authenticateWithSystem()
                } else {
                    blocker.isBlocking = true
                }
            }) {
                ZStack {
                    Circle()
                        .fill(
                            colorScheme == .dark
                            ? Color.white.opacity(0.16)
                            : Color.black.opacity(0.08)
                        )
                        .frame(width: 76, height: 76)
                        .shadow(color: Color.black.opacity(0.20), radius: isPressed ? 2 : 7, y: isPressed ? 0 : 4)
                        .overlay(
                            Circle()
                                .stroke(
                                    colorScheme == .dark ? Color.white.opacity(0.18) : Color.black.opacity(0.13),
                                    lineWidth: 1.2
                                )
                        )

                    Image(systemName: blocker.isBlocking ? "lock.fill" : "lock.open")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)
                        .foregroundColor(blocker.isBlocking ? .red : .green)
                        .offset(y: -2)
                        .scaleEffect(isPressed ? 0.93 : 1.0)
                        .animation(.easeOut(duration: 0.1), value: isPressed)
                }
            }
            .buttonStyle(.plain)
            .onLongPressGesture(minimumDuration: 0.01, pressing: { pressing in
                withAnimation { isPressed = pressing }
            }, perform: {})

            Spacer(minLength: 18)

            Button {
                NSApp.terminate(nil)
            } label: {
                Label("Quit", systemImage: "power")
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .frame(width: 108)
            .padding(.bottom, 12)
        }
        .frame(width: 220, height: 186)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(radius: 16)
        .animation(.easeInOut(duration: 0.2), value: blocker.isBlocking)
    }

    func authenticateWithSystem() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Verify your identity to unlock the keyboard.") { success, _ in
                DispatchQueue.main.async {
                    blocker.isBlocking = !success
                }
            }
        } else {
            print("Authentication not available: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
}
