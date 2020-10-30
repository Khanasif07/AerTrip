//
//  AerinCustomPopoverVC+SpeechRecognizer.swift
//  AERTRIP
//
//  Created by Rishabh on 27/10/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension AerinCustomPopoverVC: SpeechRecognizerDelegate {
    
    func recordedText(_ text: String) {
        setupListeningLblForSpeechText()
        listeningLbl.text = text
    }
    
    func recordButtonState(_ toEnable: Bool) {
        guard let msg = listeningLbl.text else { return }
        giveSuccessHapticFeedback()
        if msg == LocalizedString.Listening.localized + "..." {
            if self.setupForView != .communicationControls {
                self.setupForView = .communicationControls
                self.listeningLblBackView.isHidden = true
            }
            return
        }
        if self.chatVm.messages.isEmpty {
            hideWelcomeView()
            toggleSuggestions(true, animated: true)
        }
        self.animationLabel.text = msg
        self.chatVm.messages.append(MessageModel(msg: msg, source: MessageModel.MessageSource.me))
        self.chatTableView.reloadData()
        if aerinImgView.alpha != 1.0 {
            showTopAerinImgView()
        }
        self.resetFrames()
        scrollTableViewToLast()
        self.hideShowSenderCellContent(ishidden: true)
        self.chatVm.msgToBeSent = msg
        self.chatVm.lastMessageSentType = .voice
        delay(seconds: 0.27) {
            self.animateCellForSpeechRecognizer(text : msg)
            self.setupForView = .communicationControls
            self.listeningLblBackView.isHidden = true
        }
    }
    
    private func animateCellForSpeechRecognizer(text: String) {
        
        let rectOfLastCell = self.chatTableView.rectForRow(at: IndexPath(row: self.chatVm.getMylastMessageIndex(), section: 0))
        let rectWrtView = self.chatTableView.convert(rectOfLastCell, to: self.view)
        self.showAnimationViewWith(text: text)
        let listeningLblFrame = listeningLblBackView.convert(listeningLbl.frame, to: view)
        print("frame ---- \(listeningLblFrame)")
        self.animationView.frame = CGRect(x: 0, y: listeningLblFrame.origin.y - 10, width: self.view.frame.width, height: self.animationLabel.frame.height + 28)
        let horizintalScale = self.animationBubbleImageView.frame.origin.x - listeningLblFrame.origin.x
        self.animationLabel.transform = CGAffineTransform(translationX: -horizintalScale, y: 0)
        self.animationBubbleImageView.transform = CGAffineTransform(translationX: -horizintalScale, y: 0)
        self.sendBtn.isEnabled = false
        self.micBtn.isEnabled = false
        self.messageTextView.text = ""
        self.resetFrames()
        let animationOptions: UIView.AnimationOptions = .curveEaseOut
        let keyframeAnimationOptions: UIView.KeyframeAnimationOptions = UIView.KeyframeAnimationOptions(rawValue: animationOptions.rawValue)
        
        UIView.animateKeyframes(withDuration: 1.2, delay: 0.0, options: keyframeAnimationOptions, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1) {
                self.animationBubbleImageView.transform = CGAffineTransform.identity
                self.animationLabel.transform = CGAffineTransform.identity
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.28) {
                self.animationView.frame.origin.y = rectWrtView.origin.y
            }
            printDebug("animation..\(Date().timeIntervalSince1970)")
      
            delay(seconds: 0.35) {
                self.hideShowSenderCellContent(ishidden: false)
                self.hideAnimationView()
                self.chatVm.messages[self.chatVm.getMylastMessageIndex()].isHidden = false
                self.scheduleTypingCell()
            }
           
        
        }) { (success) in
            printDebug("animation..success\(Date().timeIntervalSince1970)")
        }
    }
}

// Feedback
extension AerinCustomPopoverVC {
    func giveSuccessHapticFeedback() {
        //*******************Haptic Feedback code********************
        printDebug("Generate feedback")
        let selectionFeedbackGenerator = UINotificationFeedbackGenerator()
        selectionFeedbackGenerator.notificationOccurred(.success)
        //*******************Haptic Feedback code********************
    }
}
