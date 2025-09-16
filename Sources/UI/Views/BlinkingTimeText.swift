import SwiftUI

struct BlinkingTimeText: View {
    let timeString: String
    let colonOpacity: Double
    let dotOpacity: Double
    @Environment(\.font) var font

    init(_ timeString: String, colonOpacity: Double, dotOpacity: Double = 0.8) {
        self.timeString = timeString
        self.colonOpacity = colonOpacity
        self.dotOpacity = dotOpacity
    }

    var body: some View {
        let chars = Array(timeString)
        let dotPos = chars.firstIndex(of: ".")
        
        return HStack(spacing: 0) {
            ForEach(0..<chars.count, id: \.self) { index in
                let ch = chars[index]
                if ch == ":" {
                    Text(":")
                        .fontWeight(.light)
                        .opacity(colonOpacity)
                } else if ch == "." {
                    Text(".")
                        .fontWeight(.light)
                        .opacity(dotOpacity)
                } else if let dp = dotPos, index > dp {
                    // Milliseconds after dot
                    Text(String(ch))
                        .fontWeight(.light)
                        .opacity(dotOpacity)
                } else {
                    // Hours, minutes, seconds remain with original weight
                    Text(String(ch))
                }
            }
        }
    }
}

#Preview("Blinking Time - Running") {
    BlinkingTimeText("12:34:56.789", colonOpacity: 0.5, dotOpacity: 0.5)
        .font(.system(size: 48, weight: .semibold, design: .monospaced))
        .padding()
}

#Preview("Blinking Time - Static") {
    BlinkingTimeText("00:00:00.000", colonOpacity: 0.8, dotOpacity: 0.8)
        .font(.system(size: 48, weight: .semibold, design: .monospaced))
        .padding()
}
