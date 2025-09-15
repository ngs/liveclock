import SwiftUI
import LiveClockCore

struct ControlsView: View {
    @EnvironmentObject var app: AppState
    var showsLapButton: Bool = true

    var body: some View {
        HStack(spacing: 16) {
            switch app.stopwatchState {
            case .idle:
                Button("Start", action: app.stopwatch.start)
                    .buttonStyle(.borderedProminent)
            case .running:
                if showsLapButton {
                    Button("Lap", action: app.stopwatch.lap)
                        .buttonStyle(.bordered)
                }
                Button("Stop", action: app.stopwatch.pause)
                    .buttonStyle(.borderedProminent)
            case .paused:
                Button("Reset", role: .destructive, action: app.stopwatch.reset)
                    .buttonStyle(.bordered)
                Button("Resume", action: app.stopwatch.start)
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}

private extension AppState {
    var stopwatchState: StopwatchState { stopwatch.state }
}
