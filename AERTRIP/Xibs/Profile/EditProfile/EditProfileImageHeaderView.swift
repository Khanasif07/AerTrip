//
//  EditProfileImageHeaderView.swift
//  AERTRIP
//
//  Created by apple on 21/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol EditProfileImageHeaderViewDelegate:class {
    func editButtonTapped()
    func salutationViewTapped()
    func selectGroupTapped()
}

class EditProfileImageHeaderView: UIView {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var salutationView: UIView!
    @IBOutlet weak var salutaionLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var groupTitleLabel: UILabel!
    
    @IBOutlet weak var selectGroupViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectGroupView: UIView!
    
    // MARK: - Variables
    weak var delegate : EditProfileImageHeaderViewDelegate?
    
    override func awakeFromNib() {
        editButton.setTitle(LocalizedString.Edit.rawValue.localizedLowercase, for: .normal)
        salutaionLabel.text = LocalizedString.Title.rawValue
        firstNameTextField.placeholder = LocalizedString.FirstName.rawValue
        lastNameTextField.placeholder = LocalizedString.LastName.rawValue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.salutationView(_:)))
        salutationView.isUserInteractionEnabled = true
        salutationView.addGestureRecognizer(tap)
        
        let selectGrouptap = UITapGestureRecognizer(target: self, action: #selector(self.selectGroupTapped(_:)))
        selectGroupView.isUserInteractionEnabled = true
        selectGroupView.addGestureRecognizer(selectGrouptap)
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.layer.borderColor = AppColors.themeGray40.cgColor
        self.profileImageView.layer.borderWidth = 2.0
        self.profileImageView.clipsToBounds = true
        
        self.groupTitleLabel.text = LocalizedString.Group.localized
        
    }
    
    // MARK: - Helper methods
    
    class func instanceFromNib() -> EditProfileImageHeaderView {
        return UINib(nibName: "EditProfileImageHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EditProfileImageHeaderView
    }
    
    
    // MARK: - IB Actions
    
    @IBAction func editButtonTapped(_ sender: Any) {
        delegate?.editButtonTapped()
        }
    
    @objc  func salutationView(_ sender: UITapGestureRecognizer) {
        delegate?.salutationViewTapped()
    }
    
    
    @objc  func selectGroupTapped(_ sender: UITapGestureRecognizer) {
        delegate?.selectGroupTapped()
    }
    
    
    

}
