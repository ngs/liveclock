import Foundation
#if os(iOS)
import UIKit
import AVFoundation
#elseif os(macOS)
import AppKit
#endif
import LiveClockCore

@MainActor
public final class FeedbackManager {
    public static let shared = FeedbackManager()

    #if os(iOS)
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let notificationFeedback = UINotificationFeedbackGenerator()
    private var soundPlayers: [String: AVAudioPlayer] = [:]
    #endif

    private var preferences: Preferences?

    private init() {
        #if os(iOS)
        impactFeedback.prepare()
        notificationFeedback.prepare()
        setupAudio()
        loadSounds()
        #endif
    }

    public func setPreferences(_ prefs: Preferences) {
        self.preferences = prefs
    }

    #if os(iOS)
    private func setupAudio() {
        do {
            // Use .ambient to respect silent mode
            // This category respects the silent switch - no sound in silent mode
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    private func loadSounds() {
        let soundMappings: [String: String] = [
            "start": "tap_high",
            "stop": "tap_low",
            "lap": "tap_soft",
            "reset": "tap_low"
        ]

        for (key, filename) in soundMappings {
            if let url = Bundle.module.url(forResource: filename, withExtension: "wav") {
                do {
                    let player = try AVAudioPlayer(contentsOf: url)
                    player.prepareToPlay()
                    soundPlayers[key] = player
                } catch {
                    print("Failed to load sound \(filename): \(error)")
                }
            }
        }
    }

    private func playSound(_ name: String) {
        guard preferences?.enableSounds ?? true else { return }

        // Create a new player instance for concurrent playback
        if let player = soundPlayers[name] {
            // AVAudioPlayer with .ambient category respects silent mode
            player.play()
        }
    }
    #endif

    public func playStartFeedback() {
        #if os(iOS)
        if preferences?.enableHaptics ?? true {
            impactFeedback.impactOccurred()
        }
        playSound("start")
        #elseif os(macOS)
        if preferences?.enableSounds ?? true {
            NSSound.beep()
        }
        #endif
    }

    public func playStopFeedback() {
        #if os(iOS)
        if preferences?.enableHaptics ?? true {
            impactFeedback.impactOccurred()
        }
        playSound("stop")
        #elseif os(macOS)
        if preferences?.enableSounds ?? true {
            NSSound.beep()
        }
        #endif
    }

    public func playLapFeedback() {
        #if os(iOS)
        if preferences?.enableHaptics ?? true {
            impactFeedback.impactOccurred(intensity: 0.7)
        }
        playSound("lap")
        #endif
    }

    public func playResetFeedback() {
        #if os(iOS)
        if preferences?.enableHaptics ?? true {
            notificationFeedback.notificationOccurred(.warning)
        }
        playSound("reset")
        #endif
    }
}
