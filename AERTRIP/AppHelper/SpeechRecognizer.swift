//
//  SpeechRecognizer.swift
//  TestApp
//
//  Created by Rishabh on 08/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Speech

protocol SpeechRecognizerDelegate: AnyObject {
    func recordedText(_ text: String)
    func recordButtonState(_ toEnable: Bool)
}

class SpeechRecognizer: NSObject {
        
    // MARK: Properties
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-IN"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    weak var delegate: SpeechRecognizerDelegate?
    
//    func toggleSpeechRecognition(_ isActiveForDictation:((Bool) -> ())) {
//        speechRecognizer?.delegate = self
//        if SFSpeechRecognizer.authorizationStatus() != .authorized {
//            requestTranscribePermissions()
//        }
//
//        if audioEngine.isRunning {
//            audioEngine.stop()
//            recognitionRequest?.endAudio()
//            self.delegate?.recordButtonState(false)
//            isActiveForDictation(true)
//        } else {
//            startRecording()
//            isActiveForDictation(false)
//        }
//    }
    
    func start() {
        speechRecognizer?.delegate = self
        if SFSpeechRecognizer.authorizationStatus() != .authorized {
            requestTranscribePermissions()
        }
        if !audioEngine.isRunning {
            startRecording()
        }
    }
    
    func stop() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        }
    }
    
    private func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
                
            default:
                isButtonEnabled = false
                print("default case for speech recognizer")
            }
            
            OperationQueue.main.addOperation() {
                self.delegate?.recordButtonState(isButtonEnabled)
            }
        }
    }
    
    private func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.delegate?.recordedText(result?.bestTranscription.formattedString ?? "")
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.delegate?.recordButtonState(true)
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
//        self.delegate?.recordedText("Say something, I'm listening!")
    }
}

extension SpeechRecognizer: SFSpeechRecognizerDelegate {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        self.delegate?.recordButtonState(available)
    }
}
