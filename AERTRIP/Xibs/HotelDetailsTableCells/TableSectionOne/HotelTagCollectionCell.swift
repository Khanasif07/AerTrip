//
//  HotelTagCollectionCell.swift
//  AERTRIP
//
//  Created by Admin on 02/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol DeleteTagButtonDelegate: class {
    func deleteTagButton(indexPath: IndexPath)
}

class HotelTagCollectionCell: UICollectionViewCell {
    
    //Mark:- Variables
    //================
    internal var currentTagButton: String = ""
    internal weak var delegate: DeleteTagButtonDelegate?
    
    //Mark:- IBOutlets
    //
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tagOptionNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    ///ConfigureUI
    private func configureUI() {
        self.backgroundColor = AppColors.screensBackground.color
        self.containerView.layer.cornerRadius = 14.0
        self.containerView.layer.borderWidth = 0.6
        self.containerView.layer.masksToBounds = true
        //Color
        self.containerView.backgroundColor = AppColors.iceGreen
        self.containerView.layer.borderColor = AppColors.themeGreen.cgColor
        //Text Color
        self.tagOptionNameLabel.tintColor = AppColors.themeGreen
        //Font
        self.tagOptionNameLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.cancelButton.setImage(#imageLiteral(resourceName: "cross_icon").withRenderingMode(.alwaysTemplate), for: .normal)
        self.cancelButton.imageView?.contentMode = .scaleAspectFit
        self.cancelButton.imageEdgeInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    }
    
    internal func configureCell(tagTitle: String, titleColor: UIColor , tagBtnColor: UIColor) {
        self.tagOptionNameLabel.text = tagTitle
        self.tagOptionNameLabel.textColor = titleColor
        self.cancelButton.imageView?.tintColor = titleColor
        self.containerView.backgroundColor = tagBtnColor
        self.containerView.layer.borderColor = titleColor.cgColor
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        if let safeDelegate = self.delegate, let indexPath = self.indexPathForCell {
            safeDelegate.deleteTagButton(indexPath: indexPath)
        }
//        if let parentView = self.rootSuperView() as? SearchBarHeaderView, parentView.tagButtons.contains(self.currentTagButton) {
//            parentView.tagButtons.remove(object: currentTagButton)
//            parentView.tagCollectionView.reloadData()
//        }
        printDebug("cancel button tapped")
    }
}
