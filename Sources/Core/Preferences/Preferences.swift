import SwiftUI
#if os(iOS) || os(tvOS) || os(visionOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public enum AppearanceMode: String, CaseIterable, Identifiable {
    case system
    case light
    case dark
    public var id: String { rawValue }

    public var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

public final class Preferences: ObservableObject {
    @AppStorage("appearanceMode") public var appearanceModeRaw: String = AppearanceMode.system.rawValue
    @AppStorage("useCustomTextColor") public var useCustomTextColor: Bool = false
    @AppStorage("customTextColorR") public var textR: Double = 1.0
    @AppStorage("customTextColorG") public var textG: Double = 1.0
    @AppStorage("customTextColorB") public var textB: Double = 1.0
    @AppStorage("customTextColorA") public var textA: Double = 1.0
    @AppStorage("keepAwake") public var keepAwake: Bool = true
    @AppStorage("enableHaptics") public var enableHaptics: Bool = true
    @AppStorage("enableSounds") public var enableSounds: Bool = true

    public var appearanceMode: AppearanceMode {
        get { AppearanceMode(rawValue: appearanceModeRaw) ?? .system }
        set { appearanceModeRaw = newValue.rawValue }
    }

    public var colorScheme: ColorScheme? { appearanceMode.colorScheme }

    public var textColor: Color {
        if useCustomTextColor {
            return Color(red: textR, green: textG, blue: textB, opacity: textA)
        } else {
            return .primary
        }
    }

    public func setTextColor(_ color: Color) {
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
        useCustomTextColor = true
    }
}

public final class AppState: ObservableObject {
    @Published public var stopwatch = Stopwatch()
    @Published public var preferences = Preferences()
    @Published public var now = Date()
    @Published public var showExporter = false
    @Published public var showSettings = false

    public init() {}

    public func applyKeepAwake() {
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
