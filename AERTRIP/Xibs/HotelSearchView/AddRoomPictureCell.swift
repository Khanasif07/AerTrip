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
    @IBOutlet weak var adultStackView: UIStackView!
    @IBOutlet weak var adultPopUpBtn: UIButton!
    @IBOutlet weak var adultCountLabel: UILabel!
    @IBOutlet weak var cancelBtnOutlet: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var lineViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var childStackView: UIStackView!
    @IBOutlet weak var childPopUpBtn: UIButton!
    @IBOutlet weak var childCountLabel: UILabel!
    @IBOutlet weak var roomCountLabelLeadingConstraint: NSLayoutConstraint!
    
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.configureUI()
    }
    
    //Mark:- IBActions
    //================
    @IBAction func adultPopUpAction(_ sender: UIButton) {
    }
    
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
        self.adultCountLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.adultCountLabel.textColor = AppColors.textFieldTextColor51
        self.adultPopUpBtn.isUserInteractionEnabled = false
        self.childPopUpBtn.isUserInteractionEnabled = false
    }
    
    ///Configure Cell
    internal func configureCell(viewModel: HotelsSearchVM) {
        self.roomCountLabel.text = "\(LocalizedString.Room.localized) \(indexPath.item + 1)"
        //roomData.count == 2
        if viewModel.adultsCount.count == 1 {
            self.cancelBtnOutlet.isHidden = true
            self.lineView.isHidden = true
            //self.childStackView.isHidden = true
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
            self.childStackView.isHidden = viewModel.childrenCounts[indexPath.item] == 0 ? true : false
            self.adultCountLabel.text = "\(viewModel.adultsCount[indexPath.item])"
            self.childCountLabel.text = "\(viewModel.childrenCounts[indexPath.item])"
        }
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.roomCountLabelLeadingConstraint.constant = (self.cancelBtnOutlet.isHidden ? self.centerX/1.5 : 40.0)
            self.layoutIfNeeded()
        })
    }
}

//Mark:- Room Data Delegate
//=========================
extension AddRoomPictureCell: RoomDataDelegate {
    func adultAndChildData(adultCount: Int, childCount: Int) {
        self.adultCountLabel.text = "\(adultCount)"
        self.childCountLabel.text = "\(childCount)"
        if let parent = self.parentViewController as? HotelsSearchVC {
            parent.addRoomCollectionView.reloadData()
        }
    }
}
