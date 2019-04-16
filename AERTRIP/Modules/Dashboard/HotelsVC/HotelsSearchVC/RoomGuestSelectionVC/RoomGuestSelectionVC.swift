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
    @IBOutlet weak var firstLineView: UIView!
    @IBOutlet weak var secondLineView: UIView!
    @IBOutlet weak var doneButtonBottomConstraint: NSLayoutConstraint!
    
    
    //MARK:- Properties
    //================
    private(set) var viewModel = RoomGuestSelectionVM()
    weak var delegate: RoomGuestSelectionVCDelegate?
    private var containerHeight: CGFloat {
        return 420.0 + AppFlowManager.default.safeAreaInsets.bottom
    }
    private var mainContainerHeight: CGFloat = 0.0
    
    //MARK:- ViewLifeCycle
    //====================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetups()
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
        delay(seconds: 0.1) {
            self.updateSelection(animated: false)
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
        
        //background view
        self.backgroundView.alpha = 1.0
        self.backgroundView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.3)
        self.mainContainerView.roundTopCorners(cornerRadius: 15.0)
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(tappedOnBackgroundView(_:)))
        self.backgroundView.addGestureRecognizer(tapGest)
        
        self.setOldAges()
        self.hide(animated: false)
        delay(seconds: 0.1) { [weak self] in
            self?.show(animated: true)
        }
        
        self.firstLineView.isHidden = true
        self.secondLineView.isHidden = true
        self.doneButtonBottomConstraint.constant = AppFlowManager.default.safeAreaInsets.bottom
    }
    
    private func setOldAges() {
        for picker in self.agePickers {
            picker.dataSource = self
            picker.delegate = self
            if self.viewModel.childrenAge[picker.tag] > 0 {
                picker.selectRow(self.viewModel.childrenAge[picker.tag], inComponent: 0, animated: false)
            }
        }
    }
    
    private func show(animated: Bool) {
        self.mainContainerHeight = (self.mainContainerHeightConstraint.constant + AppFlowManager.default.safeAreaInsets.bottom)
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerBottomConstraints.constant = 0.0
//            self.mainContainerHeightConstraint.constant = self.mainContainerHeightConstraint.constant// - self.agesContainerView.frame.height//280.0
            self.view.layoutIfNeeded()
        })
    }
    
    private func hide(animated: Bool, shouldRemove: Bool = false) {

        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerBottomConstraints.constant = -(self.mainContainerView.height)
            self.view.layoutIfNeeded()
        }, completion: { (isDone) in
            if shouldRemove {
                self.removeFromParentVC
            }
        })
    }
    
    private func updateSelection(animated: Bool = true) {
        
        if self.viewModel.selectedChilds > 0 {
            self.showAgesPicker(animated: animated)
        }
        else {
            self.hideAgesPicker(animated: animated)
        }
        
        //update adults buttons
        for button in self.adultsButtons {
            let oldState = button.isSelected
            button.isSelected = button.tag <= self.viewModel.selectedAdults
            
            if oldState != button.isSelected {
                button.isSelected ? button.selectedState(selectedImage: #imageLiteral(resourceName: "adult_selected")) : button.deselectedState()
            }
        }
        
        //update children buttons
        for button in self.childrenButtons {
            let oldState = button.isSelected
            button.isSelected = button.tag <= self.viewModel.selectedChilds
            
            if oldState != button.isSelected {
                button.isSelected ? button.selectedState(selectedImage: #imageLiteral(resourceName: "child_selected")) : button.deselectedState()
            }
        }
        self.guestSelectionLabel.text = self.viewModel.selectionString
        self.messageLabel.isHidden = (self.viewModel.selectedAdults + self.viewModel.selectedChilds) <= 3
    }
    
    private func enableAgePicker() {
        for picker in self.agePickers {
            picker.isHidden = (picker.tag + 1) > self.viewModel.selectedChilds
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
        self.firstLineView.isHidden = false
        self.secondLineView.isHidden = false
        let mainH = self.containerHeight
        // - self.agesContainerView.frame.height
        //let mainH = self.mainContainerHeight + self.agesContainerView.frame.height
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
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
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.mainContainerHeightConstraint.constant = mainH
            self.ageSelectionLabel.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: { (isDone) in
            self.ageSelectionLabel.isHidden = true
            self.agesContainerView.isHidden = true
        })
    }
    //MARK:- Public
    
    
    //MARK:- Action
    @objc func tappedOnBackgroundView(_ sender: UIGestureRecognizer) {
        self.hide(animated: true, shouldRemove: true)
    }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        self.delegate?.didSelectedRoomGuest(adults: self.viewModel.selectedAdults, children: self.viewModel.selectedChilds, childrenAges: self.viewModel.childrenAge, roomNumber: self.viewModel.roomNumber)
        self.hide(animated: true, shouldRemove: true)
    }
    
    @IBAction func adultsButtonsAction(_ sender: ATGuestButton) {

        if sender.tag == 1 {
            //first button tapped, clear all selection except first adult
            self.viewModel.selectedAdults = sender.tag
            self.updateSelection()
        }
        else {
            var tag = (self.viewModel.selectedAdults >= sender.tag) ? (sender.tag - 1) : sender.tag
            if (tag + self.viewModel.selectedChilds) >= self.viewModel.maxGuest {
                tag = (self.viewModel.maxGuest - self.viewModel.selectedChilds)
            }
            self.viewModel.selectedAdults = tag
            self.updateSelection()
        }
    }
    
    @IBAction func childrenButtonsAction(_ sender: ATGuestButton) {

        var tag = (self.viewModel.selectedChilds >= sender.tag) ? (sender.tag - 1) : sender.tag
        if (tag + self.viewModel.selectedAdults) >= self.viewModel.maxGuest {
            tag = (self.viewModel.maxGuest - self.viewModel.selectedAdults)
        }
        self.viewModel.selectedChilds = tag
        self.updateSelection()
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


