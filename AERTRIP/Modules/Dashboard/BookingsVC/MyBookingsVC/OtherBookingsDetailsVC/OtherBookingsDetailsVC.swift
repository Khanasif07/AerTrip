//
//  OtherBookingsDetails.swift
//  AERTRIP
//
//  Created by Admin on 17/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import MXParallaxHeader
import Alamofire

class OtherBookingsDetailsVC: BaseVC {
    
    //MARK:- Variables
    //MARK:===========
    let viewModel = OtherBookingsDetailsVM()
    var headerView: OtherBookingDetailsHeaderView?
    var eventTypeImage: UIImage {
        return #imageLiteral(resourceName: "others")
    }
    private var navBarHeight: CGFloat {
        return UIDevice.isIPhoneX ? 84.0 : 64.0
    }
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var topNavBar: TopNavigationView!
    @IBOutlet weak var dataTableView: ATTableView! {
        didSet {
            self.dataTableView.estimatedRowHeight = 100.0
            self.dataTableView.rowHeight = UITableView.automaticDimension
//            self.dataTableView.contentInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 10.0, right: 0.0)
            self.dataTableView.estimatedSectionHeaderHeight = CGFloat.zero
            self.dataTableView.sectionHeaderHeight = CGFloat.zero
        }
    }
    @IBOutlet weak var topNavBarHeightConstraint: NSLayoutConstraint!
    
    //MARK:- LifeCycle
    //MARK:===========
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.getSectionData()
        self.viewModel.getDocumentDownloadingData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.statusBarStyle = .lightContent
    }
    
    override func initialSetup() {
        self.statusBarStyle = .default
        self.topNavBarHeightConstraint.constant = self.navBarHeight
        self.topNavBar.shouldAddBlurEffect = true
        self.topNavBar.configureNavBar(title: nil, isLeftButton: true, isFirstRightButton: true , isDivider: false)
        self.topNavBar.configureLeftButton(normalImage: #imageLiteral(resourceName: "backGreen"), selectedImage: #imageLiteral(resourceName: "backGreen"))
        self.topNavBar.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "greenPopOverButton"), selectedImage: #imageLiteral(resourceName: "greenPopOverButton"))
        self.configureTableHeaderView()
        self.setupParallaxHeader()
        self.registerNibs()
        self.dataTableView.delegate = self
        self.dataTableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        for documentData in self.viewModel.documentDownloadingData {
            if documentData.downloadingStatus == .downloading {
                documentData.downloadRequest?.cancel()
            }
        }
    }
    
    override func setupTexts() {
    }
    
    override func setupFonts() {
    }
    
    override func setupColors() {
        self.topNavBar.backgroundColor = AppColors.clear
    }
    
    override func bindViewModel() {
        self.topNavBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let view = self.headerView {
            view.frame = CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: 152.0)
        }
    }
    
    //MARK:- Functions
    //MARK:===========
    
    ///ConfigureCheckInOutView
    private func configureTableHeaderView() {
        self.headerView = OtherBookingDetailsHeaderView(frame: CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: 152.0))
        if let view = self.headerView {
            view.configureUI(bookingEventTypeImage: self.eventTypeImage, bookingIdStr: "B/16-17/", bookingIdNumbers: "6859403", date: "4 Mar’17")
        }
    }
    
    private func setupParallaxHeader() {
        let parallexHeaderHeight = CGFloat(152.0)
        let parallexHeaderMinHeight = navigationController?.navigationBar.bounds.height ?? 74
        self.dataTableView.parallaxHeader.view = self.headerView
        self.dataTableView.parallaxHeader.minimumHeight = parallexHeaderMinHeight
        self.dataTableView.parallaxHeader.height = parallexHeaderHeight
        self.dataTableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        self.dataTableView.parallaxHeader.delegate = self
        self.view.bringSubviewToFront(self.topNavBar)
    }
    
    private func registerNibs() {
        self.dataTableView.registerCell(nibName: TitleWithSubTitleTableViewCell.reusableIdentifier)
        self.dataTableView.registerCell(nibName: BookingTravellersDetailsTableViewCell.reusableIdentifier)
        self.dataTableView.registerCell(nibName: BookingDocumentsTableViewCell.reusableIdentifier)
        self.dataTableView.registerCell(nibName: PaymentInfoTableViewCell.reusableIdentifier)
        self.dataTableView.registerCell(nibName: BookingPaymentDetailsTableViewCell.reusableIdentifier)
    }
    
    //MARK:- IBActions
    //MARK:===========
}
