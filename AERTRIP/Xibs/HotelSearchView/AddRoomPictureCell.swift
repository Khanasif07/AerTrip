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
    internal var indexPath:IndexPath!
    internal weak var roomGuestDelegate: RoomGuestSelectionVCDelegate?
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var roomCountLabel: UILabel!
    @IBOutlet weak var adultPopUpBtn: UIButton!
    @IBOutlet weak var cancelBtnOutlet: UIButton!
    @IBOutlet weak var lineView: ATDividerView! {
        didSet {
            self.lineView.alpha = 0.6
        }
    }
    @IBOutlet weak var childPopUpBtn: UIButton!
    @IBOutlet weak var lineViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineViewTrailingConstraint: NSLayoutConstraint!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    //Mark:- IBActions
    //================
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        if let delegate = self.delegate{
            sender.alpha = 0.5
            UIView.animate(withDuration: AppConstants.kAnimationDuration) {
                delegate.cancelButtonTouched(indexPath: self.indexPath)
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
        self.lineView.backgroundColor = AppColors.divider.color
        self.lineView.isHidden = true
        let regularFontSize16 = AppFonts.Regular.withSize(16.0)
        self.roomCountLabel.font = regularFontSize16
        self.roomCountLabel.textColor = AppColors.themeGray40
        self.adultPopUpBtn.setImage(#imageLiteral(resourceName: "adult_icon"), for: .normal)
        self.childPopUpBtn.setImage(#imageLiteral(resourceName: "child_icon"), for: .normal)
        self.adultPopUpBtn.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        self.childPopUpBtn.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        self.adultPopUpBtn.setTitleColor(AppColors.textFieldTextColor51, for: .normal)
        self.childPopUpBtn.setTitleColor(AppColors.textFieldTextColor51, for: .normal)
        self.adultPopUpBtn.isUserInteractionEnabled = false
        self.childPopUpBtn.isUserInteractionEnabled = false
    }
    
    ///Configure Cell
    internal func configureCell(viewModel: HotelsSearchVM) {
        self.lineView.backgroundColor = AppColors.divider.color
        self.roomCountLabel.text = "\(LocalizedString.Room.localized) \(indexPath.item + 1)"
        if viewModel.adultsCount.count == 1 {
            self.cancelBtnOutlet.isHidden = true
            self.lineView.isHidden = true
        } else{
            if indexPath.item == 0 || indexPath.item == 1 {
                self.lineView.isHidden = false
                if indexPath.item == 0 {
                    self.lineViewLeadingConstraint.constant = 16.0
                    self.lineViewTrailingConstraint.constant = 0.0
                } else {
                    self.lineViewLeadingConstraint.constant = 0.0
                    self.lineViewTrailingConstraint.constant = 16.0
                }
            } else {
                self.lineView.isHidden = true
                self.lineViewLeadingConstraint.constant = 0.0
            }
            self.cancelBtnOutlet.isHidden = false
        }
        if indexPath.item < 4 {
            self.childPopUpBtn.isHidden = viewModel.childrenCounts[indexPath.item] == 0 ? true : false
            self.adultPopUpBtn.setTitle("\(viewModel.adultsCount[indexPath.item])", for: .normal)
            self.childPopUpBtn.setTitle("\(viewModel.childrenCounts[indexPath.item])", for: .normal)
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
