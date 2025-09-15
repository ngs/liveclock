import Foundation
#if os(iOS)
import UIKit
import AVFoundation
#elseif os(macOS)
import AppKit
#endif

public final class FeedbackManager {
    public static let shared = FeedbackManager()
    
    #if os(iOS)
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let notificationFeedback = UINotificationFeedbackGenerator()
    private var audioPlayer: AVAudioPlayer?
    #endif
    
    private init() {
        #if os(iOS)
        impactFeedback.prepare()
        notificationFeedback.prepare()
        setupAudio()
        #endif
    }
    
    #if os(iOS)
    private func setupAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    #endif
    
    public func playStartFeedback() {
        #if os(iOS)
        impactFeedback.impactOccurred()
        playSystemSound(1117)
        #elseif os(macOS)
        NSSound.beep()
        #endif
    }
    
    public func playStopFeedback() {
        #if os(iOS)
        impactFeedback.impactOccurred()
        playSystemSound(1118)
        #elseif os(macOS)
        NSSound.beep()
        #endif
    }
    
    public func playLapFeedback() {
        #if os(iOS)
        impactFeedback.impactOccurred(intensity: 0.7)
        playSystemSound(1103)
        #endif
    }
    
    public func playResetFeedback() {
        #if os(iOS)
        notificationFeedback.notificationOccurred(.warning)
        playSystemSound(1102)
        #endif
    }
    
    public func playCountdownFinishedFeedback() {
        #if os(iOS)
        notificationFeedback.notificationOccurred(.success)
        playSystemSound(1336)
        #elseif os(macOS)
        for _ in 0..<3 {
            NSSound.beep()
            Thread.sleep(forTimeInterval: 0.2)
        }
        #endif
    }
    
    #if os(iOS)
    private func playSystemSound(_ soundID: UInt32) {
        AudioServicesPlaySystemSound(soundID)
    }
    #endif
}