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
    func twoPartEditLeftViewTap(_ indexPath:IndexPath,_ gesture: UITapGestureRecognizer)
    func rightViewTap(_ indexPath: IndexPath,_ gesture: UITapGestureRecognizer)
}

class TwoPartEditTableViewCell: UITableViewCell {
    @IBOutlet var leftView: UIView!
    @IBOutlet var leftTitleLabel: UILabel!
    @IBOutlet var leftTextField: UITextField!
    @IBOutlet var frequentFlyerView: UIView!
    @IBOutlet var frequentFlyerImageView: UIImageView!
    @IBOutlet var frequentFlyerLabel: UILabel!
    @IBOutlet var downArrowImageView: UIImageView!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet var rightView: UIView!
    @IBOutlet var rightTitleLabel: UILabel!
    @IBOutlet var rightTextField: UITextField!
    @IBOutlet weak var leftTitleLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftSeparatorView: UIView!
    @IBOutlet weak var rightSeparatorView: UIView!
    
    // MARK: - Variables
    
    weak var delegate: TwoPartEditTableViewCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func cofigureCell(_ indexPath: IndexPath, _ isFrequentFlyer: Bool, _ issueDate: String, _ expiryDate: String, _ logoUrl: String, _ flightName: String, _ flightNo: String) {
        self.indexPath = indexPath
        
        if isFrequentFlyer {
            frequentFlyerImageView.kf.setImage(with: URL(string: logoUrl))
            frequentFlyerLabel.text = flightName
            frequentFlyerLabel.text = flightNo
            if indexPath.row == 2 {
                leftTitleLabel.isHidden = false
                leftTitleLabel.text = LocalizedString.FrequentFlyer.rawValue
            } else {
                leftTitleLabelHeightConstraint.constant = 0
                leftTitleLabel.isHidden = true
            }
        } else {
            leftTextField.text = issueDate
            rightTextField.text = expiryDate
        }
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(leftViewTap(gesture:)))
        gesture.numberOfTapsRequired = 1
        leftView.isUserInteractionEnabled = true
        leftView.tag = indexPath.row
        leftView.addGestureRecognizer(gesture)
        
        let rightViewGesture = UITapGestureRecognizer(target: self, action: #selector(middleViewTap(gesture:)))
        rightViewGesture.numberOfTapsRequired = 1
        rightView.isUserInteractionEnabled = true
        rightView.tag = indexPath.row
        rightView.addGestureRecognizer(rightViewGesture)
    }
    
    @objc func leftViewTap(gesture: UITapGestureRecognizer) {
        if let indexPath = indexPath {
             delegate?.twoPartEditLeftViewTap(indexPath,gesture)
        }
       
    }
    
    @objc func middleViewTap(gesture: UITapGestureRecognizer) {
        NSLog("middle view tapped")
        if let indexPath = indexPath {
            delegate?.rightViewTap(indexPath,gesture)
        }
        
    }
    
    @IBAction func deleteCellTapped(_ sender: Any) {
        if let indexPath = indexPath {
            delegate?.twoPartDeleteCellTapped(indexPath)
        }
    }
}
