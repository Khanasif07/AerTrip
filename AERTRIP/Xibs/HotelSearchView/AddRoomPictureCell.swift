//
//  AddRoomPictureCell.swift
//  AERTRIP
//
//  Created by Admin on 22/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol RoomDataDelegate: class {
    func adultAndChildData(adultCount: Int , childCount: Int)
}

class AddRoomPictureCell: UICollectionViewCell {
    
    //Mark:- Variables
    //================
    internal weak var delegate: ExpandedCellDelegate?
    internal weak var roomGuestDelegate: RoomGuestSelectionVCDelegate?
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var roomCountLabel: UILabel!
    @IBOutlet weak var adultPopUpBtn: UIButton!
    @IBOutlet weak var cancelBtnOutlet: UIButton!
    @IBOutlet weak var lineView: ATDividerView! {
        didSet {
            self.lineView.alpha = 1.0
        }
    }
    @IBOutlet weak var childPopUpBtn: UIButton!
    @IBOutlet weak var lineViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewTrailingConstraint: NSLayoutConstraint!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //Mark:- IBActions
    //================
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        if let delegate = self.delegate, let idxPath = self.indexPath{
            sender.alpha = 0.5
            UIView.animate(withDuration: AppConstants.kAnimationDuration) {
                delegate.cancelButtonTouched(indexPath: idxPath)
                sender.alpha = 1
            }
        }
    }
    
    //Mark:- Functions
    //================
    //Mark:- Private
    //==============
    ///Configure UI
    private func configureUI() {
        self.stackViewLeadingConstraint.constant = 16.5
        //        self.lineView.backgroundColor = AppColors.divider.color
        self.lineView.isHidden = true
        let regularFontSize16 = AppFonts.Regular.withSize(16.0)
        self.roomCountLabel.font = regularFontSize16
        self.roomCountLabel.textColor = AppColors.themeGray40
        self.adultPopUpBtn.setImage(AppImages.adult_icon, for: .normal)
        self.childPopUpBtn.setImage(AppImages.child_icon, for: .normal)
        self.adultPopUpBtn.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        self.childPopUpBtn.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        self.adultPopUpBtn.setTitleColor(AppColors.textFieldTextColor51, for: .normal)
        self.childPopUpBtn.setTitleColor(AppColors.textFieldTextColor51, for: .normal)
        self.adultPopUpBtn.isUserInteractionEnabled = false
        self.childPopUpBtn.isUserInteractionEnabled = false
        self.backgroundColor = AppColors.themeWhiteDashboard
        
    }
    
    ///Configure Cell
    func hideCrossButton(isHidden: Bool, animated: Bool) {
        if animated {
            UIViewPropertyAnimator(duration: animated ? 0.2 : 0.0, curve: .easeIn) { [weak self] in
                self?.cancelBtnOutlet.isHidden = isHidden
            }.startAnimation()
        }
    }
    
    internal func configureCell(for indexPath: IndexPath, viewModel: HotelsSearchVM, animate: Bool = false) {
        let idxPath = indexPath
        //?? IndexPath(item: 0, section: 0)
        //        self.lineView.backgroundColor = AppColors.divider.color
        self.roomCountLabel.text = "\(LocalizedString.Room.localized) \(idxPath.item + 1)"
        if viewModel.searchedFormData.adultsCount.count == 1 {
            self.hideCrossButton(isHidden: true, animated: false)
            self.cancelBtnOutlet.isHidden = true
            self.lineView.isHidden = true
            if animate {
                UIView.animate(withDuration: 0.4) {  [weak self] in
                    self?.stackViewLeadingConstraint.constant = 16.5
                    self?.contentView.layoutIfNeeded()
                }
            } else {
                self.stackViewLeadingConstraint.constant = 16.5
            }
            //self.stackViewTrailingConstraint.constant = 22.5
        } else{
            if idxPath.item % 2 == 0 {
                if animate {
                    UIView.animate(withDuration: 0.4) {  [weak self] in
                        self?.stackViewTrailingConstraint.constant = 25.5
                        self?.stackViewLeadingConstraint.constant = 20.0
                        self?.contentView.layoutIfNeeded()
                    }
                } else {
                    self.stackViewTrailingConstraint.constant = 25.5
                    self.stackViewLeadingConstraint.constant = 20.0
                }
                
            } else {
                if animate {
                    UIView.animate(withDuration: 0.4) {  [weak self] in
                        self?.stackViewLeadingConstraint.constant = 28.0
                        self?.stackViewTrailingConstraint.constant = 14.5
                        self?.contentView.layoutIfNeeded()
                    }
                } else {
                    self.stackViewLeadingConstraint.constant = 28.0
                    self.stackViewTrailingConstraint.constant = 14.5
                }
            }
            if idxPath.item == 0 || idxPath.item == 1 {
                self.lineView.isHidden = false
                if idxPath.item == 0 {
                    if animate {
                        UIView.animate(withDuration: 0.4) {  [weak self] in
                            self?.lineViewLeadingConstraint.constant = 16.0
                            self?.lineViewTrailingConstraint.constant = 0.0
                            self?.contentView.layoutIfNeeded()
                        }
                    } else {
                        self.lineViewLeadingConstraint.constant = 16.0
                        self.lineViewTrailingConstraint.constant = 0.0
                    }
                } else {
                    if animate {
                        UIView.animate(withDuration: 0.4) {  [weak self] in
                            self?.lineViewLeadingConstraint.constant = 0.0
                            self?.lineViewTrailingConstraint.constant = 16.0
                            self?.contentView.layoutIfNeeded()
                        }
                    } else {
                        self.lineViewLeadingConstraint.constant = 0.0
                        self.lineViewTrailingConstraint.constant = 16.0
                    }
                }
            } else {
                if animate {
                    UIView.animate(withDuration: 0.4) {  [weak self] in
                        self?.lineView.isHidden = true
                        self?.lineViewLeadingConstraint.constant = 0.0
                        self?.contentView.layoutIfNeeded()
                    }
                } else {
                    self.lineView.isHidden = true
                    self.lineViewLeadingConstraint.constant = 0.0
                }
            }
            
            //            self.cancelBtnOutlet.isHidden = false
            self.hideCrossButton(isHidden: false, animated: true)
        }
        if idxPath.item < viewModel.searchedFormData.childrenCounts.count {
            self.childPopUpBtn.isHidden = viewModel.searchedFormData.childrenCounts[idxPath.item] == 0 ? true : false
            self.adultPopUpBtn.setTitle("\(viewModel.searchedFormData.adultsCount[idxPath.item])", for: .normal)
            self.childPopUpBtn.setTitle("\(viewModel.searchedFormData.childrenCounts[idxPath.item])", for: .normal)
        }
    }
}

//Mark:- Room Data Delegate
//=========================
extension AddRoomPictureCell: RoomDataDelegate {
    func adultAndChildData(adultCount: Int, childCount: Int) {
        self.adultPopUpBtn.setTitle("\(adultCount)", for: .normal)
        self.childPopUpBtn.setTitle("\(childCount)", for: .normal)
        if let parent = self.parentViewController as? HotelsSearchVC {
            parent.addRoomCollectionView.reloadData()
        }
    }
}
