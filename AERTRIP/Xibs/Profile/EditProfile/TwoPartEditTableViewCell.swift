//
//  TwoPartEditTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 27/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol TwoPartEditTableViewCellDelegate: class {
    func twoPartDeleteCellTapped(_ indexPath: IndexPath)
    func twoPartEditLeftViewTap(_ indexPath: IndexPath, _ gesture: UITapGestureRecognizer)
    func rightViewTap(_ indexPath: IndexPath, _ gesture: UITapGestureRecognizer)
    func twoPartEditTextField(_ indexPath: IndexPath, _ fullString: String)
}

class TwoPartEditTableViewCell: UITableViewCell {
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var leftTextField: UITextField!
    @IBOutlet weak var frequentFlyerView: UIView!
    @IBOutlet weak var frequentFlyerImageView: UIImageView!
    @IBOutlet weak var frequentFlyerLabel: UILabel!
    @IBOutlet weak var downArrowImageView: UIImageView!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var rightTitleLabel: UILabel!
    @IBOutlet weak var rightTextField: UITextField!
    @IBOutlet weak var leftTitleLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var frequentFyerImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var frequentFlyerLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftSeparatorView: ATDividerView!
    @IBOutlet weak var rightSeparatorView: ATDividerView!
    
    // MARK: - Variables
    
    weak var delegate: TwoPartEditTableViewCellDelegate?
    var ffData: FrequentFlyer? {
        didSet {
            configureCell()
        }
    }
    
    var issueDate: String = "" {
        didSet {
            configureCell()
        }
    }
    
    var expiryDate: String = "" {
        didSet {
            self.configureCell()
        }
    }
    
    var isFFTitleHidden: Bool = false {
        didSet {
            self.updateFFTitle()
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
        leftTextField.placeholder = ""
        rightTextField.placeholder = ""
        downArrowImageView.isHidden = false
    }
    
    private func updateFFTitle() {
        leftTitleLabel.isHidden = self.isFFTitleHidden
        leftTitleLabelHeightConstraint.constant = self.isFFTitleHidden ?  0.0 : 18.0
    }
    
    private func configureCell() {
        self.updateFFTitle()
        if let ff = self.ffData {
           // frequentFlyerImageView.kf.setImage(with: URL(string: ff.logoUrl))
            frequentFlyerImageView.setImageWithUrl(ff.logoUrl, placeholder: AppPlaceholderImage.frequentFlyer, showIndicator: false)
            if ff.airlineName == LocalizedString.SelectAirline.localized {
                frequentFlyerLabel.text = ff.airlineName
                frequentFlyerLabelLeadingConstraint.constant = 0
                frequentFyerImageViewWidthConstraint.constant = 0
            } else {
                frequentFlyerLabel.text = ff.airlineName
                frequentFlyerLabelLeadingConstraint.constant = 16
                frequentFyerImageViewWidthConstraint.constant = 23
            }
            rightTextField.text = ff.number
            rightTextField.delegate = self
            leftTitleLabel.text = LocalizedString.FrequentFlyer.rawValue
            
            frequentFlyerView.isHidden = false
            deleteButton.isHidden = false
            leftTextField.isEnabled = false
            rightTextField.isEnabled = true
        } else {
            leftTextField.text = issueDate
            rightTextField.text = expiryDate
            
            frequentFlyerView.isHidden = true
            leftTitleLabel.text = LocalizedString.IssueDate.localized
            rightTitleLabel.text = LocalizedString.ExpiryDate.localized
            deleteButton.isHidden = true
            leftTextField.isEnabled = false
            rightTextField.isEnabled = false
        }
    }
    
    private func addGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(leftViewTap(gesture:)))
        gesture.numberOfTapsRequired = 1
        leftView.isUserInteractionEnabled = true
        leftView.addGestureRecognizer(gesture)
        
        let rightViewGesture = UITapGestureRecognizer(target: self, action: #selector(middleViewTap(gesture:)))
        rightViewGesture.numberOfTapsRequired = 1
        rightView.isUserInteractionEnabled = true
        rightView.addGestureRecognizer(rightViewGesture)
    }
    
    @objc func leftViewTap(gesture: UITapGestureRecognizer) {
        if let idxPath = indexPath {
            delegate?.twoPartEditLeftViewTap(idxPath, gesture)
        }
    }
    
    @objc func middleViewTap(gesture: UITapGestureRecognizer) {
        printDebug("middle view tapped")
        if let idxPath = indexPath {
            delegate?.rightViewTap(idxPath, gesture)
        }
    }
    
    @IBAction func deleteCellTapped(_ sender: Any) {
        if let idxPath = indexPath {
            delegate?.twoPartDeleteCellTapped(idxPath)
        }
    }
}

// MARK: - UITextFieldDelegate methods

extension TwoPartEditTableViewCell: UITextFieldDelegate {
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
                delegate?.twoPartEditTextField(idxPath, fullString)
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
