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
    @IBOutlet var leftView: UIView!
    @IBOutlet var leftTitleLabel: UILabel!
    @IBOutlet var leftTextField: UITextField!
    @IBOutlet var frequentFlyerView: UIView!
    @IBOutlet var frequentFlyerImageView: UIImageView!
    @IBOutlet var frequentFlyerLabel: UILabel!
    @IBOutlet var downArrowImageView: UIImageView!
    
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var rightView: UIView!
    @IBOutlet var rightTitleLabel: UILabel!
    @IBOutlet var rightTextField: UITextField!
    @IBOutlet var leftTitleLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var frequentFyerImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var frequentFlyerLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var leftSeparatorView: ATDividerView!
    @IBOutlet var rightSeparatorView: ATDividerView!
    
    // MARK: - Variables
    
    weak var delegate: TwoPartEditTableViewCellDelegate?
    var indexPath: IndexPath?
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
        if let indexPath = indexPath {
            delegate?.twoPartEditLeftViewTap(indexPath, gesture)
        }
    }
    
    @objc func middleViewTap(gesture: UITapGestureRecognizer) {
        NSLog("middle view tapped")
        if let indexPath = indexPath {
            delegate?.rightViewTap(indexPath, gesture)
        }
    }
    
    @IBAction func deleteCellTapped(_ sender: Any) {
        if let indexPath = indexPath {
            delegate?.twoPartDeleteCellTapped(indexPath)
        }
    }
}

// MARK: - UITextFieldDelegate methods

extension TwoPartEditTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSLog("text field text \(textField.text ?? " ")")
        if let indexPath = indexPath {
            if let textFieldString = textField.text, let swtRange = Range(range, in: textFieldString) {
                let fullString = textFieldString.replacingCharacters(in: swtRange, with: string)
                delegate?.twoPartEditTextField(indexPath, fullString)
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
