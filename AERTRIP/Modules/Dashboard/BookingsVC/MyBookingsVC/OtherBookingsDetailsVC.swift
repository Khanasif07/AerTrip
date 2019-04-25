//
//  OtherBookingsDetails.swift
//  AERTRIP
//
//  Created by Admin on 17/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class OtherBookingsDetailsVC: BaseVC {

    //MARK:- Variables
    //MARK
    let viewModel = OtherBookingsDetailsVM()
    
    //MARK:- IBOutlets
    //MARK
    @IBOutlet weak var topNavBar: TopNavigationView!
    @IBOutlet weak var bookingDataContainerView: UIView!
    @IBOutlet weak var bookingEventTypeImageView: UIImageView!
    @IBOutlet weak var bookingIdAndDateTitleLabel: UILabel!
    @IBOutlet weak var bookingIdAndDateLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var dataTableView: UITableView! {
        didSet {
            self.dataTableView.delegate = self
            self.dataTableView.dataSource = self
            self.dataTableView.estimatedRowHeight = 100.0
            self.dataTableView.rowHeight = UITableView.automaticDimension
            self.dataTableView.contentInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 10.0, right: 0.0)
        }
    }
    
    //MARK:- LifeCycle
    //MARK
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        self.registerNibs()
    }
    
    override func setupTexts() {
        self.bookingIdAndDateTitleLabel.text = LocalizedString.BookingIDAndDate.localized
    }
    
    override func setupFonts() {
        self.bookingIdAndDateTitleLabel.font = AppFonts.Regular.withSize(14.0)
        self.bookingIdAndDateLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupColors() {
        self.bookingIdAndDateTitleLabel.textColor = AppColors.themeGray40
        self.bookingIdAndDateLabel.textColor = AppColors.themeBlack
        self.topNavBar.backgroundColor = AppColors.clear
    }
    
    override func bindViewModel() {
        self.topNavBar.delegate = self
    }
    
    //MARK:- Functions
    //MARK
    private func registerNibs() {
        self.dataTableView.registerCell(nibName: TitleWithSubTitleTableViewCell.reusableIdentifier)
        self.dataTableView.registerCell(nibName: BookingTravellersDetailsTableViewCell.reusableIdentifier)
        self.dataTableView.registerCell(nibName: BookingDocumentsTableViewCell.reusableIdentifier)
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
//        cell.titleLabelTopConstraint.constant = 16.0
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        cell.containerViewTopConstraint.constant = 26.0
        cell.titleBottomConstraint.constant = 6.0
        cell.configCell(title: LocalizedString.PaymentInfo.localized, titleFont: AppFonts.Regular.withSize(14.0) , titleColor: AppColors.themeGray40 , isFirstCell: true, isLastCell: false)
        return cell
    }
    
    func getBookingCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingPaymentDetailsTableViewCell.reusableIdentifier, for: indexPath) as? BookingPaymentDetailsTableViewCell else { return UITableViewCell() }
        cell.titleTopConstraint.constant = 6.0
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
        print("downloadLocation:", location)
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
            print("Copy Error: \(error.localizedDescription)")
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
