//
//  RoomGuestSelectionVC.swift
//  AERTRIP
//
//  Created by Admin on 21/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol RoomGuestSelectionVCDelegate: class {
    func didSelectedRoomGuest(adults: Int, children: Int, childrenAges: [Int], roomNumber: Int)
}

class RoomGuestSelectionVC: BaseVC {
    
    //MARK:- IBOutlets
    //================
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainContainerBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var roomNumberLabel: UILabel!
    @IBOutlet weak var guestSelectionLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var adultsTitleLabel: UILabel!
    @IBOutlet weak var adultsAgeLabel: UILabel!
    @IBOutlet weak var childTitleLabel: UILabel!
    @IBOutlet weak var childAgeLabel: UILabel!
    @IBOutlet var adultsButtons: [ATGuestButton]!
    @IBOutlet var childrenButtons: [ATGuestButton]!
    @IBOutlet weak var ageSelectionLabel: UILabel!
    @IBOutlet var agePickers: [UIPickerView]!
    @IBOutlet weak var agesContainerView: UIStackView!
    @IBOutlet weak var mainContainerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var firstLineView: ATDividerView!
    @IBOutlet weak var secondLineView: ATDividerView!
    @IBOutlet weak var doneButtonBottomConstraint: NSLayoutConstraint!
    
    
    //MARK:- Properties
    //================
    private(set) var viewModel = RoomGuestSelectionVM()
    var initialTouchPoint: CGPoint = CGPoint.zero
    weak var delegate: RoomGuestSelectionVCDelegate?
    private var containerHeight: CGFloat {
        return 420.0 + AppFlowManager.default.safeAreaInsets.bottom
    }
    private var mainContainerHeight: CGFloat = 0.0
    var viewTranslation = CGPoint(x: 0, y: 0)
    //MARK:- ViewLifeCycle
    //====================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetups()
        self.view.layoutIfNeeded()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.show(animated: true)
    }
    
    override func setupFonts() {
        self.doneButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
        
        self.roomNumberLabel.font = AppFonts.SemiBold.withSize(17.0)
        self.guestSelectionLabel.font = AppFonts.Regular.withSize(14.0)
        self.messageLabel.font = AppFonts.Regular.withSize(14.0)
        
        self.adultsTitleLabel.font = AppFonts.Regular.withSize(17.0)
        self.adultsAgeLabel.font = AppFonts.Regular.withSize(14.0)
        
        self.childTitleLabel.font = AppFonts.Regular.withSize(17.0)
        self.childAgeLabel.font = AppFonts.Regular.withSize(14.0)
        
        self.ageSelectionLabel.font = AppFonts.Regular.withSize(17.0)
    }
    
    override func setupTexts() {
        self.doneButton.setTitle(LocalizedString.Done.localized, for: UIControl.State.normal)
        self.doneButton.setTitle(LocalizedString.Done.localized, for: UIControl.State.selected)
        
        self.roomNumberLabel.text = "\(LocalizedString.Room.localized) \(self.viewModel.roomNumber)"
        delay(seconds: 0.0) {
            self.updateSelection(animated: false, needToChangePickerViewHeight: true)
        }
        
        self.messageLabel.text = LocalizedString.MostHotelsTypicallyAllow.localized
        
        self.adultsTitleLabel.text = LocalizedString.Adults.localized
        self.adultsAgeLabel.text = LocalizedString.AdultsAges.localized
        
        self.childTitleLabel.text = LocalizedString.Children.localized
        self.childAgeLabel.text = LocalizedString.ChildAges.localized
        
        self.ageSelectionLabel.text = LocalizedString.ageInYrs.localized
    }
    
    override func setupColors() {
        self.doneButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.doneButton.setTitleColor(AppColors.themeGreen, for: .selected)
        self.doneButton.addShadow(cornerRadius: 0.0, shadowColor: AppColors.themeBlack.withAlphaComponent(0.2), offset: CGSize(width: 0, height: -8))
        
        self.roomNumberLabel.textColor = AppColors.themeBlack
        self.guestSelectionLabel.textColor = AppColors.themeGray40
        self.messageLabel.textColor = AppColors.themeOrange
        
        self.adultsTitleLabel.textColor = AppColors.themeBlack
        self.adultsAgeLabel.textColor = AppColors.themeGray40
        
        self.childTitleLabel.textColor = AppColors.themeBlack
        self.childAgeLabel.textColor = AppColors.themeGray40
        
        self.ageSelectionLabel.textColor = AppColors.themeBlack
    }
    
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        
        //AddGesture:-
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        self.view.isUserInteractionEnabled = true
        swipeGesture.direction = .down
        swipeGesture.delegate = self
        self.view.addGestureRecognizer(swipeGesture)
        
        //background view
        self.backgroundView.alpha = 1.0
        self.backgroundView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.001)
        self.mainContainerView.roundTopCorners(cornerRadius: 15.0)
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(tappedOnBackgroundView(_:)))
        self.backgroundView.addGestureRecognizer(tapGest)
        
        self.setOldAges()
        self.hide(animated: false)
        //        delay(seconds: 0.0) { [weak self] in
        //            self?.show(animated: true)
        //        }
        
        self.firstLineView.isHidden = true
        self.secondLineView.isHidden = true
        self.doneButtonBottomConstraint.constant = AppFlowManager.default.safeAreaInsets.bottom
        
    }
    
    private func setOldAges() {
        for picker in self.agePickers {
            picker.dataSource = self
            picker.delegate = self
            if self.viewModel.childrenAge[picker.tag] >= 0 {
                picker.selectRow(self.viewModel.childrenAge[picker.tag], inComponent: 0, animated: false)
            } else {
                picker.selectRow(3, inComponent: 0, animated: false)
            }
            picker.reloadAllComponents()
        }
    }
    
    private func show(animated: Bool) {
        self.mainContainerHeight = (self.mainContainerHeightConstraint.constant + AppFlowManager.default.safeAreaInsets.bottom)
        
        func setValue() {
            self.mainContainerBottomConstraints.constant = 0.0
            self.view.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.3)
            self.view.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, delay: 0, options: .curveEaseInOut, animations: {
                setValue()
            }, completion: { (isDone) in
            })
        }
        else {
            setValue()
        }
    }
    
    private func hide(animated: Bool, shouldRemove: Bool = false) {
        
        func setValue() {
            self.mainContainerBottomConstraints.constant = -(self.mainContainerView.height)
            self.view.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.001)
            self.view.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, delay: 0, options: .curveEaseIn, animations: {
                setValue()
            }, completion: { (isDone) in
                if shouldRemove {
                    self.dismiss(animated: false, completion: nil)
                }
            })
            //            UIView.animate(withDuration: animated ? AppConstants.kCloseAnimationDuration : 0.0, animations: {
            //                setValue()
            //            }, completion: { (isDone) in
            //                if shouldRemove {
            //                    self.removeFromParentVC
            //                }
            //            })
        }
        else {
            setValue()
        }
    }
    
    private func updateSelection(animated: Bool = true , needToChangePickerViewHeight: Bool) {
        if needToChangePickerViewHeight { 
            if self.viewModel.selectedChilds > 0 {
                self.showAgesPicker(animated: animated)
            }
            else {
                self.hideAgesPicker(animated: animated)
            }
        } else {
            printDebug("Adult Button Pressed")
        }
        
        
        //update adults buttons
        for button in self.adultsButtons {
            let oldState = button.isSelected
            button.isSelected = button.tag <= self.viewModel.selectedAdults
            
            if oldState != button.isSelected {
                if button.isSelected == true { //self.selectButtonAnimation(button: button,isFirstTime: animated)
                } else {
                    //self.deselectButtonAnimation(button: button,isFirstTime: animated)
                }
            }
        }
        
        //update children buttons
        for button in self.childrenButtons {
            let oldState = button.isSelected
            button.isSelected = button.tag <= self.viewModel.selectedChilds
            
            if oldState != button.isSelected {
                if button.isSelected == true  { //self.selectButtonAnimation(button: button,isFirstTime: animated)
                } else {
                    //self.deselectButtonAnimation(button: button,isFirstTime: animated)
                }
            }
        }
        
        self.guestSelectionLabel.text = self.viewModel.selectionString
        self.messageLabel.isHidden = (self.viewModel.selectedAdults + self.viewModel.selectedChilds) <= 3
    }
    
    func selectButtonAnimation(button: UIButton,isFirstTime: Bool = false){
        //Total animation duration is 1.0 seconds - This time is inside the
        if isFirstTime {
            UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.33, animations: {
                    //1.Expansion + button label alpha
                    button.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.33, animations: {
                    //2.Shrink
                    button.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.33, animations: {
                    //4.Move out of screen and reduce alpha to 0
                    button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            }) { (completed) in
                //Completion of whole animation sequence
            }
        }
    }
    
    func deselectButtonAnimation(button: UIButton,isFirstTime: Bool = false){
        //Total animation duration is 1.0 seconds - This time is inside the
        //        if isFirstTime {
        //            UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, options: [], animations: {
        //                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.33, animations: {
        //                    //1.Expansion + button label alpha
        //                    button.imageView?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        //                })
        //                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.33, animations: {
        //                    //2.Shrink
        //                    button.imageView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        //                })
        //                UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.33, animations: {
        //                    //4.Move out of screen and reduce alpha to 0
        //                    button.imageView?.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        //                })
        //            }) { (completed) in
        //                //Completion of whole animation sequence
        //                button.imageView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        //            }
        //        }
    }
    
    private func enableAgePicker() {
        for picker in self.agePickers {
            if (picker.tag + 1) > self.viewModel.selectedChilds {
                picker.isHidden = true
                self.viewModel.childrenAge[picker.tag] = 3
                picker.selectRow(3, inComponent: 0, animated: false)
            } else {
                picker.isHidden = false
            }
            
            
        }
    }
    
    private func showAgesPicker(animated: Bool) {
        self.enableAgePicker()
        /*
         guard self.mainContainerHeightConstraint.constant != self.containerHeight else {
         return
         }
         */
        guard self.mainContainerHeightConstraint.constant <= self.containerHeight else {
            return
        }
        
        self.agesContainerView.isHidden = false
        self.ageSelectionLabel.isHidden = false
        if #available(iOS 14.0, *) {} else {
            self.firstLineView.isHidden = false
            self.secondLineView.isHidden = false
        }
        let mainH = self.containerHeight
        // - self.agesContainerView.frame.height
        //let mainH = self.mainContainerHeight + self.agesContainerView.frame.height
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseInOut], animations: {
            //        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.mainContainerHeightConstraint.constant = mainH
            self.ageSelectionLabel.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: { (isDone) in
        })
    }
    
    private func hideAgesPicker(animated: Bool) {
        self.enableAgePicker()
        guard self.mainContainerHeightConstraint.constant <= self.containerHeight else {
            return
        }
        
        //let mainH = self.containerHeight - 90.0
        self.firstLineView.isHidden = true
        self.secondLineView.isHidden = true
        let mainH = self.mainContainerHeight - self.agesContainerView.frame.height
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseInOut], animations: {
            //        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.mainContainerHeightConstraint.constant = mainH
            self.ageSelectionLabel.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { (isDone) in
            self.ageSelectionLabel.isHidden = true
            self.agesContainerView.isHidden = true
        })
    }
    
    private func applyRoomChanges() {
        self.delegate?.didSelectedRoomGuest(adults: self.viewModel.selectedAdults, children: self.viewModel.selectedChilds, childrenAges: self.viewModel.childrenAge, roomNumber: self.viewModel.roomNumber)
    }
    //MARK:- Public
    
    
    //MARK:- Action
    @objc func tappedOnBackgroundView(_ sender: UIGestureRecognizer) {
        applyRoomChanges()
        self.hide(animated: true, shouldRemove: true)
    }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        applyRoomChanges()
        self.hide(animated: true, shouldRemove: true)
    }
    
    @IBAction func adultsButtonsAction(_ sender: ATGuestButton) {
        var showMessage = false
        if sender.tag == 1 {
            //first button tapped, clear all selection except first adult
            self.viewModel.selectedAdults = sender.tag
            self.updateSelection(needToChangePickerViewHeight: false)
        }
        else {
            var tag = sender.tag//(self.viewModel.selectedAdults >= sender.tag) ? (sender.tag - 1) : sender.tag
            showMessage = (tag + self.viewModel.selectedAdults) > self.viewModel.maxGuest
            if (tag + self.viewModel.selectedChilds) >= self.viewModel.maxGuest {
                tag = (self.viewModel.maxGuest - self.viewModel.selectedChilds)
            }
            // need to remove unselect on tap of selected uncomment comment logic
            //            self.viewModel.selectedAdults = tag
            self.viewModel.selectedAdults = (self.viewModel.selectedAdults == tag) ? (tag - 1) : tag
            self.updateSelection(needToChangePickerViewHeight: false)
        }
        if showMessage {
            self.checkForMaximumGuest()
        }
    }
    
    @IBAction func childrenButtonsAction(_ sender: ATGuestButton) {
        var tag = (self.viewModel.selectedChilds >= sender.tag) ? (sender.tag - 1) : sender.tag
        let showMessage = (tag + self.viewModel.selectedAdults) > self.viewModel.maxGuest
        if (tag + self.viewModel.selectedAdults) >= self.viewModel.maxGuest {
            tag = (self.viewModel.maxGuest - self.viewModel.selectedAdults)
        }
        self.viewModel.selectedChilds = tag
        self.updateSelection(needToChangePickerViewHeight: true)
        if showMessage {
            self.checkForMaximumGuest()
        }
    }
    
    func checkForMaximumGuest() {
        //        if (self.viewModel.selectedAdults + self.viewModel.selectedChilds) >= 6 {
        AppToast.default.showToastMessage(message: LocalizedString.MaxGuestSelectionMessage.localized)
        //        }
    }
}

//MARK:- UIPicker View data source and delegate
//MARK:-
extension RoomGuestSelectionVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        return 13
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = AppFonts.Regular.withSize(23.0)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = (row == 0) ? "<1" : "\(row)"
        pickerLabel?.textColor = AppColors.themeBlack
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.viewModel.childrenAge[pickerView.tag] = row
    }
}


extension RoomGuestSelectionVC {
    //Handle Swipe Gesture
    @objc func handleSwipes(_ sender: UIPanGestureRecognizer) {
        closeBottomSheet()
    }
    
    func openBottomSheet() {
        self.show(animated: true)
    }
    
    func closeBottomSheet() {
        applyRoomChanges()
        self.hide(animated: true, shouldRemove: true)
    }
}
