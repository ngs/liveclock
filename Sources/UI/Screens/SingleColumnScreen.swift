import SwiftUI
import LiveClockCore

struct SingleColumnScreen: View {
    @EnvironmentObject var app: AppState
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                ClockView()
                StopwatchDigitsView()
                ControlsView()
                Divider()
                LapListView()
            }
            .padding()
#if os(iOS)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        app.showSettings = true
                    } label: {
                        Label(String(localized: "Settings", bundle: .module), systemImage: "gearshape")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    ExportButton()
                }
            }
#endif // os(iOS)
        }
    }
}

#Preview {
    SingleColumnScreen()
        .environmentObject(AppState())
}
