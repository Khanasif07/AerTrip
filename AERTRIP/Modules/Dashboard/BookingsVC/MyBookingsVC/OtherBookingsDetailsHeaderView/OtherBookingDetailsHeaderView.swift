//
//  OtherBookingDetails.swift
//  AERTRIP
//
//  Created by Admin on 24/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class OtherBookingDetailsHeaderView: UIView {
    
    //MARK:- Variables
    //MARK:===========
    private var time: Float = 0.0
    private var timer: Timer?
    
    //MARK:- IBOutlets
    //MARK:===========
    
    @IBOutlet weak var bookingDataContainerView: UIView!
    @IBOutlet weak var bookingEventTypeImageView: UIImageView!
    @IBOutlet weak var bookingIdAndDateTitleLabel: UILabel!
    @IBOutlet weak var bookingIdAndDateLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var progressView: UIProgressView!
    
    //MARK:- LifeCycle
    //MARK:===========
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetUp()
    }
    
    //MARK:- Functions
    //MARK:===========
    private func initialSetUp() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "OtherBookingDetailsHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.progressView.transform = self.progressView.transform.scaledBy(x: 1, y: 1)
        self.progressView?.isHidden = true
        //        self.configureUI()
    }
    
    internal func configureUI(bookingEventTypeImage: UIImage , bookingIdStr: String , bookingIdNumbers: String , date: String , isDividerView: Bool = true) {
        //Image
        self.bookingEventTypeImageView.image = bookingEventTypeImage
        
        //Text
        self.bookingIdAndDateTitleLabel.text = LocalizedString.BookingIDAndDate.localized
        self.attributeLabelSetUp(bookingIdStr: bookingIdStr, bookingIdNumbers: bookingIdNumbers, date: date)
        
        //Fonts
        self.bookingIdAndDateTitleLabel.font = AppFonts.Regular.withSize(14.0)
        
        //Colors
        self.bookingIdAndDateTitleLabel.textColor = AppColors.themeGray40
        
        self.dividerView.isHidden = !isDividerView
        
    }
    
    
    ///AttributeLabelSetup
    private func attributeLabelSetUp(bookingIdStr: String , bookingIdNumbers: String , date: String) {
        
        guard !bookingIdNumbers.isEmpty, !date.isEmpty else {
            self.bookingIdAndDateLabel.text = ""
            return
        }
        let finalString = "\(bookingIdNumbers) | \(date)"
        
        let attributedString = NSMutableAttributedString(string: finalString)
        
        attributedString.addAttributes([NSAttributedString.Key.font: AppFonts.Regular.withSize(16.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack], range: NSRange(location: 0, length: finalString.count))
        
        if let num = bookingIdNumbers.components(separatedBy: "/").last, !num.isEmpty {
            attributedString.addAttributes([NSAttributedString.Key.font: AppFonts.SemiBold.withSize(16.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack], range: (finalString as NSString).range(of: num))
        }
        self.bookingIdAndDateLabel.attributedText = attributedString
    }
    
    func startProgress() {
        // Invalid timer if it is valid
        if self.timer?.isValid == true {
            self.timer?.invalidate()
        }
        self.progressView?.isHidden = false
        self.time = 0.0
        self.progressView.setProgress(0.0, animated: false)
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
    }
    
    @objc func setProgress() {
        self.time += 1.0
        self.progressView?.setProgress(self.time / 10, animated: true)
        
        if self.time == 8 {
            self.timer?.invalidate()
            return
        }
        if self.time == 2 {
            self.timer!.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
            }
        }
        
        if self.time >= 10 {
            self.timer!.invalidate()
            delay(seconds: 0.5) {
                self.progressView?.isHidden = true
            }
        }
    }
    func stopProgress() {
        self.time += 1
        self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
    }
    //MARK:- IBActions
    //MARK:===========
}
