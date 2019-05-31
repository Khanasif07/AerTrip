//
//  OtherBookingsDetails.swift
//  AERTRIP
//
//  Created by Admin on 17/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import MXParallaxHeader
import UIKit

class OtherBookingsDetailsVC: BaseVC {

    //MARK:- Variables
    //MARK
    let viewModel = OtherBookingsDetailsVM()
    private var headerView: OtherBookingDetailsHeaderView = OtherBookingDetailsHeaderView()
    
    //MARK:- IBOutlets
    //MARK
    @IBOutlet weak var topNavBar: TopNavigationView!
    @IBOutlet weak var dataTableView: ATTableView!
    
    //MARK:- LifeCycle
    //MARK
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       headerView = OtherBookingDetailsHeaderView.instanceFromNib()
       headerView.backgroundColor = .red
        self.viewModel.getSectionData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.statusBarStyle = .lightContent
    }
    
    override func initialSetup() {
        self.statusBarStyle = .default
        self.topNavBar.configureNavBar(title: nil, isLeftButton: true, isFirstRightButton: true , isDivider: false)
        self.topNavBar.configureLeftButton(normalImage: #imageLiteral(resourceName: "backGreen"), selectedImage: #imageLiteral(resourceName: "backGreen"))
        self.topNavBar.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "greenPopOverButton"), selectedImage: #imageLiteral(resourceName: "greenPopOverButton"))
        self.setupParallaxHeader()
        //self.configureTableHeaderView()
        self.registerNibs()
        self.dataTableView.delegate = self
        self.dataTableView.dataSource = self
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
        self.headerView.delegate = self
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//      
//            headerView.frame = CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: 152.0)
//        
//    }
    
    override func viewDidLayoutSubviews() {
        guard let headerView = dataTableView.tableHeaderView else {
            return
        }

        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            self.dataTableView.tableHeaderView = headerView
            self.dataTableView.layoutIfNeeded()
        }
    }
    
//    ///ConfigureCheckInOutView
//    private func configureTableHeaderView() {
//        self.headerView = OtherBookingDetailsHeaderView(frame: CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: 152.0))
////        if let view = self.headerView {
////            self.dataTableView.tableHeaderView = view
////        }
//    }
    
    //MARK:- Functions
    //MARK
    
    private func setupParallaxHeader() { // Parallax Header
        let parallexHeaderHeight = CGFloat(152.0)
        let parallexHeaderMinHeight = navigationController?.navigationBar.bounds.height ?? 74 //105
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
    //MARK
}

//MARK:- Extensions
//MARK=
extension OtherBookingsDetailsVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.sectionData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = self.viewModel.sectionData[indexPath.section]
        switch currentSection[indexPath.row] {
        case .insurenceCell:
            let cell = self.getInsurenceCell(tableView, indexPath: indexPath)
            return cell
        case .policyDetailCell:
            let cell = self.getPolicyDetailCell(tableView, indexPath: indexPath)
            return cell
        case .travellersDetailCell:
            let cell = self.getTravellersDetailsCell(tableView, indexPath: indexPath)
            return cell
        case .documentCell:
            let cell = self.getBookingDocumentsCell(tableView, indexPath: indexPath)
            return cell
        case .paymentInfoCell:
            let cell = self.getPaymentInfoCell(tableView, indexPath: indexPath)
            return cell
        case .bookingCell:
            let cell = self.getBookingCell(tableView, indexPath: indexPath)
            return cell
        case .paidCell:
            let cell = self.getPaidCell(tableView, indexPath: indexPath)
            return cell
        case .nameCell:
            let cell = self.getNameCell(tableView, indexPath: indexPath)
            return cell
        case .emailCell:
            let cell = self.getEmailCell(tableView, indexPath: indexPath)
            return cell
        case .mobileCell:
            let cell = self.getMobileCell(tableView, indexPath: indexPath)
            return cell
        case .gstCell:
            let cell = self.getGstCell(tableView, indexPath: indexPath)
            return cell
        case .billingAddressCell:
            let cell = self.getBillingAddressCell(tableView, indexPath: indexPath)
            return cell
        }
    }
}


extension OtherBookingsDetailsVC {
    func getInsurenceCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.configCell(title: "Travel Insurance", subTitle: "Non Refundable")
        cell.titleLabelBottomConstraint.constant = 0.0
        cell.dividerView.isHidden = true
        cell.containerView.backgroundColor = AppColors.themeWhite
        return cell
    }
    
    func getPolicyDetailCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.titleLabelBottomConstraint.constant = 6.0
        cell.configCell(title: "Policy Certificate No.:", titleFont: AppFonts.SemiBold.withSize(16.0), titleColor: AppColors.themeBlack, subTitle: "4110/O-GTASPL/P/47450/00/000 GOLD TAG PNR : B11828D", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.themeBlack)
        cell.dividerView.isHidden = true
        cell.containerView.backgroundColor = AppColors.themeWhite
        return cell
    }
    
    func getTravellersDetailsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingTravellersDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingTravellersDetailsTableViewCell else { return UITableViewCell() }
        cell.configCell(name: "Mrs. Julian Delgado", imageUrl: "")
        return cell
    }
    
    func getBookingDocumentsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingDocumentsTableViewCell.reusableIdentifier, for: indexPath) as? BookingDocumentsTableViewCell else { return UITableViewCell() }
        cell.delegate = self
            return cell
        }
    
    func getPaymentInfoCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentInfoTableViewCell.reusableIdentifier, for: indexPath) as? PaymentInfoTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    func getBookingCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        cell.containerViewBottomConstraint.constant = 0.0
        cell.configCell(title: LocalizedString.Booking.localized, titleFont: AppFonts.Regular.withSize(16.0) , titleColor: AppColors.themeBlack , isFirstCell: false, price: "₹ 10,000", isLastCell: false)
        return cell
    }
    
    func getPaidCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        cell.containerViewBottomConstraint.constant = 26.0
        cell.configCell(title: LocalizedString.Paid.localized, titleFont: AppFonts.Regular.withSize(16.0) , titleColor: AppColors.themeBlack , isFirstCell: false, price: "₹ 10,000", isLastCell: true)
        return cell
    }
    
    func getNameCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.titleLabelTopConstraint.constant = 18.0
        cell.dividerView.isHidden = false
        cell.configCell(title: "Billing Name", titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: "Rosa Luettgen", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.textFieldTextColor51)
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.subtitleLabelBottomConstraint.constant = 9.0
        return cell
    }
    
    func getEmailCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.configCell(title: "Email", titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: "rosa.luettgen@gmail.com", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.textFieldTextColor51)
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        cell.subtitleLabelBottomConstraint.constant = 9.0
        cell.titleLabelBottomConstraint.constant = 2.0
        return cell
    }
    
    func getMobileCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.configCell(title: "Mobile", titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: "+91 12345 67890", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.textFieldTextColor51)
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.subtitleLabelBottomConstraint.constant = 9.0
        return cell
    }
    
    func getGstCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.configCell(title: "GSTIN", titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: "-", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.textFieldTextColor51)
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.subtitleLabelBottomConstraint.constant = 9.0
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        return cell
    }
    
    func getBillingAddressCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleWithSubTitleTableViewCell.reusableIdentifier, for: indexPath) as? TitleWithSubTitleTableViewCell else { return UITableViewCell() }
        cell.titleLabelBottomConstraint.constant = 2.0
        cell.subtitleLabelBottomConstraint.constant = 9.0
        cell.configCell(title: "Billing Address", titleFont: AppFonts.Regular.withSize(14.0), titleColor: AppColors.themeGray40, subTitle: "21/22, Y.A Chunawala Industrial Estate, Kondivita Lane, Andheri East, Mumbai - 400059, Maharashtra, IN", subTitleFont: AppFonts.Regular.withSize(18.0), subTitleColor: AppColors.textFieldTextColor51)
        cell.containerView.backgroundColor = AppColors.screensBackground.color
        return cell
    }
}


extension OtherBookingsDetailsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension OtherBookingsDetailsVC:  URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        printDebug("downloadLocation: \(location)")
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            self.viewModel.urlLink = destinationURL
        } catch let error {
            printDebug("Copy Error: \(error.localizedDescription)")
        }
    }
}

extension OtherBookingsDetailsVC: BookingDocumentsTableViewCellDelegate {
    
    func downloadDocument(url: String, tableIndex: IndexPath, collectionIndex: IndexPath) {
        self.viewModel.urlOfDocuments = url
        guard let url = URL(string: url) else { return }
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
}

//MARK:- ScrollView Delegate
//==========================
extension OtherBookingsDetailsVC : MXParallaxHeaderDelegate {
    func updateForParallexProgress() {
        
        let prallexProgress = self.dataTableView.parallaxHeader.progress
        
        printDebug("progress %f \(prallexProgress)")
        
        if prallexProgress >= 0.6 {
//            profileImageHeaderView.profileImageViewHeightConstraint.constant = 121 * prallexProgress
        }
        
        if prallexProgress <= 0.5 {
            self.topNavBar.animateBackView(isHidden: false) { [weak self](isDone) in
                self?.topNavBar.firstRightButton.isSelected = true
                self?.topNavBar.leftButton.isSelected = true
                self?.topNavBar.leftButton.tintColor = AppColors.themeGreen
                self?.topNavBar.navTitleLabel.text = "BOM → DEL"
                self?.topNavBar.dividerView.isHidden = false
            }
        } else {
            self.topNavBar.animateBackView(isHidden: true) { [weak self](isDone) in
                self?.topNavBar.firstRightButton.isSelected = false
                self?.topNavBar.leftButton.isSelected = false
                self?.topNavBar.leftButton.tintColor = AppColors.themeWhite
                self?.topNavBar.navTitleLabel.text = ""
                self?.topNavBar.dividerView.isHidden = true
            }
        }
        self.headerView.layoutIfNeeded()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateForParallexProgress()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updateForParallexProgress()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.updateForParallexProgress()
    }
}

extension OtherBookingsDetailsVC: OtherBookingDetailsHeaderViewDelegate {
    func backButtonAction() {
        print("Back Button Pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    func optionButtonAction() {
        print("Option Button Pressed")
    }
}
