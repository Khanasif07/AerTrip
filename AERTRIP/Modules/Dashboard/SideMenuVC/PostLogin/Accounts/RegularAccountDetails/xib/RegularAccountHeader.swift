//
//  RegularAccountHeader.swift
//  AERTRIP
//
//  Created by Appinventiv  on 03/03/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import UIKit


protocol  RegularAccountHeaderDelegate: NSObjectProtocol{
    func headerFilterButtonIsTapped()
    func headerOptionButtonIsTapped()
    func searchbarTapped()
    func searchBarMicButtonTapped()
}

class RegularAccountHeader: UIView {
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var balanceValueLabel: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var accountTitleFilterView: UIView!
    @IBOutlet weak var accountLaderTitleLabel: UILabel!
    @IBOutlet weak var searchbarView: UIView!
    @IBOutlet weak var searchBar: ATSearchBar!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    weak var delegate:RegularAccountHeaderDelegate?
    private var time: Float = 0.0
    private var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.searchBar.delegate = self
        self.setText()
        self.setFonts()
        self.setColors()
        self.progressSetup()
        self.setImagesToButton()
        self.setAccountBalance()
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        self.delegate?.headerFilterButtonIsTapped()
    }
    
    @IBAction func optionButtonTapped(_ sender: Any) {
        self.delegate?.headerOptionButtonIsTapped()
    }
    
    private func setText(){
        self.balanceTitleLabel.text = LocalizedString.Balance.localized
        self.accountLaderTitleLabel.text = LocalizedString.AccountLegder.localized
    }
    
    private func setFonts(){
        self.balanceTitleLabel.font = AppFonts.Regular.withSize(14.0)
        self.accountLaderTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
    }
    
    private func setColors(){
        self.balanceTitleLabel.textColor = AppColors.themeGray40
        self.accountLaderTitleLabel.textColor = AppColors.themeBlack
        self.emptyView.backgroundColor = AppColors.greyO4
        
    }
    
    private func setImagesToButton(){
        self.optionButton.setImage(AppImages.greenPopOverButton, for: .normal)
        self.optionButton.setImage(AppImages.greenPopOverButton, for: .selected)
        self.filterButton.setImage(AppImages.bookingFilterIcon, for: .normal)
        self.filterButton.setImage( AppImages.bookingFilterIconSelected, for: .selected)
    }

    private func progressSetup(){
        self.progressView.transform = self.progressView.transform.scaledBy(x: 1, y: 1)
        self.progressView?.isHidden = true
    }
    
    
    func setAccountBalance(){
        if let accountData = UserInfo.loggedInUser?.accountData {
            let amount = (accountData.walletAmount != 0) ? (accountData.walletAmount * -1): accountData.walletAmount
            self.balanceValueLabel.attributedText = amount.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(28.0))
        }else{
            self.balanceValueLabel.attributedText = 0.0.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(28.0))
        }
        
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
            self.timer?.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
            }
        }
        
        if self.time >= 10 {
            self.timer?.invalidate()
            delay(seconds: 0.5) {
                self.timer?.invalidate()
                self.progressView?.isHidden = true
            }
        }
    }
    func stopProgress() {
        self.time += 1
        if self.time <= 8  {
            self.time = 9
        }
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
    }
    
}

extension RegularAccountHeader: UISearchBarDelegate{

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.delegate?.searchbarTapped()
        return false
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        self.delegate?.searchBarMicButtonTapped()
    }
    
    
}



