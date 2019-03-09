//
//  EmailComposerHeaderView.swift
//  AERTRIP
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol EmailComposeerHeaderViewDelegate: class {
    func openContactScreen()
    func textFieldText(_ textfield: UITextField)
    func textViewText(_ textView: UITextView)
}

class EmailComposerHeaderView: UIView {
    // MARK: - IB Outlets
    
    @IBOutlet var toEmailTextView: UITextView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var toLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var hotelResultLabel: UILabel!
    @IBOutlet var sharedStatusLabel: UILabel!
    @IBOutlet var firstDotedView: UIView!
    @IBOutlet var secondDotedView: UIView!
    @IBOutlet var checkInCheckOutView: UIView!
    
    @IBOutlet var checkInDateLabel: UILabel!
    @IBOutlet var checkInDayLabel: UILabel!
    @IBOutlet var checkOutDateLabel: UILabel!
    @IBOutlet var checkOutDayLabel: UILabel!
    @IBOutlet var checkOutMessageLabel: UILabel!
    @IBOutlet var seeRatesButton: ATButton!
    @IBOutlet var numberOfNightsLabel: UILabel!
    
    // MARK: - Properties
    
    weak var delegate: EmailComposeerHeaderViewDelegate?
    
    class func instanceFromNib() -> EmailComposerHeaderView {
        return UINib(nibName: "EmailComposerHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EmailComposerHeaderView
    }
    
    // MARK: - View LifeCycel
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.doInitialSeup()
        self.setUpText()
        self.setUpColor()
        self.setUpFont()
    }
    
    // MARK: - Helper methods
    
    private func doInitialSeup() {
        self.drawDottedLine(start: CGPoint(x: self.firstDotedView.bounds.minX, y: self.firstDotedView.bounds.minY), end: CGPoint(x: self.firstDotedView.bounds.maxX, y: self.firstDotedView.bounds.minY), view: self.firstDotedView)
        self.drawDottedLine(start: CGPoint(x: self.secondDotedView.bounds.minX, y: self.secondDotedView.bounds.minY), end: CGPoint(x: self.secondDotedView.bounds.maxX, y: self.secondDotedView.bounds.minY), view: self.secondDotedView)
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
        self.checkOutMessageLabel.font = AppFonts.Italic.withSize(18.0)
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
    
    // MARK: - IB Actions
    
    @IBAction func openContactScreenTapped(_ sender: Any) {
        self.delegate?.openContactScreen()
    }
}

// MARK: - UITextFieldDelegate methods

// MARK: - UITextField methods

extension EmailComposerHeaderView: UITextFieldDelegate {
    @objc func textFieldDidChanged(_ textField: UITextField) {
        self.delegate?.textFieldText(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITextView Delegate methods

extension EmailComposerHeaderView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.delegate?.textViewText(textView)
    }
}
