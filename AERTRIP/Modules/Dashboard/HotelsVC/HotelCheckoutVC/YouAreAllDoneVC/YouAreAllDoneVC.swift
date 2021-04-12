//
//  YouAreAllDoneVC.swift
//  AERTRIP
//
//  Created by Admin on 19/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import FBSDKShareKit
import PassKit

class YouAreAllDoneVC: BaseVC {
    
    //Mark:- Variables
    //================
    let viewModel = YouAreAllDoneVM()
    var allIndexPath = [IndexPath]()
    var needToShowLoaderOnShare:Bool = false

    //var tableFooterView: YouAreAllDoneFooterView?
    
    private var viewButton: ATButton?
    private var isSuccessAnimationShown = false
    private var tickLayer: CAShapeLayer!
    private var tickImageSize: CGSize {
        let tickImageWidth: CGFloat = 25.0
        return CGSize(width: tickImageWidth, height: tickImageWidth*0.8)
    }
    private var tickLineWidth: CGFloat = 4.0
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var allDoneTableView: ATTableView! {
        didSet {
            self.allDoneTableView.contentInset = UIEdgeInsets.zero
            self.allDoneTableView.delegate = self
            self.allDoneTableView.dataSource = self
            self.allDoneTableView.estimatedSectionFooterHeight = CGFloat.leastNonzeroMagnitude
            self.allDoneTableView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
            self.allDoneTableView.backgroundColor = AppColors.screensBackground.color
        }
    }
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var returnToHomeButton: UIButton!
    @IBOutlet weak var whiteBackgroundView: UIView!
    @IBOutlet weak var tickMarckButton: ATButton!
    @IBOutlet weak var tickMarkBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tickMarkBtnWidthConstraint: NSLayoutConstraint!
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.statusBarStyle = .darkContent
        
        AppFlowManager.default.mainNavigationController.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.isSuccessAnimationShown {
            self.isSuccessAnimationShown = true
            self.setupViewForSuccessAnimation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppFlowManager.default.mainNavigationController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.viewButton?.isLoading = false
    }
    
    override func viewDidLayoutSubviews() {
        self.gradientView.addGredient(isVertical: false)
    }
    
    override func initialSetup() {
        self.view.layoutIfNeeded()
        self.registerNibs()
        self.tableFooterViewSetUp()
        if  let model = self.viewModel.hotelReceiptData {
            if model.booking_status == .booked {
                 self.isSuccessAnimationShown = false
            } else {
                  self.isSuccessAnimationShown = true
                self.whiteBackgroundView.isHidden = true
            }
            getBookingReceiptSuccess()
        } else {
            self.viewModel.getBookingReceipt()
            self.whiteBackgroundView.isHidden = true
            self.isSuccessAnimationShown = true
        }
        
        self.tickMarkBtnWidthConstraint.constant = self.view.width
        self.tickMarckButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
        self.view.layoutIfNeeded()
        //Text
        self.returnToHomeButton.setTitle(LocalizedString.ReturnHome.localized, for: .normal)
        //Font
        self.returnToHomeButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
        //Color
        self.returnToHomeButton.setTitleColor(AppColors.themeWhite, for: .normal)
        
        self.tickMarckButton.setTitle("", for: .normal)
        
        let y = self.whiteBackgroundView.height - 32 - self.tickMarckButton.y - self.tickMarckButton.height
        self.tickMarckButton.transform = CGAffineTransform(translationX:  0, y: y)
    }
    
    //    func setupViewForSuccessAnimation() {
    //
    //            self.tickMarckButton.setTitle(nil, for: .normal)
    //            self.tickMarckButton.setImage(#imageLiteral(resourceName: "Checkmark"), for: .normal)
    //            self.tickMarkBtnWidthConstraint.constant = 74
    //            self.view.layoutIfNeeded()
    //            UIView.animate(withDuration: AppConstants.kAnimationDuration / 4.0, animations: {
    //                self.tickMarkBtnWidthConstraint.constant = 74
    //                self.tickMarkBtnHeightConstraint.constant = 74
    //                self.tickMarckButton.myCornerRadius = 74 / 2.0
    //                self.whiteBackgroundView.alpha = 1.0
    //                self.view.layoutIfNeeded()
    //
    //            }) { (isCompleted) in
    //                //self.letsStartedButton.layer.cornerRadius = reScaleFrame.height / 2.0
    //
    //                let tY = (self.whiteBackgroundView.height) - self.tickMarckButton.height/2 - 115
    //                var t = CGAffineTransform.identity
    //                t = t.translatedBy(x: 0.0, y: -tY)
    //
    //                UIView.animate(withDuration: ((AppConstants.kAnimationDuration / 4.0) * 3.0), animations: {
    //                    self.tickMarckButton.transform = t
    //                    self.whiteBackgroundView.alpha = 1.0
    //                }) { (isCompleted) in
    //                    if isCompleted {
    //                        self.whiteBackgroundView.isHidden = true
    //                        self.allDoneTableView.reloadData()
    //                    }
    //                }
    //            }
    //        }
    
    private func setupViewForSuccessAnimation() {
        self.tickMarckButton.setTitle(nil, for: .normal)
        self.tickMarckButton.setImage(nil, for: .normal)
        self.tickMarkBtnWidthConstraint.constant = 62
        self.view.layoutIfNeeded()
        
        // self.searchBtnOutlet.translatesAutoresizingMaskIntoConstraints = true
        UIView.animate(withDuration: AppConstants.kAnimationDuration / 4.0, animations: {
            self.tickMarkBtnWidthConstraint.constant = 62
            self.tickMarkBtnHeightConstraint.constant = 62
            self.tickMarckButton.myCornerRadius = 62 / 2.0
            self.view.layoutIfNeeded()
            
        }) { (isCompleted) in
            
            let tY: CGFloat
            tY = ((self.whiteBackgroundView.height) / 2.0) - self.tickMarckButton.height/2 - 115
            var t = CGAffineTransform.identity
            t = t.translatedBy(x: 0.0, y: tY )
            UIView.animate(withDuration: ((AppConstants.kAnimationDuration / 4.0) * 3.0), animations: {
                self.tickMarckButton.transform = t
            }) { (isCompleted) in
                self.animatingCheckMark()
                delay(seconds: AppConstants.kAnimationDuration + 0.1, completion: {
                    self.finalTransFormation()
                })
            }
        }
    }
    
    private func finalTransFormation() {
        UIView.animate(withDuration: ((AppConstants.kAnimationDuration / 4.0) * 3.0), animations: {
            self.updateTickPath()
            // self.tickMarckButton.myCornerRadius = self.tickMarckButton.width / 2.0
             self.tickMarckButton.transform = .identity
            
            //                        self.allDoneTableView.reloadData()
            //               self.view.layoutIfNeeded()
        }, completion: { (isCompleted) in
            // self.tickLayer.frame = CGRect(x: (self.tickMarckButton.frame.width - self.tickImageSize.width) / 2.0, y: ((self.tickMarckButton.frame.height - self.tickImageSize.height) / 2.0) + 2, width: self.tickImageSize.width, height: self.tickImageSize.height)
            self.whiteBackgroundView.isHidden = true
            self.allDoneTableView.reloadData()
        })
    }
    
    func updateTickPath() {
        self.tickLayer.frame = CGRect(x: (self.tickMarckButton.frame.width - tickImageSize.width) / 2.0, y: ((self.tickMarckButton.frame.height - tickImageSize.height) / 2.0) + 2, width: tickImageSize.width, height: tickImageSize.height)
    }
    
    ///CheckMark
    private func animatingCheckMark() {
        
        // Shape layer for Check mark path
        let shapeLayer = CAShapeLayer()
        self.tickLayer = shapeLayer
        shapeLayer.frame = CGRect(x: (self.tickMarckButton.frame.width - tickImageSize.width) / 2.0, y: ((self.tickMarckButton.frame.height - tickImageSize.height) / 2.0), width: tickImageSize.width, height: tickImageSize.height)
        shapeLayer.fillColor = AppColors.clear.cgColor
        shapeLayer.strokeColor = AppColors.themeWhite.cgColor
        shapeLayer.lineWidth = tickLineWidth
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.path = self.getTickMarkPath()
        
        // Animation
        self.tickMarckButton.layer.addSublayer(shapeLayer)
        
        // Animation
        self.tickMarckButton.layer.addSublayer(shapeLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = AppConstants.kAnimationDuration
        shapeLayer.add(animation, forKey: "MyAnimation")
    }
    
    private func getTickMarkPath() -> CGPath {
        
        let size: CGSize = tickImageSize
        let path = CGMutablePath()
        path.move(to: CGPoint(x: tickLineWidth / 2.0, y: size.height / 2.0), transform: .identity)
        path.addLine(to: CGPoint(x: CGFloat(ceilf(Float(size.width * 0.3))), y: size.height - tickLineWidth / 1.0), transform: .identity)
        path.addLine(to: CGPoint(x: size.width - tickLineWidth / 3.0, y: tickLineWidth / 3.0), transform: .identity)
        return UIBezierPath(cgPath: path).cgPath
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
        self.allDoneTableView.registerCell(nibName: HCHotelAddreesCell.reusableIdentifier)
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
        return section == 1 ? 44.0 : CGFloat.leastNonzeroMagnitude
    }
    
    ///Table FooterView SetUp
    private func tableFooterViewSetUp() {
        //        self.allDoneTableView.tableFooterView?.size = CGSize(width: self.allDoneTableView.frame.width, height: 50.0)
        //        self.tableFooterView = YouAreAllDoneFooterView(frame: CGRect(x: 0.0, y: self.allDoneTableView.frame.height - 50.0, width: self.allDoneTableView.frame.width, height: 50.0))
        //        if let tableFooterView = self.tableFooterView {
        //            self.allDoneTableView.tableFooterView = tableFooterView
        //        }
    }
    
    //Mark:- IBActions
    //================
    @objc func viewConfirmationVoucherAction(_ sender: ATButton) {
        //open pdf for booking id
        
        if let bId = self.viewModel.bookingIds.first {
            sender.isLoading = true
            AppGlobals.shared.viewPdf(urlPath: "\(AppKeys.baseUrl)api/v1/dashboard/booking-action?type=pdf&booking_id=\(bId)", screenTitle: LocalizedString.ConfirmationVoucher.localized, showLoader: false)
        }
    }
    
    @IBAction func returnHomeBtnAction(_ sender: Any) {
        GuestDetailsVM.shared.guests.removeAll()
//        AppFlowManager.default.mainNavigationController.popToRootController(animated: false)
//        AppFlowManager.default.mainNavigationController.dismiss(animated: false, completion: nil)
//        AppFlowManager.default.currentNavigation?.dismiss(animated: false, completion: nil)
        self.viewModel.logEvent(with: .TapOnReturnToHomeButton)
        AppFlowManager.default.goToDashboard()
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
            headerView.delegate = self
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
        //        if indexPath.section == 1, indexPath.row == 1 , self.viewModel.sectionData[1].contains(.addressCell) {
        //            if let hotelData = self.viewModel.hotelReceiptData {
        //                let text = hotelData.address + "Maps    "
        //                let size = text.sizeCount(withFont: AppFonts.Regular.withSize(18.0), bundingSize: CGSize(width: UIDevice.screenWidth - 32.0, height: 10000.0))
        //                return size.height + 46.5
        //                    + 21.0  + 2.0//y of textview 46.5 + bottom space 21.0
        //            }
        //        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.heightForHeaderInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.heightForHeaderInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if (tableView.cellForRow(at: indexPath) as? HCHotelAddreesCell) != nil {
//            AppGlobals.shared.redirectToMap(sourceView: view, originLat: self.viewModel.originLat, originLong: self.viewModel.originLong, destLat: self.viewModel.hotelReceiptData?.lat ?? "", destLong: self.viewModel.hotelReceiptData?.long ?? "")
//        }else
            if (indexPath.section != 0) && (indexPath.section < tableView.numberOfSections - 1){
                self.viewModel.logEvent(with: .OpenBookedHotelDetails)
            AppFlowManager.default.moveToBookingHotelDetailVC(bookingDetail: nil, hotelTitle: getUpdatedTitle(), bookingId: self.viewModel.bookingIds.first ?? "", hotelName: self.viewModel.hotelReceiptData?.hname ?? "", taRating: self.viewModel.hotelReceiptData?.rating ?? 0.0, hotelStarRating: self.viewModel.hotelReceiptData?.star ?? 0.0, presentingStatusBarStyle: statusBarStyle, dismissalStatusBarStyle: statusBarStyle)
        }
        
        
//        else if (tableView.cellForRow(at: indexPath) as? HCHotelRatingTableViewCell) != nil {
//            //self.viewModel.getBookingDetail()
//            AppFlowManager.default.moveToBookingHotelDetailVC(bookingDetail: nil, hotelTitle: getUpdatedTitle(), bookingId: self.viewModel.bookingIds.first ?? "", hotelName: self.viewModel.hotelReceiptData?.hname ?? "", taRating: self.viewModel.hotelReceiptData?.rating ?? 0.0, hotelStarRating: self.viewModel.hotelReceiptData?.star ?? 0.0)
//        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 10 {
            self.allDoneTableView.backgroundColor = AppColors.themeWhite
        } else {
            self.allDoneTableView.backgroundColor = AppColors.screensBackground.color
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
    
    func willGetBookingDetail() {
        AppGlobals.shared.startLoading()
    }
    
    func getBookingDetailSucces() {
        AppGlobals.shared.stopLoading()
        AppFlowManager.default.moveToBookingHotelDetailVC(bookingDetail: self.viewModel.bookingDetail,hotelTitle: getUpdatedTitle())
        
    }
    
    func getBookingDetailFaiure(error: ErrorCodes) {
        AppGlobals.shared.stopLoading()
        AppToast.default.showToastMessage(message: LocalizedString.SomethingWentWrong.localized)
    }
    func getUpdatedTitle() -> String {
        let updatedTitle = self.viewModel.hotelReceiptData?.hname ?? ""
//        if updatedTitle.count > 24 {
//            updatedTitle = updatedTitle.substring(from: 0, to: 8) + "..." +  updatedTitle.substring(from: updatedTitle.count - 8, to: updatedTitle.count)
//        }
        return updatedTitle
    }
    
    func willGetPinnedTemplate() {
//        AppGlobals.shared.startLoading()
         self.needToShowLoaderOnShare = true
        self.allDoneTableView.reloadData()
//        self.hotelTableView.reloadRow(at: IndexPath(row: 1, section: 0), with: .none)
    }
    
    func getPinnedTemplateSuccess() {
        delay(seconds: 0.5 ) {
            self.needToShowLoaderOnShare = false
            self.allDoneTableView.reloadData()
//            self.hotelTableView.reloadRow(at: IndexPath(row: 1, section: 0), with: .none)
        }
    }
    
    func getPinnedTemplateFail() {
        self.needToShowLoaderOnShare = false
        self.allDoneTableView.reloadData()
//        self.hotelTableView.reloadRow(at: IndexPath(row: 1, section: 0), with: .none)
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
        self.viewModel.logEvent(with: .TapOnFacebookShareButton)
        printDebug("Share On FaceBook")
        
        guard let url = URL(string: AppKeys.kAppStoreLink) else { return }
        let content = ShareLinkContent()
        content.contentURL = url
        let dialog = ShareDialog(
            fromViewController: self,
            content: content,
            delegate: nil
        )
        dialog.mode = .automatic
        dialog.show()
    }
    
    func shareOnTwitter() {
        self.viewModel.logEvent(with: .TapOnTwitterShareButton)
        printDebug("Share On Twitter")
        let tweetText = "\(AppConstants.kAppName) Appstore Link: "
        let tweetUrl = AppKeys.kAppStoreLink
        let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)"
        
        // encode a space to %20 for example
        if let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let url = URL(string: escapedShareString) {
            if UIApplication.shared.canOpenURL(url ) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                AppFlowManager.default.showURLOnATWebView(url, screenTitle:  "")
            }
        }
    }
    
    func shareOnInstagram() {
        self.viewModel.logEvent(with: .TapOnShareButton)
        printDebug("Share On instagram")
        //AppGlobals.shared.shareWithActivityViewController(VC: self , shareData: AppConstants.kAppStoreLink)
        if !self.viewModel.shareLinkURL.isEmpty{
            DispatchQueue.main.async {
                self.willGetPinnedTemplate()
                AppGlobals.shared.shareWithActivityViewController(VC: self , shareData: self.viewModel.shareLinkURL)
                delay(seconds: 0.5) {
                    self.getPinnedTemplateFail()
                }
            }
        } else {
            self.viewModel.getShareLinkAPI {[weak self] (sucess) in
                guard let strongSelf = self else {return}
                if sucess {
                    if !strongSelf.viewModel.shareLinkURL.isEmpty{
                       DispatchQueue.main.async {
                            AppGlobals.shared.shareWithActivityViewController(VC: strongSelf, shareData: strongSelf.viewModel.shareLinkURL)
                        }
                    }
                }
            }
        }
        
//        InstagramManager.sharedManager.postImageToInstagramWithCaption(imageInstagram: UIImage(named: "aertripGreenText")!, instagramCaption: "\(AppConstants.kAppName) Appstore Link: \(AppConstants.kAppStoreLink)", view: self.view)
/*
        let image = UIImage(named: "aertripGreenText")
        let instagramURL = URL(string: "instagram://app")
        if UIApplication.shared.canOpenURL(instagramURL!) {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let saveImagePath = documentsPath + "Image.igo"
            let imageData = image!.pngData()
            do {
                try imageData?.write(to: URL(string: saveImagePath)! , options: Data.WritingOptions(rawValue: 0))
                //try imageData?.writeToFile(saveImagePath, options: NSData.WritingOptions(rawValue: 0))
            } catch {
         printDebug("Instagram sharing error")
            }
            let imageURL = URL(fileURLWithPath: saveImagePath)
            let documentInteractionController = UIDocumentInteractionController()
            documentInteractionController.url = imageURL
            documentInteractionController.annotation = ["InstagramCaption" : "\(AppConstants.kAppName) Appstore Link: \(AppConstants.kAppStoreLink)"]
            documentInteractionController.uti = "com.instagram.exclusivegram"
            
            
            if !documentInteractionController.presentPreview(animated: true) {
         printDebug("Instagram not found")
            }
            
        }
        else {
            print("Instagram not found")
        }
 */
        
    }
}
//Mark:- HCWhatNextTableViewCell Delegate
//=========================================
extension YouAreAllDoneVC: YouAreAllDoneTableViewCellDelegate {
    func addToAppleWalletTapped(button: ATButton) {
        guard let indexPath = self.allDoneTableView.indexPath(forItem: button) else {return}
        
        printDebug("Add To Apple Wallet")
        let endPoints = "\(APIEndPoint.pass.path)?booking_id=\(self.viewModel.bookingDetail?.id ?? "")"
        printDebug("endPoints: \(endPoints)")
        guard let url = URL(string: endPoints) else {return}
        self.viewModel.showWaletLoader = true
        if let cell = self.allDoneTableView.cellForRow(at: indexPath) as? YouAreAllDoneTableViewCell {
            cell.addToAppleWalletButton.isLoading = true
        } else {
            self.allDoneTableView.reloadRow(at: indexPath, with: .none)
        }
        AppGlobals.shared.downloadWallet(fileURL: url, showLoader: false) {[weak self] (passUrl) in
            DispatchQueue.main.async {
                if let localURL = passUrl {
                    printDebug("localURL: \(localURL)")
                    self?.addWallet(passFilePath: localURL)
                }
                self?.viewModel.showWaletLoader = false
                if let cell = self?.allDoneTableView.cellForRow(at: indexPath) as? YouAreAllDoneTableViewCell {
                    cell.addToAppleWalletButton.isLoading = false
                } else {
                    self?.allDoneTableView.reloadRow(at: indexPath, with: .none)
                }
            }
        }
        
    }
    
    private func addWallet(passFilePath: URL) {
        // let filePath = Bundle.main.path(forResource: "DealsPasses", ofType: "pkpass")!
        guard let passData = try? Data(contentsOf: passFilePath) else {return}
        do {
            guard let newpass = try? PKPass.init(data: passData), let addController =  PKAddPassesViewController(pass: newpass) else {return}
            addController.delegate = self
            self.present(addController, animated: true)
        } catch {
            printDebug(error)
        }
    }
    
    func addToCallendarTapped() {
        if let start = self.viewModel.hotelReceiptData?.eventStartDate, let end = self.viewModel.hotelReceiptData?.eventEndDate {
            let bId = self.viewModel.bookingIds.first ?? ""
            
            let title = "Hotel: \(self.viewModel.hotelReceiptData?.hname ?? ""), \(self.viewModel.hotelReceiptData?.city ?? "")"
            let location = self.viewModel.hotelReceiptData?.address ?? ""
            let bookingId = "Booking Id: \(bId)"
            _ = "Confirmation Code: \(bId)"
            // confirmation code pending to append
            let notes = bookingId //+ "\n \(confirmationCode)"
            
            AppGlobals.shared.addEventToCalender(title: title, startDate: start, endDate: end, location: location,  notes: notes, uniqueId: bId)
        }
    }
    
    
}

//Mark:- HCBookingDetailsTableViewHeaderFooterView Delegate
//=========================================================
extension YouAreAllDoneVC: HCBookingDetailsTableViewHeaderFooterViewDelegate {
    func emailIternaryButtonTapped() {
        AppFlowManager.default.presentHCEmailItinerariesVC(forBookingId: self.viewModel.bookingIds.first ?? "", travellers: self.viewModel.hotelReceiptData?.travellers.flatMap({ $0 }) ?? [], presentingStatusBarStyle: statusBarStyle, dismissalStatusBarStyle: statusBarStyle)
    }
    
}

extension YouAreAllDoneVC{
    
    func tapOnSeletedWhatNext(index: Int){
        if self.viewModel.hotelReceiptData?.whatNext.count == 0{
            guard let bookingId = self.viewModel.bookingIds.first else {
                return
            }
            self.viewModel.logEvent(with: .TapOnWhatsNextModifyBookingCard)
            AppFlowManager.default.moveToHotelBookingsDetailsVC(bookingId: bookingId)
        }else{
            if index == self.viewModel.hotelReceiptData?.whatNext.count{
                guard let bookingId = self.viewModel.bookingIds.first else {
                    return
                }
                self.viewModel.logEvent(with: .TapOnWhatsNextModifyBookingCard)
                AppFlowManager.default.moveToHotelBookingsDetailsVC(bookingId: bookingId)
            }else{
                guard let whtNxt = self.viewModel.hotelReceiptData?.whatNext[index] else {return}
                switch whtNxt.productType{
                case .flight:
                    self.viewModel.logEvent(with: .TapOnWhatsNextFlightCard)
                    self.bookFlightFor(whtNxt)
                case .hotel:
                    self.bookAnotherHotels(whtNxt)
                    self.viewModel.logEvent(with: .TapOnWhatsNextHotelsCard)
                default: break;
                }
            }
            
        }
    }
    
    
    func bookAnotherHotels(_ whatNext: WhatNext) {
        if let checkIn = whatNext.checkin.toDate(dateFormat: "E, dd MMM yy")?.toString(dateFormat: "yyyy-MM-dd"), let checkOut = whatNext.checkout.toDate(dateFormat: "E, dd MMM yy")?.toString(dateFormat: "yyyy-MM-dd"){
            var hotelData = HotelFormPreviosSearchData()
            hotelData.cityName = whatNext.city
            hotelData.adultsCount = whatNext.rooms.map{$0.adult}
            hotelData.childrenCounts = whatNext.rooms.map{$0.child}
            hotelData.destId = whatNext.destID
            hotelData.destType = whatNext.destType
            hotelData.destName = whatNext.destName
            hotelData.roomNumber =  whatNext.rooms.count
            hotelData.checkInDate = checkIn
            hotelData.checkOutDate = checkOut
            var splittedStringArray = whatNext.destName.components(separatedBy: ",")
            splittedStringArray.removeFirst()
            let stateName = splittedStringArray.joined(separator: ",")
            hotelData.stateName = stateName
            HotelsSearchVM.hotelFormData = hotelData
            AppFlowManager.default.goToDashboard(toBeSelect: .hotels)
        }
    }
    
    func bookFlightFor(_ whatNext:WhatNext){
        FlightWhatNextData.shared.isSettingForWhatNext = true
        FlightWhatNextData.shared.whatNext = whatNext
        AppFlowManager.default.goToDashboard(toBeSelect: .flight)
        
    }
}
extension YouAreAllDoneVC: PKAddPassesViewControllerDelegate {
    
}
/*
 how to call the apple wallet from ios app using swift
 https://stackoverflow.com/questions/51060832/how-to-call-the-apple-wallet-from-ios-app-using-swift
 */

/*
 instagram RND
 https://stackoverflow.com/questions/11393071/how-to-share-an-image-on-instagram-in-ios/28272642#28272642
 https://help.instagram.com/355896521173347
 https://stackoverflow.com/questions/51318060/instagram-share-image-text-and-url-via-ios-app-swift
 https://developers.facebook.com/docs/instagram/sharing-to-feed
 */
