import SwiftUI
import LiveClockCore
import LiveClockPlatform

struct ControlsView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        let buttonWidth: CGFloat = 110

        return HStack(spacing: 16) {
            if app.stopwatchState == .paused {
                Button(role: .destructive, action: {
                    app.stopwatch.reset()
                    FeedbackManager.shared.playResetFeedback()
                }, label: {
                    Text(String(localized: "Reset", bundle: .module))
                        .frame(width: buttonWidth)
                })
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .keyboardShortcut("r")
                    .accessibilityHint(String(localized: "Reset the stopwatch to zero", bundle: .module))
                Button(action: {
                    app.stopwatch.start()
                    FeedbackManager.shared.playStartFeedback()
                }, label: {
                    Text(String(localized: "Resume", bundle: .module))
                        .frame(width: buttonWidth)
                })
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .keyboardShortcut(.space)
                    .accessibilityHint(String(localized: "Resume the stopwatch", bundle: .module))
            } else {
                Button(action: {
                    app.stopwatch.lap()
                    FeedbackManager.shared.playLapFeedback()
                }, label: {
                    Text(String(localized: "Lap", bundle: .module))
                        .frame(width: buttonWidth)
                })
                    .buttonStyle(.bordered)
                    .disabled(app.stopwatchState == .idle)
                    .controlSize(.large)
                    .keyboardShortcut("l")
                    .accessibilityHint(String(localized: "Record a lap time", bundle: .module))
                if app.stopwatchState == .running {
                    Button(role: .destructive, action: {
                        app.stopwatch.pause()
                        FeedbackManager.shared.playStopFeedback()
                    }, label: {
                        Text(String(localized: "Stop", bundle: .module))
                            .frame(width: buttonWidth)
                    })
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .keyboardShortcut(.space)
                    .accessibilityHint(String(localized: "Pause the stopwatch", bundle: .module))
                } else {
                    Button(action: {
                        app.stopwatch.start()
                        FeedbackManager.shared.playStartFeedback()
                    }, label: {
                        Text(String(localized: "Start", bundle: .module))
                            .frame(width: buttonWidth)
                    })
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .keyboardShortcut(.space)
                        .accessibilityHint(String(localized: "Start the stopwatch", bundle: .module))
                }
            }
        }
    }
}

private extension AppState {
    var stopwatchState: StopwatchState { stopwatch.state }
}

#Preview("Idle State") {
    ControlsView()
        .environmentObject(AppState())
        .padding()
}

#Preview("Running State") {
    let appState = AppState()
    appState.stopwatch.start()
    return ControlsView()
        .environmentObject(appState)
        .padding()
}

#Preview("Paused State") {
    let appState = AppState()
    appState.stopwatch.start()
    appState.stopwatch.pause()
    return ControlsView()
        .environmentObject(appState)
        .padding()
}
