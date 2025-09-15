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
                Button("Start", action: {
                    app.stopwatch.start()
                    if app.preferences.enableHaptics || app.preferences.enableSounds {
                        FeedbackManager.shared.playStartFeedback()
                    }
                })
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.space)
                    .accessibilityHint("Start the stopwatch")
            case .running:
                if showsLapButton {
                    Button("Lap", action: {
                        app.stopwatch.lap()
                        if app.preferences.enableHaptics || app.preferences.enableSounds {
                            FeedbackManager.shared.playLapFeedback()
                        }
                    })
                        .buttonStyle(.bordered)
                        .keyboardShortcut("l")
                        .accessibilityHint("Record a lap time")
                }
                Button("Stop", action: {
                    app.stopwatch.pause()
                    if app.preferences.enableHaptics || app.preferences.enableSounds {
                        FeedbackManager.shared.playStopFeedback()
                    }
                })
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.space)
                    .accessibilityHint("Pause the stopwatch")
            case .paused:
                Button("Reset", role: .destructive, action: {
                    app.stopwatch.reset()
                    if app.preferences.enableHaptics || app.preferences.enableSounds {
                        FeedbackManager.shared.playResetFeedback()
                    }
                })
                    .buttonStyle(.bordered)
                    .keyboardShortcut("r")
                    .accessibilityHint("Reset the stopwatch to zero")
                Button("Resume", action: {
                    app.stopwatch.start()
                    if app.preferences.enableHaptics || app.preferences.enableSounds {
                        FeedbackManager.shared.playStartFeedback()
                    }
                })
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.space)
                    .accessibilityHint("Resume the stopwatch")
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
