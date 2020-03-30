//
//  ChatVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 17/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import IQKeyboardManager

class ChatVC : BaseVC {
    
    //MARK:- IBOutlets
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var morningLabel: UILabel!
    @IBOutlet weak var whereToGoLabel: UILabel!
    @IBOutlet weak var morningBackView: UIView!
    @IBOutlet weak var chatButtonTop: NSLayoutConstraint!
    @IBOutlet weak var textViewBackViewBottom: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: IQTextView!
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var chatBackViewHeight: NSLayoutConstraint!
    @IBOutlet var animationView: UIView!
    @IBOutlet weak var animationLabel: UILabel!
    @IBOutlet weak var animationBubbleImageView: UIImageView!
    @IBOutlet weak var textViewBackView: UIView!
    @IBOutlet weak var suggestionsCollectionView: UICollectionView!
    @IBOutlet weak var sendButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var collectionViewBottom: NSLayoutConstraint!
    
    
    //MARK:- Variables
    private var name = "Guru"
    let chatVm = ChatVM()
    var dotsView: AMDots?
    var typingCellTimer : Timer?
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        addKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnabled = true
        removeKeyboard()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        self.chatVm.delegate = self
    }
    
    @IBAction func chatButtonTapped(_ sender: UIButton) { }
    
    //MARK:- Send Button Tapped
    @IBAction func sendButton(_ sender: UIButton) {
        self.invalidateTypingCellTimer()
        guard  let msg = self.messageTextView.text, !msg.isEmpty else { return }
        if self.chatVm.messages.isEmpty {
            hideWelcomeView()
            hideSuggestions()
        }
        self.chatVm.messages.append(MessageModel(msg: msg, source: MessageModel.MessageSource.me))
        self.chatTableView.reloadData()
        self.resetFrames()
        scrollTableViewToLast()
        self.hideShowSenderCellContent(ishidden: true)
        self.messageTextView.text = ""
//        self.showHideSendButton()
        self.chatVm.msgToBeSent = msg
        delay(seconds: 0.27) {
            self.animateCell(text : msg)
        }
        //MARK:- Here i had used insert row due to some issue with the yIndex of the cell i had used reload
    }
    
    //MARK:- Add dot animation to tableview cell
    func addDotViewToTypingCell(){
        if let typingCellIndex = self.chatVm.messages.lastIndex(where: { (obj) -> Bool in
            obj.msgSource == .typing
        }){
            guard let cell = self.chatTableView.cellForRow(at: IndexPath(row: typingCellIndex, section: 0)) as? TypingStatusChatCell else { return }
            dotsView = AMDots(frame: CGRect(x: cell.dotsView.frame.origin.x, y: cell.dotsView.frame.origin.y, width: cell.dotsView.frame.width, height: cell.dotsView.frame.height), colors: [#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1),#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1),#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)])
            dotsView?.hidesWhenStopped = true
            dotsView?.backgroundColor = UIColor.clear
            dotsView?.animationType = .jump
            dotsView?.dotSize = 5
            dotsView?.animationDuration = 1.4
            dotsView?.spacing = 5
            dotsView?.aheadTime = 1
            cell.contentView.addSubview(self.dotsView ?? UIView())
            dotsView?.start()
        }
    }
}

//MARK:- Functions
extension ChatVC {
    
    //MARK:- Setup view
    private func setUpSubView(){
        self.setUpNavigationView()
        self.setUpAttributes()
        self.performInitialAnimation()
        self.configureTableView()
        self.configureCollectionView()
//        self.chatVm.getRecentHotels()
//        self.chatVm.getRecentFlights()
    }
    
    //MARK:- Set view attributes
    private func setUpAttributes(){
        self.whereToGoLabel.font = AppFonts.Regular.withSize(28)
        self.animationLabel.font = AppFonts.Regular.withSize(18)
        self.morningLabel.textColor = AppColors.themeGreen
//        self.textViewBackView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.morningLabel.alpha = 0
        self.whereToGoLabel.alpha = 0
        let morningStr = "Good \(Date().morningOrEvening), \(name)"
        self.morningLabel.attributedText = morningStr.attributeStringWithColors(stringToColor: name, strClr: UIColor.black, substrClr: AppColors.themeGreen, strFont: AppFonts.Regular.withSize(28), strClrFont: AppFonts.SemiBold.withSize(28))
        messageTextView.font = AppFonts.Regular.withSize(18)
        self.messageTextView.delegate = self
        self.animationBubbleImageView.image = UIImage(named: "Green Chat bubble")?.resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21), resizingMode: .stretch).withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        self.view.addSubview(animationView)
        self.hideAnimationView()
        self.chatTableView.isHidden = true
        self.chatButton.isUserInteractionEnabled = false
        self.messageTextView.tintColor = AppColors.themeGreen
//        self.showHideSendButton()
    }
    
    //MARK:- Configure tableview
    private func configureTableView(){
        chatTableView.dataSource = self
        chatTableView.delegate = self
        chatTableView.register(UINib(nibName: "SenderChatCell", bundle: nil), forCellReuseIdentifier: "SenderChatCell")
        chatTableView.register(UINib(nibName: "TypingStatusChatCell", bundle: nil), forCellReuseIdentifier: "TypingStatusChatCell")
        chatTableView.register(UINib(nibName: "ReceiverChatCell", bundle: nil), forCellReuseIdentifier: "ReceiverChatCell")
        chatTableView.estimatedRowHeight = 100
        chatTableView.rowHeight = UITableView.automaticDimension
    }
    
    func configureCollectionView(){
        suggestionsCollectionView.dataSource = self
        suggestionsCollectionView.delegate = self
        suggestionsCollectionView.register(UINib(nibName: "SuggestionsCell", bundle: nil), forCellWithReuseIdentifier: "SuggestionsCell")
        suggestionsCollectionView.contentInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
//        suggestionsCollectionView.isHidden = true
    }
    
    //MARK:- Set navigation view
    private func setUpNavigationView(){
        topNavView.delegate = self
        topNavView.configureNavBar(title: "", isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        topNavView.configureLeftButton(normalImage: #imageLiteral(resourceName: "back"), selectedImage:  #imageLiteral(resourceName: "back"), normalTitle: "", selectedTitle: "", normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
        topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "green_2"), selectedImage: #imageLiteral(resourceName: "green_2"), normalTitle: "", selectedTitle: "", normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
    }
    
    private func scrollTableViewToLast(withAnimation : Bool = true){
        if self.chatVm.messages.isEmpty { return }
        self.chatTableView.scrollToRow(at: IndexPath(row: self.chatVm.messages.count - 1, section: 0), at: UITableView.ScrollPosition.top, animated: withAnimation)
    }
}

extension ChatVC : TopNavigationViewDelegate {
    
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        invalidateTypingCellTimer()
        self.navigationController?.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
//        AppFlowManager.default.moveToSettingsVC()
    }
}

//MARK:- Animations
extension ChatVC {
    //MARK:- Welcome animation
    private func performInitialAnimation(){
        UIView.animate(withDuration: 0.2, animations: {
            self.chatButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { (success) in
            UIView.animate(withDuration: 0.2, animations: {
                self.chatButtonTop.constant = 10
                self.view.layoutIfNeeded()
            }) { (success) in
                self.animateMorningLabel()
            }
        }
    }
    
    //MARK:- MorningView animation
    private func animateMorningLabel(){
        delay(seconds: 0.3) {
            UIView.animate(withDuration: 1) {
//                self.morningBackView.alpha = 1
                self.morningLabel.alpha = 1
            }
        }
        UIView.animate(withDuration: 1, animations: {
            self.morningBackView.transform = CGAffineTransform(translationX: 0, y: (-50))
        }) { (success) in
            delay(seconds: 1) {
                self.animateWhereToGoLabel()
            }
        }
    }
    
    func animateWhereToGoLabel(){
        self.morningLabel.isHidden = true
                
        UIView.animate(withDuration: 0.6, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.whereToGoLabel.alpha = 1
        }, completion: nil)

        UIView.animate(withDuration: 0.6, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
              self.whereToGoLabel.transform = CGAffineTransform(translationX: 0, y: (-(self.morningLabel.frame.height + 2)))
          }, completion: nil)
        
    }
    
    private func hideWelcomeView(){
        UIView.animate(withDuration: 0.2, animations: {
            self.morningLabel.alpha = 0
            self.whereToGoLabel.alpha = 0
            self.chatButton.alpha = 0
        }) { (success) in
            self.morningLabel.isHidden = true
            self.whereToGoLabel.isHidden = true
            self.chatButton.isHidden = true
            self.chatTableView.isHidden = false
        }
    }
    
    private func hideSuggestions(){
        
//        UIView.animate(withDuration: 0.5, animations: {
//            self.suggestionsCollectionView.alpha = 0
//        }) { (success) in
//            self.suggestionsCollectionView.isHidden = true
//        }
        
        UIView.animate(withDuration: 0.5) {
            self.collectionViewBottom.constant = -200
        }
    }
    
    private func animateCell(text : String = ""){
        let rectOfLastCell = self.chatTableView.rectForRow(at: IndexPath(row: self.chatVm.messages.count - 1, section: 0))
        let rectWrtView = self.chatTableView.convert(rectOfLastCell, to: self.view)
        self.animationView.frame = CGRect(x: 0, y: self.textViewBackView.frame.origin.y, width: self.view.frame.width, height: self.animationLabel.frame.height + 28)
        let horizintalScale = self.animationView.frame.width - self.animationBubbleImageView.frame.width - 8 - 15
        self.animationLabel.transform = CGAffineTransform(translationX: -horizintalScale, y: 0)
        self.animationBubbleImageView.transform = CGAffineTransform(translationX: -horizintalScale, y: 0)
        self.sendButton.isEnabled = false
        self.showAnimationViewWith(text: text)
        
        //MARK:- To be used further if needed
        //        UIView.animate(withDuration: 0.3, animations: {
        //            self.animationBubbleImageView.transform = CGAffineTransform.identity
        //            self.animationLabel.transform = CGAffineTransform.identity
        //            self.animationView.frame.origin.y = rectWrtView.origin.y
        //
        //        }) { (success) in
        //
        //            self.hideShowSenderCellContent(ishidden: false)
        //            self.animationView.isHidden = true
        //            self.chatVm.messages[self.chatVm.messages.count - 1].isHidden = false
        //        }
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                self.animationBubbleImageView.transform = CGAffineTransform.identity
                self.animationLabel.transform = CGAffineTransform.identity
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.3) {
                self.animationView.frame.origin.y = rectWrtView.origin.y
            }
            
        }) { (success) in
            self.hideShowSenderCellContent(ishidden: false)
            self.hideAnimationView()
            self.chatVm.messages[self.chatVm.messages.count - 1].isHidden = false
            delay(seconds: 0.2) {
                self.sendButton.isEnabled = true
            }
            self.scheduleTypingCell()
        }
    }
    
    private func showAnimationViewWith(text : String){
        self.animationLabel.textAlignment = text.count <= 10 ? .center : .left
        self.animationView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.animationLabel.text = text
            self.animationView.alpha = 1
        }
    }
    
    private func hideAnimationView(){
        self.animationView.isHidden = true
        self.animationLabel.text = ""
        self.animationView.alpha = 0
    }
    
    private func hideShowSenderCellContent(ishidden : Bool){
        guard let cell = self.chatTableView.cellForRow(at: IndexPath(row: self.chatVm.messages.count - 1, section: 0)) as? SenderChatCell else {
            return }
        cell.contentView.isHidden = ishidden
    }
}

//MARK:- ManageTypingCell
extension ChatVC {
    
    func scheduleTypingCell(){
        if self.chatVm.typingCellTimerCounter > 0 { return }
        self.insertTypingCell()
        self.typingCellTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleTypingCellTimer), userInfo: nil, repeats: true)
    }
    
    @objc func handleTypingCellTimer(){
//        if self.chatVm.typingCellTimerCounter == 0{ self.insertTypingCell() }
        self.chatVm.typingCellTimerCounter += 1
        if self.chatVm.typingCellTimerCounter == 1{self.chatVm.sendMessageToChatBot(message: self.chatVm.msgToBeSent) }
        if self.chatVm.typingCellTimerCounter == 10{ invalidateTypingCellTimer() }
    }
    
    func invalidateTypingCellTimer(){
        self.typingCellTimer?.invalidate()
        self.chatVm.typingCellTimerCounter = 0
        removeTypingCell()
    }
    
    private func insertTypingCell(){
        self.chatVm.messages.append(MessageModel(msg: "", source: MessageModel.MessageSource.typing))
        self.chatTableView.beginUpdates()
        self.chatTableView.insertRows(at: [IndexPath(row: self.chatVm.messages.count - 1, section: 0)], with: UITableView.RowAnimation.none)
        self.chatTableView.endUpdates()
        scrollTableViewToLast()
        delay(seconds: 0.05) {
            self.addDotViewToTypingCell()
        }
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
extension ChatVC {
    
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
                } else {
                    strongSelf.textViewBackViewBottom.constant = (keyBoardHeight - safeAreaBottomInset)
                }
                strongSelf.view.layoutIfNeeded()
                
            }, completion: nil)
            
        })
    }
    
    private func removeKeyboard(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}


extension ChatVC {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollTableViewToLast(withAnimation : false)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (range.location == 0 && text == " ") {return false}
        
        if self.sendButtonWidth.constant == 0{
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
            self.sendButtonWidth.constant = text.isEmpty ? 0 : 44
            self.view.layoutIfNeeded()
        }
    }
    
    func arrangeTextViewHeight(){
        
        let text = messageTextView.text ?? ""
        
        let height = text.heightOfText(self.view.frame.size.width - 74, font: AppFonts.Regular.withSize(18)) + 10
        
        if height > 44 && height < 90 {
            self.chatBackViewHeight.constant = height + 10
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }else if height < 44{
            resetFrames()
        }
    }
    
    func resetFrames() {
        UIView.animate(withDuration: 0.3) {
            self.chatBackViewHeight.constant = 44
            self.view.layoutIfNeeded()
        }
    }
}

extension ChatVC : ChatBotDelegatesDelegate {
   
    func willstarttChatBotSession() {
//        self.scheduleTypingCell()

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
    
    func moveFurtherWhenallRequiredInformationSubmited() {
        let vc = FlightsDemoVC.instantiate(fromAppStoryboard: AppStoryboard.Dashboard)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
 
    
}
