import SwiftUI
import LiveClockCore

struct LapListView: View {
    @EnvironmentObject var app: AppState
    
    var fastestLapId: UUID? {
        guard app.stopwatch.laps.count > 1 else { return nil }
        let realLaps = app.stopwatch.laps.filter { $0.index > 0 }
        return realLaps.min(by: { $0.deltaFromPrev < $1.deltaFromPrev })?.id
    }
    
    var slowestLapId: UUID? {
        guard app.stopwatch.laps.count > 1 else { return nil }
        let realLaps = app.stopwatch.laps.filter { $0.index > 0 }
        return realLaps.max(by: { $0.deltaFromPrev < $1.deltaFromPrev })?.id
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .center, spacing: 0) {
                    ForEach(app.stopwatch.laps) { lap in
                        LapRowView(lap: lap, isFastest: lap.id == fastestLapId, isSlowest: lap.id == slowestLapId)
                            .id(lap.id)
                    }
                }.padding(.bottom, 20)
            }
            .onChange(of: app.stopwatch.laps.count) {
                if let firstLap = app.stopwatch.laps.first {
                    withAnimation {
                        proxy.scrollTo(firstLap.id, anchor: .top)
                    }
                }
            }
        }
    }
}

struct LapRowView: View {
    let lap: Lap
    let isFastest: Bool
    let isSlowest: Bool
    
    var body: some View {
        let fgColor = isFastest ? Color.blue : (isSlowest ? Color.orange : Color.primary)
        
        GeometryReader { proxy in
            let sizeL = proxy.size.width > 280.0
            let sizeM = proxy.size.width > 250.0
            let sizeS = proxy.size.width > 200.0
            
            return HStack(spacing: 10) {
                Spacer(minLength: 0)
                if sizeM {
                    HStack {
                        if sizeL {
                            Group {
                                if isFastest {
                                    Image(systemName: "hare.fill")
                                        .foregroundStyle(Color.blue)
                                        .font(.system(size: 14))
                                } else if isSlowest {
                                    Image(systemName: "tortoise.fill")
                                        .foregroundStyle(Color.orange)
                                        .font(.system(size: 14))
                                } else {
                                    Color.clear
                                        .frame(width: 14, height: 14)
                                }
                            }
                            .frame(width: 20, alignment: .trailing)
                        }
                        if lap.index == 0 {
                            Image(systemName: "play.circle")
                                .foregroundStyle(fgColor)
                                .opacity(0.6)
                        } else {
                            Text("#\(lap.index)")
                                .font(.system(.body, design: .monospaced))
                                .lineLimit(1)
                                .foregroundStyle(fgColor)
                                .opacity(0.6)
                        }
                    }
                    .frame(width: sizeL ? 74 : 44, alignment: .trailing)
                }
                
                Text(TimeFormatter.hmsms(lap.deltaFromPrev))
                    .font(.system(.body, design: .monospaced))
                    .lineLimit(1)
                    .foregroundStyle(fgColor)
                
                if sizeS {
                    Text(TimeFormatter.timeOfDay(lap.capturedDate))
                        .font(.system(.body, design: .monospaced))
                        .lineLimit(1)
                        .foregroundStyle(fgColor)
                        .opacity(0.6)
                }
                Spacer(minLength: 0)
            }
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
