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
    func textViewText(emailTextView: UITextView)
    func textViewText(messageTextView: UITextView)
    func updateHeightOfHeader(_ headerView: EmailComposerHeaderView, _ textView: UITextView)
    
}

class EmailComposerHeaderView: UIView {
    // MARK: - IB Outlets
    
    @IBOutlet weak var aertripLogo: UIImageView!
    @IBOutlet weak var toEmailTextView: ATEmailSelectorTextView!
    @IBOutlet weak var messageSubjectTextView: UITextView!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var hotelResultLabel: UILabel!
    @IBOutlet weak var sharedStatusLabel: UILabel!
    @IBOutlet weak var firstDotedView: UIView!
    @IBOutlet weak var secondDotedView: UIView!
    @IBOutlet weak var checkInCheckOutView: UIView!
    
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDayLabel: UILabel!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDayLabel: UILabel!
    @IBOutlet weak var checkOutMessageLabel: UILabel!
    @IBOutlet weak var seeRatesButton: ATButton!
    @IBOutlet weak var numberOfNightsLabel: UILabel!
    @IBOutlet weak var emailHeightConatraint: NSLayoutConstraint!
    @IBOutlet weak var subjectHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var checkInTitleLable: UILabel!
    @IBOutlet weak var checkOutTitleLable: UILabel!
    
    @IBOutlet weak var checkOutMessageLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var emailTextField: ZFTokenField!
    
    
    // MARK: - Properties
    
    weak var delegate: EmailComposeerHeaderViewDelegate?
    
    class func instanceFromNib() -> EmailComposerHeaderView {
        return UINib(nibName: "EmailComposerHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EmailComposerHeaderView
    }
    
    var emails : [String] = []
    
    // MARK: - View LifeCycel
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.doInitialSeup()
        self.setUpText()
        self.setUpColor()
        self.setUpFont()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.firstDotedView.makeDottedLine()
        self.secondDotedView.makeDottedLine()
    }
    // MARK: - Helper methods
    
    private func doInitialSeup() {
        //aertripLogo.transform = CGAffineTransform(rotationAngle: 3/2*CGFloat.pi)
        
        self.messageSubjectTextView.text = LocalizedString.CheckoutMyFavouriteHotels.localized
        self.checkInCheckOutView.layer.cornerRadius = 5.0
        self.checkInCheckOutView.layer.borderWidth = 0.5
        self.checkInCheckOutView.layer.borderColor = AppColors.themeGray40.cgColor
        self.messageSubjectTextView.delegate = self
        self.seeRatesButton.layer.cornerRadius = 5.0
        self.seeRatesButton.shadowColor = AppColors.themeBlack.withAlphaComponent(0.16)
        self.seeRatesButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
        self.seeRatesButton.isUserInteractionEnabled = false
        
//        self.toEmailTextView.delegate = self
        self.toEmailTextView.keyboardType = .emailAddress
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
        self.toEmailTextView.placeholder = LocalizedString.EnterEmail.localized
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
        
        checkInDateLabel.font = AppFonts.Regular.withSize(26.0)
        checkInDayLabel.font = AppFonts.Regular.withSize(16.0)
        checkOutDateLabel.font = AppFonts.Regular.withSize(26.0)
        checkOutDayLabel.font = AppFonts.Regular.withSize(16.0)
        checkInTitleLable.font = AppFonts.Regular.withSize(16.0)
        checkOutTitleLable.font = AppFonts.Regular.withSize(16.0)
        numberOfNightsLabel.font = AppFonts.SemiBold.withSize(14.0)
        
        
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
        self.toEmailTextView.activeTagFontColor = UIColor.white
        self.toEmailTextView.tagSeparatorColor = AppColors.themeGreen
        if #available(iOS 13, *) {
        }else{
            self.toEmailTextView.placeholderTextColor = AppColors.themeGray40
        }
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
        if textView == self.toEmailTextView {
            self.delegate?.textViewText(emailTextView: textView)
        } else if textView == self.messageSubjectTextView {
            self.checkOutMessageLabel.text = textView.text
            self.delegate?.textViewText(messageTextView: textView)
        }
        self.delegate?.updateHeightOfHeader(self, textView)
    }


    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == " " {
            return false
        }
        return true
    }


}


extension EmailComposerHeaderView : ZFTokenFieldDataSource, ZFTokenFieldDelegate {
    
    
    func configureEmailField(){
        self.emailTextField.dataSource = self;
        self.emailTextField.delegate = self;
        self.emailTextField.textField.placeholder = "Enter here";
        self.emailTextField.reloadData()
        
//        [self.tokenField.textField becomeFirstResponder];
    }
    
    func lineHeightForToken(in tokenField: ZFTokenField!) -> CGFloat {
        return 30
    }
    
    func numberOfToken(in tokenField: ZFTokenField!) -> UInt {
        return UInt(self.emails.count)
    }
    
    func tokenField(_ tokenField: ZFTokenField!, viewForTokenAt index: UInt) -> UIView! {
        let nibContents = Bundle.main.loadNibNamed("TokenView", owner: nil, options: nil)
        guard let tokenView = nibContents?.first else { return UIView() }
        guard let tokView = tokenView as? UIView else { return UIView() }
        let label = UILabel()
        label.text = self.emails[Int(index)]
        let size = label.sizeThatFits(CGSize(width: 1000,height: 30))
        tokView.frame = CGRect(x: 0, y: 0, width: size.width + 32, height: 30);
        return tokView
    }
    
    func tokenMarginInToken(in tokenField: ZFTokenField!) -> CGFloat {
        return 5
    }
    
    func tokenField(_ tokenField: ZFTokenField!, didReturnWithText text: String!) {
        self.emails.append(text)
        self.emailTextField.reloadData()
    }
    
    func tokenField(_ tokenField: ZFTokenField!, didRemoveTokenAt index: UInt) {
        return emails.remove(at: Int(index))
    }
    
}


