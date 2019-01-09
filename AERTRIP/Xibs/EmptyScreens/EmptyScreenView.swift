//
//  EmptyScreenView.swift
//  AERTRIP
//
//  Created by Admin on 03/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol EmptyScreenViewDelegate: class {
}

class EmptyScreenView: UIView {
    
    enum EmptyScreenViewType {
        case hotelPreferences
        case none
    }

    //MARK:- properties -
    var delegate: EmptyScreenViewDelegate?
    var vType: EmptyScreenViewType = .none {
        didSet {
            self.initialSetup()
        }
    }
    
    //MARK:- IBOutlets -
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
        self.initialSetup()
    }
    
    init() {
        super.init(frame: .zero)
        
        self.commonInit()
        self.initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
        self.initialSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("\(EmptyScreenView.self)", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }

    //MARK:- Private Function -
}

extension EmptyScreenView {
    
    /// - Initial Setup -
    private func initialSetup() {
        
        switch self.vType {
        case .hotelPreferences:
            self.setupForHotelPreferences()
        
        case .none:
            self.setupForNone()
        }
        
        self.layoutIfNeeded()
    }

    //MARK: - Tenant My Apartments -
    private func setupForNone() {
        self.mainImageView.image = nil
        self.messageLabel.font = AppFonts.Regular.withSize(17.0)
        self.messageLabel.textColor = AppColors.themeGray40
        self.messageLabel.text = LocalizedString.noData.localized
    }
    
    private func setupForHotelPreferences() {
        self.mainImageView.image = #imageLiteral(resourceName: "hotelEmpty")
        self.messageLabel.font = AppFonts.Regular.withSize(17.0)
        self.messageLabel.textColor = AppColors.themeGray40
        self.messageLabel.attributedText = self.getTextWithImage(startText: "Tap ", image: #imageLiteral(resourceName: "saveHotels"), endText: " to add a hotel to favorite list")//"Tap   to add a hotel to favorite list"
    }
    
    private func getTextWithImage(startText: String, image: UIImage, endText: String) -> NSMutableAttributedString {
        // create an NSMutableAttributedString that we'll append everything to
        let fullString = NSMutableAttributedString(string: startText)
        
        // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = image
        
        // wrap the attachment in its own attributed string so we can append it
        let image1String = NSAttributedString(attachment: image1Attachment)
        
        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.append(image1String)
        fullString.append(NSAttributedString(string: endText))
        
        return fullString
    }
}
