//
//  SpeechSynthesizer.swift
//  AERTRIP
//
//  Created by Rishabh on 29/10/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
import AVFoundation

class SpeechSynthesizer: NSObject, AVSpeechSynthesizerDelegate {

    private let speechSynthesizer = AVSpeechSynthesizer()
    
    var onSpeechFinish: (() -> ())?
    
    func synthesizeToSpeech(_ text: String) {
        speechSynthesizer.delegate = self
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.soloAmbient)
            try audioSession.setMode(AVAudioSession.Mode.default)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-compact")
        speechSynthesizer.speak(speechUtterance)
    }
    
    func stopImmediate() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        onSpeechFinish?()
    }
}
