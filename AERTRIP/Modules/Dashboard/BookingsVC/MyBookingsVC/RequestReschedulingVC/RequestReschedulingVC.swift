//
//  RequestReschedulingVC.swift
//  AERTRIP
//
//  Created by Admin on 03/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class RequestReschedulingVC: BaseVC {

    //MARK:- Variables
    //MARK:===========
    let viewModel = RequestReschedulingVM()
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var topNavBar: BookingTopNavBarWithSubtitle!
    @IBOutlet weak var rescheduleAmountView: UIView!
    @IBOutlet weak var reschedulingViewHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var totalRefundTitleLabel: UILabel!
    @IBOutlet weak var totalRefundAmountLabel: UILabel!
    @IBOutlet weak var reschedulingTableView: UITableView! {
        didSet {
            self.reschedulingTableView.estimatedRowHeight = UITableView.automaticDimension
            self.reschedulingTableView.backgroundColor = AppColors.themeGray04
//            self.reschedulingTableView.rowHeight = UITableView.automaticDimension
        }
    }
    @IBOutlet weak var requestReschedulingBtnOutlet: ATButton!
    @IBOutlet weak var gradientView: UIView!
    
    //MARK:- LifeCycle
    //MARK:===========
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reschedulingViewHeightConstraints.constant = 0.0
        self.rescheduleAmountView.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.gradientView.addGredient(isVertical: false)
    }
    
    override func initialSetup() {
        self.reschedulingTableView.contentInset = UIEdgeInsets(top: topNavBar.height + 2.0, left: 0.0, bottom: 0.0, right: 0.0)

        self.topNavBar.configureView(title: LocalizedString.newDate.localized, subTitle: LocalizedString.selectNewDepartingDate.localized, isleftButton: true, isRightButton: false)
        self.registerXibs()
        self.reschedulingTableView.delegate = self
        self.reschedulingTableView.dataSource = self
        self.topNavBar.delegate = self
        self.requestReschedulingBtnOutlet.isShadowColorNeeded = true
        self.requestReschedulingBtnOutlet.shadowColor = AppColors.clear
        self.requestReschedulingBtnOutlet.shouldShowPressAnimation = false
        self.setTotalRefundAmount()
        self.gradientView.addGredient(isVertical: false)
        self.reschedulingTableView.backgroundColor = AppColors.themeGray04
    }
    
    override func setupColors() {
        self.requestReschedulingBtnOutlet.backgroundColor = AppColors.clear
    }
    
    override func setupTexts() {
       self.totalRefundTitleLabel.text = LocalizedString.TotalNetRefund.localized
        self.requestReschedulingBtnOutlet.setTitle(LocalizedString.RequestRescheduling.localized, for: .normal)
    }
    
    override func setupFonts() {
        self.totalRefundTitleLabel.font = AppFonts.Regular.withSize(18.0)
        self.totalRefundAmountLabel.font = AppFonts.Regular.withSize(18.0)
        self.requestReschedulingBtnOutlet.setTitleFont(font: AppFonts.SemiBold.withSize(20.0), for: .normal)
        self.requestReschedulingBtnOutlet.setTitleFont(font: AppFonts.SemiBold.withSize(20.0), for: .selected)
        self.requestReschedulingBtnOutlet.setTitleFont(font: AppFonts.SemiBold.withSize(20.0), for: .highlighted)
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientView.addGredient(isVertical: false)
    }
    
    //MARK:- Functions
    //MARK:===========
    private func setTotalRefundAmount() {
        self.totalRefundAmountLabel.text = self.viewModel.totRefund.delimiterWithSymbol
    }
    private func registerXibs() {
        self.reschedulingTableView.registerCell(nibName: ParallelLabelsTableViewCell.reusableIdentifier)
        self.reschedulingTableView.registerCell(nibName: SelectDateTableViewCell.reusableIdentifier)
        self.reschedulingTableView.registerCell(nibName: HCSpecialRequestTextfieldCell.reusableIdentifier)
        self.reschedulingTableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        self.reschedulingTableView.registerCell(nibName: CustomerContactCellTableViewCell.reusableIdentifier)
    }
    
    internal func heightForRow(_ tableView: UITableView, indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK:- IBActions
    //MARK:===========
    @IBAction func requestReschedulingBtnAction(_ sender: ATButton) {
        self.view.endEditing(true)
        if self.viewModel.isValidData() {
           self.viewModel.makeRequestForRescheduling()
        }
    }
}
