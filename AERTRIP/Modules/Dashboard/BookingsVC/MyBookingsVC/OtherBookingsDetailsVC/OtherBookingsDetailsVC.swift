//
//  OtherBookingsDetails.swift
//  AERTRIP
//
//  Created by Admin on 17/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Alamofire
import MXParallaxHeader
import UIKit

class OtherBookingsDetailsVC: BaseVC {
    // MARK: - Variables
    
    // MARK: ===========
    
    let viewModel = BookingProductDetailVM()
    var headerView: OtherBookingDetailsHeaderView?
    var eventTypeImage: UIImage {
        return #imageLiteral(resourceName: "others")
    }
    
    private var navBarHeight: CGFloat {
        return UIDevice.isIPhoneX ? 88.0 : 64.0
    }
    
    // MARK: - IBOutlets
    
    // MARK: ===========
    
    @IBOutlet weak var topNavBar: TopNavigationView!
    @IBOutlet weak var dataTableView: ATTableView! {
        didSet {
            self.dataTableView.estimatedRowHeight = 100.0
            self.dataTableView.rowHeight = UITableView.automaticDimension
            self.dataTableView.contentInset = UIEdgeInsets(top: 4.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.dataTableView.estimatedSectionHeaderHeight = 0
            self.dataTableView.sectionHeaderHeight = 0
        }
    }
    
    @IBOutlet weak var topNavBarHeightConstraint: NSLayoutConstraint!
    
    // MARK: - LifeCycle
    
    // MARK: ===========
    override func initialSetup() {
        self.headerView = OtherBookingDetailsHeaderView(frame: CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: 147.0))
        self.viewModel.getBookingDetail()
        self.statusBarStyle = .default
        self.topNavBarHeightConstraint.constant = self.navBarHeight
        self.topNavBar.configureNavBar(title: nil, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: false, backgroundType: .blurAnimatedView(isDark: false))
        self.topNavBar.configureLeftButton(normalImage: #imageLiteral(resourceName: "backGreen"), selectedImage: #imageLiteral(resourceName: "backGreen"))
        self.topNavBar.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "greenPopOverButton"), selectedImage: #imageLiteral(resourceName: "greenPopOverButton"))
        self.setupParallaxHeader()
        self.registerNibs()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let documentDownloadingData = self.viewModel.bookingDetail?.documents else { return }
        for documentData in documentDownloadingData {
            if documentData.downloadingStatus == .downloading {
                documentData.downloadRequest?.cancel()
            }
        }
    }
    
    override func setupTexts() {}
    
    override func setupFonts() {}
    
    override func setupColors() {
        self.topNavBar.backgroundColor = AppColors.clear
    }
    
    override func bindViewModel() {
        self.topNavBar.delegate = self
        self.viewModel.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let view = self.headerView {
            view.frame = CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: 152.0)
        }
    }
    
    // MARK: - Functions
    
    // MARK: ===========
    
    /// ConfigureCheckInOutView
    func configureTableHeaderView() {
        if let view = self.headerView {
            view.configureUI(bookingEventTypeImage: self.eventTypeImage, bookingIdStr: self.viewModel.bookingDetail?.id ?? "", bookingIdNumbers: self.viewModel.bookingDetail?.bookingNumber ?? "", date: self.viewModel.bookingDetail?.bookingDate?.toString(dateFormat: "d MMM ''yy") ?? "")
            view.dividerView.isHidden = true
        }
    }
    
    private func setupParallaxHeader() {
        let parallexHeaderHeight = CGFloat(147.0)
        let parallexHeaderMinHeight = CGFloat(0.0)//navigationController?.navigationBar.bounds.height ?? 74
        self.headerView?.translatesAutoresizingMaskIntoConstraints = false
        self.headerView?.widthAnchor.constraint(equalToConstant: dataTableView?.width ?? 0.0).isActive = true
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
        self.dataTableView.registerCell(nibName: TravellersDetailsTableViewCell.reusableIdentifier)
    }
    
    // MARK: - IBActions
    
    // MARK: ===========
}
