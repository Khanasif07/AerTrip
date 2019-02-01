//
//  RoomGuestSelectionVC.swift
//  AERTRIP
//
//  Created by Admin on 21/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol RoomGuestSelectionVCDelegate: class {
    func didSelectedRoomGuest(adults: Int, children: Int, childrenAges: [Int])
}

class RoomGuestSelectionVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainContainerBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var roomNumberLabel: UILabel!
    @IBOutlet weak var guestSelectionLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var adultsTitleLabel: UILabel!
    @IBOutlet weak var adultsAgeLabel: UILabel!
    @IBOutlet weak var childTitleLabel: UILabel!
    @IBOutlet weak var childAgeLabel: UILabel!
    @IBOutlet var adultsButtons: [UIButton]!
    @IBOutlet weak var adultATBtnOutlet: ATGuestButton!
    @IBOutlet var childrenButtons: [UIButton]!
    @IBOutlet weak var ageSelectionLabel: UILabel!
    @IBOutlet var agePickers: [UIPickerView]!
    @IBOutlet weak var agesContainerView: UIStackView!
    @IBOutlet weak var mainContainerHeightConstraint: NSLayoutConstraint!
    
    
    //MARK:- Properties
    //MARK:- Public
    private(set) var viewModel = RoomGuestSelectionVM()
    weak var delegate: RoomGuestSelectionVCDelegate?
    private var containerHeight: CGFloat {
        return UIDevice.screenHeight * 0.56
    }
    var count = 0
    //MARK:- Private
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func setupFonts() {
        self.doneButton.titleLabel?.font = AppFonts.SemiBold.withSize(16.0)
        
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
        
        self.mainContainerView.roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(tappedOnBackgroundView(_:)))
        self.backgroundView.addGestureRecognizer(tapGest)
        
        self.setOldAges()
        
        self.hide(animated: false)
        delay(seconds: 0.1) { [weak self] in
            self?.show(animated: true)
        }
    }
    
    private func setOldAges() {
        for picker in self.agePickers {
            picker.dataSource = self
            picker.delegate = self
            if self.viewModel.childrenAge[picker.tag] > 0 {
                picker.selectRow(self.viewModel.childrenAge[picker.tag]-1, inComponent: 0, animated: false)
            }
        }
    }
    
    private func show(animated: Bool) {
        
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerBottomConstraints.constant = 0.0
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
            button.isSelected = button.tag <= self.viewModel.selectedAdults
        }
        
        //update children buttons
        for button in self.childrenButtons {
            button.isSelected = button.tag <= self.viewModel.selectedChilds
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
        guard self.mainContainerHeightConstraint.constant != self.containerHeight else {
            return
        }
        
        self.agesContainerView.isHidden = false
        self.ageSelectionLabel.isHidden = false
        let mainH = self.containerHeight
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
        
        let mainH = self.containerHeight - 90.0
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
        self.delegate?.didSelectedRoomGuest(adults: self.viewModel.selectedAdults, children: self.viewModel.selectedChilds, childrenAges: self.viewModel.childrenAge)
        self.hide(animated: true, shouldRemove: true)
    }
    
    @IBAction func adultsButtonsAction(_ sender: UIButton) {

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
        if sender.isSelected {
            sender.dumpingButtonSelectionAnimation()
        } else {
            self.removeImage(sender)
            //sender.dumbingButtonDeselctionAnimation()
        }
        //sender.removeImageBtn()
    }
    
    @IBAction func adultAtBtnAction(_ sender: ATGuestButton) {
        //sender.
        if count%2 == 0 {
            sender.selectedState()
            sender.setImage(#imageLiteral(resourceName: "adult_selected"), for: .selected)
        } else {
            sender.isSpringLoaded = true
            sender.setImage(nil, for: .normal)
            //sender.deselectedState()
        }
        self.count += 1
    }
    
    
    @IBAction func childrenButtonsAction(_ sender: UIButton) {

        var tag = (self.viewModel.selectedChilds >= sender.tag) ? (sender.tag - 1) : sender.tag
        if (tag + self.viewModel.selectedAdults) >= self.viewModel.maxGuest {
            tag = (self.viewModel.maxGuest - self.viewModel.selectedAdults)
        }
        self.viewModel.selectedChilds = tag
        self.updateSelection()
        
        if sender.isSelected {
            sender.dumpingButtonSelectionAnimation()
        } else {
            sender.dumbingButtonDeselctionAnimation()
        }
    }
    
    private func removeImage(_ sender: UIButton) {
        sender.transform = .identity
        sender.setImage(#imageLiteral(resourceName: "adult_selected"), for: .normal)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0, options: .allowAnimatedContent, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (true) in
            sender.transform = .identity
            sender.setImage(#imageLiteral(resourceName: "adult_deSelected"), for: .normal)
        }
    }
}

//MARK:- UIPicker View data source and delegate
//MARK:-
extension RoomGuestSelectionVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 12
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = AppFonts.Regular.withSize(23.0)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = "\(row + 1)"
        pickerLabel?.textColor = AppColors.themeBlack
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.viewModel.childrenAge[pickerView.tag] = row + 1
    }
}


