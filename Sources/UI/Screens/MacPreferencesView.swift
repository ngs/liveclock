import SwiftUI
import LiveClockCore

#if os(macOS)
public struct MacPreferencesView: View {
    @EnvironmentObject var app: AppState

    public init() {}

    public var body: some View {
        Form {
            Picker(String(localized: "Theme", bundle: .module), selection: $app.preferences.appearanceModeRaw) {
                ForEach(AppearanceMode.allCases) { mode in
                    Text(mode.rawValue.capitalized).tag(mode.rawValue)
                }
            }
            .pickerStyle(.palette)

            Divider().padding([.top, .bottom], 10)

            Toggle(String(localized: "Use Custom Text Color", bundle: .module), isOn: $app.preferences.useCustomTextColor)

            ColorPicker(String(localized: "Text Color", bundle: .module), selection: Binding(
                get: { app.preferences.textColor },
                set: { app.preferences.setTextColor($0) }
            )).disabled(!app.preferences.useCustomTextColor)

            Divider().padding([.top, .bottom], 10)

            Toggle(String(localized: "Keep Awake", bundle: .module), isOn: $app.preferences.keepAwake)
            Toggle(String(localized: "Sounds", bundle: .module), isOn: $app.preferences.enableSounds)

            Spacer()
        }
        .padding(.top, 40)
        .padding([.leading, .trailing], 20)
        .frame(width: 300, height: 240)
    }
}

#Preview {
    MacPreferencesView()
        .environmentObject(AppState())
}
#endif
