import SwiftUI
#if os(iOS) || os(tvOS) || os(visionOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

enum AppearanceMode: String, CaseIterable, Identifiable {
    case system
    case light
    case dark
    var id: String { rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

final class Preferences: ObservableObject {
    @AppStorage("appearanceMode") var appearanceModeRaw: String = AppearanceMode.system.rawValue
    @AppStorage("customTextColorR") var textR: Double = 1.0
    @AppStorage("customTextColorG") var textG: Double = 1.0
    @AppStorage("customTextColorB") var textB: Double = 1.0
    @AppStorage("customTextColorA") var textA: Double = 1.0

    @AppStorage("layoutMode") var layoutModeRaw: String = LayoutMode.single.rawValue
    @AppStorage("followDeviceRotation") var followDeviceRotation: Bool = true
    @AppStorage("fixedLayoutOrientation") var fixedLayoutOrientationRaw: String = FixedLayoutOrientation.portrait.rawValue
    @AppStorage("keepAwake") var keepAwake: Bool = true

    var appearanceMode: AppearanceMode {
        get { AppearanceMode(rawValue: appearanceModeRaw) ?? .system }
        set { appearanceModeRaw = newValue.rawValue }
    }

    var colorScheme: ColorScheme? { appearanceMode.colorScheme }

    var textColor: Color {
        Color(red: textR, green: textG, blue: textB, opacity: textA)
    }

    func setTextColor(_ color: Color) {
        #if os(macOS)
        if let cg = color.cgColor, let ns = NSColor(cgColor: cg) {
            textR = Double(ns.redComponent)
            textG = Double(ns.greenComponent)
            textB = Double(ns.blueComponent)
            textA = Double(ns.alphaComponent)
        }
        #else
        var r: CGFloat = 1, g: CGFloat = 1, b: CGFloat = 1, a: CGFloat = 1
        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)
        textR = Double(r); textG = Double(g); textB = Double(b); textA = Double(a)
        #endif
    }
}

enum LayoutMode: String, CaseIterable, Identifiable { case single, double; var id: String { rawValue } }
enum FixedLayoutOrientation: String, CaseIterable, Identifiable { case portrait, landscape; var id: String { rawValue } }

final class AppState: ObservableObject {
    @Published var stopwatch = Stopwatch()
    @Published var preferences = Preferences()

    func applyKeepAwake() {
        #if os(iOS) || os(tvOS) || os(visionOS)
        UIApplication.shared.isIdleTimerDisabled = preferences.keepAwake
        #elseif os(macOS)
        if preferences.keepAwake {
            if activity == nil {
                activity = ProcessInfo.processInfo.beginActivity(options: [.idleSystemSleepDisabled], reason: "Live timing")
            }
        } else {
            if let a = activity { ProcessInfo.processInfo.endActivity(a); activity = nil }
        }
        #endif
    }

    #if os(macOS)
    private var activity: NSObjectProtocol?
    #endif
}
