import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var app: AppState

    var body: some View {
        Form {
            Section("Appearance") {
                Picker("Theme", selection: $app.preferences.appearanceModeRaw) {
                    ForEach(AppearanceMode.allCases) { mode in
                        Text(mode.rawValue.capitalized).tag(mode.rawValue)
                    }
                }
                ColorPicker("Text Color", selection: Binding(get: { app.preferences.textColor }, set: { app.preferences.setTextColor($0) }))
            }
            Section("Layout") {
                Picker("Columns", selection: $app.preferences.layoutModeRaw) {
                    ForEach(LayoutMode.allCases) { mode in
                        Text(mode.rawValue.capitalized).tag(mode.rawValue)
                    }
                }
                Toggle("Follow Device Rotation", isOn: $app.preferences.followDeviceRotation)
                Picker("Fixed Orientation", selection: $app.preferences.fixedLayoutOrientationRaw) {
                    ForEach(FixedLayoutOrientation.allCases) { o in
                        Text(o.rawValue.capitalized).tag(o.rawValue)
                    }
                }
            }
            Section("Behavior") {
                Toggle("Keep Awake", isOn: $app.preferences.keepAwake)
            }
        }
        .navigationTitle("Preferences")
    }
}

