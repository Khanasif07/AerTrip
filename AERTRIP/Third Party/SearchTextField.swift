//
//  CustomTextField.swift
//
//
//  Created by Pawan Kumar on 26/12/18.
//  
//

import UIKit

class SearchTextField: UITextField {
    
    //MARK: - Inspectable -
    @IBInspectable var imageLeftButton: UIImage? {
        didSet {
            self.inputLeftButton()
        }
    }
    
    @IBInspectable var imageRightButton: UIImage? {
        didSet {
            self.inputRightButton()
        }
    }
    
    //MARK: - Variable -
    var rightButton: UIButton = UIButton()
    var leftButton: UIButton = UIButton()
    var textFieldButtonTap: ((_ crossButtonTap: Bool) -> Swift.Void)?
    
    //MARK: - View life cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateProperties()
    }
    
    //MARK: - Initalize class -
    private func inputLeftButton() {
        self.leftViewMode = UITextField.ViewMode.always
        self.leftView = UIView(frame: CGRect(x: 5, y: 0, width: 44, height: 36))
        self.leftView?.backgroundColor = UIColor.clear
        
        self.leftButton.frame = CGRect(x: 5, y: 0, width: 44, height: 36)
        self.leftButton.contentMode = UIView.ContentMode.center
        self.leftButton.addTarget(self, action: #selector(self.leftButtonAction), for: UIControl.Event.touchUpInside)
        self.leftButton.setTitle("", for: UIControl.State.normal)
        self.leftButton.setImage(UIImage(named: "searchBarIcon"), for: .normal)
        self.leftButton.backgroundColor = UIColor.clear
        
        self.removeEarlierButtonsSubviews(viewSuperView: self.leftView)
        self.leftView?.addSubview(leftButton)
    }
    
    private func inputRightButton() {
        self.rightViewMode = UITextField.ViewMode.always
        self.rightView = UIView(frame: CGRect(x: self.bounds.size.width - 40, y: 0, width: 40, height: 40))
        self.rightView?.backgroundColor = UIColor.clear
        
        self.rightButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.rightButton.contentMode = UIView.ContentMode.center
        self.rightButton.addTarget(self, action: #selector(self.rightButtonAction), for: UIControl.Event.touchUpInside)
        self.rightButton.setTitle("", for: UIControl.State.normal)
        self.rightButton.setImage(UIImage(named: "icon"), for: .normal)
        self.rightButton.backgroundColor = UIColor.clear
        
        self.removeEarlierButtonsSubviews(viewSuperView: self.rightView)
        self.rightView?.addSubview(rightButton)
    }
    
    internal func removeEarlierButtonsSubviews(viewSuperView: UIView?) {
        if let earlierSubviews: [UIView] = viewSuperView?.subviews, earlierSubviews.count > 0 {
            for addedView in earlierSubviews {
                addedView.removeFromSuperview()
            }
        }
    }
    
    @objc func rightButtonAction() {
        self.textFieldButtonTap?(true)
    }
    
    @objc func leftButtonAction() {
        self.textFieldButtonTap?(false)
    }
    
    //MARK: - Private methods -
    private func updateProperties() {
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    //MARK: - Public methods -
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) {
        let newText = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        self.changeButtonStateForText(string: newText)
    }
    
    private func changeButtonStateForText(string: String) {
        if string.count > 0 {
            self.rightButton.setImage(self.imageRightButton, for: .normal)
            self.rightButton.isUserInteractionEnabled = true
        } else {
            self.rightButton.setImage(nil, for: .normal)
            self.rightButton.isUserInteractionEnabled = false
        }
    }
}

