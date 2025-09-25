import Foundation
import Logging
import AVFoundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import LiveClockCore

@MainActor
public final class FeedbackManager {
    public static let shared = FeedbackManager()
    private let logger = LiveClockLogger.platform

    #if os(iOS)
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let notificationFeedback = UINotificationFeedbackGenerator()
    #endif

    private var soundPlayers: [String: AVAudioPlayer] = [:]
    private var preferences: Preferences?

    private init() {
        #if os(iOS)
        impactFeedback.prepare()
        notificationFeedback.prepare()
        #endif
        setupAudio()
        loadSounds()
    }

    public func setPreferences(_ prefs: Preferences) {
        self.preferences = prefs
    }

    private func setupAudio() {
        #if os(iOS)
        do {
            // Use .ambient to respect silent mode on iOS
            // This category respects the silent switch - no sound in silent mode
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            logger.error("Failed to set up audio session: \(error)")
        }
        #endif
        // macOS doesn't need audio session setup
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
                    logger.debug("Loaded sound: \(filename)")
                } catch {
                    logger.error("Failed to load sound \(filename): \(error)")
                }
            } else {
                logger.warning("Sound file not found: \(filename).wav")
            }
        }
    }

    private func playSound(_ name: String) {
        guard preferences?.enableSounds ?? true else { return }

        if let player = soundPlayers[name] {
            // AVAudioPlayer with .ambient category respects silent mode on iOS
            player.play()
        }
    }

    public func playStartFeedback() {
        #if os(iOS)
        if preferences?.enableHaptics ?? true {
            impactFeedback.impactOccurred()
        }
        #endif
        playSound("start")
    }

    public func playStopFeedback() {
        #if os(iOS)
        if preferences?.enableHaptics ?? true {
            impactFeedback.impactOccurred()
        }
        #endif
        playSound("stop")
    }

    public func playLapFeedback() {
        #if os(iOS)
        if preferences?.enableHaptics ?? true {
            impactFeedback.impactOccurred(intensity: 0.7)
        }
        #endif
        playSound("lap")
    }

    public func playResetFeedback() {
        #if os(iOS)
        if preferences?.enableHaptics ?? true {
            notificationFeedback.notificationOccurred(.warning)
        }
        #endif
        playSound("reset")
    }
}
