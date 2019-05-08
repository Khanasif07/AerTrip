//
//  SpecialAccountDetailsVC+Delegate.swift
//  AERTRIP
//
//  Created by Admin on 06/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

extension SpecialAccountDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch self.currentUserType {
        case .statement: return 4
        case .topUp: return 3
        case .billWise: return 4
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch self.currentUserType {
        case .statement:
            
            return [0.0, 10.0, 10.0, 35.0][section]
            
        case .topUp:
            
            return [0.0, 10.0, 35.0][section]
            
        case .billWise:
            
            return [0.0, 10.0, 10.0, 35.0][section]
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier) as? EmptyTableViewCell else {
            return nil
        }
        
        cell.contentView.backgroundColor = AppColors.screensBackground.color
        
        return cell.contentView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.currentUserType {
        case .statement:
            
            return [self.viewModel.statementSummery.count, self.viewModel.creditSummery.count, 1, self.viewModel.otherAction.count][section]
            
        case .topUp:
            
            return [self.viewModel.topUpSummery.count, 1, self.viewModel.otherAction.count][section]
            
        case .billWise:
            
            return [self.viewModel.bilWiseSummery.count, self.viewModel.creditSummery.count, 1, self.viewModel.otherAction.count][section]
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.currentUserType {
        case .statement:
            
            switch indexPath.section {
            //statement summery
            case 0: return self.viewModel.statementSummery[indexPath.row].height
            
            //credit summery
            case 1: return self.viewModel.creditSummery[indexPath.row].height
                
            //deposit cell
            case 2: return self.viewModel.depositCellHeight
                
            //other action
            case 3: return self.viewModel.otherAction[indexPath.row].height

            default: return 0
            }
            
        case .topUp:
            
            switch indexPath.section {
            //topup summery
            case 0: return self.viewModel.topUpSummery[indexPath.row].height
                
            //deposit cell
            case 1: return self.viewModel.depositCellHeight
                
            //other action
            case 2: return self.viewModel.otherAction[indexPath.row].height
                
            default: return 0
            }
            
        case .billWise:
            
            switch indexPath.section {
            //bilwise summery
            case 0: return self.viewModel.bilWiseSummery[indexPath.row].height
                
            //credit summery
            case 1: return self.viewModel.creditSummery[indexPath.row].height
                
            //deposit cell
            case 2: return self.viewModel.depositCellHeight
                
            //other action
            case 3: return self.viewModel.otherAction[indexPath.row].height
                
            default: return 0
            }
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.currentUserType {
        case .statement:
            
            switch indexPath.section {
            //statement summery
            case 0:
                return getSummeryCell(withData: self.viewModel.statementSummery[indexPath.row])
                
            //credit summery
            case 1:
                return getSummeryCell(withData: self.viewModel.creditSummery[indexPath.row])
                
            //deposit cell
            case 2:
                return getDepositCell(amount: 0.0)
                
            //other action
            case 3:
                return getSummeryCell(withData: self.viewModel.otherAction[indexPath.row])
                
            default:
                return UITableViewCell()
            }
            
        case .topUp:
            
            switch indexPath.section {
            //topup summery
            case 0:
                let cell = getSummeryCell(withData: self.viewModel.topUpSummery[indexPath.row]) as! AccountSummeryCell
                
                if indexPath.row == 1 {
                    cell.stackViewTop.constant = -4.0
                }
                else if let sym = self.viewModel.topUpSummery[indexPath.row].symbol, sym == "=" {
                    cell.stackViewTop.constant = 4.0
                }
                
                return cell
                
            //deposit cell
            case 1:
                return getDepositCell(amount: 5953.0)
                
            //other action
            case 2:
                return getSummeryCell(withData: self.viewModel.otherAction[indexPath.row])
                
            default:
                return UITableViewCell()
            }
            
        case .billWise:
            
            switch indexPath.section {
            //bilwise summery
            case 0:
                let cell = getSummeryCell(withData: self.viewModel.bilWiseSummery[indexPath.row]) as! AccountSummeryCell
                
                if indexPath.row == 1 {
                    cell.stackViewTop.constant = -4.0
                }
                
                return cell
                
            //credit summery
            case 1:
                return getSummeryCell(withData: self.viewModel.creditSummery[indexPath.row])
                
            //deposit cell
            case 2:
                return getDepositCell(amount: 0.0)
                
            //other action
            case 3:
                return getSummeryCell(withData: self.viewModel.otherAction[indexPath.row])
                
            default:
                return UITableViewCell()
            }
            
        default:
            return UITableViewCell()
        }
    }
    
    func getSummeryCell(withData: SpecialAccountEvent) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummeryCell.reusableIdentifier) as? AccountSummeryCell else {
            return UITableViewCell()
        }
        
        cell.event = withData
        
        return cell
    }
    
    func getDepositCell(amount: Double) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountDepositCell.reusableIdentifier) as? AccountDepositCell else {
            return UITableViewCell()
        }
        
        cell.configure(amount: amount.amountInDelimeterWithSymbol)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.currentUserType {
        case .statement:
            if (indexPath.section == 3) {
                switch indexPath.row {
                case 0:
                    AppFlowManager.default.moveToAccountDetailsVC(usingFor: .accountLadger)
                    
                case 1:
                    AppFlowManager.default.moveToAccountOutstandingLadgerVC()
                    
                case 2:
                    printDebug("predioc statement")
                    
                default:
                    printDebug("no need to implement")
                }
            }

        case .topUp:
            if (indexPath.section == 2) {
                switch indexPath.row {
                case 0:
                    AppFlowManager.default.moveToAccountDetailsVC(usingFor: .accountLadger)
                    
                case 1:
                    AppFlowManager.default.moveToAccountOutstandingLadgerVC()
                    
                default:
                    printDebug("no need to implement")
                }
            }

        case .billWise:
            if (indexPath.section == 3) {
                switch indexPath.row {
                case 0:
                    AppFlowManager.default.moveToAccountDetailsVC(usingFor: .accountLadger)
                    
                case 1:
                    AppFlowManager.default.moveToAccountOutstandingLadgerVC()
                    
                default:
                    printDebug("no need to implement")
                }
            }
            
        default:
            printDebug("No need to implement")
        }
    }
}


//MARK:- Cell Classes
//MARK:-
class AccountSummeryCell: UITableViewCell {
    
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var dividerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dividerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewTop: NSLayoutConstraint!
    @IBOutlet weak var amountLabelTraillingConstant: NSLayoutConstraint!
    
    
    //MARK:- Life Cycle
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    var event: SpecialAccountEvent? {
        didSet {
            self.setupData()
        }
    }
    
    //MARK:- Properties
    //MARK:- Private
    private func resetAllSubViews() {
        titleLabel.isHidden = true
        descLabel.isHidden = true
        symbolLabel.isHidden = true
        amountLabel.isHidden = true
        dividerView.isHidden = true
        
        titleLabel.text = ""
        descLabel.text = ""
        symbolLabel.text = ""
        amountLabel.text = ""
        amountLabel.attributedText = nil
        
        dividerViewLeadingConstraint.constant = 16.0
        dividerViewTrailingConstraint.constant = 16.0
        amountLabelTraillingConstant.constant = 16.0
        
        if let user = UserInfo.loggedInUser, (user.userType == .topUp) {
            stackViewTop.constant = self.event!.isForTitle ? 4.0 : 0.0
        }
    }
    
    //MARK:- Public
    
    
    //MARK:- Methods
    //MARK:- Private
    private func setupData() {
        guard let evnt = self.event else {
            self.resetAllSubViews()
            return
        }
        
        if evnt.isForTitle {
            self.configureHeader(title: evnt.title)
        }
        else if evnt.isNext {
            self.configureNext(title: evnt.title)
        }
        else if let sym = evnt.symbol, sym == "=" {
            self.configureGrandTotal(title: evnt.title, totalAmount: evnt.amount)
        }
        else {
            self.configure(detail: evnt.title, amount: evnt.amount, descp: evnt.description, symbol: evnt.symbol)
        }
    }
    
    //MARK:- Public
    private func configureHeader(title: String) {
        self.resetAllSubViews()
        
        self.titleLabel.isHidden = false
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.titleLabel.textColor = AppColors.themeGray40
        self.titleLabel.text = title
    }
    
    private func configure(detail: String, amount: String, descp: String? = nil, symbol: String? = nil) {
        self.resetAllSubViews()
        
        self.dividerView.isHidden = !(self.event!.isDevider)
        self.dividerViewTrailingConstraint.constant = 16.0
        
        self.titleLabel.isHidden = false
        self.titleLabel.font = AppFonts.Regular.withSize(16.0)
        self.titleLabel.textColor = AppColors.themeBlack
        self.titleLabel.text = detail
        
        if let sym = symbol {
            self.symbolLabel.isHidden = false
            self.symbolLabel.font = AppFonts.SemiBold.withSize(20.0)
            self.symbolLabel.textColor = AppColors.themeBlack
            self.symbolLabel.text = sym
        }
        
        if let des = descp {
            self.descLabel.isHidden = false
            self.descLabel.font = AppFonts.Regular.withSize(14.0)
            self.descLabel.textColor = AppColors.themeGray40
            self.descLabel.text = des
        }
        
        self.amountLabel.isHidden = false
        self.amountLabel.font = AppFonts.Regular.withSize(16.0)
        self.amountLabel.textColor = AppColors.themeBlack
        self.amountLabel.text = amount
    }
    
    private func configureGrandTotal(title: String, totalAmount: String) {
        self.resetAllSubViews()
        
        self.titleLabel.isHidden = false
        self.titleLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.titleLabel.textColor = AppColors.themeBlack
        self.titleLabel.text = title
        
        self.symbolLabel.isHidden = false
        self.symbolLabel.font = AppFonts.SemiBold.withSize(20.0)
        self.symbolLabel.textColor = AppColors.themeBlack
        self.symbolLabel.text = "="
        
        self.amountLabel.isHidden = false
        self.amountLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.amountLabel.textColor = AppColors.themeBlack
        self.amountLabel.text = totalAmount
    }
    
    private func configureNext(title: String) {
        self.resetAllSubViews()
        
        self.dividerView.isHidden = false
        self.dividerViewTrailingConstraint.constant = 0.0
        if self.event!.isLastNext {
            self.dividerViewLeadingConstraint.constant = 0.0
        }
        
        self.titleLabel.isHidden = false
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        self.titleLabel.textColor = AppColors.themeBlack
        self.titleLabel.text = title
        
        self.amountLabel.isHidden = false
        self.amountLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.amountLabel.textColor = AppColors.themeBlack
        self.amountLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image: #imageLiteral(resourceName: "arrowNextScreen"), endText: "", font: AppFonts.SemiBold.withSize(16.0))
        self.amountLabelTraillingConstant.constant = 0.0
    }
}

class AccountDepositCell: UITableViewCell {
    
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var depositButton: ATButton!
    
    
    //MARK:- Life Cycle
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.depositButton.layer.cornerRadius = self.depositButton.height / 2.0
    }
    
    //MARK:- Properties
    //MARK:- Private
    
    //MARK:- Public
    
    
    //MARK:- Methods
    //MARK:- Private
    func configure(amount: String) {
        
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.titleLabel.textColor = AppColors.themeGray40
        self.titleLabel.text = "Total Amount Due"
        
        self.amountLabel.font = AppFonts.SemiBold.withSize(28.0)
        self.amountLabel.textColor = AppColors.themeBlack
        self.amountLabel.text = amount
        
        self.dateLabel.font = AppFonts.Regular.withSize(14.0)
        self.dateLabel.textColor = AppColors.themeRed
        self.dateLabel.text = "Before Fri, 12 May 2017"
        
        self.depositButton.setTitle("Deposit", for: .normal)
        self.depositButton.setTitle("Deposit", for: .selected)
        self.depositButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.depositButton.setTitleColor(AppColors.themeWhite, for: .selected)
    }
    
    //MARK:- Public
}
