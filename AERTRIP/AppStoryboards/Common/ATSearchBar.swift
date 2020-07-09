//
//  ATSearchBar.swift
//  AERTRIP
//
//  Created by Admin on 03/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Speech

protocol ATSearchBarDelegate: UISearchBarDelegate {
//extension UISearchBarDelegate {

    func searchBarDidTappedMicButton(_ searchBar: ATSearchBar) //{} // called when mic button tapped
}

class ATSearchBar: UISearchBar {
    
    enum SpeechStatus {
        case ready
        case recognizing
        case unavailable
    }
    
    //private(set) var micButton: UIButton!
    
    var isMicEnabled: Bool = true {
        didSet {
            self.hideMiceButton(isHidden: !self.isMicEnabled)
        }
    }
    private var status = SpeechStatus.ready
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    private let request = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask: SFSpeechRecognitionTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialSetup()
    }
    
    deinit {
        printDebug("ATSearchBar deinit")
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidEndEditingNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidBeginEditingNotification, object: nil)

    }
    

    var mDelegate: ATSearchBarDelegate? {
        didSet {
            self.delegate = self.mDelegate
        }
    }
    
    var edgeInset: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0) {
        didSet {
            self.layoutSubviews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
      //  let xRatio = (self.width - (edgeInset.left + edgeInset.right)) / self.width
       // let yRatio = (self.width - (edgeInset.top + edgeInset.bottom)) / self.width
        //self.transform = CGAffineTransform(scaleX: xRatio, y: yRatio)
        
//        var micX = (self.width - (self.height + 6.0))
//
//        if self.showsCancelButton {
//            micX -= 58.0
//        }
//        self.micButton?.frame = CGRect(x: micX, y: 1.0, width: self.height, height: self.height)
    }
    
    private func initialSetup() {
        self.backgroundImage = UIImage()
        
        if let textField = self.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = AppColors.themeGray04
            textField.font = AppFonts.Regular.withSize(18.0)
            textField.tintColor = AppColors.themeGreen
        }
        
        self.tintColor = AppColors.themeGreen
        
//        self.micButton = UIButton(frame: CGRect(x: (self.width - self.height) + 15.0, y: 1.0, width: self.height, height: self.height))
//        self.micButton.setImage(#imageLiteral(resourceName: "ic_search_mic"), for: .normal)
//       self.micButton.setImage(#imageLiteral(resourceName: "ic_search_mic"), for: .selected)
//        self.micButton.setTitle(nil, for: .normal)
//        self.micButton.addTarget(self, action: #selector(micButtonAction(_:)), for: .touchUpInside)

        self.hideMiceButton(isHidden: self.isMicEnabled)
        //self.addSubview(self.micButton)
        
        //self.setImage(#imageLiteral(resourceName: "icClear"), for: .clear, state: .normal)
        //self.showsBookmarkButton = !self.isMicEnabled
        self.setImage(#imageLiteral(resourceName: "searchBarIcon"), for: .search, state: .normal)

        self.setImage(#imageLiteral(resourceName: "ic_search_mic"), for: .bookmark, state: .normal)
        self.setPositionAdjustment(UIOffset(horizontal: +9, vertical: 0), for: .bookmark)
        self.setPositionAdjustment(UIOffset(horizontal: +3, vertical: 0), for: .search)

        self.searchTextPositionAdjustment = UIOffset(horizontal: 2, vertical: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing), name: UITextField.textDidEndEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing), name: UITextField.textDidBeginEditingNotification, object: nil)

        self.layoutIfNeeded()
        
    }
    
    
    
    func hideMiceButton(isHidden: Bool) {
//        self.micButton.isHidden = isHidden
//        self.bringSubviewToFront(self.micButton)
        self.showsBookmarkButton = isHidden
//        if (self.micButton != nil) {
//        switch SFSpeechRecognizer.authorizationStatus() {
//        case .notDetermined:
//            askSpeechPermission()
//        case .authorized:
//            self.status = .ready
//        case .denied, .restricted:
//            self.status = .unavailable
//        @unknown default: break
//            }
//        }
    }
    
    @objc private func micButtonAction(_ sender: UIButton) {
        self.mDelegate?.searchBarDidTappedMicButton(self)
//        switch status {
//        case .ready:
//            startRecording()
//            status = .recognizing
//        case .recognizing:
//            cancelRecording()
//            status = .ready
//        default:
//            break
//        }
    }
    
    @objc private func textDidEndEditing() {
        if !(self.text ?? "").isEmpty {
            self.hideMiceButton(isHidden: false)
        } else {
            self.hideMiceButton(isHidden: true)
        }
        (self.value(forKey: "cancelButton") as? UIButton)?.isEnabled = true
    }
    
    @objc private func textDidChange() {
        if self.isMicEnabled, (self.text ?? "").isEmpty {
            self.hideMiceButton(isHidden: false)
        }
        else {
            self.hideMiceButton(isHidden: true)
        }
    }
}

extension ATSearchBar {
    /// Ask permission to the user to access their speech data.
    private func askSpeechPermission() {
        SFSpeechRecognizer.requestAuthorization { status in
            OperationQueue.main.addOperation {
                switch status {
                case .authorized:
                    self.status = .ready
                default:
                    self.status = .unavailable
                }
            }
        }
    }
    
    /// Start streaming the microphone data to the speech recognizer to recognize it live.
    private func startRecording() {
        // Setup audio engine and speech recognizer
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }

        // Prepare and start recording
        audioEngine.prepare()
        do {
            try audioEngine.start()
            self.status = .recognizing
        } catch {
            return printDebug(error)
        }

        // Analyze the speech
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { [weak self] (result, error) in
            guard let strongSelf = self else {return}
            if let result = result {
                printDebug(result.bestTranscription.formattedString)
            } else if let error = error {
                printDebug(error)
            }
            strongSelf.cancelRecording()
        })
    }

    /// Stops and cancels the speech recognition.
    private func cancelRecording() {
        audioEngine.stop()
        let node = audioEngine.inputNode
            node.removeTap(onBus: 0)
        recognitionTask?.cancel()
    }
}
