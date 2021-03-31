//
//  PeriodicStatementListVC.swift
//  AERTRIP
//
//  Created by Admin on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit


class PeriodicStatementListVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet weak var dividerView: ATDividerView!
    
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = PeriodicStatementListVM()
    
    //MARK:- Private
    private lazy var emptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noStatementGenrated
        return newEmptyView
    }()
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func bindViewModel() {
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundView = self.emptyView
        self.tableView.backgroundView?.isHidden = true
        self.dividerView.isHidden = false
        self.tableView.backgroundColor = AppColors.themeGray04
        
        self.tableView.register(UINib(nibName: AppConstants.ktableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: AppConstants.ktableViewHeaderViewIdentifier)
    }
        
    private func viewStatement(forId: String, screenTitle: String) {
        //open pdf for booking id
        AppGlobals.shared.viewPdf(urlPath: "\(APIEndPoint.baseUrlPath.path)user-accounts/report-action?action=pdf&type=statement&statement_id[]=\(forId)", screenTitle: screenTitle)
    }

    //MARK:- Public
    
    
    //MARK:- Action
}


extension PeriodicStatementListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = self.viewModel.allDates.count
        tableView.backgroundView?.isHidden = (count > 0)
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (self.viewModel.allDates.count - 1 == section) ? 35  : CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (self.viewModel.allDates.count - 1 == section){
            let ftr = UIView()
            ftr.backgroundColor = AppColors.clear
            return ftr
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AppConstants.ktableViewHeaderViewIdentifier) as? ViewProfileDetailTableViewSectionView else {
            fatalError("ViewProfileDetailTableViewSectionView not found")
        }
        headerView.topSeparatorView.isHidden = false
        var dateStr = self.viewModel.allDates[section]
        
        if dateStr.count >= 3 {
            dateStr.removeFirst(3)
        }
        
        headerView.headerLabel.text = dateStr.uppercased()
        headerView.backgroundColor = AppColors.themeGray04
        headerView.containerView.backgroundColor = AppColors.themeGray04
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getEvent(forIndexPath: IndexPath(row: 0, section: section)).allCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: PeriodicStatementCell.reusableIdentifier) as? PeriodicStatementCell else {
            return UITableViewCell()
        }
        
        var (event, allCount) = self.getEvent(forIndexPath: indexPath)
        event?.title = "Statement \(indexPath.row + 1)"
        cell.event = event
        if (indexPath.section == (self.viewModel.allDates.count - 1)), (indexPath.row >= (allCount - 1)) {
            cell.dividerView.isHidden = false
            cell.dividerViewLeadingConstraint.constant = 0
        }
        else {
            cell.dividerView.isHidden = (indexPath.row >= (allCount - 1))
            cell.dividerViewLeadingConstraint.constant = 16.0
        }
        
        return cell
    }
    
    func getEvent(forIndexPath indexPath: IndexPath) -> (event: PeriodicStatementEvent?, allCount: Int){

        guard let allEvent = self.viewModel.yearData[self.viewModel.allDates[indexPath.section]] as? [PeriodicStatementEvent] else {
            return (nil, 0)
        }
        return (allEvent[indexPath.row], allEvent.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        if let event = self.getEvent(forIndexPath: indexPath).event {
//            FirebaseAnalyticsController.shared.logEvent(name: "PeriodicStatementSelectedStatementFromList", params: ["ScreenName":"PeriodicStatement", "ScreenClass":"PeriodicStatementListVC","AccountType":UserInfo.loggedInUser?.userCreditType ?? "","StatementId":event.id])

            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.AccountsLedger.rawValue, params: [AnalyticsKeys.FilterName.rawValue:FirebaseEventLogs.EventsTypeName.AccountsPeriodicStatementViewStatementDetailsSelectedFromList, AnalyticsKeys.FilterType.rawValue: "LoggedInUserType", AnalyticsKeys.Values.rawValue: UserInfo.loggedInUser?.userCreditType ?? "n/a", AnalyticsKeys.FilterName.rawValue:"StatementId", AnalyticsKeys.FilterType.rawValue: "n/a", AnalyticsKeys.Values.rawValue: event.id])

            self.viewStatement(forId: event.id, screenTitle: "Statement\(indexPath.row + 1)")
        }
    }
}



//MARK:- Cell Class
//MARK:-
class PeriodicStatementCell: UITableViewCell {
    //MARK:- IBOutlets
    //MARK:-
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var dividerViewLeadingConstraint: NSLayoutConstraint!

    var event: PeriodicStatementEvent? {
        didSet {
            self.setData()
        }
    }
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.setFontAndColor()
    }
    
    private func setFontAndColor() {
        
        self.backgroundColor = AppColors.themeWhite
        
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        self.dateLabel.font = AppFonts.Regular.withSize(16.0)
        
        self.titleLabel.textColor = AppColors.themeBlack
        self.dateLabel.textColor = AppColors.themeGray40
        
        self.resetAllText()
    }
    
    private func resetAllText() {
        self.titleLabel.text = ""
        self.dateLabel.text = ""
    }
    
    private func setData() {

        self.titleLabel.text = self.event?.title ?? ""
        self.dateLabel.text = self.event?.periodTitle ?? ""
    }
}
