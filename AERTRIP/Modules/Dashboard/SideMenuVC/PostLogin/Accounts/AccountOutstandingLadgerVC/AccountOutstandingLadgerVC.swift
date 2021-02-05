//
//  AccountOutstandingLadgerVC.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import IQKeyboardManager

class AccountOutstandingLadgerVC: BaseVC {
    
    enum ViewState {
        case searching
        case selecting
        case normal
    }
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var blankSpaceView: UIView!
    @IBOutlet weak var searchBarContainerView: UIView!
    @IBOutlet weak var searchBar: ATSearchBar!
    @IBOutlet weak var subHeaderContainer: UIView!
    @IBOutlet weak var subHeaderContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var subHeaderContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var summeryLabel: UILabel!
    @IBOutlet weak var grossOutstandingLabel: UILabel!
    @IBOutlet weak var onAccountLabel: UILabel!
    @IBOutlet weak var netOutstandingLabel: UILabel!
    @IBOutlet weak var grossOutstandingValueLabel: UILabel!
    @IBOutlet weak var onAccountValueLabel: UILabel!
    @IBOutlet weak var netOutstandingValueLabel: UILabel!
    @IBOutlet weak var searchDataContainerView: UIView!
    @IBOutlet weak var searchTableView: ATTableView!
    @IBOutlet weak var mainSearchBar: ATSearchBar!
    @IBOutlet weak var searchModeSearchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var makePaymentContainerView: UIView!
    @IBOutlet weak var payableAmountLabel: UILabel!
    @IBOutlet weak var makePaymentTitleLabel: UILabel!
    @IBOutlet weak var makePaymentContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var subheaderDetailsConstainer: UIView!
    
    @IBOutlet weak var loaderContainer: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var subHeaderTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var gradientView: UIView!
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = AccountOutstandingLadgerVM()
    
    //MARK:- Private
    var tableViewHeaderCellIdentifier = "TravellerListTableViewSectionView"
    private var searchModeSearchBarTopCurrent: CGFloat = 0.0
    private var oldOffset: CGPoint = CGPoint.zero
    private(set) var currentViewState = ViewState.normal {
        didSet {
            if oldValue != currentViewState {
                //currentViewState is being changed then manage header
                self.manageHeader(animated: true)
            }
        }
    }
    private let refreshControl = UIRefreshControl()
    
    // Empty State view
    private lazy var noAccountTransectionView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noAccountTransection
        return newEmptyView
    }()
    
    lazy var noResultemptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noResult
        return newEmptyView
    }()
    
    
    
    //MARK:- ViewLifeCycle
    //MARK:-
    deinit {
        NotificationCenter.default.removeObserver(self, name: .accountDetailFetched, object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.gradientView.addGredient(isVertical: false)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    override func initialSetup() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        self.loaderContainer.backgroundColor = .clear
        self.makePaymentContainerView.backgroundColor = .clear
        self.topNavView.delegate = self
        
        //add search view in tableView header
        self.tableView.register(DateTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "DateTableHeaderView")
        self.tableView.registerCell(nibName: AccountDetailEventHeaderCell.reusableIdentifier)
        self.tableView.registerCell(nibName: AccountOutstandingEventDescriptionCell.reusableIdentifier)
        self.tableView.register(UINib(nibName: tableViewHeaderCellIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: tableViewHeaderCellIdentifier)
        
        self.searchBar.isMicEnabled = true
        
        self.searchDataContainerView.backgroundColor = AppColors.clear
        self.mainSearchBar.showsCancelButton = true
        self.mainSearchBar.showsCancelButton = true
        if let cancelButton = mainSearchBar.value(forKey: "cancelButton") as? UIButton{
            cancelButton.titleLabel?.font = AppFonts.Regular.withSize(18)
        }
        self.searchBar.delegate = self
        self.mainSearchBar.delegate = self
        
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchTableView.backgroundView = self.noResultemptyView
        self.searchTableView.register(DateTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "DateTableHeaderView")
        self.searchTableView.registerCell(nibName: AccountDetailEventHeaderCell.reusableIdentifier)
        self.searchTableView.registerCell(nibName: AccountOutstandingEventDescriptionCell.reusableIdentifier)
        
        self.manageHeader(animated: false)
        self.reloadList()
        self.manageLoader(shouldStart: false)
        
        //for header blur
        self.searchDataContainerView.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        //self.view.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        topNavView.backgroundColor = AppColors.clear
        
        self.searchModeSearchBarTopConstraint.constant = ((self.subHeaderContainer.height + self.topNavView.height) - self.mainSearchBar.height)
        
        NotificationCenter.default.addObserver(self, selector: #selector(accountDetailFetched(_:)), name: .accountDetailFetched, object: nil)
        
        self.refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        self.refreshControl.tintColor = AppColors.themeGreen
        self.tableView.refreshControl = refreshControl
        self.tableView.showsVerticalScrollIndicator = true
        
        addLongPressOnTableView()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func setupFonts() {
        self.summeryLabel.font = AppFonts.Regular.withSize(14.0)
        
        self.grossOutstandingLabel.font = AppFonts.Regular.withSize(16.0)
        self.onAccountLabel.font = AppFonts.Regular.withSize(16.0)
        self.netOutstandingLabel.font = AppFonts.Regular.withSize(16.0)
        
        self.grossOutstandingValueLabel.font = AppFonts.Regular.withSize(16.0)
        self.onAccountValueLabel.font = AppFonts.Regular.withSize(16.0)
        self.netOutstandingValueLabel.font = AppFonts.Regular.withSize(16.0)
        
        self.makePaymentTitleLabel.font = AppFonts.SemiBold.withSize(20.0)
    }
    
    override func setupTexts() {
        self.summeryLabel.text = LocalizedString.Summary.localized
        
        self.grossOutstandingLabel.text = LocalizedString.GrossOutstanding.localized
        self.onAccountLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: LocalizedString.OnAccount.localized, image: #imageLiteral(resourceName: "ic_next_arrow_zeroSpacing"), endText: "", font: AppFonts.Regular.withSize(16.0))
        self.netOutstandingLabel.text = LocalizedString.NetOutstanding.localized
        
        let drAttr = NSMutableAttributedString(string: " \(LocalizedString.DebitShort.localized)", attributes: [.font: AppFonts.Regular.withSize(16.0)])
        let crAttr = NSMutableAttributedString(string: " \(LocalizedString.CreditShort.localized)", attributes: [.font: AppFonts.Regular.withSize(16.0)])
        
        let grossAmount = self.viewModel.accountOutstanding?.grossAmount ?? 0.0
        let grossStr = abs(grossAmount).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
        grossStr.append((grossAmount > 0) ? drAttr : crAttr)
        self.grossOutstandingValueLabel.attributedText = grossStr
        
        let onAccAmount = self.viewModel.accountOutstanding?.onAccountAmount ?? 0.0
        let onAcc = abs(onAccAmount).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
        onAcc.append((onAccAmount > 0) ? drAttr : crAttr)
        self.onAccountValueLabel.attributedText = onAcc
        
        let netOutAmount = self.viewModel.accountOutstanding?.netAmount ?? 0.0
        let netOutStr = abs(netOutAmount).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
        netOutStr.append((netOutAmount > 0) ? drAttr : crAttr)
        self.netOutstandingValueLabel.attributedText = netOutStr
        
        self.searchBar.placeholder = LocalizedString.search.localized
        self.mainSearchBar.placeholder = LocalizedString.search.localized
    }
    
    override func setupColors() {
        self.summeryLabel.textColor = AppColors.themeGray40
        
        self.tableView.backgroundColor = AppColors.themeWhite
        
        self.searchContainerView.backgroundColor = AppColors.themeWhite
        self.searchBarContainerView.backgroundColor = AppColors.themeWhite
        self.blankSpaceView.backgroundColor = AppColors.themeGray04
        
        self.makePaymentTitleLabel.textColor = AppColors.themeWhite
        
        self.makePaymentContainerView.addShadow(cornerRadius: 0.0, shadowColor: AppColors.themeGreen, backgroundColor: AppColors.clear, offset: CGSize(width: 0.0, height: 12.0))
    }
    
    @objc func accountDetailFetched(_ note: Notification) {
        if let object = note.object as? AccountDetailPostModel {
            printDebug("accountDetailFetched")
            self.viewModel.accountOutstanding = object.outstandingLadger
            reloadList()
            setupTexts()
        }
    }
    
    //MARK:- Methods
    //MARK:- Private
    override func setupNavBar() {
        if self.currentViewState == .normal {
            self.topNavView.configureNavBar(title: LocalizedString.OutstandingLedger.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true, backgroundType: .color(color: AppColors.themeWhite))
            
            self.topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "greenPopOverButton"), selectedImage: #imageLiteral(resourceName: "greenPopOverButton"), normalTitle: nil, selectedTitle: nil)
        }
        else {
            self.topNavView.configureNavBar(title: LocalizedString.SelectBooking.localized, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: true, backgroundType: .color(color: AppColors.themeWhite))
            
            self.topNavView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Cancel.localized, selectedTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        }
        topNavView.backgroundColor = AppColors.clear
    }
    
    private func manageHeader(animated: Bool) {
        
        if (self.currentViewState == .normal) {
            self.subHeaderContainer.isHidden = false
            self.view.endEditing(true)
        }
        
        if self.searchModeSearchBarTopConstraint.constant > 0.0 {
            self.searchModeSearchBarTopCurrent = self.searchModeSearchBarTopConstraint.constant
        }
        
        if (self.currentViewState == .searching) {
            self.searchDataContainerView.isHidden = false
        }
        
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
            guard let sSelf = self else {return}
            
            if (sSelf.currentViewState == .searching) {
                sSelf.subHeaderContainerTopConstraint.constant = -(sSelf.subHeaderContainer.height)
                sSelf.subHeaderContainer.alpha = 0.0
                sSelf.searchDataContainerView.alpha = 1.0
                sSelf.searchModeSearchBarTopConstraint.constant = 0.0
            }
            else {
                sSelf.subHeaderContainerTopConstraint.constant = 0.0
                sSelf.subHeaderContainer.alpha = 1.0
                sSelf.searchDataContainerView.alpha = 0.0
                sSelf.searchModeSearchBarTopConstraint.constant = sSelf.searchModeSearchBarTopCurrent
                sSelf.subheaderDetailsConstainer.isHidden = false
            }
            
            sSelf.view.layoutIfNeeded()
            
        }, completion: { [weak self](isDone) in
            guard let sSelf = self else {return}
            sSelf.subHeaderContainer.isHidden = (sSelf.currentViewState == .searching)
            sSelf.searchTableView.reloadData()
            if (sSelf.currentViewState == .searching) {
                sSelf.searchDataContainerView.isHidden = false
                sSelf.mainSearchBar.becomeFirstResponder()
                sSelf.searchDataContainerView.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.4)
            }
            else {
                sSelf.searchDataContainerView.isHidden = true
                sSelf.searchDataContainerView.backgroundColor = AppColors.clear
            }
        })
    }
    
    private func showMoreOptions() {
        
        var titles = [LocalizedString.Email.localized, LocalizedString.DownloadAsPdf.localized]
        if !self.viewModel.allDates.isEmpty {
            let titleStr = (self.currentViewState == .selecting) ? "De\(LocalizedString.SelectBookingsPay.localized.lowercased())" : LocalizedString.SelectBookingsPay.localized
            titles.insert(titleStr, at: 0)
        }
        
        let ttlClrs = Array(repeating: AppColors.themeDarkGreen, count: titles.count)
        
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: titles, colors: ttlClrs)
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
            if index == 0 {
                //select bookings pay
                if self.currentViewState == .selecting {
                    self.currentViewState = .normal
                }
                else {
                    self.currentViewState = .selecting
                }
                self.reloadList()
                printDebug("select bookings pay")
            }
            else if index == 1 {
                //email tapped
                AppToast.default.showToastMessage(message: "Sending email")
                self.viewModel.sendEmailForLedger(onVC: self)
            }
            else {
                //download pdf tapped
                self.topNavView.isToShowIndicatorView = true
                self.topNavView.startActivityIndicaorLoading()
                self.topNavView.firstRightButton.isHidden = true
                self.topNavView.secondRightButton.isHidden = true
                AppGlobals.shared.viewPdf(urlPath: "\(APIEndPoint.baseUrlPath.path)user-accounts/report-action?action=pdf&type=ledger&limit=20", screenTitle: LocalizedString.OutstandingLedger.localized, showLoader: false, complition: { [weak self] (status) in
                    self?.topNavView.isToShowIndicatorView = false
                    self?.topNavView.stopActivityIndicaorLoading()
                    self?.topNavView.firstRightButton.isHidden = false
                    self?.topNavView.secondRightButton.isHidden = false
                })
                
                printDebug("download pdf tapped")
            }
        }
    }
    
    private func manageMakePaymentView(isHidden: Bool, animated: Bool) {
        
        if isHidden {
            self.makePaymentContainerView.isHidden = false
        }
        
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
            guard let sSelf = self else {return}
            sSelf.makePaymentContainerHeightConstraint.constant = isHidden ? 0.0 : 50.0
        }) { [weak self](isDone) in
            guard let sSelf = self else {return}
            
            sSelf.makePaymentContainerView.isHidden = isHidden
        }
    }
    
    private func setPayableAmount() {
        var totalAmount: Double = self.viewModel.accountOutstanding?.netAmount ?? 0.0
        
        if self.currentViewState == .selecting {
            let selected = self.viewModel.totalAmountForSelected
            totalAmount = (selected > 0.0) ? selected : 0.0
        }
        
        let attrText = totalAmount.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(20.0))
        attrText.addAttributes([NSAttributedString.Key.foregroundColor : AppColors.themeWhite], range: NSRange(location: 0, length: attrText.length))
        self.payableAmountLabel.attributedText = attrText
        self.makePaymentTitleLabel.alpha = (totalAmount > 0) ? 1.0 : 0.6
        self.makePaymentTitleLabel.text = LocalizedString.MakePayment.localized
    }
    
    private func manageLoader(shouldStart: Bool) {
        self.indicatorView.style = .medium//.white
        self.indicatorView.color = AppColors.themeWhite
        self.indicatorView.startAnimating()
        self.makePaymentTitleLabel.text = shouldStart ? "" : "Make Payment"
        self.loaderContainer.isHidden = !shouldStart
    }
    
    private func addLongPressOnTableView() {
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(AccountOutstandingLadgerVC.handleLongPress(_:)))
        longPressGesture.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                printDebug(indexPath)
                //                tableView.separatorStyle = .singleLine
                func  selectRow() {
                    self.tableView(self.tableView, didSelectRowAt: indexPath)
                }
                if self.currentViewState != .selecting {
                    delay(seconds: 0.1) {
                        selectRow()
                    }
                } else {
                    selectRow()
                }
                //                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            if self.currentViewState != .selecting {
                self.currentViewState = .selecting
                self.reloadList()
            }
        }
    }
    
    //MARK:- Public
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.viewModel.getAccountDetails(showProgres: false)
    }
    
    func reloadList() {
        
        self.setupNavBar()
        self.setPayableAmount()
        
        self.tableView.backgroundView = self.noAccountTransectionView
        
        let isAllDatesEmpty = self.viewModel.allDates.isEmpty
        self.tableView.backgroundView?.isHidden = !isAllDatesEmpty
        self.tableView.isScrollEnabled = !isAllDatesEmpty
        self.manageMakePaymentView(isHidden: isAllDatesEmpty, animated: true)
        
        self.topNavView.firstRightButton.isEnabled = !isAllDatesEmpty
        self.topNavView.secondRightButton.isEnabled = !isAllDatesEmpty
        
        self.tableView.reloadData()
        self.searchTableView.reloadData()
    }
    
    //MARK:- Action
    @IBAction func onAccountButtonAction(_ sender: UIButton) {
        if let obj = self.viewModel.accountOutstanding {
            AppFlowManager.default.moveToOnAccountDetailVC(outstanding: obj)
        }
    }
    @IBAction func makePaymentButtonAction(_ sender: UIButton) {
        if self.makePaymentTitleLabel.alpha >= 1.0 {
            self.viewModel.getOutstandingPayment()
        }
    }
}

//MARK:- SearchBar delegate Methods
//MARK:-
extension AccountOutstandingLadgerVC: UISearchBarDelegate {
    func clearSearchData() {
        self.mainSearchBar.text = ""
        self.searchBar.text = ""
        self.viewModel.setSearchedAccountDetails(data: [:])
        self.viewModel.setAccountDetails(data: self.viewModel._accountDetails)
        self.reloadList()
    }
    
    func preserveSearchData() {
        self.searchBar.text = self.mainSearchBar.text
        self.viewModel.setAccountDetails(data: self.viewModel.searchedAccountDetails)
        self.reloadList()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar === self.mainSearchBar {
            self.currentViewState = .normal
            self.clearSearchData()
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        if (searchBar === self.searchBar) {
            self.currentViewState = .searching
            return false
        }
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text?.isEmpty ?? false){
            self.searchBarCancelButtonClicked(searchBar)
        }else{
            self.preserveSearchData()
            //        self.currentViewState = .normal
            self.view.endEditing(true)
            
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if (searchBar.text ?? "").isEmpty {
            self.searchBarCancelButtonClicked(searchBar)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar === self.mainSearchBar {
            //searchText.count >= AppConstants.kSearchTextLimit
            self.viewModel.searchEvent(forText: searchText)
            if !searchText.isEmpty {
                self.noResultemptyView.searchTextLabel.isHidden = false
                self.noResultemptyView.searchTextLabel.text = "\(LocalizedString.For.localized) '\(searchText)'"
            } else {
                self.clearSearchData()
            }
        }
        else {
            //reset tot the old state
            //            if (searchBar.text ?? "").isEmpty {
            //                self.clearSearchData()
            //            }
            //            else {
            //                self.reloadList()
            //            }
        }
    }
}

//MARK:- Nav bar delegate methods
//MARK:-
extension AccountOutstandingLadgerVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        //back button action
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        //dots button action
        if self.currentViewState == .normal {
            self.showMoreOptions()
        }
        else {
            self.currentViewState = .normal
            self.viewModel.selectedEvent.removeAll()
            self.reloadList()
        }
    }
    
    func topNavBarSecondRightButtonAction(_ sender: UIButton) {
        //filter button action
        //AppFlowManager.default.moveToADEventFilterVC(delegate: self, voucherTypes: ["Sales", "Receipt"], oldFilter: nil)
    }
}

//MARK:- Filter VC delegate methods
//MARK:-
//extension AccountOutstandingLadgerVC: ADEventFilterVCDelegate {
//
//}


//MARK:- ScrollView delegate methods
//MARK:-
extension AccountOutstandingLadgerVC {
    
    func manageSubheader(isHidden: Bool, animated: Bool) {
        
        let constToHide: CGFloat = -(self.subHeaderContainer.height)
        if isHidden, self.subHeaderContainerTopConstraint.constant == constToHide {
            //if already hidden then return
            
            return
        }
        else if !isHidden, self.subHeaderContainerTopConstraint.constant == 0.0  {
            //if already shown then return
            return
        }
        
        self.subheaderDetailsConstainer.isHidden = false
        UIView.animate(withDuration: animated ? 0.2 : 0.0, animations: {[weak self] in
            guard let sSelf = self else {return}
            let value = isHidden ? constToHide : 0.0
            if sSelf.subHeaderContainerTopConstraint.constant != value {
                sSelf.subHeaderContainerTopConstraint.constant = value
                sSelf.view.layoutIfNeeded()
            }
        }, completion: { [weak self](isDone) in
            guard let sSelf = self else {return}
            
            sSelf.subHeaderContainer.isHidden = isHidden
            if !isHidden {
                sSelf.searchModeSearchBarTopConstraint.constant = ((sSelf.subHeaderContainer.height + sSelf.topNavView.height) - sSelf.mainSearchBar.height)
            }
        })
    }
    
    func manageSubheaderSearch(isHidden: Bool, animated: Bool) {
        
        let constToHide: CGFloat = -(self.subHeaderContainer.height)
        let constToShow: CGFloat = -(self.subHeaderContainer.height - self.searchBarContainerView.height)
        if isHidden, self.subHeaderContainerTopConstraint.constant == constToHide {
            //if already hidden then return
            return
        }
        else if !isHidden, self.subHeaderContainerTopConstraint.constant == 0.0  {
            //if already shown then return
            return
        }
        
        self.subheaderDetailsConstainer.isHidden = true
        self.subHeaderContainer.isHidden = false
        UIView.animate(withDuration: animated ? 0.2 : 0.0, animations: {[weak self] in
            guard let sSelf = self else {return}
            let value = isHidden ? constToHide : constToShow
            if sSelf.subHeaderContainerTopConstraint.constant != value {
                sSelf.subHeaderContainerTopConstraint.constant = value
                sSelf.view.layoutIfNeeded()
            }
        }, completion: { [weak self](isDone) in
            guard let sSelf = self else {return}
            
            sSelf.subHeaderContainer.isHidden = isHidden
            if !isHidden {
                sSelf.searchModeSearchBarTopConstraint.constant = 44.0
            }
        })
    }
    
    func manageHeader(_ scrollView: UIScrollView) {
        defer {
            self.oldOffset = scrollView.contentOffset
        }
        let yOffset = Int(scrollView.contentOffset.y)
        
        let maxLimit = Int(scrollView.contentSize.height - scrollView.height)
        let yChanged = Int(self.oldOffset.y) - yOffset
        
        guard maxLimit > 0, 0...maxLimit ~= yOffset, abs(yChanged) > 3 else {return}
        
        //checking for the boundry limits and returning
        if yOffset <= 0 {
            //show full header
            self.manageSubheader(isHidden: false, animated: true)
            return
        }
        else if yOffset >= maxLimit {
            //hide full header
            self.manageSubheader(isHidden: true, animated: true)
            return
        }
        else {
            //if the offset is under the boundery limits
            if (0...Int(self.subHeaderContainerHeightConstraint.constant)) ~= yOffset {
                if yChanged > 0 {
                    //show full header
                    self.manageSubheader(isHidden: false, animated: true)
                }
                else {
                    //hide full header
                    self.manageSubheader(isHidden: true, animated: true)
                }
            }
            else {
                if yChanged > 0 {
                    //show search bar
                    self.manageSubheaderSearch(isHidden: false, animated: true)
                }
                else {
                    //hide search bar
                    self.manageSubheaderSearch(isHidden: true, animated: true)
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.currentViewState != .searching {
            self.manageHeader(scrollView)
        }
    }
}


//MARK:- View model delegate methods
//MARK:-
extension AccountOutstandingLadgerVC: AccountOutstandingLadgerVMDelegate {
    
    private func showDepositOptions() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.PayOnline.localized, LocalizedString.PayOfflineNRegister.localized], colors: [AppColors.themeDarkGreen, AppColors.themeDarkGreen])
        
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) { _, index in
            
            switch index {
            case 0:
                //PayOnline
                AppFlowManager.default.moveToAccountOnlineDepositVC(depositItinerary: self.viewModel.itineraryData, usingToPaymentFor: .outstandingLedger)
                
            case 1:
                //PayOfflineNRegister
                AppFlowManager.default.moveToAccountOfflineDepositVC(usingFor: .fundTransfer, usingToPaymentFor: .accountDeposit, paymentModeDetail: self.viewModel.itineraryData?.chequeOrDD, netAmount: self.viewModel.itineraryData?.netAmount ?? 0.0, bankMaster: self.viewModel.itineraryData?.bankMaster ?? [])
                printDebug("PayOfflineNRegister")
                
                
            default:
                printDebug("no need to implement")
            }
        }
    }
    
    
    func willGetOutstandingPayment() {
        self.manageLoader(shouldStart: true)
    }
    
    func getOutstandingPaymentSuccess() {
        self.manageLoader(shouldStart: false)
        showDepositOptions()
        //        AppFlowManager.default.moveToAccountOnlineDepositVC(depositItinerary: self.viewModel.itineraryData, usingToPaymentFor: .accountDeposit)
    }
    
    func getOutstandingPaymentFail() {
        self.manageLoader(shouldStart: false)
    }
    
    func willGetAccountDetails(showProgres: Bool) {
        //AppGlobals.shared.startLoading()
        self.topNavView.firstRightButton.isUserInteractionEnabled = false
        self.topNavView.secondRightButton.isUserInteractionEnabled = false
    }
    
    func getAccountDetailsSuccess(model: AccountDetailPostModel, showProgres: Bool) {
        self.refreshControl.endRefreshing()
        self.topNavView.firstRightButton.isUserInteractionEnabled = true
        self.topNavView.secondRightButton.isUserInteractionEnabled = true
        self.reloadList()
        NotificationCenter.default.post(name: .accountDetailFetched, object: model)
    }
    
    func getAccountDetailsFail(showProgres: Bool) {
        self.refreshControl.endRefreshing()
    }
    
    func searchEventsSuccess() {
        self.reloadList()
    }
}
