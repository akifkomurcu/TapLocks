import SwiftUI

struct WelcomeStep {
    let icon: String
    let title: String
    let description: String
}

let welcomeSteps = [
    WelcomeStep(icon: "lock.fill", title: "Keyboard Lock", description: "TapLocks temporarily locks your keyboard input with one click."),
    WelcomeStep(icon: "menubar.rectangle", title: "Menu Bar", description: "Click the TapLocks icon in your menu bar to quickly lock or unlock."),
    WelcomeStep(icon: "cursorarrow.click", title: "Unlock Easily", description: "While locked, just click anywhere to unlock your screen."),
    WelcomeStep(icon: "touchid", title: "Extra Security", description: "You can use Touch ID or your password to unlock if enabled.")
]

struct WelcomeOverlay: View {
    var onDismiss: () -> Void
    @State private var step = 0

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: welcomeSteps[step].icon)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.accentColor)
                .padding(.top, 32)
            
            Text(welcomeSteps[step].title)
                .font(.title.bold())
                .multilineTextAlignment(.center)
            
            Text(welcomeSteps[step].description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)
            
            Spacer()
            
            HStack {
                if step > 0 {
                    Button("Back") {
                        withAnimation {
                            step = max(0, step - 1)
                        }
                    }
                }
                Spacer()
                if step < welcomeSteps.count - 1 {
                    Button("Next") {
                        withAnimation {
                            step = min(welcomeSteps.count - 1, step + 1)
                        }
                    }
                    .keyboardShortcut(.defaultAction)
                } else {
                    Button("Finish") {
                        onDismiss()
                    }
                    .keyboardShortcut(.defaultAction)
                }
            }
            .font(.headline)
            .padding(.horizontal, 28)
            .padding(.bottom, 28)
        }
        .frame(width: 400, height: 400)
        .background(.thinMaterial)
        .cornerRadius(32)
        .shadow(radius: 36)
        .padding()
        .transition(.scale.combined(with: .opacity))
        .zIndex(10)
    }
}
