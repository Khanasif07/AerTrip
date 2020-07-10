//
//  AbortRequestVC.swift
//  AERTRIP
//
//  Created by apple on 17/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import IQKeyboardManager

class AbortRequestVC: BaseVC {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var confirmAbortButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var confirmBtnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: ATTableView!
    
    //MARK: - Variables
    let viewModel = AbortRequestVM()
    var estimatedHeight:CGFloat = 60.0
    
    private var keyboardHeight: CGFloat = 0.0
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientView.addGredient(isVertical: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    // MARK:- Overide methods
    
    override func initialSetup() {
        self.view.backgroundColor = AppColors.themeWhite
        confirmBtnBottomConstraint.constant = AppFlowManager.default.safeAreaInsets.bottom
        self.view.layoutIfNeeded()
        self.gradientView.addGredient(isVertical: false)
        registerXib()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = AppColors.themeGray04
        
    }
    
    override func setupFonts() {
        self.confirmAbortButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
        
    }
    
    override func setupTexts() {
        self.confirmAbortButton.setTitle(LocalizedString.ConfirmAbort.localized, for: .normal)
        self.confirmAbortButton.setTitle(LocalizedString.ConfirmAbort.localized, for: .selected)
        
    }
    
    override func setupColors() {
        self.confirmAbortButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.confirmAbortButton.setTitleColor(AppColors.themeWhite, for: .selected)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientView.addGredient(isVertical: false)
    }
    
    override func setupNavBar() {
        self.topNavView.navTitleLabel.textColor = AppColors.textFieldTextColor51
        self.topNavView.configureNavBar(title: LocalizedString.AbortThisRequest.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: true)
        self.topNavView.delegate = self
        
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    func registerXib() {
        tableView.register(UINib(nibName: AbortRequestTableViewCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: AbortRequestTableViewCell.reusableIdentifier)
    }
    
    @IBAction func confirmAbortButtonTapped(_ sender: Any) {
        self.viewModel.makeRequestAbort()
    }
    
}


extension AbortRequestVC: AbortRequestVMDelegate {
    func willMakeRequestAbort() {
        AppGlobals.shared.startLoading()
    }
    
    func makeRequestAbortSuccess() {
        AppGlobals.shared.stopLoading()
        self.sendDataChangedNotification(data: ATNotification.myBookingCasesRequestStatusChanged)
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func makeRequestAbortFail() {
        AppGlobals.shared.stopLoading()
    }
}

// MARK: - Top Navigation View Delegate methods
extension AbortRequestVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}

// MARK: - UITableViewCellDataSource and UITableViewCellDelegateMethods

extension AbortRequestVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AbortRequestTableViewCell.reusableIdentifier, for: indexPath) as? AbortRequestTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.configure(comment: viewModel.comment)
        return cell
    }
    
}


extension AbortRequestVC: AbortRequestTableViewCellDelegate {
    func AbortRequestComment(comment: String, textView: UITextView) {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        textView.isScrollEnabled = false
        tableView.endUpdates()
        estimatedHeight = tableView.contentSize.height
        viewModel.comment = comment
        UIView.setAnimationsEnabled(true)
    }
}

