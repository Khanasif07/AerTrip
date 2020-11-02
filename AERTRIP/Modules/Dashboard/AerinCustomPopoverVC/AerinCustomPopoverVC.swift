//
//  AerinCustomPopoverVC.swift
//  AERTRIP
//
//  Created by Rishabh on 22/10/20.
//  Copyright © 2020 Rishabh. All rights reserved.
//

import UIKit
import IQKeyboardManager

class AerinCustomPopoverVC: BaseVC {

    // MARK: Variables
    
    enum StartPoint {
        case center
        case top
    }
    
    enum SetupForViewType {
        case textView
        case textViewOpen
        case waveAnimation
        case communicationControls
    }
    
    enum SendButtonState {
        case send
        case record
    }
    
    var startPoint: StartPoint = .center
    let chatVm = ChatVM()
    var dotsView: AMDots?
    var typingCellTimer : Timer?
    
    // Speech Recognizer
    private let speechRecognizer = SpeechRecognizer()
    
    // Wave Animation
    var firstWaveView: HeartLoadingView?
    var secondWaveView: HeartLoadingView?
    
    private var initialPoint: CGFloat = .zero
    private var midPoint: CGFloat = .zero
    private var maxPoint: CGFloat = .zero
    private var minPoint: CGFloat = .zero
    private let maxViewColorAlpha: CGFloat = 0.4
    
    private var waveContainerHeightConstant: CGFloat {
        let waveContainerHeight: CGFloat = 250
        return waveContainerHeight + view.safeAreaInsets.bottom
    }
        
    // Not to be used externally
    var setupForView: SetupForViewType = .textView {
        didSet {
            resetViewSetup()
        }
    }
    
    private var sendBtnState: SendButtonState = .record {
        didSet {
            switch sendBtnState {
            case .record:   sendBtn.setImage(#imageLiteral(resourceName: "aerinSmallMic"), for: .normal)
            case .send:     sendBtn.setImage(#imageLiteral(resourceName: "sendIcon"), for: .normal)
            }
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var popoverView: UIView!
    @IBOutlet weak var popoverViewHeight: NSLayoutConstraint!
    @IBOutlet weak var popoverViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var dragView: UIView!
    @IBOutlet weak var topAerinImgView: UIImageView!
    
    @IBOutlet weak var aerinImgView: UIImageView!
    @IBOutlet weak var morningBackView: UIView!
    @IBOutlet weak var morningLbl: UILabel!
    @IBOutlet weak var whereToGoLbl: UILabel!
    
    @IBOutlet weak var alignmentView: UIView!
    @IBOutlet weak var alignmentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var alignmentViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var textViewWhiteView: UIView!
    @IBOutlet weak var textViewBackView: UIView!
    @IBOutlet weak var textViewBackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textViewBackViewBottom: NSLayoutConstraint!
    @IBOutlet weak var separatorView: ATDividerView!
    @IBOutlet weak var messageTextView: IQTextView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var sendBtnWidth: NSLayoutConstraint!
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var suggestionsCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var animationBubbleImageView: UIImageView!
    @IBOutlet weak var animationLabel: UILabel!
    
    @IBOutlet weak var waveAnimationContainerView: UIView!
    @IBOutlet weak var waveAnimationContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var waveAnimationContainerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var waveAnimationContentView: UIView!
    @IBOutlet weak var hideWaveBtn: UIButton!
    @IBOutlet weak var listeningLblBackView: UIView!
    @IBOutlet weak var listeningLbl: UILabel!
    
    @IBOutlet weak var aerinCommunicationOptionsView: UIView!
    @IBOutlet weak var keyboardBtn: UIButton!
    @IBOutlet weak var micBtn: UIButton!
    @IBOutlet weak var aerinommunicationHelpBtn: UIButton!
    
    // MARK: View life cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setWaveContainerView()
        startPresentAnimation()
        delay(seconds: 0.33) {
            self.animateMorningLabel()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = false
        addKeyboard()
        self.statusBarStyle = .darkContent
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboard()
        IQKeyboardManager.shared().isEnabled = true
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func appDidEnterForeground() {
        if let dotAnimationCell = chatTableView.cellForRow(at: IndexPath(row: chatVm.messages.count - 1, section: 0)) as? TypingStatusChatCell {
            dotAnimationCell.loader.play()
        }
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        chatVm.delegate = self
    }
    
    deinit {
        speechRecognizer.stop()
    }
    
    // MARK: Actions
    
    @IBAction func dismissBtnAction(_ sender: UIButton) {
        messageTextView.resignFirstResponder()
        startDismissAnimation()
    }
    
    @IBAction func hideWaveBtnAction(_ sender: UIButton) {
        speechRecognizer.stop()
    }
    
    @IBAction func keyboardBtnAction(_ sender: UIButton) {
        let micImgFrame = micBtn.convert(micBtn.imageView!.frame, to: view)
        setupForView = .textViewOpen
        animateMicToMessageView(micImgFrame: micImgFrame)
    }
    
    @IBAction func micBtnAction(_ sender: UIButton) {
        if speechRecognizer.authStatus() != .authorized {
            speechRecognizer.requestTranscribePermissions()
            return
        }
        setupForView = .waveAnimation
    }
    
    @IBAction func helpBtnAction(_ sender: UIButton) {
        if startPoint != .top {
            startPoint = .top
            startPresentAnimation()
        }
        let vc = ThingsCanBeAskedVC.instantiate(fromAppStoryboard: AppStoryboard.Dashboard)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func sendBtnAction(_ sender: UIButton) {
        switch sendBtnState {
        case .send:
            //            removeSeeResultsAgainCell()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            delay(seconds: 1) {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            
            self.messageTextView.placeholder = ""
            self.invalidateTypingCellTimer()
            guard  let msg = self.messageTextView.text, !msg.isEmpty else { return }
            if self.chatVm.messages.isEmpty {
                hideWelcomeView()
                toggleSuggestions(true, animated: true)
            }
            self.animationLabel.text = msg
            self.chatVm.messages.append(MessageModel(msg: msg, source: MessageModel.MessageSource.me))
            if aerinImgView.alpha != 1.0 {
                showTopAerinImgView()
            }
            self.chatTableView.reloadData()
            self.resetFrames()
            scrollTableViewToLast()
            self.hideShowSenderCellContent(ishidden: true)
            self.chatVm.msgToBeSent = msg
            delay(seconds: 0.27) {
                self.animateCell(text : msg)
            }
        //MARK:- Here i had used insert row due to some issue with the yIndex of the cell i had used reload
        
        case .record:
            if speechRecognizer.authStatus() != .authorized {
                speechRecognizer.requestTranscribePermissions()
                return
            }
            setupForView = .waveAnimation
        }
    }
    
    // MARK: Functions
    
    internal override func initialSetup() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        messageTextView.delegate = self
        speechRecognizer.delegate = self
        setupSubViews()
    }
    
    private func resetViewSetup() {
        switch setupForView {
        case .textView:
            alignmentViewHeight.constant = textViewBackView.height
        case .textViewOpen:
            setupForTextViewOpen()
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
        messageTextView.resignFirstResponder()
        textViewWhiteView.isHidden = true
        textViewBackView.isHidden = true
        toggleSuggestions(true, animated: true)
        if chatVm.messages.isEmpty {
            alignmentViewHeight.constant = aerinCommunicationOptionsView.height
        } else {
            alignmentViewHeight.constant = 0
            chatTableView.contentInset = UIEdgeInsets(top: topNavView.height, left: 0, bottom: waveContainerHeightConstant/1.5, right: 0)
        }
        toggleWaveAnimationsView(false)
        toggleCommControlsView(true)
    }
    
    private func setupForCommControls() {
        messageTextView.resignFirstResponder()
        textViewWhiteView.isHidden = true
        textViewBackView.isHidden = true
        alignmentViewHeight.constant = aerinCommunicationOptionsView.height
        toggleWaveAnimationsView(true)
        toggleSuggestions(false, animated: true)
        toggleCommControlsView(false)
        scrollTableViewToLast()
        UIView.animate(withDuration: 0.3, delay: 0.4, options: .curveEaseInOut, animations: {
            self.chatTableView.contentInset = UIEdgeInsets(top: self.topNavView.height, left: 0, bottom: 20, right: 0)
        }, completion: nil)
    }
    
    private func setupForTextViewOpen() {
        UIView.animate(withDuration: 0.3, delay: 0.4, options: .curveEaseInOut, animations: {
            self.chatTableView.contentInset = UIEdgeInsets(top: self.topNavView.height, left: 0, bottom: 0, right: 0)
        }, completion: nil)
        toggleWaveAnimationsView(true)
        toggleSuggestions(false, animated: true)
        toggleCommControlsView(true, animated: false)
        textViewWhiteView.isHidden = false
        textViewBackView.isHidden = false
        messageTextView.becomeFirstResponder()
        alignmentViewHeight.constant = -(textViewBackViewBottom.constant) + textViewBackView.height
    }
    
    private func animateMicToMessageView(micImgFrame: CGRect) {
        sendBtn.alpha = 0
        micBtn.alpha = 0
        let initialFrame = micImgFrame
        let finalFrame = sendBtn.convert(sendBtn.imageView!.frame, to: view)
        let animationMicImgView = UIImageView(frame: initialFrame)
//        animationMicImgView.contentMode = .scaleToFill
        animationMicImgView.image = micBtn.currentImage
        view.addSubview(animationMicImgView)
        
        // Horizontal and size animation
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            animationMicImgView.frame.origin.x = finalFrame.origin.x - 3
            animationMicImgView.frame.size = CGSize(width: finalFrame.width*1.2, height: finalFrame.height*1.2)
        }, completion: nil)
        
        // Vertical animation with total animation time of 0.3 seconds
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            animationMicImgView.frame.origin.y = finalFrame.origin.y - 1
        } completion: { (_) in
            DispatchQueue.delay(0.1) {
                animationMicImgView.removeFromSuperview()
                self.sendBtn.alpha = 1
            }
            self.micBtn.alpha = 1
            
        }
    }
    
    private func toggleCommControlsView(_ hidden: Bool, animated: Bool = true) {
        let animationDuration: TimeInterval = animated ? 0.5 : 0
        UIView.animate(withDuration: animationDuration) {
            if hidden {
                self.aerinCommunicationOptionsView.alpha = 0
                self.micBtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            } else {
                self.aerinCommunicationOptionsView.alpha = 1
                self.micBtn.transform = .identity
            }
        }
    }
    
    private func toggleWaveAnimationsView(_ hidden: Bool) {
        if !hidden {
            giveSuccessHapticFeedback()
            waveAnimationContainerView.alpha = 1
            DispatchQueue.delay(0.2) {
                self.speechRecognizer.start()
            }
            resetListeningLbl()
        }
        UIView.animate(withDuration: 0.5, animations: {
            if hidden {
                if self.waveAnimationContainerView.alpha != 0 {
                    self.waveAnimationContainerView.transform = CGAffineTransform(translationX: 0, y: self.waveContainerHeightConstant)
                }
            } else {
                self.waveAnimationContainerView.transform = .identity
            }
            self.popoverView.layoutIfNeeded()
        }) { _ in
            if hidden {
                self.waveAnimationContainerView.alpha = 0
            }
        }
    }
    
//    private func removeSeeResultsAgainCell() {
//        chatVm.messages.removeAll(where: { $0.msgSource == .seeResultsAgain })
//        chatTableView.reloadData()
//    }
    
    func hideWelcomeView(){
        UIView.animate(withDuration: 0.2, animations: {
            self.morningLbl.alpha = 0
            self.whereToGoLbl.alpha = 0
            self.aerinImgView.alpha = 0
        }) { (success) in
            self.morningLbl.isHidden = true
            self.whereToGoLbl.isHidden = true
            self.aerinImgView.isHidden = true
            self.chatTableView.isHidden = false
        }
    }
    
    func toggleSuggestions(_ hidden: Bool, animated: Bool){
        let animationDuration: TimeInterval = animated ? 0.5 : 0
        if !hidden && !chatVm.messages.isEmpty {
            return
        }
        UIView.animate(withDuration: animationDuration, animations: {
            if hidden {
                self.suggestionsCollectionView.transform = CGAffineTransform(translationX: self.view.width, y: 0)
                self.suggestionsCollectionView.alpha = 0
            } else {
                self.suggestionsCollectionView.transform = .identity
                self.suggestionsCollectionView.alpha = 1
            }
        })
    }
    
    func animateCell(text : String = ""){

        let rectOfLastCell = self.chatTableView.rectForRow(at: IndexPath(row: self.chatVm.getMylastMessageIndex(), section: 0))
        let rectWrtView = self.chatTableView.convert(rectOfLastCell, to: self.view)
        self.showAnimationViewWith(text: text)
        self.animationView.frame = CGRect(x: 0, y: self.textViewBackView.frame.origin.y - 6, width: self.view.frame.width, height: self.animationLabel.frame.height + 28)
        let horizintalScale = self.animationBubbleImageView.frame.origin.x - 4
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
    
    private func setupSubViews() {
        setupPopoverView()
        addPanGesture()
        setUpAttributes()
        configureTableView()
        configureCollectionView()
        chatVm.getRecentHotels()
        chatVm.getRecentFlights()
        resetFrames()
        addWaveAnimation()
        
        if speechRecognizer.authStatus() == .denied {
            self.waveAnimationContainerView.isHidden = true
            setupForView = .textView
            startPoint = .top
            delay(seconds: 0.3) {
                self.setupForView = .textViewOpen
                self.waveAnimationContainerView.isHidden = false
            }
        } else {
            setupForView = .waveAnimation
        }
    }
    
    private func setWaveContainerView() {
        waveAnimationContainerView.backgroundColor = .clear
        waveAnimationContainerViewHeight.constant = waveContainerHeightConstant
        waveAnimationContainerViewBottom.constant = view.safeAreaInsets.bottom
    }
        
    private func setUpAttributes(){
        resetListeningLbl()
        listeningLblBackView.roundCorners()
        alignmentView.backgroundColor = .clear
        whereToGoLbl.font = AppFonts.Regular.withSize(28)
        animationLabel.font = AppFonts.Regular.withSize(18)
        morningLbl.textColor = UIColor.black
        morningLbl.alpha = 1
        whereToGoLbl.alpha = 0
        setMorningLabelText()
        messageTextView.font = AppFonts.Regular.withSize(18)
        messageTextView.delegate = self
        messageTextView.autocorrectionType = .no
        animationBubbleImageView.image = UIImage(named: "Green Chat bubble")?.resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21), resizingMode: .stretch).withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        view.addSubview(animationView)
        hideAnimationView()
        chatTableView.isHidden = true
        chatTableView.keyboardDismissMode = .onDrag
        messageTextView.tintColor = AppColors.themeGreen
        messageTextView.placeholder = LocalizedString.TryDelhiToGoaTomorrow.localized
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
    
    func scrollTableViewToLast(withAnimation : Bool = true){
        if chatVm.messages.isEmpty { return }
        chatTableView.scrollToRow(at: IndexPath(row: chatVm.messages.count - 1, section: 0), at: UITableView.ScrollPosition.top, animated: withAnimation)
    }
    
    func showAnimationViewWith(text : String){
        self.animationLabel.textAlignment = text.count <= 10 ? .center : .left
        self.animationView.isHidden = false
        self.animationLabel.text = text
        UIView.animate(withDuration: 0.25) {
            self.animationBubbleImageView.alpha = 1
        }
    }
    
    func hideAnimationView(){
        animationView.isHidden = true
        animationLabel.text = ""
        animationBubbleImageView.alpha = 0
    }
    
    func hideShowSenderCellContent(ishidden : Bool){
        guard let cell = chatTableView.cellForRow(at: IndexPath(row: chatVm.getMylastMessageIndex(), section: 0)) as? SenderChatCell else {
            return }
        cell.contentView.isHidden = ishidden
    }
    
    func showTopAerinImgView() {
        UIView.animate(withDuration: 0.3) {
            self.topAerinImgView.alpha = 1.0
        }
    }
    
    //MARK:- Configure tableview
    private func configureTableView(){
        chatTableView.dataSource = self
        chatTableView.delegate = self
        chatTableView.register(UINib(nibName: "SenderChatCell", bundle: nil), forCellReuseIdentifier: "SenderChatCell")
        chatTableView.register(UINib(nibName: "TypingStatusChatCell", bundle: nil), forCellReuseIdentifier: "TypingStatusChatCell")
        chatTableView.register(UINib(nibName: "ReceiverChatCell", bundle: nil), forCellReuseIdentifier: "ReceiverChatCell")
        chatTableView.register(UINib(nibName: "SeeResultsAgainCell", bundle: nil), forCellReuseIdentifier: "SeeResultsAgainCell")
        chatTableView.estimatedRowHeight = 100
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.contentInset = UIEdgeInsets(top: topNavView.height, left: 0, bottom: 0, right: 0)
    }
    
    func configureCollectionView(){
        suggestionsCollectionView.dataSource = self
        suggestionsCollectionView.delegate = self
        suggestionsCollectionView.register(UINib(nibName: "SuggestionsCell", bundle: nil), forCellWithReuseIdentifier: "SuggestionsCell")
        suggestionsCollectionView.contentInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        //        suggestionsCollectionView.isHidden = true
    }
    
    private func setMorningLabelText(){
        if let info = UserInfo.loggedInUser, !info.firstName.isEmpty {
            let morningStr = "Good \(Date().morningOrEvening), \(info.firstName)"
            morningLbl.attributedText = morningStr.attributeStringWithColors(subString: info.firstName, strClr: UIColor.black, substrClr: AppColors.themeGreen, strFont: AppFonts.Regular.withSize(28), subStrFont: AppFonts.SemiBold.withSize(28))
        }else{
            morningLbl.text = "Good \(Date().morningOrEvening)"
        }
    }
    
    //MARK:- MorningView animation
    private func animateMorningLabel(){
        delay(seconds: 1.0) {
            self.animateWhereToGoLabel()
        }
    }
    
    func animateWhereToGoLabel(){
        self.morningLbl.isHidden = true
        
        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.whereToGoLbl.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.whereToGoLbl.transform = CGAffineTransform(translationX: 0, y: (-(self.morningLbl.frame.height + 2)))
        }, completion: nil)
    }
    
    private func setupPopoverView() {
        popoverView.roundParticularCorners(10, [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        popoverViewHeight.constant = view.bounds.height
        midPoint = view.bounds.height * 0.4
        maxPoint = 0
        minPoint = view.bounds.height
        popoverViewTop.constant = minPoint
        dragView.backgroundColor = AppColors.blackWith20PerAlpha
        dragView.roundedCorners(cornerRadius: 2.5)
        topAerinImgView.alpha = 0
        
    }
    
    private func startPresentAnimation() {
        self.initialPoint = startPoint == .center ? midPoint : maxPoint
        UIView.animate(withDuration: 0.33) {
            let fractionForAlpha = self.maxViewColorAlpha - (((self.startPoint == .center ? self.midPoint : self.maxPoint)/self.minPoint)) * self.maxViewColorAlpha
            self.view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: fractionForAlpha)
            self.popoverViewTop.constant = self.initialPoint
            self.alignmentViewBottom.constant = (self.popoverViewTop.constant + self.popoverViewHeight.constant + self.view.safeAreaInsets.bottom + self.view.safeAreaInsets.top) - self.view.bounds.height
            self.view.layoutIfNeeded()
        }
    }
    
    func startDismissAnimation(_ animationDuration: TimeInterval = 0.3) {
        UIView.animate(withDuration: animationDuration, animations:  {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.popoverViewTop.constant = self.minPoint
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
}

extension AerinCustomPopoverVC {
    private func addPanGesture() {
        let dismissGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanViewToDismiss(_:)))
        view.addGestureRecognizer(dismissGesture)
    }
    
    @objc private func didPanViewToDismiss(_ sender: UIPanGestureRecognizer) {
        let yTranslation = sender.translation(in: view).y
        if yTranslation > 0 {
            messageTextView.resignFirstResponder()
        }
                
        switch sender.state {
        case .ended:
            let yVelocity = sender.velocity(in: view).y
            if (yVelocity > 500) && (popoverViewTop.constant > view.bounds.height * 0.75) && (popoverViewTop.constant < minPoint) {
                startDismissAnimation()
            } else if popoverViewTop.constant >= minPoint {
                startDismissAnimation(0.0)
            } else if popoverViewTop.constant >= midPoint && popoverViewTop.constant < minPoint {
                startPoint = .center
                startPresentAnimation()
            } else {
                if (startPoint == .top) && (yVelocity > 500) {
                    startPoint = .center
                } else {
                    startPoint = .top
                }
                startPresentAnimation()
            }
        default:
            transformViewBy(yTranslation)
        }
    }
    
    private func transformViewBy(_ yTranslation: CGFloat) {
        guard (initialPoint + yTranslation) >= maxPoint else { return }
        popoverViewTop.constant = initialPoint + yTranslation
        let whiteViewBottomConstant = (popoverViewTop.constant + popoverViewHeight.constant + view.safeAreaInsets.bottom + view.safeAreaInsets.top) - view.bounds.height
        if popoverViewTop.constant <= midPoint {
            alignmentViewBottom.constant = whiteViewBottomConstant
        }
        let fractionForAlpha = maxViewColorAlpha - ((popoverViewTop.constant/minPoint) * maxViewColorAlpha)
        view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: fractionForAlpha)
    }
}

//MARK:- ManageTypingCell
extension AerinCustomPopoverVC {
    
    func scheduleTypingCell(){
        if self.chatVm.typingCellTimerCounter > 0 { return }
        self.insertTypingCell()
        self.chatVm.sendMessageToChatBot(message: self.chatVm.msgToBeSent)
        self.typingCellTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleTypingCellTimer), userInfo: nil, repeats: true)
    }
    
    @objc func handleTypingCellTimer(){
        //        if self.chatVm.typingCellTimerCounter == 0{ self.insertTypingCell() }
        self.chatVm.typingCellTimerCounter += 1
//        if self.chatVm.typingCellTimerCounter == 1{self.chatVm.sendMessageToChatBot(message: self.chatVm.msgToBeSent) }
        if self.chatVm.typingCellTimerCounter == 10{
            invalidateTypingCellTimer()
        }
    }
    
    func invalidateTypingCellTimer(){
        self.typingCellTimer?.invalidate()
        self.chatVm.typingCellTimerCounter = 0
        self.sendBtn.isEnabled = true
        self.micBtn.isEnabled = true
        removeTypingCell()
    }
    
    private func insertTypingCell(){
        
        printDebug("time1...\(Date().timeIntervalSince1970)")
        
        self.chatVm.messages.append(MessageModel(msg: "", source: MessageModel.MessageSource.typing))
        
//        self.chatTableView.beginUpdates()
//        self.chatTableView.insertRows(at: [IndexPath(row: self.chatVm.messages.count - 1, section: 0)], with: UITableView.RowAnimation.none)
//        self.chatTableView.endUpdates()
     
        self.chatTableView.reloadData()
    
        printDebug("time2...\(Date().timeIntervalSince1970)")
      
        self.scrollTableViewToLast(withAnimation: true)
  
        printDebug("time3...\(Date().timeIntervalSince1970)")
 //       delay(seconds: 0.3) {
//            self.addDotViewToTypingCell()

//            printDebug("time4...\(Date().timeIntervalSince1970)")

  //      }
    }
    
    private func removeTypingCell(){
        self.chatVm.messages = self.chatVm.messages.filter { $0.msgSource != .typing }
        self.chatTableView.reloadData()
        self.dotsView?.stop()
        self.dotsView?.removeFromSuperview()
        self.dotsView = nil
    }
}

//MARK:- Keyboard SetUp
extension AerinCustomPopoverVC {
    
    private func addKeyboard(){
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: OperationQueue.main, using: {[weak self] (notification) in
            guard let info = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            guard let strongSelf = self else {return}
            let keyBoardHeight = info.cgRectValue.height
            
            var safeAreaBottomInset : CGFloat = 0
            if #available(iOS 11.0, *) {
                safeAreaBottomInset = strongSelf.view.safeAreaInsets.bottom
            } else { }
            UIView.animate(withDuration: 0.1,  delay: 0, options: .curveEaseInOut, animations: {
                if (info.cgRectValue.origin.y) >= UIDevice.screenHeight {
                    strongSelf.textViewBackViewBottom.constant = 0
                    strongSelf.setupForView = .textView
                } else {
                    strongSelf.textViewBackViewBottom.constant = -(keyBoardHeight - safeAreaBottomInset)
                    strongSelf.setupForView = .textViewOpen
                }
                strongSelf.view.layoutIfNeeded()
            }, completion: nil)
            
        })
    }
    
    private func removeKeyboard(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        popoverView.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard() {
        messageTextView.resignFirstResponder()
    }
}

// MARK: Text View Delegates
extension AerinCustomPopoverVC {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if startPoint == .center {
            startPoint = .top
            startPresentAnimation()
        }
        scrollTableViewToLast(withAnimation : false)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (range.location == 0 && text == " ") {return false}
        
        if self.sendBtnWidth.constant == 0{
            //  showHideSendButton(text : text, shouldCheckCount : false)
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        arrangeTextViewHeight()
        //        showHideSendButton(text: textView.text ?? "")
    }
    
    func showHideSendButton(text : String = "", shouldCheckCount : Bool = true){
        if text.count > 1 && shouldCheckCount { return }
        UIView.animate(withDuration: 0.3) {
            self.sendBtnWidth.constant = text.isEmpty ? 0 : 44
            self.view.layoutIfNeeded()
        }
    }
    
    func arrangeTextViewHeight(){
        
        let text = messageTextView.text ?? ""
        
        let height = text.heightOfText(self.view.frame.size.width - 74, font: AppFonts.Regular.withSize(18)) + 10
        
        if height > 44 && height < 90 {
            self.textViewBackViewHeight.constant = height + 10
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            checkSendButtonStatus()
        }else if height < 44{
            resetFrames()
        }
    }
    
    func resetFrames() {
        UIView.animate(withDuration: 0.3) {
            self.textViewBackViewHeight.constant = 44
            self.view.layoutIfNeeded()
        }
        checkSendButtonStatus()
    }
    func checkSendButtonStatus() {
        sendBtnState = messageTextView.text.isEmpty ? .record : .send
    }
}

// MARK: Chatbot Delegate
extension AerinCustomPopoverVC : ChatBotDelegatesDelegate {
    
   
    func willstarttChatBotSession() {

    }
    
    func chatBotSessionCreatedSuccessfully() {
        invalidateTypingCellTimer()
        scrollTableViewToLast()
    }
    
    func failedToCreateChatBotSession() {
        
    }
    
    func willCommunicateWithChatBot() {
        
    }
    
    func chatBotCommunicatedSuccessfully() {
        invalidateTypingCellTimer()
        scrollTableViewToLast()
    }
    
    func failedToCommunicateWithChatBot() {
        invalidateTypingCellTimer()
    }
    
    func hideTypingCell(){
        invalidateTypingCellTimer()
    }
    
    func moveFurtherWhenallRequiredInformationSubmited(data: MessageModel) {
        invalidateTypingCellTimer()
        print("lets go...\(data)")
        chatVm.lastCachedResultModel = data
        chatVm.createFlightSearchDictionaryAndPushToVC(data)
        messageTextView.resignFirstResponder()
        startDismissAnimation()
        
//        if chatVm.messages.last?.msgSource != .seeResultsAgain {
//            let seeAgainMsgModel = MessageModel(msg: LocalizedString.seeResultsAgain.localized, source: .seeResultsAgain)
//            chatVm.messages.append(seeAgainMsgModel)
//            DispatchQueue.delay(1) { [weak self] in
//                self?.chatTableView.reloadData()
//            }
//        }
    }
    
    func willGetRecentSearchHotel(){
        
    }
    
    func getRecentSearchHotelSuccessFully(){
        self.suggestionsCollectionView.reloadData()
    }
    
    func failedToGetRecentSearchApi(){
        
    }
    
    func willGetRecentSearchFlights(){
        
    }
    
    func getRecentSearchFlightsSuccessFully(){
        self.suggestionsCollectionView.reloadData()
    }
    
    func failedToGetRecentSearchedFlightsApi(){
        
    }
}
