//
//  AerinTextSpeechDetailVC.swift
//  AERTRIP
//
//  Created by apple on 22/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AerinTextSpeechDetailVC: BaseVC {
    
    //MARK: - IBOutlets
    //MARK: -
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topNavigationView: TopNavigationView!
    @IBOutlet weak var aerinTableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var aerinInfoContainerView: UIView!
    
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var chatTextViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var bottomConstraintOfCollectionAndTextView
    : NSLayoutConstraint!
    
    @IBOutlet weak var collectionChatTextView: UIView!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionChatTextViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var chatTextViewButton: UIButton!
    @IBOutlet weak var aerinInfoContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var aerinInfoContainerHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Variables
    var keyboardHeight: CGFloat = 0.0
    var initialBottomConstraintOfcollectionAndTextView: CGFloat = 0.0
    let images = ["flightIcon","ic_acc_hotels","flightIcon","flightIcon","ic_acc_hotels","flightIcon","flightIcon","ic_acc_hotels","flightIcon"]
    let text = ["BOM","Goa","Goa","BOM","Goa","Goa","BOM","Goa","Goa"]
    
    var chatArray: [String] = []
    var indexPath: IndexPath = IndexPath()
    
    
    
    // MARK: - Variables
     var aerinInfoView: AerinTextSpeechInfoHelpView?
    var isAerinInfoViewOpen: Bool = false
    var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    //MARK: - Cell Identifier
    let cellIdentifier = "AerinSuggestionCollectionViewCell"
    
    
    override func initialSetup() {
        self.registerXib()
        self.configurationNavBar()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.reloadData()
        self.chatTextView.delegate = self
        self.chatTextView.textContainerInset = UIEdgeInsets.zero
       self.configureAerinInfoView()
      self.aerinTableView.separatorStyle = .none
        self.aerinTableView.dataSource = self
        self.aerinTableView.delegate = self
        self.initialBottomConstraintOfcollectionAndTextView = self.bottomConstraintOfCollectionAndTextView.constant
        self.setUpInitialChatView()
    }
    
    

    
    private func setUpInitialChatView() {
        self.chatTextViewButton.isHidden = true
        self.collectionChatTextViewHeightConstraint.constant = self.collectionChatTextViewHeightConstraint.constant -    self.chatTextViewHeightConstraint.constant
        self.chatTextViewHeightConstraint.constant = 0
    }
    
    
    override func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            printDebug("notification: Keyboard will show")
            self.keyboardHeight = keyboardSize.height
            printDebug("keyboard height is \(self.keyboardHeight)")
        }
    }
    
    override func keyboardWillHide(notification: Notification) {
        self.keyboardHeight = 0
        self.setUpInitialChatView()
        self.bottomConstraintOfCollectionAndTextView.constant = self.initialBottomConstraintOfcollectionAndTextView
    }
    
    //MARK: - IB Action
    
    @IBAction func keyboardButtonTapped(_ sender: Any) {
        self.chatTextView.becomeFirstResponder()
        // initial height when keyboad is shown
        self.chatTextViewHeightConstraint.constant = 42
        self.collectionChatTextViewHeightConstraint.constant = 96
        self.chatTextViewButton.isHidden = false
        self.bottomConstraintOfCollectionAndTextView.constant = self.keyboardHeight - self.bottomViewConstraint.constant
        
    }
    
    @IBAction func speakerIconTapped(_ sender: Any) {
    }
    
    
    @IBAction func infoIconTappped(_ sender: Any) {
            updateAerinInfoView()
        self.animateAerinInfoView(isHidden: false, animated: true)
    }
        
    @IBAction func sendMessageTapped(_ sender: Any) {
        self.chatArray.append(self.chatTextView.text)
        self.chatTextView.text = ""
        self.aerinTableView.reloadData()
    }
    
    
    //MARK: - Helper Methods
    private func animateAerinInfoView(isHidden: Bool, animated: Bool) {
        
//        if isHidden {
            self.aerinInfoContainerView.isHidden = false
//        }
        
        let bottomToShow = -(self.aerinInfoContainerView.height - (self.bottomView.height + 20.0))
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            [weak self] in
            guard let sSelf = self else {return}
            
            sSelf.aerinInfoContainerBottomConstraint.constant = isHidden ? bottomToShow : 0.0
            sSelf.view.layoutIfNeeded()
        }) { [weak self](isDone) in
            self?.aerinInfoContainerView.isHidden = isHidden
        }
    }
    
    private func registerXib() {
          self.collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
            self.aerinTableView.registerCell(nibName: AerinCurrentStateTableViewCell.reusableIdentifier)
            self.aerinTableView.registerCell(nibName: AerinChatTableViewCell.reusableIdentifier)
    }
    
    private func configurationNavBar() {
      self.topNavigationView.configureNavBar(title: "", isDivider: false)
        self.topNavigationView.delegate = self
        
    }
    
    private func configureAerinInfoView() {
        self.aerinInfoContainerHeightConstraint.constant = UIDevice.screenHeight - (self.statusBarHeight)
        aerinInfoView = AerinTextSpeechInfoHelpView(frame: CGRect.zero)
        if let aerinInfoView = self.aerinInfoView {
            aerinInfoView.delegate = self
            aerinInfoView.frame = aerinInfoContainerView.bounds
            aerinInfoContainerView.addSubview(aerinInfoView)
        }
        updateAerinInfoView()
        self.animateAerinInfoView(isHidden: true, animated: false)
    }
    
    private func updateAerinInfoView() {
        if let aerinInfoView = self.aerinInfoView {
            aerinInfoView.updateData()
        }
    }
    
    // Update HeightOf Collection of and text View
    func manageHeight(_ collectionChatView: UIView, _ textView: UITextView) {
        let minHeight = textView.font!.lineHeight * 1.0
        let maxHeight = textView.font!.lineHeight * 5.0
        
        var chatViewHeight = textView.text.sizeCount(withFont: textView.font!, bundingSize: CGSize(width: (UIDevice.screenWidth - 62.0), height: 1000)).height
        printDebug("chat view height is \(chatViewHeight)")
        
        chatViewHeight = max(minHeight, chatViewHeight)
        chatViewHeight = min(maxHeight, chatViewHeight)
        
//        self.collectionChatTextView.frame = CGRect(x: 0, y: self.collectionChatTextView.frame.origin.y, width: UIDevice.screenWidth, height: self.collectionChatTextViewHeightConstraint.constant + chatViewHeight)
//        self.chatTextViewHeightConstraint.constant = chatViewHeight
        
    }
}


// MARK: - Top Navigation  View Delegate method

extension AerinTextSpeechDetailVC : TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension AerinTextSpeechDetailVC : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200, height: 35.0)
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AerinSuggestionCollectionViewCell else {
            return UICollectionViewCell()
        }
       
        cell.suggestionImageView.image = UIImage(named: images[indexPath.row])
        cell.suggestionTitleLabel.text = text[indexPath.row]
        
        return cell
    }
    
    
}


extension AerinTextSpeechDetailVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = aerinTableView.dequeueReusableCell(withIdentifier: "AerinChatTableViewCell", for: indexPath) as? AerinChatTableViewCell else {
            printDebug("AerinChatTableViewCell not found")
            return UITableViewCell()
        }
        cell.backgroundColor = .red
        cell.chatTextView.isEditable = false
        cell.chatTextView.text = chatArray[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    
}

extension AerinTextSpeechDetailVC: AerinTextSpeechInfoHelpViewDelegate {
    func keyboardButtonTapped() {
        printDebug("keyboard button Tapped")
    }
    
    func speakerButtonTapped() {
        printDebug("speaker button tapped")
    }
    
    func downArrowTapped() {
        self.animateAerinInfoView(isHidden: true, animated: true)
        printDebug("down arrow tapped")
    }
    
    
    
    
}

//MARK: - UITextViewDelegate methods

extension AerinTextSpeechDetailVC {
    func textViewDidChange(_ textView: UITextView) {
       
        // update header
        if textView.text.isEmpty {
            self.chatTextViewButton.isSelected = false
        } else {
            self.chatTextViewButton.isSelected = true

        }
        manageHeight(self.collectionChatTextView, textView)
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if !chatArray.isEmpty {
            self.chatArray[self.indexPath.row] = textView.text
            self.aerinTableView.reloadData()
        }
       
    }
}



// MARK: - AerinChatTableViewCellDelegate methods

extension AerinTextSpeechDetailVC: AerinChatTableViewCellDelegate {
    func tapToEditButtonTapped(_ textView:UITextView) {
        
        if let indexPath = self.aerinTableView.indexPath(forItem: textView) {
            self.indexPath = indexPath
            guard let cell = self.aerinTableView.cellForRow(at: indexPath) as? AerinChatTableViewCell else {
                fatalError("AerinChatTableViewCell not found")
            }
            cell.chatTextView.isEditable = true
            cell.chatTextView.becomeFirstResponder()
        }
        printDebug("edit button Tapped")
    
        
    }
}
