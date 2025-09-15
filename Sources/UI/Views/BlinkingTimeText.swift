import SwiftUI

struct BlinkingTimeText: View {
    let timeString: String
    let colonOpacity: Double
    let dotOpacity: Double

    init(_ timeString: String, colonOpacity: Double, dotOpacity: Double = 0.8) {
        self.timeString = timeString
        self.colonOpacity = colonOpacity
        self.dotOpacity = dotOpacity
    }

    var body: some View {
        let chars = Array(timeString)
        let dotPos = chars.firstIndex(of: ".")
        return HStack(spacing: 0) {
            ForEach(0..<chars.count, id: \.self) { i in
                let ch = chars[i]
                if ch == ":" {
                    Text(":").opacity(colonOpacity)
                } else if ch == "." {
                    Text(".").opacity(dotOpacity)
                } else if let dp = dotPos, i > dp {
                    Text(String(ch)).opacity(dotOpacity)
                } else {
                    Text(String(ch))
                }
            }
        }
    }
}

