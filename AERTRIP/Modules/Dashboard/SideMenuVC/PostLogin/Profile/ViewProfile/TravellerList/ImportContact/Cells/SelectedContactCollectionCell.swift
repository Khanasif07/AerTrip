//
//  SelectedContactCollectionCell.swift
//  AERTRIP
//
//  Created by Admin on 09/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SelectedContactCollectionCellDelegate: class {
    func crossButtonAction(_ sender: UIButton)
}

class SelectedContactCollectionCell: UICollectionViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    weak var delegate: SelectedContactCollectionCellDelegate?

    var contact: ATContact? {
        didSet {
            self.populateData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetup()
        self.setupTextAndColor()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.profileImageView.layer.cornerRadius = self.profileImageView.height / 2.0
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.borderColor = AppColors.themeGray40.cgColor
        self.profileImageView.layer.borderWidth = 1.0
    }
    
    private func initialSetup() {
        self.crossButton.layer.cornerRadius = self.crossButton.height / 2.0
        self.crossButton.layer.masksToBounds = true
        self.crossButton.layer.borderColor = AppColors.themeWhite.cgColor
        self.crossButton.layer.borderWidth = 1.0
        self.crossButton.addTarget(self, action: #selector(crossButtonAction(_:)), for: UIControl.Event.touchUpInside)
    }
    
    private func setupTextAndColor() {
        self.nameLabel.font = AppFonts.Regular.withSize(14.0)
        self.nameLabel.textColor = AppColors.themeBlack
    }
    
    private func populateData() {
        self.nameLabel.text = self.contact?.firstName ?? ""
        
        let placeholder = AppGlobals.shared.getImageFor(firstName: self.contact?.firstName, lastName: self.contact?.lastName, offSet: CGPoint(x: 0.0, y: 9.0))
        self.profileImageView.image = placeholder
        if let imgData = self.contact?.imageData {
            self.profileImageView.image = UIImage(data: imgData)
        }
        else if let img = self.contact?.image, !img.isEmpty {
            self.profileImageView.setImageWithUrl(img, placeholder: placeholder, showIndicator: false)
        }        
    }
    
    @objc func crossButtonAction(_ sender: UIButton) {
        self.delegate?.crossButtonAction(sender)
    }
}
