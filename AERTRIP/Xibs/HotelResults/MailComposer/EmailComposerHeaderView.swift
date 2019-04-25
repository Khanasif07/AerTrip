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
    func textViewText(_ textView: UITextView)
    func updateHeightOfHeader(_ headerView: EmailComposerHeaderView, _ textView: UITextView)
}

class EmailComposerHeaderView: UIView {
    // MARK: - IB Outlets
    
    @IBOutlet var toEmailTextView: ATEmailSelectorTextView!
    @IBOutlet var messageSubjectTextView: UITextView!
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
    @IBOutlet weak var emailHeightConatraint: NSLayoutConstraint!
    @IBOutlet weak var subjectHeightConstraint: NSLayoutConstraint!
    
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
        self.messageSubjectTextView.text = LocalizedString.CheckoutMyFavouriteHotels.localized
        self.checkInCheckOutView.layer.cornerRadius = 5.0
        self.checkInCheckOutView.layer.borderWidth = 0.5
        self.checkInCheckOutView.layer.borderColor = AppColors.themeGray40.cgColor
        self.messageSubjectTextView.delegate = self
        self.seeRatesButton.layer.cornerRadius = 5.0
        
        self.toEmailTextView.delegate = self
        
        self.toEmailTextView.textContainerInset = UIEdgeInsets.zero
//        self.toEmailTextView.textContainer.lineFragmentPadding = 0
        
        self.messageSubjectTextView.textContainerInset = UIEdgeInsets.zero
//        self.messageSubjectTextView.textContainer.lineFragmentPadding = 0
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
        // to Email Text View font
        self.toEmailTextView.inactiveTagFont = AppFonts.Regular.withSize(18.0)
        self.toEmailTextView.activeTagFont = AppFonts.Regular.withSize(18.0)
        self.toEmailTextView.tagSeparatorFont = AppFonts.Regular.withSize(18.0)
        
        self.messageSubjectTextView.font = AppFonts.Regular.withSize(18.0)
    }
    
    private func setUpColor() {
        self.toLabel.textColor = AppColors.themeGray40
        self.messageLabel.textColor = AppColors.themeGray40
        self.seeRatesButton.backgroundColor = AppColors.themeGreen
        self.seeRatesButton.titleLabel?.textColor = AppColors.themeWhite
        self.checkOutMessageLabel.textColor = AppColors.textFieldTextColor51
        self.hotelResultLabel.textColor = AppColors.themeGray60
        self.messageSubjectTextView.textColor = AppColors.textFieldTextColor51
        // toEmail Text View Color
        self.toEmailTextView.activeTagBackgroundColor = AppColors.themeGreen
        self.toEmailTextView.inactiveTagFontColor = AppColors.themeGreen
        self.toEmailTextView.activeTagFontColor = AppColors.themeWhite
        self.toEmailTextView.tagSeparatorColor = AppColors.themeGreen
    }
    
    // Check Out View
    
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [3, 2] // 3 is the length of dash, 2 is length of the gap.
        
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

// MARK: - UITextViewDelegate methods

// MARK: - UITextViewDelegate  Methods

extension EmailComposerHeaderView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.delegate?.textViewText(textView)
        
        self.delegate?.updateHeightOfHeader(self, textView)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == " " {
            return false
        }
        return true
    }
  
    
}
