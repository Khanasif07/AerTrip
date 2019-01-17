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
    
    @IBOutlet var leftSeparatorView: UIView!
    @IBOutlet var rightSeparatorView: UIView!
    
    // MARK: - Variables
    
    weak var delegate: TwoPartEditTableViewCellDelegate?
    var indexPath: IndexPath?
    var ffData: FrequentFlyer? {
        didSet {
            self.configureCell()
        }
    }
    
    var issueDate: String = "" {
        didSet {
            self.configureCell()
        }
    }
    var expiryDate: String = "" {
        didSet {
            self.configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addGesture()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.leftTextField.placeholder = ""
        self.rightTextField.placeholder = ""
        self.frequentFlyerLabel.text = ""
        self.downArrowImageView.isHidden = false
    }
    
    private func configureCell() {

        if let ff = self.ffData {
            frequentFlyerImageView.kf.setImage(with: URL(string: ff.logoUrl))
            frequentFlyerLabel.text = ff.airlineName
            rightTextField.text = ff.number
            rightTextField.delegate = self
            leftTitleLabel.isHidden = false
            leftTitleLabel.text = LocalizedString.FrequentFlyer.rawValue
            
            self.frequentFlyerView.isHidden = false
            self.deleteButton.isHidden = false
            self.leftTextField.isEnabled = false
            self.rightTextField.isEnabled = true
        }
        else {
            leftTextField.text = issueDate
            rightTextField.text = expiryDate
            
            self.frequentFlyerView.isHidden = true
            self.leftTitleLabel.text = LocalizedString.issueDate.rawValue
            self.rightTitleLabel.text = LocalizedString.expiryDate.rawValue
            self.deleteButton.isHidden = true
            self.leftTextField.isEnabled = false
            self.rightTextField.isEnabled = false
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
