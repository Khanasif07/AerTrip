//
//  OnAccountDetailVC.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class OnAccountDetailVC: BaseVC {

    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var tableView: ATTableView!
    
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = OnAccountDetailVM()
    
    //MARK:- Private

    
    // Empty State view
    private lazy var noAccountTransectionView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noAccountTransection
        return newEmptyView
    }()
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {

        self.topNavView.configureNavBar(title: "", isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: true)
        
        self.setScreenTitle()
        self.topNavView.delegate = self

        //tableView setup
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundView = self.noAccountTransectionView
        
        self.tableView.register(UINib(nibName: AppConstants.ktableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: AppConstants.ktableViewHeaderViewIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setScreenTitle()
        self.reloadList()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func setScreenTitle() {
        let title = LocalizedString.OnAccount.localized
        let dateStr = (self.viewModel.outstanding?.onAccountDate ?? Date()).toString(dateFormat: "dd MMM YYYY")//"22 Oct 2018"
        let subTitle = "\(LocalizedString.ason.localized) \(dateStr)"
        
        let finalStr = "\(title)\n\(subTitle)"
        
        let titleAttributedString = NSMutableAttributedString(string: finalStr, attributes: [
            .font: AppFonts.Regular.withSize(13.0),
            .foregroundColor: AppColors.themeBlack
            ])
        
        //subTitle beautify
        if let subRange = finalStr.range(of: title)?.asNSRange(inString: finalStr) {
            titleAttributedString.addAttribute(.font, value: AppFonts.SemiBold.withSize(18.0), range: subRange)
        }

        self.topNavView.navTitleLabel.attributedText = titleAttributedString
    }
    
    //MARK:- Public
    func reloadList() {
        self.tableView.reloadData()
    }
    
    //MARK:- Action
}

//MARK:- Nav bar delegate methods
//MARK:-
extension OnAccountDetailVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        //back button action
        AppFlowManager.default.popViewController(animated: true)
    }
}


//MARK:- View model delegate methods
//MARK:-
extension OnAccountDetailVC: OnAccountDetailVMDelegate {
    func willGetOnAccountDetails() {
    }
    
    func getOnAccountDetailsSuccess() {
        self.reloadList()
    }
    
    func getOnAccountDetailsFail() {
    }
}
