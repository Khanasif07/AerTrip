//
//  BookingTopNavBarWithSubtitle.swift
//  AERTRIP
//
//  Created by Admin on 03/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol BookingTopNavBarWithSubtitleDelegate: class {
    func leftButtonAction()
    func rightButtonAction()
}

extension BookingTopNavBarWithSubtitleDelegate{
    func leftButtonAction() {}
    func rightButtonAction() {}
}

class BookingTopNavBarWithSubtitle: UIView {
    
    weak var delegate: BookingTopNavBarWithSubtitleDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var leftButonOutlet: UIButton!
    @IBOutlet weak var rightButtonOutlet: UIButton!
    @IBOutlet weak var dividerView: ATDividerView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetUp()
    }
    
    ///InitialSetUp
    private func initialSetUp() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "BookingTopNavBarWithSubtitle", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.configureUI()
    }
    

    
    private func configureUI() {
        self.titleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.subTitleLabel.font = AppFonts.Regular.withSize(16.0)
        self.rightButtonOutlet.titleLabel?.font = AppFonts.Regular.withSize(18.0)
        self.rightButtonOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
        self.leftButonOutlet.isHidden = true
        self.rightButtonOutlet.isHidden = true
    }

    internal func configureView(title: String , subTitle: String, isleftButton: Bool = false, leftButtonImage: UIImage = AppImages.backGreen, isRightButton: Bool = false, rightButtonTitle: String = LocalizedString.Cancel.localized ) {
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
        if isleftButton {
            self.leftButonOutlet.isHidden = false
            self.leftButonOutlet.setImage(leftButtonImage, for: .normal)
        }
        if isRightButton {
            self.rightButtonOutlet.isHidden = false
            self.rightButtonOutlet.setTitle(rightButtonTitle, for: .normal)
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.delegate?.leftButtonAction()
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.delegate?.rightButtonAction()
    }
}
