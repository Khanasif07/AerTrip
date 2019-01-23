//
//  AddRoomPictureCell.swift
//  AERTRIP
//
//  Created by Admin on 22/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol RoomDataDelegate: class {
    func adultAndChildData(adultCount: Int , child: Int)
}

class AddRoomPictureCell: UICollectionViewCell {

    //Mark:- Variables
    //================
    internal weak var delegate: ExpandedCellDelegate?
    internal var indexPath:IndexPath!
    
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
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.configureUI()
    }

    //Mark:- IBActions
    //================
    @IBAction func roomPopUpAction(_ sender: UIButton) {
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        if let delegate = self.delegate{
            delegate.cancelButtonTouched(indexPath: indexPath)
        }
    }
    
    //Mark:- Functions
    //================
    //Mark:- Private
    //==============
    private func configureUI() {
        self.lineView.backgroundColor = AppColors.divider.color
        self.lineView.isHidden = true
        let regularFontSize16 = AppFonts.Regular.withSize(16.0)
        self.roomCountLabel.font = regularFontSize16
        self.roomCountLabel.textColor = AppColors.themeGray40
        self.adultCountLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.adultCountLabel.textColor = AppColors.textFieldTextColor51
    }
}
