//
//  SpeechSynthesizer.swift
//  AERTRIP
//
//  Created by Rishabh on 29/10/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
import AVFoundation

class SpeechSynthesizer {

    let speechSynthesizer = AVSpeechSynthesizer()
    
    func synthesizeToSpeech(_ text: String) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
            try audioSession.setMode(AVAudioSession.Mode.default)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.volume = 1
        speechUtterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-compact")
        speechSynthesizer.speak(speechUtterance)
    }
}
