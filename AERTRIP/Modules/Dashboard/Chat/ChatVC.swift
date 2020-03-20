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
    
    private var name = "Guru"
    let chatVm = ChatVM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setUpSubView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared()
        addKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnabled = true
        removeKeyboard()
    }
    
    @IBAction func chatButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        guard  let msg = self.messageTextView.text else { return }
        self.chatVm.messages.append(MessageModel(msg: msg, source: MessageModel.MessageSource.me))
        self.chatTableView.beginUpdates()
        self.chatTableView.insertRows(at: [IndexPath(row: self.chatVm.messages.count - 1, section: 0)], with: UITableView.RowAnimation.none)
        self.chatTableView.endUpdates()
        self.hideShowSenderCellContent(ishidden: true)
        self.chatTableView.scrollToRow(at: IndexPath(row: self.chatVm.messages.count - 1, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        self.resetFrames()
        delay(seconds: 0.1) {
            self.animateCell()
            self.messageTextView.text = ""
        }
    }
    
    func animateCell(){
        
       let rectOfLastCell = self.chatTableView.rectForRow(at: IndexPath(row: self.chatVm.messages.count - 1, section: 0))
        let rectWrtView = self.chatTableView.convert(rectOfLastCell, to: self.view)
      
        printDebug("rectWrtView before...\(rectWrtView)")
        
        self.animationView.isHidden = true
        guard let msg = self.messageTextView.text else { return }
        self.animationLabel.text = msg
        self.animationView.frame = CGRect(x: 0, y: self.textViewBackView.frame.origin.y, width: self.view.frame.width, height: self.animationLabel.frame.height + 28)
       let horizintalScale = self.animationView.frame.width - self.animationBubbleImageView.frame.width - 8 - 15
        self.animationLabel.transform = CGAffineTransform(translationX: -horizintalScale, y: 0)
        self.animationBubbleImageView.transform = CGAffineTransform(translationX: -horizintalScale, y: 0)

        self.animationView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.animationBubbleImageView.transform = CGAffineTransform.identity
            self.animationLabel.transform = CGAffineTransform.identity
            self.animationView.frame.origin.y = rectWrtView.origin.y - (self.animationView.frame.height / 2)
        }) { (success) in
            delay(seconds: 0.1) {
                self.hideShowSenderCellContent(ishidden: false)
                self.animationView.isHidden = true
            }
               let rectWrtView = self.chatTableView.convert(rectOfLastCell, to: self.view)
            printDebug("rectWrtView after...\(rectWrtView)")
        }
    }
    
    func hideShowSenderCellContent(ishidden : Bool){
        guard let cell = self.chatTableView.cellForRow(at: IndexPath(row: self.chatVm.messages.count - 1, section: 0)) as? SenderChatCell else { return }
        cell.contentView.isHidden = ishidden
    }
    
}


extension ChatVC {
    
    func setUpSubView(){
        setUpNavigationView()
        setUpAttributes()
        performInitialAnimation()
        configureTableView()
    }
    
    func setUpAttributes(){
//        self.morningLabel.font = AppFonts.SemiBold.withSize(28)
        self.whereToGoLabel.font = AppFonts.Regular.withSize(28)
        self.animationLabel.font = AppFonts.Regular.withSize(14)
        self.morningLabel.textColor = AppColors.themeGreen
        self.morningBackView.alpha = 0
        let morningStr = "Good Morning, \(name)"
        self.morningLabel.attributedText = morningStr.attributeStringWithColors(stringToColor: name, strClr: UIColor.black, substrClr: AppColors.themeGreen, strFont: AppFonts.Regular.withSize(28), strClrFont: AppFonts.SemiBold.withSize(28))
        self.messageTextView.delegate = self
        
        let bubbleImage = UIImage(named: "outgoing-message-bubble")?.resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21), resizingMode: .stretch).withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.animationBubbleImageView.image = bubbleImage
        self.view.addSubview(animationView)
        self.animationView.isHidden = true
  }
    
    func configureTableView(){
        chatTableView.dataSource = self
        chatTableView.delegate = self
        chatTableView.register(UINib(nibName: "SenderChatCell", bundle: nil), forCellReuseIdentifier: "SenderChatCell")
        chatTableView.estimatedRowHeight = 100
        chatTableView.rowHeight = UITableView.automaticDimension
    }
    
    func setUpNavigationView(){
        topNavView.delegate = self
        topNavView.configureNavBar(title: "", isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        topNavView.configureLeftButton(normalImage: #imageLiteral(resourceName: "back"), selectedImage:  #imageLiteral(resourceName: "back"), normalTitle: "", selectedTitle: "", normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
        topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "green_2"), selectedImage: #imageLiteral(resourceName: "green_2"), normalTitle: "", selectedTitle: "", normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
    }
    
    func performInitialAnimation(){
        UIView.animate(withDuration: 0.2, animations: {
            self.chatButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { (success) in
            UIView.animate(withDuration: 0.2, animations: {
               // self.chatButton.transform = CGAffineTransform(translationX: 0, y: (-self.chatButton.frame.origin.y + 70)).scaledBy(x: 0.5, y: 0.5)
                self.chatButtonTop.constant = 10
                self.view.layoutIfNeeded()
            }) { (success) in
                self.animateMorningView()
            }
        }
    }
    
    func animateMorningView(){
        delay(seconds: 0.3) {
            UIView.animate(withDuration: 1) {
                self.morningBackView.alpha = 1
            }
          }
        UIView.animate(withDuration: 1, animations: {
            self.morningBackView.transform = CGAffineTransform(translationX: 0, y: (-50))
        }) { (success) in
        }
    }
}

extension ChatVC : TopNavigationViewDelegate {
    
func topNavBarLeftButtonAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: false)
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        arrangeTextViewHeight()
    }
    
    func arrangeTextViewHeight(){
         
         let text = messageTextView.text ?? ""
        
         let height = text.heightOfText(self.view.frame.size.width - 74, font: AppFonts.Regular.withSize(14)) + 10
         
         if height > 44 && height < 90 {
             self.chatBackViewHeight.constant = height + 10
             UIView.animate(withDuration: 0.3) {
                 self.view.layoutIfNeeded()
             }
         }else if height < 44{
             resetFrames()
         }
         messageTextView.isScrollEnabled = (height > 90)
     }
    
    func resetFrames() {
        UIView.animate(withDuration: 0.3) {
            self.chatBackViewHeight.constant = 44
            self.view.layoutIfNeeded()
        }
    }
}
