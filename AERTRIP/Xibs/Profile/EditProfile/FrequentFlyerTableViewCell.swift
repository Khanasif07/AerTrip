//
//  FrequentFlyerTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 28/01/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

protocol FrequentFlyerTableViewCellDelegate: class {
    func frequentFlyerTaped(_ indexPath: IndexPath)
    func programTextField(_ indexPath: IndexPath)
    func numberTextField(_ indexPath: IndexPath, _ number: String)
    func deleteCellTapped(_ indexPath: IndexPath)
    
}

class FrequentFlyerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var leftTextField: UITextField!
    //    @IBOutlet weak var rightTitleLabel: UILabel!
    @IBOutlet weak var rightTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var frequentFlyerView: UIView!
    @IBOutlet weak var frequentFlyerTextField: UITextField!
    @IBOutlet weak var frequentFlyerImageView: UIImageView!
    @IBOutlet weak var frequentFlyerLabel: UILabel!
    @IBOutlet weak var frequentFyerImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var frequentFlyerLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftSeparatorView: ATDividerView!
    @IBOutlet weak var rightSeparatorView: ATDividerView!
    
    // MARK: - Variables
    
    weak var delegate: FrequentFlyerTableViewCellDelegate?
    var ffData: FrequentFlyer? {
        didSet {
            configureCell()
        }
    }
    
    var isFFTitleHidden: Bool = false {
        didSet {
            self.updateFFTitle()
        }
    }
    
    var hideSeperator: Bool = false {
        didSet {
            self.updateSeperator()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        frequentFlyerLabel.text = LocalizedString.SelectAirline.localized
        addGesture()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //        downArrowImageView.isHidden = false
    }
    
    
    
    private func updateFFTitle() {
        titleView.isHidden = self.isFFTitleHidden
    }
    
    private func updateSeperator() {
        leftSeparatorView.isHidden = self.hideSeperator
        rightSeparatorView.isHidden = self.hideSeperator
    }
    
    private func configureCell() {
        self.updateFFTitle()
        guard let ff = self.ffData else {return}
        // frequentFlyerImageView.kf.setImage(with: URL(string: ff.logoUrl))
        frequentFlyerImageView.setImageWithUrl(ff.logoUrl, placeholder: AppPlaceholderImage.frequentFlyer, showIndicator: false)
        if ff.airlineName == LocalizedString.SelectAirline.localized {
            frequentFlyerLabel.text = ff.airlineName
            frequentFlyerLabelLeadingConstraint.constant = 0
            frequentFyerImageViewWidthConstraint.constant = 0
            frequentFlyerLabel.textColor = AppColors.themeGray20
        } else {
            frequentFlyerLabel.text = ff.airlineName
            frequentFlyerLabelLeadingConstraint.constant = 16
            frequentFyerImageViewWidthConstraint.constant = 23
            frequentFlyerLabel.textColor = AppColors.textFieldTextColor51
        }
        rightTextField.text = ff.number
        rightTextField.delegate = self
        titleLabel.text = LocalizedString.FrequentFlyer.rawValue
        leftTitleLabel.textColor = AppColors.themeGray20
        
        frequentFlyerView.isHidden = false
        deleteButton.isHidden = false
        leftTextField.isEnabled = false
        rightTextField.isEnabled = true
        
    }
    
    private func addGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(frequentFleyViewTap(gesture:)))
        gesture.numberOfTapsRequired = 1
        frequentFlyerView.isUserInteractionEnabled = true
        frequentFlyerView.addGestureRecognizer(gesture)
        
        let rightViewGesture = UITapGestureRecognizer(target: self, action: #selector(leftViewTap(gesture:)))
        rightViewGesture.numberOfTapsRequired = 1
        leftView.isUserInteractionEnabled = true
        leftView.addGestureRecognizer(rightViewGesture)
    }
    
    @objc func frequentFleyViewTap(gesture: UITapGestureRecognizer) {
        if let idxPath = indexPath {
            delegate?.frequentFlyerTaped(idxPath)
        }
    }
    
    @objc func leftViewTap(gesture: UITapGestureRecognizer) {
        if let idxPath = indexPath {
            delegate?.programTextField(idxPath)
        }
    }
    
    @IBAction func deleteCellTapped(_ sender: Any) {
        if let idxPath = indexPath {
            delegate?.deleteCellTapped(idxPath)
        }
    }
}

// MARK: - UITextFieldDelegate methods

extension FrequentFlyerTableViewCell: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        printDebug("text field text \(textField.text ?? " ")")
        guard let inputMode = textField.textInputMode else {
            return false
        }
        if inputMode.primaryLanguage == "emoji" || !(inputMode.primaryLanguage != nil) {
            return false
        }
        if let idxPath = indexPath {
            if let textFieldString = textField.text, let swtRange = Range(range, in: textFieldString) {
                let fullString = textFieldString.replacingCharacters(in: swtRange, with: string)
                if textField === self.rightTextField {
                    delegate?.numberTextField(idxPath, fullString)
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

