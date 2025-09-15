import SwiftUI
import LiveClockCore

public struct PreferencesView: View {
    @EnvironmentObject var app: AppState

    public init() {}

    public var body: some View {
        Form {
            Section(String(localized: "Appearance", bundle: .module)) {
                Picker(String(localized: "Theme", bundle: .module), selection: $app.preferences.appearanceModeRaw) {
                    ForEach(AppearanceMode.allCases) { mode in
                        Text(mode.rawValue.capitalized).tag(mode.rawValue)
                    }
                }
                Toggle(String(localized: "Use Custom Text Color", bundle: .module), isOn: $app.preferences.useCustomTextColor)
                if app.preferences.useCustomTextColor {
                    ColorPicker(String(localized: "Text Color", bundle: .module), selection: Binding(get: { app.preferences.textColor }, set: { app.preferences.setTextColor($0) }))
                }
            }
            Section(String(localized: "Layout", bundle: .module)) {
                Picker(String(localized: "Columns", bundle: .module), selection: $app.preferences.layoutModeRaw) {
                    ForEach(LayoutMode.allCases) { mode in
                        Text(mode.rawValue.capitalized).tag(mode.rawValue)
                    }
                }
                #if !os(macOS)
                Toggle(String(localized: "Follow Device Rotation", bundle: .module), isOn: $app.preferences.followDeviceRotation)
                Picker(String(localized: "Fixed Orientation", bundle: .module), selection: $app.preferences.fixedLayoutOrientationRaw) {
                    ForEach(FixedLayoutOrientation.allCases) { o in
                        Text(o.rawValue.capitalized).tag(o.rawValue)
                    }
                }
                #endif
            }
            Section(String(localized: "Behavior", bundle: .module)) {
                Toggle(String(localized: "Keep Awake", bundle: .module), isOn: $app.preferences.keepAwake)
            }
        }
        .navigationTitle(String(localized: "Preferences", bundle: .module))
    }
}

#Preview {
    NavigationView {
        PreferencesView()
            .environmentObject(AppState())
    }
}
