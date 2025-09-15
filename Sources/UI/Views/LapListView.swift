import SwiftUI
import LiveClockCore

struct LapListView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        List(app.stopwatch.laps) { lap in
            HStack {
                Text("#\(lap.index)")
                    .foregroundStyle(.secondary)
                    .frame(width: 44, alignment: .trailing)
                Text(TimeFormatter.hmsms(lap.deltaFromPrev))
                    .font(.system(.body, design: .monospaced))
                Spacer()
                Text(TimeFormatter.hmsms(lap.atTotal))
                    .font(.system(.body, design: .monospaced))
                    .foregroundStyle(.secondary)
            }
        }
        .listStyle(.plain)
    }
}
