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
        
        self.viewModel.fetchMonthsForGivenYear()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundView = self.emptyView
        self.tableView.backgroundView?.isHidden = true
        self.dividerView.isHidden = false
        
        self.tableView.register(UINib(nibName: AppConstants.ktableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: AppConstants.ktableViewHeaderViewIdentifier)
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AppConstants.ktableViewHeaderViewIdentifier) as? ViewProfileDetailTableViewSectionView else {
            fatalError("ViewProfileDetailTableViewSectionView not found")
        }
        headerView.topSeparatorView.isHidden = false
        headerView.headerLabel.text = self.viewModel.allDates[section]
        headerView.backgroundColor = AppColors.themeGray04
        headerView.containerView.backgroundColor = AppColors.themeGray04
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let allEvent = self.viewModel.accountDetails[self.viewModel.allDates[section]] as? [AccountDetailEvent] {
//            return allEvent.count
//        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let (currentEvent, allCount) = self.getEvent(forIndexPath: indexPath, forTableView: tableView)
//        guard let event = currentEvent, let cell = self.tableView.dequeueReusableCell(withIdentifier: PeriodicStatementCell.reusableIdentifier) as? PeriodicStatementCell else {
//            return UITableViewCell()
//        }
        
        let allCount = 4
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: PeriodicStatementCell.reusableIdentifier) as? PeriodicStatementCell else {
            return UITableViewCell()
        }
        
        cell.event = "Statement \(indexPath.row + 1)"
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
    
//    func getEvent(forIndexPath indexPath: IndexPath, forTableView: UITableView) -> (event: AccountDetailEvent?, allCount: Int){
//
//        guard !self.viewModel.accountDetails.isEmpty else {
//            return (nil, 0)
//        }
//
//        let allEvent = (self.viewModel.accountDetails[self.viewModel.allDates[indexPath.section]] as? [AccountDetailEvent]) ?? []
//
//        guard !allEvent.isEmpty else {
//            return (nil, 0)
//        }
//
//        return (allEvent[indexPath.row], allEvent.count)
//    }
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

    var event: String? {
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

        self.titleLabel.text = self.event ?? ""
        self.dateLabel.text = "6 Jan - 11 Jan"
    }
}
