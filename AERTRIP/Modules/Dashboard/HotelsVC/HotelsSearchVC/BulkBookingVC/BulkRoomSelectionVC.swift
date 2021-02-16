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
    var initialTouchPoint: CGPoint = CGPoint.zero
    
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
    
    @IBOutlet weak var firstLineView: ATDividerView!
    
    @IBOutlet weak var secondLineView: ATDividerView!
    @IBOutlet weak var roomsPicker: UIPickerView! {
        didSet {
            self.roomsPicker.delegate = self
            self.roomsPicker.dataSource = self
            self.roomsPicker.selectRow(self.viewModel.roomCount - 5 , inComponent: 0, animated: true)
        }
    }
    @IBOutlet weak var adultsPicker: UIPickerView!{
        didSet {
            self.adultsPicker.delegate = self
            self.adultsPicker.dataSource = self
            self.adultsPicker.selectRow(self.viewModel.adultCount - 10, inComponent: 0, animated: true)
        }
    }
    @IBOutlet weak var childrenPicker: UIPickerView!{
        didSet {
            self.childrenPicker.delegate = self
            self.childrenPicker.dataSource = self
            self.childrenPicker.selectRow(self.viewModel.childrenCounts, inComponent: 0, animated: true)
        }
    }
    @IBOutlet weak var safeAreaBackView: UIView!
    
    
    //Mark:- LifeCycles
    //=================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.show(animated: true)
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
        //        self.firstLineView.backgroundColor = AppColors.themeGray10
        //        self.secondLineView.backgroundColor = AppColors.themeGray10
    }
    
    //Mark:- Methods
    //==============
    
    //MARK:- Private
    private func initialSetUp() {
        
        
        //AddGesture:-
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        self.view.isUserInteractionEnabled = true
        swipeGesture.direction = .down
        swipeGesture.delegate = self
        self.view.addGestureRecognizer(swipeGesture)
        
        self.backgroundView.alpha = 1.0
        //self.headerView.roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
        self.mainContainerView.roundTopCorners(cornerRadius: 15.0)
        //        self.headerView.layer.masksToBounds = true
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(tappedOnBackgroundView(_:)))
        self.backgroundView.addGestureRecognizer(tapGest)
        self.hide(animated: false)
//        delay(seconds: 0.05) { [weak self] in
//            self?.show(animated: true)
//        }
        
        if #available(iOS 14.0, *) {
            self.firstLineView.isHidden = true
            self.secondLineView.isHidden = true
        }
    }
     
    private func show(animated: Bool) {
        self.safeAreaBackView.isHidden = false
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            guard let self = self else { return }
            self.safeAreaBackView.alpha = 1.0
            self.headerView.isHidden = self.mainContainerView.size.height > 200.0
            self.mainContainerView.transform = .identity
            self.view.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.3)

        }, completion: { (isDone) in
        })
    }
    
    private func hide(animated: Bool, shouldRemove: Bool = false) {
        self.headerView.isHidden = true
        self.safeAreaBackView.alpha = 0.0
        let heightToChange = self.mainContainerView.height + 100
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            guard let _self = self else { return }
            _self.safeAreaBackView.alpha = 0.0
            _self.mainContainerView.transform = CGAffineTransform(translationX: 0, y: heightToChange)
            _self.view.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.001)

            }, completion: { [weak self] _ in
                guard let _self = self else { return }
                _self.safeAreaBackView.isHidden = true
                if shouldRemove {
                    _self.dismiss(animated: false, completion: nil)
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
            return 97
        case self.adultsPicker:
            return 192
        default:
            return 202
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
            let rowCount = row + 5
            let rowText = rowCount > 100 ? "100+" : "\(rowCount)"
            pickerLabel?.text = rowText
        case self.adultsPicker:
            let rowCount = row + 10
            let rowText = rowCount > 200 ? "200+" : "\(rowCount)"
            pickerLabel?.text = rowText
        default:
            let rowText = row > 200 ? "200+" : "\(row)"
            pickerLabel?.text = rowText
        }
        pickerLabel?.textColor = AppColors.themeBlack
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35.0
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

extension BulkRoomSelectionVC {
    //Handle Swipe Gesture
    @objc func handleSwipes(_ sender: UIPanGestureRecognizer) {
        closeBottomSheet()
    }
    
    func openBottomSheet() {
        self.show(animated: true)
    }
    
    func closeBottomSheet() {
        self.hide(animated: true, shouldRemove: true)
    }
}
