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
            self.reviewsTblView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.reviewsTblView.delegate = self
            self.reviewsTblView.dataSource = self
            self.reviewsTblView.estimatedRowHeight = UITableView.automaticDimension
            self.reviewsTblView.rowHeight = UITableView.automaticDimension
            self.reviewsTblView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
            self.reviewsTblView.estimatedSectionFooterHeight = CGFloat.leastNonzeroMagnitude
            self.reviewsTblView.backgroundColor = AppColors.themeWhite
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
            return 49
        default:
            return CGFloat.leastNonzeroMagnitude
        }
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
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.getHeightForHeaderInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.getHeightForHeaderInSection(section: section)
    }
    
}

extension HotelDetailsReviewsVC {
    
    internal func getTripAdvisorTravelerRatingCell(_ tableView: UITableView, indexPath: IndexPath,tripAdviserDetails: HotelDetailsReviewsModel) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TripAdvisorTravelerRatingTableViewCell", for: indexPath) as? TripAdvisorTravelerRatingTableViewCell else { return UITableViewCell() }
        cell.reviewsLabel.text = tripAdviserDetails.numReviews + " " + LocalizedString.Reviews.localized
        cell.tripAdviserRatingView.rating = Double(tripAdviserDetails.rating) ?? 0.0
        cell.hotelNumberLabel.text = tripAdviserDetails.rankingData?.rankingString
        return cell
    }
    
    internal func getTripAdviserReviewsCell(_ tableView: UITableView, indexPath: IndexPath,tripAdviserDetails: HotelDetailsReviewsModel) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as? ReviewTableViewCell else { return UITableViewCell() }
        if let currentReview = tripAdviserDetails.reviewRatingCount[self.getReverseNumber(row: indexPath.row)] as? String {
            cell.configCell(title: self.ratingNames[indexPath.row] ,totalNumbReviews: tripAdviserDetails.numReviews, currentReviews: currentReview)
            if indexPath.row == ratingNames.count - 1 {
                cell.progressViewBottomConstraints.constant = 26.5
            } else {
                cell.progressViewBottomConstraints.constant = 6.5
            }
        }
        return cell
    }
    
    internal func getAdvisorRatingSummaryCell(_ tableView: UITableView, indexPath: IndexPath,tripAdviserDetails: HotelDetailsReviewsModel) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AdvisorRatingTableViewCell.reusableIdentifier, for: indexPath) as? AdvisorRatingTableViewCell else { return UITableViewCell() }
        if let ratingSummary = tripAdviserDetails.ratingSummary {
            cell.configCell(ratingSummary: ratingSummary[indexPath.row])
            if indexPath.row == ratingSummary.count - 1 {
                cell.dividerViewTopConstraints.constant = 26.5
                cell.dividerView.isHidden = false
                } else {
                cell.dividerViewTopConstraints.constant = 6.5
                cell.dividerView.isHidden = true
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
}

extension HotelDetailsReviewsVC {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}

extension HotelDetailsReviewsVC: HotelTripAdvisorDetailsDelegate {
    func getHotelTripAdvisorDetailsSuccess() {
        self.viewModel.getTypeOfCellInSections()
        
        printDebug("Reviews")
        self.reviewsTblView.reloadData()
    }
    
    func getHotelTripAdvisorFail() {
        printDebug("Api parsing failed")
    }
}
