//
//  BulkRoomSelectionVC.swift
//  AERTRIP
//
//  Created by Admin on 05/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol BulkRoomSelectionVCDelegate: class {
    func didSelectRooms(rooms: Int, adults: Int, children: Int)
}

class BulkRoomSelectionVC: BaseVC {

    //Mark:- Variables
    //================
    weak var delegate: BulkRoomSelectionVCDelegate?
    private(set) var viewModel = BulkRoomSelectionVM()

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var adultLabel: UILabel!
    @IBOutlet weak var adultAgeLabel: UILabel!
    @IBOutlet weak var childLabel: UILabel!
    @IBOutlet weak var childAgeLabel: UILabel!
    @IBOutlet weak var firstLineView: UIView!
    @IBOutlet weak var secondLineView: UIView!
    @IBOutlet var roomsPicker: UIPickerView! {
        didSet {
            self.roomsPicker.delegate = self
            self.roomsPicker.dataSource = self
            self.roomsPicker.selectRow(self.viewModel.roomCount - 5 , inComponent: 0, animated: true)
        }
    }
    @IBOutlet var adultsPicker: UIPickerView!{
        didSet {
            self.adultsPicker.delegate = self
            self.adultsPicker.dataSource = self
            self.adultsPicker.selectRow(self.viewModel.adultCount - 10, inComponent: 0, animated: true)
        }
    }
    @IBOutlet var childrenPicker: UIPickerView!{
        didSet {
            self.childrenPicker.delegate = self
            self.childrenPicker.dataSource = self
            self.childrenPicker.selectRow(self.viewModel.childrenCounts, inComponent: 0, animated: true)
        }
    }

    
    //Mark:- LifeCycles
    //=================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetUp()
    }
    
    override func setupFonts() {
        let regularFont17 = AppFonts.Regular.withSize(17.0)
        let regularFont14 = AppFonts.Regular.withSize(14.0)
        self.doneButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
        self.roomLabel.font = regularFont17
        self.adultLabel.font = regularFont17
        self.adultAgeLabel.font = regularFont14
        self.childLabel.font = regularFont17
        self.childAgeLabel.font =  regularFont14
    }
    
    override func setupTexts() {
        self.doneButton.setTitle(LocalizedString.Done.localized, for: UIControl.State.normal)
        self.doneButton.setTitle(LocalizedString.Done.localized, for: UIControl.State.selected)
        self.roomLabel.text = LocalizedString.Rooms.localized
        self.adultLabel.text = LocalizedString.Adults.localized
        self.adultAgeLabel.text = LocalizedString.AdultsAges.localized
        self.childLabel.text = LocalizedString.Children.localized
        self.childAgeLabel.text = LocalizedString.ChildAges.localized
    }
    
    override func setupColors() {
        self.doneButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.doneButton.setTitleColor(AppColors.themeGreen, for: .selected)
        self.roomLabel.textColor = AppColors.themeBlack
        self.adultLabel.textColor = AppColors.themeBlack
        self.adultAgeLabel.textColor = AppColors.themeGray40
        self.childLabel.textColor = AppColors.themeBlack
        self.childAgeLabel.textColor = AppColors.themeGray40
        self.firstLineView.backgroundColor = AppColors.themeGray10
        self.secondLineView.backgroundColor = AppColors.themeGray10
    }
    
    //Mark:- Methods
    //==============
    
    //MARK:- Private
    private func initialSetUp() {
        self.backgroundView.alpha = 1.0
        self.backgroundView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.3)
        //self.headerView.roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
        self.headerView.cornerRadius = 15.0
        self.headerView.layer.masksToBounds = true
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(tappedOnBackgroundView(_:)))
        self.backgroundView.addGestureRecognizer(tapGest)
        self.hide(animated: false)
        delay(seconds: 0.1) { [weak self] in
            self?.show(animated: true)
        }
    }
    
    private func show(animated: Bool) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerBottomConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }, completion: { (isDone) in
        })
    }

    private func hide(animated: Bool, shouldRemove: Bool = false) {
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: {
            self.mainContainerBottomConstraint.constant = -(self.mainContainerView.height + 100)
            self.view.layoutIfNeeded()
        }, completion: { (isDone) in
            if shouldRemove {
                self.removeFromParentVC
            }
        })
    }
    
    //MARK:- IBAction
    //===============
    @objc func tappedOnBackgroundView(_ sender: UIGestureRecognizer) {
        self.hide(animated: true, shouldRemove: true)
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        self.delegate?.didSelectRooms(rooms: self.viewModel.roomCount, adults: self.viewModel.adultCount, children: self.viewModel.childrenCounts)
        self.view.endEditing(true)
        self.hide(animated: true, shouldRemove: true)
    }
}

//Mark:- UIPicker View data source and delegate
//=============================================

extension BulkRoomSelectionVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView.subviews.forEach({
            $0.isHidden = $0.frame.height < 1.0
        })
        switch pickerView {
        case self.roomsPicker:
            return 96
        case self.adultsPicker:
            return 191
        default:
            return 201
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = AppFonts.Regular.withSize(23.0)
            pickerLabel?.textAlignment = .center
        }
        switch pickerView {
        case self.roomsPicker:
            pickerLabel?.text = "\(row + 5)"
        case self.adultsPicker:
            pickerLabel?.text = "\(row + 10)"
        default:
            pickerLabel?.text = "\(row + 0)"
        }
        pickerLabel?.textColor = AppColors.themeBlack
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case self.roomsPicker:
            self.viewModel.roomCount = row + 5
        case self.adultsPicker:
            self.viewModel.adultCount = row + 10
        default:
            self.viewModel.childrenCounts = row + 0
        }
    }
}
