//
//  YouAreAllDoneVC.swift
//  AERTRIP
//
//  Created by Admin on 19/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class YouAreAllDoneVC: BaseVC {
    
    //Mark:- Variables
    //================
    let viewModel = YouAreAllDoneVM()
    var allIndexPath = [IndexPath]()
    var tableFooterView: YouAreAllDoneFooterView?
    
    private var viewButton: ATButton?

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var allDoneTableView: ATTableView! {
        didSet {
            self.allDoneTableView.contentInset = UIEdgeInsets.zero
            self.allDoneTableView.delegate = self
            self.allDoneTableView.dataSource = self
            self.allDoneTableView.estimatedSectionFooterHeight = CGFloat.leastNonzeroMagnitude
            self.allDoneTableView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
        }
    }
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.statusBarStyle = .default
        
        AppFlowManager.default.mainNavigationController.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppFlowManager.default.mainNavigationController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.viewButton?.isLoading = false
    }
    
    override func initialSetup() {
    
        self.registerNibs()
        self.tableFooterViewSetUp()
        self.viewModel.getBookingReceipt()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    //Mark:- Functions
    //================
    private func registerNibs() {
        self.allDoneTableView.registerCell(nibName: YouAreAllDoneTableViewCell.reusableIdentifier)
        self.allDoneTableView.registerCell(nibName: EventAdddedTripTableViewCell.reusableIdentifier)
        self.allDoneTableView.register(UINib(nibName: "HCBookingDetailsTableViewHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HCBookingDetailsTableViewHeaderFooterView")
        self.allDoneTableView.registerCell(nibName: HCHotelRatingTableViewCell.reusableIdentifier)
        self.allDoneTableView.registerCell(nibName: HotelInfoAddressCell.reusableIdentifier)
        self.allDoneTableView.registerCell(nibName: HCPhoneTableViewCell.reusableIdentifier)
        self.allDoneTableView.registerCell(nibName: HotelDetailsInclusionTableViewCell.reusableIdentifier)
        self.allDoneTableView.registerCell(nibName: HCCheckInOutTableViewCell.reusableIdentifier)
        self.allDoneTableView.registerCell(nibName: HCBedDetailsTableViewCell.reusableIdentifier)
        self.allDoneTableView.registerCell(nibName: HotelDetailsInclusionTableViewCell.reusableIdentifier)
        self.allDoneTableView.registerCell(nibName: HotelDetailsCancelPolicyTableCell.reusableIdentifier)
        self.allDoneTableView.registerCell(nibName: HCGuestsTableViewCell.reusableIdentifier)
        self.allDoneTableView.registerCell(nibName: HCTotalChargeTableViewCell.reusableIdentifier)
        self.allDoneTableView.registerCell(nibName: HCConfirmationVoucherTableViewCell.reusableIdentifier)
        self.allDoneTableView.registerCell(nibName: HCWhatNextTableViewCell.reusableIdentifier)
    }
    
    private func heightForHeaderInSection(section: Int) -> CGFloat {
        return section == 1 ? 63.0 : CGFloat.leastNonzeroMagnitude
    }
    
    ///Table FooterView SetUp
    private func tableFooterViewSetUp() {
        self.allDoneTableView.tableFooterView?.size = CGSize(width: self.allDoneTableView.frame.width, height: 50.0)
        self.tableFooterView = YouAreAllDoneFooterView(frame: CGRect(x: 0.0, y: self.allDoneTableView.frame.height - 50.0, width: self.allDoneTableView.frame.width, height: 50.0))
        if let tableFooterView = self.tableFooterView {
            self.allDoneTableView.tableFooterView = tableFooterView
        }
    }
    
    //Mark:- IBActions
    //================
    @objc func viewConfirmationVoucherAction(_ sender: ATButton) {
        //open pdf for booking id
        
        if let bId = self.viewModel.bookingIds.first {
            sender.isLoading = true
            AppGlobals.shared.viewPdf(urlPath: "https://beta.aertrip.com/api/v1/dashboard/booking-action?type=pdf&booking_id=\(bId)", screenTitle: LocalizedString.ConfirmationVoucher.localized)
        }
    }
}

//Mark:- UITableView Delegate DataSource
//======================================
extension YouAreAllDoneVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.sectionData[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HCBookingDetailsTableViewHeaderFooterView") as? HCBookingDetailsTableViewHeaderFooterView else { return nil }
            return headerView
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSectionData = self.viewModel.sectionData[indexPath.section]
        switch currentSectionData[indexPath.row] {
        case .allDoneCell:
                if let cell = self.getAllDoneCell(tableView, indexPath: indexPath) {
                    return cell
                }
        case .eventSharedCell:
            if let cell = self.getEventSharedCell(tableView, indexPath: indexPath) {
                return cell
            }
        case .ratingCell:
            if let cell = self.getRatingCell(tableView, indexPath: indexPath) {
                return cell
            }
        case .addressCell:
            if let cell = self.getAddressCell(tableView, indexPath: indexPath) {
                return cell
            }
        case .phoneCell:
            if let cell = self.getPhoneCell(tableView, indexPath: indexPath) {
                return cell
            }
        case .webSiteCell:
            if let cell = self.getWebSiteCell(tableView, indexPath: indexPath) {
                return cell
            }
        case .checkInOutCell:
            if let cell = self.getCheckInOutCell(tableView, indexPath: indexPath) {
                return cell
            }
        case .roomBedsDetailsCell:
            if let cell = self.getBedDetailsCell(tableView, indexPath: indexPath) {
                return cell
            }
        case .roomBedsTypeCell:
            if let cell = self.getBedTypeCell(tableView, indexPath: indexPath) {
                return cell
            }
        case .inclusionCell:
            if let cell = self.getInclusionCell(tableView, indexPath: indexPath, roomData: self.viewModel.hotelReceiptData?.rooms[indexPath.section - 2] ?? Room()) {
                return cell
            }
        case .otherInclusionCell:
            if let cell = self.getOtherInclusionCell(tableView, indexPath: indexPath, roomData: self.viewModel.hotelReceiptData?.rooms[indexPath.section - 2] ?? Room()) {
                return cell
            }
        case .cancellationPolicyCell:
            if let cell = self.getCancellationCell(tableView, indexPath: indexPath, roomData: self.viewModel.hotelReceiptData?.rooms[indexPath.section - 2] ?? Room()) {
                return cell
            }
        case .paymentPolicyCell:
            if let cell = self.getPaymentInfoCell(tableView, indexPath: indexPath, roomData: self.viewModel.hotelReceiptData?.rooms[indexPath.section - 2] ?? Room()) {
                return cell
            }
        case .notesCell:
            if let cell = self.getNotesCell(tableView, indexPath: indexPath, roomData: self.viewModel.hotelReceiptData?.rooms[indexPath.section - 2] ?? Room()) {
                return cell
            }
        case .guestsCell:
            if let cell = self.getGuestsCell(tableView, indexPath: indexPath) {
                return cell
            }
        case .totalChargeCell:
            if let cell = self.getTotalChargeCell(tableView, indexPath: indexPath) {
                return cell
            }
        case .confirmationVoucherCell:
            if let cell = self.getConfirmationVoucherCell(tableView, indexPath: indexPath) {
                self.viewButton = cell.viewButton
                cell.viewButton.addTarget(self, action: #selector(viewConfirmationVoucherAction(_:)), for: .touchUpInside)
                return cell
            }
        case .whatNextCell:
            if let cell = self.getWhatNextCell(tableView, indexPath: indexPath) {
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1, indexPath.row == 1 , self.viewModel.sectionData[1].contains(.addressCell) {
            if let hotelData = self.viewModel.hotelReceiptData {
                let text = hotelData.address + "Maps    "
                let size = text.sizeCount(withFont: AppFonts.Regular.withSize(18.0), bundingSize: CGSize(width: UIDevice.screenWidth - 32.0, height: 10000.0))
                return size.height + 46.5
                    + 21.0  + 2.0//y of textview 46.5 + bottom space 21.0
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.heightForHeaderInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.heightForHeaderInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.cellForRow(at: indexPath) as? HotelInfoAddressCell) != nil {
            AppGlobals.shared.redirectToMap(sourceView: view, originLat: self.viewModel.originLat, originLong: self.viewModel.originLong, destLat: self.viewModel.hotelReceiptData?.lat ?? "", destLong: self.viewModel.hotelReceiptData?.long ?? "")
        }
    }
}

//Mark:- GetFullInfoDelegate
//==========================
extension YouAreAllDoneVC: GetFullInfoDelegate {
    func expandCell(expandHeight: CGFloat, indexPath: IndexPath) {
        printDebug(expandHeight)
        if !allIndexPath.contains(indexPath) {
            self.allIndexPath.append(indexPath)
            self.allDoneTableView.reloadData()
        }
    }
}

extension YouAreAllDoneVC: YouAreAllDoneVMDelegate {
    
    func willGetBookingReceipt() {
    }
    
    func getBookingReceiptSuccess() {
        self.viewModel.getWhatNextData()
        self.viewModel.getTableViewSectionData()
        self.allDoneTableView.reloadData()
    }
    
    func getBookingReceiptFail() {

    }
}

//Mark:- HCGuestsTableViewCell Delegate
//=====================================
extension YouAreAllDoneVC: HCGuestsTableViewCellDelegate {
    func emailItineraryButtonAction(_ sender: UIButton , indexPath: IndexPath) {
        AppFlowManager.default.presentHCEmailItinerariesVC(forBookingId: self.viewModel.bookingIds.first ?? "", travellers: self.viewModel.hotelReceiptData?.travellers[indexPath.section - 2] ?? [])
    }
}

//Mark:- HCWhatNextTableViewCellDelegate Delegate
//=====================================
extension YouAreAllDoneVC: HCWhatNextTableViewCellDelegate {
    
    func shareOnFaceBook() {
        printDebug("Share On FaceBook")
    }
    
    func shareOnTwitter() {
        printDebug("Share On Twitter")
    }
    
    func shareOnLinkdIn() {
        printDebug("Share On LinkdIn")
    }
}
