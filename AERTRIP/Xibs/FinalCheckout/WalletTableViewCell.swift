//
//  WalletTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import SafariServices

protocol WalletTableViewCellDelegate: class {
    func valueForSwitch(isOn:Bool)
}

class WalletTableViewCell: UITableViewCell {
    
    @IBOutlet weak var walletTitleLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var walletSwitch: UISwitch!
    @IBOutlet weak var infoButton: UIButton!
    
    
    // MARK: - Properties
    weak var delegate : WalletTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpFonts()
        self.setUpColors()
        self.setUpText()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        amountLabel.attributedText = nil
    }
   
    // Mark: - Helper methods
    
    private func setUpFonts() {
        self.walletTitleLabel.font = AppFonts.Regular.withSize(18.0)
        self.balanceLabel.font = AppFonts.Regular.withSize(16.0)
        self.amountLabel.font = AppFonts.SemiBold.withSize(16.0)
    }
    
    private func setUpColors() {
        self.walletTitleLabel.textColor = AppColors.textFieldTextColor51
        self.balanceLabel.textColor = AppColors.themeGray40
        self.amountLabel.textColor = AppColors.textFieldTextColor51
        self.contentView.backgroundColor = AppColors.themeBlack26
        self.walletSwitch.onTintColor = AppColors.commonThemeGreen
    }
    
    private func setUpText() {
        self.walletTitleLabel.text = LocalizedString.PayByAertripWallet.localized
        self.balanceLabel.text = "\(LocalizedString.Balance.localized):"
    }
    
    
    @IBAction func infoButtonTaped(_ sender: Any) {
        guard let url = URL(string: AppKeys.walletAmountUrl) else { return }
        AppFlowManager.default.showURLOnATWebView(url, screenTitle: LocalizedString.AertripWallet.localized)
    }
    
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        sender.isOn ? delegate?.valueForSwitch(isOn: true) : delegate?.valueForSwitch(isOn: false)
    }
    
}

extension WalletTableViewCell: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        AppFlowManager.default.mainNavigationController.dismiss(animated: true, completion: nil)
    }
    
}

