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
        // Create light weight version of the current font for punctuation and milliseconds
        let lightFont = Font.system(.body, design: .monospaced, weight: .light)
        
        return HStack(spacing: 0) {
            ForEach(0..<chars.count, id: \.self) { i in
                let ch = chars[i]
                if ch == ":" {
                    Text(":")
                        .fontWeight(.light)
                        .opacity(colonOpacity)
                } else if ch == "." {
                    Text(".")
                        .fontWeight(.light)
                        .opacity(dotOpacity)
                } else if let dp = dotPos, i > dp {
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

