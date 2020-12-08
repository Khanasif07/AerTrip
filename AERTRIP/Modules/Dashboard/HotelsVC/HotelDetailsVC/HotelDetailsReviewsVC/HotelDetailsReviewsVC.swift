//
//  HotelDetailsReviewsVC.swift
//  AERTRIP
//
//  Created by Admin on 08/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelDetailsReviewsVC: BaseVC {
    
    //Mark:- Variables
    //================
    private(set) var viewModel = HotelDetailsReviewsVM()
    let sectionName = ["",LocalizedString.TravellerRating.localized,LocalizedString.RatingSummary.localized]
    let ratingNames = [LocalizedString.Excellent.localized,LocalizedString.VeryGood.localized,LocalizedString.Average.localized,LocalizedString.Poor.localized,LocalizedString.Terrible.localized]
    var initialTouchPoint:CGPoint = CGPoint.zero
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var mainContainerBottomConst: NSLayoutConstraint!
    @IBOutlet weak var mainContainerHeightConst: NSLayoutConstraint!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var containerViewHeigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var stickyTitleLabel: UILabel!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var reviewsTblView: UITableView! {
        didSet {
            self.reviewsTblView.delegate = self
            self.reviewsTblView.dataSource = self
            self.reviewsTblView.estimatedRowHeight = UITableView.automaticDimension
            self.reviewsTblView.rowHeight = UITableView.automaticDimension
            self.reviewsTblView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
            self.reviewsTblView.estimatedSectionFooterHeight = CGFloat.leastNonzeroMagnitude
            self.reviewsTblView.backgroundColor = AppColors.themeWhite
            self.reviewsTblView.showsVerticalScrollIndicator = false
        }
    }
    @IBOutlet weak var reviewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    private let maxHeaderHeight: CGFloat = 58.0
    private var time: Float = 0.0
    private var timer: Timer?
    
    var dismissalStatusBarStyle: UIStatusBarStyle = .darkContent
    var presentingStatusBarStyle: UIStatusBarStyle = .darkContent
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.setValue()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setValue()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer?.invalidate()
    }
    override func setupColors() {
        self.reviewsLabel.textColor = AppColors.themeBlack
        //self.stickyTitleLabel.alpha = 0.0
        self.stickyTitleLabel.textColor = AppColors.themeBlack
    }
    
    override func setupFonts() {
        self.reviewsLabel.font = AppFonts.SemiBold.withSize(22.0)
        self.stickyTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
    }
    
    override func setupTexts() {
        self.reviewsLabel.text = "TripAdvisor Rating"
        self.stickyTitleLabel.text = "TripAdvisor Rating"
    }
    
    override func initialSetup() {
        self.reviewsTblView.contentInset = UIEdgeInsets(top: headerContainerView.height, left: 0.0, bottom: 0.0, right: 0.0)
        headerContainerView.backgroundColor = .clear
        mainContainerView.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        self.view.backgroundColor = .clear
        if #available(iOS 13.0, *) {} else {
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        mainContainerView.isUserInteractionEnabled = true
        swipeGesture.delegate = self
        self.view.addGestureRecognizer(swipeGesture)
            self.view.backgroundColor = .white
        }
        
        //self.dividerView.isHidden = true
        self.registerNibs()
        delay(seconds: 0.2) { [weak self] in
            self?.viewModel.getTripAdvisorDetails()
        }
        
        self.progressView.transform = self.progressView.transform.scaledBy(x: 1, y: 1)
        self.reviewsLabel.alpha = 0.0
        self.stickyTitleLabel.alpha = 1.0
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.statusBarStyle = presentingStatusBarStyle
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.statusBarColor = AppColors.clear
        self.statusBarStyle = dismissalStatusBarStyle
    }
    
    //Mark:- Functions
    //================
    private func registerNibs() {
        let nib = UINib(nibName: "TripAdvisorReviewsHeaderView", bundle: nil)
        self.reviewsTblView.register(nib, forHeaderFooterViewReuseIdentifier: "TripAdvisorReviewsHeaderView")
        self.reviewsTblView.registerCell(nibName: TripAdvisorTravelerRatingTableViewCell.reusableIdentifier)
        self.reviewsTblView.registerCell(nibName: TripAdviserReviewsCell.reusableIdentifier)
        self.reviewsTblView.registerCell(nibName: ReviewTableViewCell.reusableIdentifier)
        self.reviewsTblView.registerCell(nibName: AdvisorRatingTableViewCell.reusableIdentifier)
        self.reviewsTblView.registerCell(nibName: ReviewsOptionTableViewCell.reusableIdentifier)
        self.reviewsTblView.registerCell(nibName: PoweredByTableViewCell.reusableIdentifier)
    }
    
    private func getReverseNumber(row: Int) -> String {
        switch row {
        case 0:
            return "5"
        case 1:
            return "4"
        case 2:
            return "3"
        case 3:
            return "2"
        case 4:
            return "1"
        default:
            return "0"
        }
    }
    
    private func getHeightForHeaderInSection(section: Int) -> CGFloat {
        switch section {
        case 1,2:
            return 35.5
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func startProgress() {
        // Invalid timer if it is valid
        if self.timer?.isValid == true {
            self.timer?.invalidate()
        }
        
        self.time = 0.0
        self.progressView.setProgress(0.0, animated: false)
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
    }
    
    @objc func setProgress() {
        self.time += 1.0
        self.progressView?.setProgress(self.time / 10, animated: true)
        
        if self.time == 8 {
            self.timer?.invalidate()
            return
        }
        if self.time == 2 {
            //self.timer?.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                guard let self = self else {return}
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
            }
        }
        
        if self.time >= 10 {
            //self.timer?.invalidate()
            delay(seconds: 0.5) { [weak self] in
                self?.timer?.invalidate()
                self?.progressView?.isHidden = true
            }
        }
    }
    func stopProgress() {
        self.time += 1
        if self.time <= 8  {
            self.time = 9
        }
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.setProgress), userInfo: nil, repeats: true)
    }
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//Mark:- UITableView Delegate And DataSource
//==========================================

extension HotelDetailsReviewsVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.viewModel.hotelTripAdvisorDetails != nil {
            return self.viewModel.sectionData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.hotelTripAdvisorDetails != nil {
            return self.viewModel.sectionData[section].count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1,2:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TripAdvisorReviewsHeaderView") as? TripAdvisorReviewsHeaderView else { return nil }
            headerView.headerLabel.text = self.sectionName[section]
            return headerView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tripAdviserDetails = self.viewModel.hotelTripAdvisorDetails {
            
            let currentSection = self.viewModel.sectionData[indexPath.section]
            switch currentSection[indexPath.row] {
            case .tripAdvisorTravelerRatingCell:
                if let cell = self.getTripAdvisorTravelerRatingCell(tableView, indexPath: indexPath, tripAdviserDetails: tripAdviserDetails) {
                    return cell
                }
            case .travellerRatingCell:
                if let cell = self.getTripAdviserReviewsCell(tableView, indexPath: indexPath, tripAdviserDetails: tripAdviserDetails) {
                    return cell
                }
            case .advisorRatingSummaryCell:
                if let cell = self.getAdvisorRatingSummaryCell(tableView, indexPath: indexPath, tripAdviserDetails: tripAdviserDetails) {
                    return cell
                }
            case .reviewsOptionCell:
                if let cell = self.getReviewsOptionCell(tableView, indexPath: indexPath, tripAdviserDetails: tripAdviserDetails) {
                    return cell
                }
            case .poweredByCell:
                if let cell = self.getPoweredByCell(tableView, indexPath: indexPath) {
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            var urlString = ""
            var screenTitle = ""
            switch indexPath.row {
            case 0:
                urlString = "https:\(self.viewModel.hotelTripAdvisorDetails?.writeReview ?? "")"
                screenTitle = LocalizedString.WriteReviews.localized
            case 1:
                urlString = "https:\(self.viewModel.hotelTripAdvisorDetails?.seeAllPhotos ?? "")"
                screenTitle = LocalizedString.Photos.localized
            case 2:
                urlString = "https:\(self.viewModel.hotelTripAdvisorDetails?.webUrl ?? "")"
                screenTitle = LocalizedString.ReadReviews.localized
            default:
                return
            }
            guard let url = URL(string: urlString) else {return}
            AppFlowManager.default.showURLOnATWebView(url, screenTitle: screenTitle, presentingStatusBarStyle: statusBarStyle, dismissalStatusBarStyle: statusBarStyle)
            //UIApplication.openSafariViewController(forUrlPath: urlString, delegate: nil, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.getHeightForHeaderInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 || section == 2 {
            return UITableView.automaticDimension
        }
        return self.getHeightForHeaderInSection(section: section)
    }
    
}

extension HotelDetailsReviewsVC {
    
    internal func getTripAdvisorTravelerRatingCell(_ tableView: UITableView, indexPath: IndexPath,tripAdviserDetails: HotelDetailsReviewsModel) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripAdvisorTravelerRatingTableViewCell", for: indexPath) as? TripAdvisorTravelerRatingTableViewCell else { return UITableViewCell() }
        cell.configCell(reviewsLabel: "\(String(describing: tripAdviserDetails.numReviews.toInt ?? 0)) \(LocalizedString.Reviews.localized)", tripAdvisorRating: Double(tripAdviserDetails.rating) ?? 0.0, ranking: tripAdviserDetails.rankingData?.rankingString ?? "")
        cell.reviewsButton.addTarget(self, action: #selector(tapCellReviewBtn), for: .touchUpInside)
        return cell
    }
    
    internal func getTripAdviserReviewsCell(_ tableView: UITableView, indexPath: IndexPath,tripAdviserDetails: HotelDetailsReviewsModel) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as? ReviewTableViewCell else { return UITableViewCell() }
        if let currentReview = tripAdviserDetails.reviewRatingCount[self.getReverseNumber(row: indexPath.row)] as? String {
            cell.configCell(title: self.ratingNames[indexPath.row] ,totalNumbReviews: tripAdviserDetails.numReviews, currentReviews: currentReview)
            if indexPath.row == ratingNames.count - 1 {
                cell.progressViewBottomConstraints.constant = 17
            } else {
                cell.progressViewBottomConstraints.constant = 7
            }
            
            if indexPath.row == 0 {
                cell.progressViewTopConstraint.constant = 14
            } else {
                cell.progressViewTopConstraint.constant = 7
            }
            var minWidth:CGFloat = 20
            for (_, value) in tripAdviserDetails.reviewRatingCount {
                if let review = value as? String {
                    let size = AppGlobals.shared.getTextWidthAndHeight(text: (review.toDouble ?? 0.0).formatedCount(), fontName: AppFonts.Regular.withSize(18.0))
                    if size.width > minWidth {
                        minWidth = size.width
                    }
                }
            }
            cell.noOfReviewsWidthContraint.constant = minWidth
            
        }
        return cell
    }
    
    internal func getAdvisorRatingSummaryCell(_ tableView: UITableView, indexPath: IndexPath,tripAdviserDetails: HotelDetailsReviewsModel) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AdvisorRatingTableViewCell.reusableIdentifier, for: indexPath) as? AdvisorRatingTableViewCell else { return UITableViewCell() }
        if let ratingSummary = tripAdviserDetails.ratingSummary {
            cell.configCell(ratingSummary: ratingSummary[indexPath.row])
            if indexPath.row == ratingSummary.count - 1 {
                cell.dividerViewTopConstraints.constant = 16.5
                cell.dividerView.isHidden = false
            } else {
                cell.dividerViewTopConstraints.constant = 6.5
                cell.dividerView.isHidden = true
            }
            if indexPath.row == 0 {
                cell.ratingViewTopConstraint.constant = 16
            } else {
                cell.ratingViewTopConstraint.constant = 6.5
            }
        }
        return cell
    }
    
    internal func getReviewsOptionCell(_ tableView: UITableView, indexPath: IndexPath,tripAdviserDetails: HotelDetailsReviewsModel) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsOptionTableViewCell.reusableIdentifier, for: indexPath) as? ReviewsOptionTableViewCell else { return UITableViewCell() }
        if indexPath.row == 0 {
            cell.titleLabel.text = LocalizedString.WriteYourOwnReview.localized
        } else if indexPath.row == 1 {
            cell.titleLabel.text = "\(LocalizedString.ViewAll.localized) \(tripAdviserDetails.photoCount) Photos"
        } else {
            cell.titleLabel.text = "\(LocalizedString.ReadAll.localized) \(tripAdviserDetails.numReviews) reviews"
        }
        return cell
    }
    
    internal func getPoweredByCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PoweredByTableViewCell.reusableIdentifier, for: indexPath) as? PoweredByTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    @objc func tapCellReviewBtn(_ sender: UIButton){
        let urlString = "https:\(self.viewModel.hotelTripAdvisorDetails?.webUrl ?? "")"
        let screenTitle = LocalizedString.ReadReviews.localized
        guard let url = URL(string: urlString) else {return}
        AppFlowManager.default.showURLOnATWebView(url, screenTitle: screenTitle, presentingStatusBarStyle: statusBarStyle, dismissalStatusBarStyle: statusBarStyle)
    }
    
}

extension HotelDetailsReviewsVC: HotelTripAdvisorDetailsDelegate {
    func willFetchHotelTripAdvisor() {
        //AppGlobals.shared.startLoading()
        startProgress()
    }
    
    func getHotelTripAdvisorDetailsSuccess() {
        self.viewModel.getTypeOfCellInSections()
        stopProgress()
        printDebug("Reviews")
        self.reviewsTblView.reloadData()
       // AppGlobals.shared.stopLoading()
    }
    
    func getHotelTripAdvisorFail() {
        stopProgress()
        printDebug("Api parsing failed")
       // AppGlobals.shared.stopLoading()
    }
}

extension HotelDetailsReviewsVC {
    
    func manageHeaderView(_ scrollView: UIScrollView) {
//        guard mainContainerView.height < scrollView.contentSize.height else {return}
//        let yOffset = (scrollView.contentOffset.y > headerContainerView.height) ? headerContainerView.height : scrollView.contentOffset.y
//        printDebug(yOffset)
//        
//        dividerView.isHidden = yOffset < (headerContainerView.height - 5.0)
//        
//        //header container view height
//        let heightToDecrease: CGFloat = 8.0
//        let height = (maxHeaderHeight) - (yOffset * (heightToDecrease / headerContainerView.height))
//        self.containerViewHeigthConstraint.constant = height
//        
//        //sticky label alpha
//        let alpha = (yOffset * (1.0 / headerContainerView.height))
//        self.stickyTitleLabel.alpha = alpha
//        
//        //reviews label
//        self.reviewsLabel.alpha = 1.0 - alpha
//        reviewTopConstraint.constant = 23.0 - (yOffset * (23.0 / headerContainerView.height))
//        //        reviewLabelYConstraint.constant = -(yOffset * (100.0 / headerContainerView.height))
//        printDebug("alpha: \(alpha)")
//        printDebug("reviewTopConstraint.constant: \(reviewTopConstraint.constant)")

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        manageHeaderView(scrollView)
        //printDebug("scrollViewDidScroll")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        manageHeaderView(scrollView)
        //printDebug("scrollViewDidEndDecelerating")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        manageHeaderView(scrollView)
        //printDebug("scrollViewDidEndDragging")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        manageHeaderView(scrollView)
        //printDebug("scrollViewDidEndScrollingAnimation")
    }
}
extension HotelDetailsReviewsVC {
    
    @objc func handleSwipes(_ sender: UIPanGestureRecognizer) {
        func reset() {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
                self?.view.transform = .identity
            })
        }
        
        func moveView() {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
                guard let self = self else {return}
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        }
        
        guard let direction = sender.direction, direction.isVertical, direction == .down, self.reviewsTblView.contentOffset.y <= 0
            else {
            reset()
            return
        }
        
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: self.view)
            moveView()
        case .ended:
            if viewTranslation.y < 200 {
                reset()
            } else {
                dismiss(animated: true, completion: nil)
            }
        case .cancelled:
            reset()
        default:
            break
        }
    }
    
    
    func setValue() {
        let toDeduct = AppFlowManager.default.safeAreaInsets.top
        var finalValue =  (self.view.height - toDeduct)
        if #available(iOS 13.0, *) {
           finalValue = self.view.height
        }
        self.mainContainerBottomConst.constant = 0.0
        self.mainContainerHeightConst.constant = finalValue
        //self.view.backgroundColor = AppColors.themeWhite.withAlphaComponent(1.0)
        self.view.layoutIfNeeded()
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
