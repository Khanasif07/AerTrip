//
//  EmailItinerariesVC.swift
//  AERTRIP
//
//  Created by Admin on 14/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCEmailItinerariesVC: BaseVC {
    
    //Mark:- Variables
    //================
    let viewModel = HCEmailItinerariesVM()
    
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var headerView: TopNavigationView!
    @IBOutlet weak var tableView: ATTableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.estimatedRowHeight = UITableView.automaticDimension
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 10.0)
        }
    }
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.fillData()
    }
    
    override func initialSetup() {
        self.headerViewSetUp()
        self.registerNibs()
    }
    
    override func setupFonts() {
        self.headerView.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
    }
    
    override func setupColors() {
        self.headerView.navTitleLabel.textColor = AppColors.themeBlack
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    //Mark:- Functions
    //================
    private func headerViewSetUp() {
        self.headerView.delegate = self
        self.headerView.configureNavBar(title: LocalizedString.EmailItineraries.localized , isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        self.headerView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Cancel.localized, selectedTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        self.headerView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.SendToAll.localized, selectedTitle: LocalizedString.Done.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
    }
    
    private func registerNibs() {
        self.tableView.registerCell(nibName: HCEmailItinerariesTableViewCell.reusableIdentifier)
    }
    
    //Mark:- IBActions
}

//Mark:- UITableView Delegate And DataSource
//==========================================
extension HCEmailItinerariesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.guestModal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HCEmailItinerariesTableViewCell.reusableIdentifier, for: indexPath) as? HCEmailItinerariesTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        cell.configureCell(emailInfo: self.viewModel.emailInfo[indexPath.row], name: (self.viewModel.guestModal[indexPath.row].firstName + self.viewModel.guestModal[indexPath.row].lastName), profileImage: self.viewModel.guestModal[indexPath.row].profilePicture)
        return cell
    }
}

//Mark:- TopNavigationViewDelegate
//================================
extension HCEmailItinerariesVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.viewModel.startSendingEmailId(isMultipleEmailSending: true)
    }
}

//Mark:- SendToEmailIDDelegate
//============================
extension HCEmailItinerariesVC: HCEmailItinerariesTableViewCellDelegate {
    
    func sendToEmailId(indexPath: IndexPath, emailId: String) {
        if emailId.isEmail {
            self.viewModel.startSendingEmailId(isMultipleEmailSending: false, currentEmailIndex: indexPath.row)
        } else {
            self.view.endEditing(true)
            AppToast.default.showToastMessage(message: "Please enter a valid email id")
        }
    }
    
    func updateEmailId(indexPath: IndexPath, emailId: String) {
        self.viewModel.emailInfo[indexPath.row].emailId = emailId
        if let cell = self.tableView.cellForRow(at: indexPath) as? HCEmailItinerariesTableViewCell {
            if emailId.isEmail {
                cell.sendButton.setTitleColor(AppColors.themeGreen, for: .normal)
                cell.emailTextField.textColor = AppColors.textFieldTextColor51
            } else {
                cell.sendButton.setTitleColor(AppColors.themeGray20, for: .normal)
                cell.emailTextField.textColor = AppColors.themeRed
            }
        }
        printDebug(emailId)
    }
}

//Mark:- HCEmailItinerariesVM Delegate
//====================================
extension HCEmailItinerariesVC: HCEmailItinerariesVMDelegate {
    
    func emailSendingSuccess(isMultipleEmailSending : Bool ,currentEmailIndex: Int) {
        if isMultipleEmailSending {
            for index in 0..<self.viewModel.emailInfo.count {
                if self.viewModel.emailInfo[index].emailStatus == .sending && self.viewModel.emailInfo[index].emailId.isEmail {
                    self.viewModel.emailInfo[index].emailStatus = .sent
                }
            }
        } else {
            self.viewModel.emailInfo[currentEmailIndex].emailStatus = .sent
        }
        self.tableView.reloadData()
    }
    
    func emailSendingFail(isMultipleEmailSending : Bool ,currentEmailIndex: Int) {
        if isMultipleEmailSending {
            for index in 0..<self.viewModel.emailInfo.count {
                if self.viewModel.emailInfo[index].emailStatus == .sending && self.viewModel.emailInfo[index].emailId.isEmail {
                    self.viewModel.emailInfo[index].emailStatus = .toBeSend
                }
            }
        } else {
            self.viewModel.emailInfo[currentEmailIndex].emailStatus = .toBeSend
        }
        self.tableView.reloadData()
    }
    
    func willBegainEmailSending(isMultipleEmailSending : Bool ,currentEmailIndex: Int) {
        if isMultipleEmailSending {
            let emailId = self.viewModel.getNonSentEmails()
            if self.viewModel.getNonSentEmails().count > 0 {
                for email in emailId {
                    if !email.isEmail {
                        AppToast.default.showToastMessage(message: "Please enter a valid email id")
                        return
                    }
                }
                for index in 0..<self.viewModel.emailInfo.count {
                    if self.viewModel.emailInfo[index].emailStatus == .toBeSend && self.viewModel.emailInfo[index].emailId.isEmail {
                        self.viewModel.emailInfo[index].emailStatus = .sending
                    }
                }
                self.tableView.reloadData()
                delay(seconds: 1) {
                    self.viewModel.sendEmailIdApi(emailId: emailId, isMultipleEmailSending: isMultipleEmailSending, currentEmailIndex: currentEmailIndex)
                }
            } else {
                AppToast.default.showToastMessage(message: "Please enter a valid email id")
            }
        } else {
            self.viewModel.emailInfo[currentEmailIndex].emailStatus = .sending
            self.tableView.reloadData()
            delay(seconds: 1) {
                self.viewModel.sendEmailIdApi( emailId: [self.viewModel.emailInfo[currentEmailIndex].emailId], isMultipleEmailSending: isMultipleEmailSending, currentEmailIndex: currentEmailIndex)
            }
        }
    }
}
