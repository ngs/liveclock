import SwiftUI
import LiveClockCore

public struct CountdownView: View {
    @StateObject private var timer = CountdownTimer()
    @State private var showingDurationPicker = false
    @State private var selectedMinutes = 1
    @State private var selectedSeconds = 0
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 20) {
            Text(TimeFormatter.format(timer.remaining))
                .font(.system(size: 72, weight: .thin, design: .monospaced))
                .minimumScaleFactor(0.3)
                .accessibilityLabel(String(localized: "Time remaining", bundle: .module))
                .accessibilityValue(voiceOverTime(timer.remaining))
            
            HStack(spacing: 16) {
                switch timer.state {
                case .idle:
                    Button(String(localized: "Set Duration", bundle: .module)) {
                        showingDurationPicker = true
                    }
                    .buttonStyle(.bordered)
                    
                    Button(String(localized: "Start", bundle: .module)) {
                        timer.start()
                    }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.space)
                    
                case .running:
                    Button(String(localized: "Pause", bundle: .module)) {
                        timer.pause()
                    }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.space)
                    
                case .paused:
                    Button(String(localized: "Reset", bundle: .module), role: .destructive) {
                        timer.reset()
                    }
                    .buttonStyle(.bordered)
                    .keyboardShortcut("r")
                    
                    Button(String(localized: "Resume", bundle: .module)) {
                        timer.start()
                    }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.space)
                    
                case .finished:
                    Text("Time's Up!", bundle: .module)
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    
                    Button(String(localized: "Reset", bundle: .module)) {
                        timer.reset()
                    }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.space)
                }
            }
        }
        .sheet(isPresented: $showingDurationPicker) {
            NavigationView {
                VStack {
                    HStack {
                        Picker(String(localized: "Minutes", bundle: .module), selection: $selectedMinutes) {
                            ForEach(0..<60) { minute in
                                Text("\(minute) min", bundle: .module).tag(minute)
                            }
                        }
                        #if os(iOS)
                        .pickerStyle(.wheel)
                        #endif
                        
                        Picker(String(localized: "Seconds", bundle: .module), selection: $selectedSeconds) {
                            ForEach(0..<60) { second in
                                Text("\(second) sec", bundle: .module).tag(second)
                            }
                        }
                        #if os(iOS)
                        .pickerStyle(.wheel)
                        #endif
                    }
                    .padding()
                }
                .navigationTitle(String(localized: "Set Duration", bundle: .module))
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(String(localized: "Cancel", bundle: .module)) {
                            showingDurationPicker = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(String(localized: "Done", bundle: .module)) {
                            let duration = TimeInterval(selectedMinutes * 60 + selectedSeconds)
                            timer.setDuration(duration)
                            showingDurationPicker = false
                        }
                    }
                }
            }
        }
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            timer.tick()
        }
    }
    
    private func voiceOverTime(_ time: TimeInterval) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        var components: [String] = []
        if minutes > 0 {
            components.append("\(minutes) \(minutes == 1 ? "minute" : "minutes")")
        }
        if seconds > 0 || components.isEmpty {
            components.append("\(seconds) \(seconds == 1 ? "second" : "seconds")")
        }
        
        return components.joined(separator: ", ")
    }
}

#Preview {
    CountdownView()
        .padding()
}