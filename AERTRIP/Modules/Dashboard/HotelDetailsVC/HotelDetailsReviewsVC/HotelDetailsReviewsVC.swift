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
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var containerViewHeigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var stickyTitleLabel: UILabel!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var reviewsTblView: UITableView! {
        didSet {
            self.reviewsTblView.contentInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.reviewsTblView.delegate = self
            self.reviewsTblView.dataSource = self
            self.reviewsTblView.estimatedRowHeight = UITableView.automaticDimension
            self.reviewsTblView.rowHeight = UITableView.automaticDimension
            self.reviewsTblView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
            self.reviewsTblView.estimatedSectionFooterHeight = CGFloat.leastNonzeroMagnitude
            self.reviewsTblView.estimatedSectionHeaderHeight = CGFloat.leastNonzeroMagnitude
            self.reviewsTblView.sectionHeaderHeight = CGFloat.leastNonzeroMagnitude
        }
    }
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupColors() {
        self.reviewsLabel.textColor = AppColors.themeBlack
        self.stickyTitleLabel.alpha = 0.0
        self.stickyTitleLabel.textColor = AppColors.themeBlack
    }
    
    override func setupFonts() {
        self.reviewsLabel.font = AppFonts.SemiBold.withSize(22.0)
        self.stickyTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
    }
    
    override func setupTexts() {
        self.reviewsLabel.text = LocalizedString.Reviews.localized
        self.stickyTitleLabel.text = LocalizedString.Reviews.localized
    }
    
    override func initialSetup() {
        self.dividerView.isHidden = true
        self.registerNibs()
        self.viewModel.getTripAdvisorDetails()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    //Mark:- Functions
    //================
    private func registerNibs() {
        self.reviewsTblView.registerCell(nibName: TripAdvisorTravelerRatingTableViewCell.reusableIdentifier)
        self.reviewsTblView.registerCell(nibName: TripAdviserReviewsCell.reusableIdentifier)
        self.reviewsTblView.registerCell(nibName: TripAdvisorTravelerRatingTableViewCell.reusableIdentifier)
        self.reviewsTblView.registerCell(nibName: HotelDetailsAdvisorRatingSummaryTableViewCell.reusableIdentifier)
        self.reviewsTblView.registerCell(nibName: ReviewsOptionTableViewCell.reusableIdentifier)
        self.reviewsTblView.registerCell(nibName: PoweredByTableViewCell.reusableIdentifier)
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//Mark:- UITableView Delegate And DataSource
//==========================================

extension HotelDetailsReviewsVC: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tripAdviserDetails = self.viewModel.hotelTripAdvisorDetails {
            switch self.viewModel.rowsData[indexPath.row] {
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
}

extension HotelDetailsReviewsVC {
    
    internal func getTripAdvisorTravelerRatingCell(_ tableView: UITableView, indexPath: IndexPath,tripAdviserDetails: HotelDetailsReviewsModel) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripAdvisorTravelerRatingTableViewCell", for: indexPath) as? TripAdvisorTravelerRatingTableViewCell else { return UITableViewCell() }
        cell.reviewsLabel.text = tripAdviserDetails.numReviews
        cell.tripAdviserRatingView.rating = Double(tripAdviserDetails.rating) ?? 0.0
        cell.hotelNumberLabel.text = tripAdviserDetails.rankingData?.rankingString
        return cell
    }
    
    internal func getTripAdviserReviewsCell(_ tableView: UITableView, indexPath: IndexPath,tripAdviserDetails: HotelDetailsReviewsModel) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripAdviserReviewsCell", for: indexPath) as? TripAdviserReviewsCell else { return UITableViewCell() }
        cell.configCell(reviewRatingCount: tripAdviserDetails.reviewRatingCount)
        return cell
    }
    
    internal func getAdvisorRatingSummaryCell(_ tableView: UITableView, indexPath: IndexPath,tripAdviserDetails: HotelDetailsReviewsModel) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelDetailsAdvisorRatingSummaryTableViewCell.reusableIdentifier, for: indexPath) as? HotelDetailsAdvisorRatingSummaryTableViewCell else { return UITableViewCell() }
        if let ratingSummary = tripAdviserDetails.ratingSummary {
            cell.configCell(ratingSummary: ratingSummary[indexPath.row])
        }
        return cell
    }
    
    internal func getReviewsOptionCell(_ tableView: UITableView, indexPath: IndexPath,tripAdviserDetails: HotelDetailsReviewsModel) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsOptionTableViewCell.reusableIdentifier, for: indexPath) as? ReviewsOptionTableViewCell else { return UITableViewCell() }
        if indexPath.row == 4 {
            cell.titleLabel.text = LocalizedString.WriteYourOwnReview.localized
        } else if indexPath.row == 5 {
            //                let text = tripAdviserDetails.photoCount == "1" ? "\(tripAdviserDetails.photoCount) photo" : "\(tripAdviserDetails.photoCount) photos"
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
}

extension HotelDetailsReviewsVC {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}

extension HotelDetailsReviewsVC: HotelTripAdvisorDetailsDelegate {
    func getHotelTripAdvisorDetailsSuccess() {
        printDebug("Reviews")
        self.reviewsTblView.reloadData()
    }
    
    func getHotelTripAdvisorFail() {
        printDebug("Api parsing failed")
    }
    
    
}
