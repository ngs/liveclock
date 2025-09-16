import SwiftUI
import LiveClockCore
import LiveClockPlatform

struct ControlsView: View {
    @EnvironmentObject var app: AppState
    var showsLapButton: Bool = true

    var body: some View {
        HStack(spacing: 16) {
            switch app.stopwatchState {
            case .idle:
                Button(String(localized: "Start", bundle: .module), action: {
                    app.stopwatch.start()
                    if app.preferences.enableHaptics || app.preferences.enableSounds {
                        FeedbackManager.shared.playStartFeedback()
                    }
                })
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .keyboardShortcut(.space)
                    .accessibilityHint(String(localized: "Start the stopwatch", bundle: .module))
            case .running:
                if showsLapButton {
                    Button(String(localized: "Lap", bundle: .module), action: {
                        app.stopwatch.lap()
                        if app.preferences.enableHaptics || app.preferences.enableSounds {
                            FeedbackManager.shared.playLapFeedback()
                        }
                    })
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .keyboardShortcut("l")
                        .accessibilityHint(String(localized: "Record a lap time", bundle: .module))
                }
                Button(String(localized: "Stop", bundle: .module), action: {
                    app.stopwatch.pause()
                    if app.preferences.enableHaptics || app.preferences.enableSounds {
                        FeedbackManager.shared.playStopFeedback()
                    }
                })
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .keyboardShortcut(.space)
                    .accessibilityHint(String(localized: "Pause the stopwatch", bundle: .module))
            case .paused:
                Button(String(localized: "Reset", bundle: .module), role: .destructive, action: {
                    app.stopwatch.reset()
                    if app.preferences.enableHaptics || app.preferences.enableSounds {
                        FeedbackManager.shared.playResetFeedback()
                    }
                })
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .keyboardShortcut("r")
                    .accessibilityHint(String(localized: "Reset the stopwatch to zero", bundle: .module))
                Button(String(localized: "Resume", bundle: .module), action: {
                    app.stopwatch.start()
                    if app.preferences.enableHaptics || app.preferences.enableSounds {
                        FeedbackManager.shared.playStartFeedback()
                    }
                })
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .keyboardShortcut(.space)
                    .accessibilityHint(String(localized: "Resume the stopwatch", bundle: .module))
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
