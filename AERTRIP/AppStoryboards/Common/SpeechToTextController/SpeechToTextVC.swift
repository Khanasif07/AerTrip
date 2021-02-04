//
//  SpeechToTextVC.swift
//  AERTRIP
//
//  Created by Appinventiv  on 20/01/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import UIKit

protocol  SpeechToTextVCDelegate:NSObjectProtocol{
    func getSpeechToText(_ text: String)
}

class SpeechToTextVC: BaseVC {

    // MARK: Outlets
    @IBOutlet weak var popoverView: UIView!
    @IBOutlet weak var popoverViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var aerinImgView: UIImageView!
    
    @IBOutlet weak var alignmentView: UIView!
    @IBOutlet weak var alignmentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var alignmentViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var waveAnimationContainerView: UIView!
    @IBOutlet weak var waveAnimationContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var waveAnimationContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var waveAnimationContentView: UIView!
    @IBOutlet weak var hideWaveBtn: UIButton!
    @IBOutlet weak var listeningLblBackView: UIView!
    @IBOutlet weak var listeningLbl: UILabel!
    
    
    
    // MARK: Variables

    enum SetupForViewType {
        case waveAnimation
        case communicationControls
    }
    var typingCellTimer : Timer?
    // Speech Recognizer
    private let speechRecognizer = SpeechRecognizer()
    // Wave Animation
    var firstWaveView: HeartLoadingView?
    var secondWaveView: HeartLoadingView?
    
    private var waveContainerHeightConstant: CGFloat {
        let waveContainerHeight: CGFloat = 200
        return waveContainerHeight + view.safeAreaInsets.bottom
    }
    
    private var heightOfPopOverView:CGFloat{
        let popOverViewHeight: CGFloat = 290
        return popOverViewHeight + view.safeAreaInsets.bottom
    }
    
    var setupForView: SetupForViewType = .waveAnimation {
        didSet {
            resetViewSetup()
        }
    }
    
    weak var delegate:SpeechToTextVCDelegate?
   

    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popoverView.transform = CGAffineTransform(translationX: 0, y: 270)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setWaveContainerView()
        self.presentAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        speechRecognizer.stop()
    }
    
    deinit {
        printDebug("AERIN POPOVER DEINIT")
    }
    
    private func presentAnimation(){
        let midPoint:CGFloat = view.bounds.height * 0.4
        let minPoint:CGFloat = view.bounds.height
        let maxViewColorAlpha:CGFloat = 0.4
        UIView.animate(withDuration: 0.33) {
            let fractionForAlpha = maxViewColorAlpha - ((midPoint/minPoint) * maxViewColorAlpha)
            self.view.backgroundColor = AppColors.themeBlack.withAlphaComponent(fractionForAlpha)
            self.popoverView.transform = .identity
            self.view.layoutIfNeeded()
        }
    }
    
    
    // MARK: Actions
    @IBAction func dismissBtnAction(_ sender: UIButton) {
        startDismissAnimation()
    }
    


    
    // MARK: Functions
    
    internal override func initialSetup() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
//        messageTextView.delegate = self
        setWaveContainerView()
        speechRecognizer.delegate = self
        setupSubViews()
    }
    
    private func resetViewSetup() {
        switch setupForView {
        case .waveAnimation:
            setupForWaveAnimation()
        case .communicationControls:
            setupForCommControls()
        }
        UIView.animate(withDuration: 0.3) {
            self.popoverView.layoutIfNeeded()
        }
    }
    
    private func setupForWaveAnimation() {
        toggleWaveAnimationsView(false)
    }
    
    private func setupForCommControls() {
        toggleWaveAnimationsView(true)
    }
    
    private func setupForTextViewOpen() {
        toggleWaveAnimationsView(true)
    }
    

    
    private func toggleWaveAnimationsView(_ hidden: Bool) {
        if !hidden {
            waveAnimationContainerView.alpha = 1
            DispatchQueue.delay(0.2) {
                self.speechRecognizer.start()
            }
            resetListeningLbl()
        }
        UIView.animate(withDuration: 0.5, animations: {
            if hidden {
//                if self.waveAnimationContainerView.alpha != 0 {
//                    self.waveAnimationContainerView.transform = CGAffineTransform(translationX: 0, y: self.waveContainerHeightConstant)
//                }
            } else {
                self.waveAnimationContainerView.transform = .identity
            }
            self.popoverView.layoutIfNeeded()
        }) { _ in
            if hidden {

            }
        }
    }
    
    
    private func setupSubViews() {
        setupPopoverView()
//        addPanGesture()
        setUpAttributes()

        addWaveAnimation()
        
        if speechRecognizer.authStatus() == .denied {
            speechRecognizer.requestTranscribePermissions()
        } else {
            setupForView = .waveAnimation
        }
    }
    
    private func setWaveContainerView() {
        waveAnimationContainerView.backgroundColor = .clear
        waveAnimationContainerViewHeight.constant = waveContainerHeightConstant
        alignmentViewHeight.constant = waveContainerHeightConstant
//        waveAnimationContainerViewBottom.constant = 0//view.safeAreaInsets.bottom
        self.view.layoutIfNeeded()
    }
        
    private func setUpAttributes(){
        resetListeningLbl()
        listeningLblBackView.roundCorners()
        alignmentView.backgroundColor = .clear
    }
    
    func resetListeningLbl() {
        listeningLblBackView.isHidden = false
        listeningLbl.textColor = AppColors.themeBlack
        listeningLbl.text = LocalizedString.Listening.localized + "..."
        listeningLbl.font = AppFonts.Regular.withSize(18)
        listeningLblBackView.backgroundColor = .clear
    }
    
    func setupListeningLblForSpeechText() {
        listeningLblBackView.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.3)
    }
    

    
    
    
    private func setupPopoverView() {
        self.popoverViewHeight.constant = self.heightOfPopOverView
        popoverView.roundParticularCorners(10, [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }

    
    func startDismissAnimation(_ animationDuration: TimeInterval = 0.3) {
        UIView.animate(withDuration: animationDuration, animations:  {
            self.popoverView.transform = CGAffineTransform(translationX: 0, y: 270)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
}

extension SpeechToTextVC {
    private func addPanGesture() {
        let dismissGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanViewToDismiss(_:)))
        view.addGestureRecognizer(dismissGesture)
    }
    
    @objc private func didPanViewToDismiss(_ sender: UIPanGestureRecognizer) {

    }
    
    private func transformViewBy(_ yTranslation: CGFloat) {

    }
}

extension SpeechToTextVC {
    
    func addWaveAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.firstWaveView = HeartLoadingView(frame: self.waveAnimationContainerView.bounds)
            self.firstWaveView?.frame.size.height = self.waveContainerHeightConstant
            self.firstWaveView?.heartAmplitude = 50
            self.firstWaveView?.lightHeartColor = AppColors.themeGreen.withAlphaComponent(0.2)
            self.firstWaveView?.heavyHeartColor = AppColors.themeGreen.withAlphaComponent(0.2)
            self.firstWaveView?.isShowProgressText = false
            self.firstWaveView?.animationSpeed = 13
            self.waveAnimationContainerView.addSubview(self.firstWaveView!)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.secondWaveView = HeartLoadingView(frame: self.waveAnimationContainerView.bounds)
            self.secondWaveView?.frame.size.height = self.waveContainerHeightConstant
            self.secondWaveView?.heartAmplitude = 50
            self.secondWaveView?.lightHeartColor = AppColors.themeGreen.withAlphaComponent(0.2)
            self.secondWaveView?.heavyHeartColor = .clear//UIColor(r: 0, g: 105, b: 100, alpha: 0.5)
            self.secondWaveView?.isShowProgressText = false
            self.secondWaveView?.animationSpeed = 9
            self.waveAnimationContainerView.addSubview(self.secondWaveView!)
            self.waveAnimationContainerView.bringSubviewToFront(self.waveAnimationContentView)
        }
    }
    

    
}
extension SpeechToTextVC: SpeechRecognizerDelegate {
    
    func recordedText(_ text: String) {
        setupListeningLblForSpeechText()
        listeningLbl.text = text
    }
    
    func recordButtonState(_ toEnable: Bool) {
        guard let msg = listeningLbl.text else { return }
        giveSuccessHapticFeedback()
//        if msg == LocalizedString.Listening.localized + "..." {
//            if self.setupForView != .communicationControls {
//                self.setupForView = .communicationControls
//                self.listeningLblBackView.isHidden = true
//            }
//            self.animateCellForSpeechRecognizer(text : "")
//            return
//        }
        delay(seconds: 0.27) {
            if msg == LocalizedString.Listening.localized + "..." {
                self.animateCellForSpeechRecognizer(text : "")
            }else{
                self.animateCellForSpeechRecognizer(text : msg)
            }
            self.setupForView = .communicationControls
            self.listeningLblBackView.isHidden = true
        }
    }
    
    private func animateCellForSpeechRecognizer(text: String) {
        self.delegate?.getSpeechToText(text)
        self.startDismissAnimation()
    }
}

// Feedback
extension SpeechToTextVC {
    func giveSuccessHapticFeedback() {
        //*******************Haptic Feedback code********************
        printDebug("Generate feedback")
        let selectionFeedbackGenerator = UINotificationFeedbackGenerator()
        selectionFeedbackGenerator.notificationOccurred(.success)
        //*******************Haptic Feedback code********************
    }
}
