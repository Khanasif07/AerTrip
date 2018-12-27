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
}

class EditProfileImageHeaderView: UIView {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var salutationView: UIView!
    @IBOutlet weak var salutaionLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
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
    
    
    

}
