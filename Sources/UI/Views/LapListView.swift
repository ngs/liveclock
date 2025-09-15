import SwiftUI
import LiveClockCore

struct LapListView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        VStack(spacing: 0) {
            LapStatisticsView(laps: app.stopwatch.laps)
            
            if app.stopwatch.laps.count > 100 {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(app.stopwatch.laps) { lap in
                                LapRowView(lap: lap)
                                    .id(lap.id)
                            }
                        }
                    }
                    .onChange(of: app.stopwatch.laps.count) { _ in
                        if let firstLap = app.stopwatch.laps.first {
                            withAnimation {
                                proxy.scrollTo(firstLap.id, anchor: .top)
                            }
                        }
                    }
                }
            } else {
                List(app.stopwatch.laps) { lap in
                    LapRowView(lap: lap)
                }
                .listStyle(.plain)
            }
        }
    }
}

struct LapRowView: View {
    let lap: Lap
    
    var body: some View {
        HStack {
            Text("#\(lap.index)")
                .foregroundStyle(.secondary)
                .frame(width: 44, alignment: .trailing)
            Text(TimeFormatter.hmsms(lap.deltaFromPrev))
                .font(.system(.body, design: .monospaced))
            Spacer()
            Text(TimeFormatter.timeOfDay(lap.capturedDate))
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

#Preview("With Laps") {
    let appState = AppState()
    appState.stopwatch.start()
    Thread.sleep(forTimeInterval: 0.1)
    appState.stopwatch.lap()
    Thread.sleep(forTimeInterval: 0.15)
    appState.stopwatch.lap()
    Thread.sleep(forTimeInterval: 0.2)
    appState.stopwatch.lap()
    
    return LapListView()
        .environmentObject(appState)
        .frame(height: 400)
}

#Preview("Empty") {
    LapListView()
        .environmentObject(AppState())
        .frame(height: 400)
}
