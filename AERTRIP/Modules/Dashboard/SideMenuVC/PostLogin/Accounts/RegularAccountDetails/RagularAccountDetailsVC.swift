//
//  RagularAccountDetailsVC.swift
//  AERTRIP
//
//  Created by Appinventiv  on 03/03/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import UIKit

class RagularAccountDetailsVC: BaseVC {
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet weak var searchDataContainerView: UIView!
    @IBOutlet weak var searchTableView: ATTableView!
    @IBOutlet weak var mainSearchBar: ATSearchBar!
    @IBOutlet weak var searchModeSearchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleHeaderView: UIView!
    @IBOutlet weak var titleHeaderTopConstraints: NSLayoutConstraint!
    
    
    enum ViewState {
        case searching
        case filterApplied
        case normal
    }
    
    enum UsingFor {
        case account
        case accountLadger
    }

    let viewModel = AccountDetailsVM()
    var currentUsingAs = UsingFor.account
    var tableViewHeaderCellIdentifier = "TravellerListTableViewSectionView"
    
    var headerView: RegularAccountHeader? = {
        let nib = UINib(nibName: "RegularAccountHeader", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? RegularAccountHeader
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setHeaderView()
        self.setupNavigation()
        // Do any additional setup after loading the view.
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
//        headerView.updatePosition()
    }

    private func setHeaderView(){
        guard self.headerView != nil else{return}
        self.headerView?.frame = CGRect(
            x: 0,
            y: tableView.safeAreaInsets.top,
            width: view.frame.width,
            height: 216)
//        let emptyView = UIView()
//        emptyView.backgroundColor = AppColors.themeRed
//        tableView.backgroundView = emptyView
        titleHeaderView.addSubview(headerView!)
    }
    
    
     func setHeaderText() {
        self.mainSearchBar.placeholder = LocalizedString.search.localized
    }
    
    private func setupNavigation(){
        let navTitle = LocalizedString.Accounts.localized//(self.currentUsingAs == .account) ? LocalizedString.Accounts.localized : LocalizedString.AccountLegder.localized
        self.topNavView.configureNavBar(title: navTitle, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: true, isDivider: false)
        
//        self.topNavView.delegate = self
        
        self.topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "greenPopOverButton"), selectedImage: #imageLiteral(resourceName: "greenPopOverButton"))
        self.topNavView.configureSecondRightButton(normalImage: #imageLiteral(resourceName: "bookingFilterIcon"), selectedImage: #imageLiteral(resourceName: "bookingFilterIconSelected"))
    }

}

extension RagularAccountDetailsVC:UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = AppColors.themeGray60
        return cell
    }
    
    
}

//ScrollView delegate
extension RagularAccountDetailsVC{
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView{
            self.updateTitleHeaderView(with: scrollView.contentOffset.y)
        }
        
    }
    
    
    
    func updateTitleHeaderView(with offset: CGFloat){
        if offset <= 216{
            if offset <= 0{
                self.titleHeaderTopConstraints.constant = 0.0
            }else{
                self.titleHeaderTopConstraints.constant = -offset
            }
            
        }else{
            self.titleHeaderTopConstraints.constant = -216.0
        }
    }
}
