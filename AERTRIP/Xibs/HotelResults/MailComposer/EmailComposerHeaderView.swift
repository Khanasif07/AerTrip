//
//  EmailComposerHeaderView.swift
//  AERTRIP
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol EmailComposeerHeaderViewDelegate : class {
    func openContactScreen()
    func textFieldText(_ textfield: UITextField)
    func textViewText(_ textView:UITextView)
}

class EmailComposerHeaderView: UIView {
    
    // MARK: - IB Outlets
    @IBOutlet var toEmailTextView: UITextView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var hotelResultLabel: UILabel!
    @IBOutlet weak var sharedStatusLabel: UILabel!
    @IBOutlet weak var firstDotedView: UIView!
    @IBOutlet weak var secondDotedView: UIView!
    @IBOutlet weak var checkInCheckOutView: UIView!
    
    @IBOutlet weak var checkOutMessageLabel: UILabel!
    @IBOutlet weak var seeRatesButton: ATButton!
    
    // MARK: - Properties
    weak var delegate : EmailComposeerHeaderViewDelegate?
    

    class func instanceFromNib() -> EmailComposerHeaderView {
        return UINib(nibName: "EmailComposerHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EmailComposerHeaderView
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.doInitialSeup()
        self.setUpText()
        self.setUpColor()
        self.setUpFont()

    }
    
    
    private func doInitialSeup() {
        self.drawDottedLine(start: CGPoint(x: firstDotedView.bounds.minX, y: firstDotedView.bounds.minY), end: CGPoint(x: firstDotedView.bounds.maxX, y: firstDotedView.bounds.minY), view: firstDotedView)
       self.drawDottedLine(start: CGPoint(x: secondDotedView.bounds.minX, y: secondDotedView.bounds.minY), end: CGPoint(x: secondDotedView.bounds.maxX, y: secondDotedView.bounds.minY), view: secondDotedView)
        self.messageTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        self.checkInCheckOutView.layer.cornerRadius = 5.0
        self.checkInCheckOutView.layer.borderWidth = 0.5
        self.checkInCheckOutView.layer.borderColor = AppColors.themeGray40.cgColor
        self.messageTextField.delegate = self
        self.toEmailTextView.delegate = self
        self.seeRatesButton.layer.cornerRadius = 5.0
      
      
     
    }
    
    
    private func setUpText() {
        self.toLabel.text = LocalizedString.To.localized
        self.messageLabel.text = LocalizedString.Message.localized
        self.sharedStatusLabel.text = LocalizedString.SharedMessage.localized
        self.hotelResultLabel.text = LocalizedString.HotelResultFor.localized
        self.seeRatesButton.setTitle(LocalizedString.SeeRates.localized, for: .normal)
        self.checkOutMessageLabel.text = LocalizedString.CheckOutMessage.localized
    }
    
    private func setUpFont() {
        self.toLabel.font = AppFonts.Regular.withSize(14.0)
        self.messageLabel.font = AppFonts.Regular.withSize(14.0)
        self.sharedStatusLabel.font = AppFonts.Regular.withSize(30.0)
        self.seeRatesButton.titleLabel?.font = AppFonts.Regular.withSize(16.0)
        self.checkOutMessageLabel.font = AppFonts.Regular.withSize(18.0)
        self.hotelResultLabel.font = AppFonts.Regular.withSize(18.0)
        self.toEmailTextView.font = AppFonts.Regular.withSize(18.0)
        self.messageTextField.font = AppFonts.Regular.withSize(18.0)
        
        
        
    }
    
    private func setUpColor() {
        self.toLabel.textColor = AppColors.themeGray40
        self.messageLabel.textColor = AppColors.themeGray40
        self.seeRatesButton.backgroundColor = AppColors.themeGreen
        self.seeRatesButton.titleLabel?.textColor = AppColors.themeWhite
        self.checkOutMessageLabel.textColor = AppColors.textFieldTextColor51
        self.hotelResultLabel.textColor = AppColors.themeGray60
        self.toEmailTextView.textColor = AppColors.themeGreen
        self.messageTextField.textColor = AppColors.textFieldTextColor51
        
        
    }
    
    // Check Out View
  
    
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.
        
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
    @IBAction func openContactScreenTapped(_ sender: Any) {
        delegate?.openContactScreen()
    }
    

}


// MARK:- UITextFieldDelegate methods

// MARK: - UITextField methods

extension EmailComposerHeaderView: UITextFieldDelegate {
    @objc func textFieldDidChanged(_ textField: UITextField) {
       delegate?.textFieldText(textField)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - UITextView Delegate methods

extension EmailComposerHeaderView : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewText(textView)
    }
}
