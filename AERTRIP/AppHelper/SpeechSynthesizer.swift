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
    
    static let shared = SpeechSynthesizer()
    private let speechSynthesizer = AVSpeechSynthesizer()

    func synthesizeToSpeech(_ text: String) {
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
    }
}
