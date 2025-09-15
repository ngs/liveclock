import SwiftUI

struct SingleColumnScreen: View {
    var body: some View {
        VStack(spacing: 24) {
            ClockView()
            ControlsView()
        }
        .padding()
    }
}

