//
//  SettingsVC+TableViewDelegates.swift
//  AERTRIP
//
//  Created by Appinventiv on 25/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension SettingsVC : UITableViewDelegate, UITableViewDataSource {
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.settingsVm.settingsDataToPopulate.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingsVm.getCountInParticularSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0,1,3:
            return 35
        default:
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
            case 1:
                return 54
            default:
                return CGFloat.leastNormalMagnitude
        }
    }
    
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
            if section == 2 { return nil }
            
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsHeaderView") as? SettingsHeaderView else {
                fatalError("SettingsHeaderView not found")
            }
            headerView.topSepratorView.isHidden = self.settingsVm.isHeaderTopSeprator(section : section)
            headerView.titleLabel.text = ""
            return headerView
        }
        
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            if section != 1 { return nil }
            
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsHeaderView") as? SettingsHeaderView else {
                           fatalError("SettingsHeaderView not found") }
            headerView.titleLabel.text = LocalizedString.AllEventSyncedToCalendarApp.localized
            return headerView
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as? SettingsCell else { fatalError("SettingsCell not found") }
        cell.sepratorView.isHidden = self.settingsVm.isSepratorHidden(section: indexPath.section, row: indexPath.row)
        cell.populateCell(type : self.settingsVm.getSettingsType(key: indexPath.section, index: indexPath.row))
        cell.switch.addTarget(self, action: #selector(toggleSwitched), for: UIControl.Event.valueChanged)
        cell.switch.setOn(false, animated: true)
        return cell
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch self.settingsVm.getSettingsType(key: indexPath.section, index: indexPath.row) {
            case .country:
                AppFlowManager.default.moveToCountryVC()
       
            case .currency:
                AppFlowManager.default.moveToCurrencyVC()
            
        case .notification:
            AppFlowManager.default.moveToNotificationSettingsVC()

        case .changeAertripId:
            printDebug("changeAertripId")
            navigateToChangeEmailVc()
            
        case .changePassword:
            printDebug("changePassword")

            AppFlowManager.default.moveToChangePasswordVC(type: (UserInfo.loggedInUser?.hasPassword == true) ? .changePassword : .setPassword, delegate: self)

        case .changeMobileNumber:
            printDebug("changeMobileNumber")
            self.changeMobileNumber()
            
        case .disableWalletOtp:
            self.enableDisableOtp()
            printDebug("disableWalletOtp")
            
            
        case .aboutUs:
            if let pageUrl = URL(string: AppKeys.about) {
                AppFlowManager.default.showURLOnATWebView(pageUrl, screenTitle:  self.settingsVm.getSettingsType(key: indexPath.section, index: indexPath.row).rawValue, presentingStatusBarStyle: .lightContent, dismissalStatusBarStyle: .darkContent)
            }
            
        case .privacyPolicy:
            if let pageUrl = URL(string: AppKeys.privacy) {
                AppFlowManager.default.showURLOnATWebView(pageUrl, screenTitle:  self.settingsVm.getSettingsType(key: indexPath.section, index: indexPath.row).rawValue, presentingStatusBarStyle: .lightContent, dismissalStatusBarStyle: .darkContent)
            }
            
        case .legal:
            if let pageUrl = URL(string: AppKeys.legal) {
                AppFlowManager.default.showURLOnATWebView(pageUrl, screenTitle:  self.settingsVm.getSettingsType(key: indexPath.section, index: indexPath.row).rawValue, presentingStatusBarStyle: .lightContent, dismissalStatusBarStyle: .darkContent)
            }
            
            
        default:
                break
        }
        
    }
    
    @objc func toggleSwitched(sender : UISwitch) {
//        toggleSettings.calenderSyncSettings = sender.isOn
        delay(seconds: 0.3) {
            AppToast.default.showToastMessage(message: LocalizedString.ThisFunctionalityWillBeAvailableSoon.localized)
            guard let cell = self.settingsTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? SettingsCell else { return }
            cell.switch.setOn(false, animated: true)
        }
    }
    
}


extension SettingsVC: ChangePasswordVCDelegate, OtpConfirmationDelegate, WalletEnableDisableDelegate {
    func otpValidationCompleted(_ isSuccess: Bool) {
//        self.updateUserData()
        self.settingsTableView.reloadData()
    }
    
    
    func passowordChangedSuccessFully() {
        self.settingsTableView.reloadData()
    }
 
    func otpEnableDisableCompleted(_ isSuccess: Bool){
        self.settingsTableView.reloadData()
    }
    
}


extension SettingsVC {
    
    func changeMobileNumber(){
        if (UserInfo.loggedInUser?.mobile.isEmpty ?? false){
            if (UserInfo.loggedInUser?.hasPassword == true){
                let vc = OTPVarificationVC.instantiate(fromAppStoryboard: .OTPAndVarification)
                vc.modalPresentationStyle = .overFullScreen
                vc.viewModel.varificationType = .setMobileNumber
                vc.delegate = self
                self.present(vc, animated: false, completion: nil)
            }else{
                AppToast.default.showToastMessage(message: "Please set your account password!")
            }
            
        }else{
            let vc = OTPVarificationVC.instantiate(fromAppStoryboard: .OTPAndVarification)
            vc.modalPresentationStyle = .overFullScreen
            vc.viewModel.varificationType = .phoneNumberChangeOtp
            vc.delegate = self
            self.present(vc, animated: false, completion: nil)
        }
}
    
    func enableDisableOtp(){
        let vc = EnableDisableWalletOTPVC.instantiate(fromAppStoryboard: .OTPAndVarification)
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: false, completion: nil)
    }
    
    func navigateToChangeEmailVc(){
        let vc = ChangeEmailVC.instantiate(fromAppStoryboard: .OTPAndVarification)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }

}

//MARK: Add Analytics
extension SettingsVC {
    
    func addAnalytics(with indexPath: IndexPath){
        var eventType = ""
        var eventDetails = "n/a"
        switch self.settingsVm.getSettingsType(key: indexPath.section, index: indexPath.row) {
        case .country:
            eventType = ""
            eventDetails = "n/a"
        case .currency:
            eventType = ""
            eventDetails = "n/a"
        case .notification:
            eventType = ""
            eventDetails = "n/a"
        case .changeAertripId:
            eventType = ""
            eventDetails = "n/a"
        case .changePassword:
            eventType = ""
            eventDetails = "n/a"
        case .changeMobileNumber:
            eventType = ""
            eventDetails = "n/a"
        case .disableWalletOtp:
            eventType = ""
            eventDetails = "n/a"
        case .aboutUs:
            eventType = ""
            eventDetails = "n/a"
            
        case .privacyPolicy:
            eventType = ""
            eventDetails = "n/a"
            
        case .legal:
            eventType = ""
            eventDetails = "n/a"
        default:
            break
        }
        
    }
    
}
