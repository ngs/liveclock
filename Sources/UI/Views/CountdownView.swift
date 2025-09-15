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
                .accessibilityLabel("Time remaining")
                .accessibilityValue(voiceOverTime(timer.remaining))
            
            HStack(spacing: 16) {
                switch timer.state {
                case .idle:
                    Button("Set Duration") {
                        showingDurationPicker = true
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Start") {
                        timer.start()
                    }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.space)
                    
                case .running:
                    Button("Pause") {
                        timer.pause()
                    }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.space)
                    
                case .paused:
                    Button("Reset", role: .destructive) {
                        timer.reset()
                    }
                    .buttonStyle(.bordered)
                    .keyboardShortcut("r")
                    
                    Button("Resume") {
                        timer.start()
                    }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.space)
                    
                case .finished:
                    Text("Time's Up!")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    
                    Button("Reset") {
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
                        Picker("Minutes", selection: $selectedMinutes) {
                            ForEach(0..<60) { minute in
                                Text("\(minute) min").tag(minute)
                            }
                        }
                        #if os(iOS)
                        .pickerStyle(.wheel)
                        #endif
                        
                        Picker("Seconds", selection: $selectedSeconds) {
                            ForEach(0..<60) { second in
                                Text("\(second) sec").tag(second)
                            }
                        }
                        #if os(iOS)
                        .pickerStyle(.wheel)
                        #endif
                    }
                    .padding()
                }
                .navigationTitle("Set Duration")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showingDurationPicker = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
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