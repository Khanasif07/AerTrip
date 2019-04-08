//
//  RatingVC.swift
//  AERTRIP
//
//  Created by apple on 05/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class RatingVC: BaseVC {
    // MARK: - IB Outlets
    
    @IBOutlet var starRatingTitleLabel: UILabel!
    @IBOutlet var starLabel: UILabel!
    @IBOutlet var includeRatedTitleLabel: UILabel!
    @IBOutlet var includeRatedStatusButton: UIButton!
    
    @IBOutlet var tripAdvisorTitleLabel: UILabel!
    @IBOutlet var tripAdvisorStarLabel: UILabel!
    @IBOutlet var starButtonsOutlet: [UIButton]!
    @IBOutlet var tripAdvisorRatingButtons: [UIButton]!
    
    // MARK: - Variables
    
    var filterApplied: UserInfo.HotelFilter = UserInfo.HotelFilter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getSavedFilter()
    }
    
    override func setupTexts() {
        self.starRatingTitleLabel.text = LocalizedString.StarRating.localized
    }
    
    override func setupColors() {
        self.starRatingTitleLabel.textColor = AppColors.themeGray40
        self.starLabel.textColor = AppColors.themeGray40
    }
    
    override func setupFonts() {
        self.starRatingTitleLabel.font = AppFonts.Regular.withSize(16.0)
        self.starLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    func getSavedFilter() {
        guard let filter = UserInfo.hotelFilter else {
            printDebug("filter not found")
            self.doInitialSetup()
            return
        }
        self.filterApplied = filter
        HotelFilterVM.shared.ratingCount = self.filterApplied.ratingCount
        HotelFilterVM.shared.tripAdvisorRatingCount = self.filterApplied.tripAdvisorRatingCount
        self.doInitialSetup()
    }
    
    private func doInitialSetup() {
        
        //setting stars
        if !HotelFilterVM.shared.ratingCount.isEmpty, HotelFilterVM.shared.ratingCount.count < 5 {
            HotelFilterVM.shared.ratingCount.removeAll()
        }
        
        for star in self.filterApplied.ratingCount {
            self.updateStarButtonState(forStar: star)
        }
        self.starLabel.text = self.getStarString(fromArr: HotelFilterVM.shared.ratingCount, maxCount: 5)
        
        for rating in HotelFilterVM.shared.tripAdvisorRatingCount {
            self.tripAdvisorRatingButtons[rating - 1].isSelected = true
        }
        
        self.starLabel.text = self.getStarString(fromArr: HotelFilterVM.shared.ratingCount, maxCount: 5)
        self.tripAdvisorStarLabel.text = self.getStarString(fromArr: HotelFilterVM.shared.tripAdvisorRatingCount, maxCount: 5,isForStarRating: false)
        self.includeRatedStatusButton.isSelected = self.filterApplied.isIncludeUnrated
    }
    
    @IBAction func starButtonsAction(_ sender: UIButton) {
        self.updateStarButtonState(forStar: sender.tag)
        self.starLabel.text = self.getStarString(fromArr: HotelFilterVM.shared.ratingCount, maxCount: 5)
        sender.setImage(#imageLiteral(resourceName: "starRatingUnfill"), for: .normal)
        sender.setImage(#imageLiteral(resourceName: "starRatingFilled"), for: .selected)
    }
    
    @IBAction func tripAdvisorRatingButtonsAction(_ sender: UIButton) {
        self.updateTripAdvisorRatingButtonState(forStar: sender.tag)
        self.tripAdvisorStarLabel.text = self.getStarString(fromArr: HotelFilterVM.shared.tripAdvisorRatingCount, maxCount: 5,isForStarRating: false)
        sender.setImage(#imageLiteral(resourceName: "deselectedAdvisorRating"), for: .normal)
        sender.setImage(#imageLiteral(resourceName: "selectedAdvisorRating"), for: .selected)
    }
    
    @IBAction func includeUnratedAction(_ sender: UIButton) {
        self.includeRatedStatusButton.isSelected = !sender.isSelected
        HotelFilterVM.shared.isIncludeUnrated = sender.isSelected
    }
    
    ///Star Button State
    private func updateStarButtonState(forStar: Int, isSettingFirstTime: Bool = false) {
        guard 1...5 ~= forStar else {return}
        if let currentButton = self.starButtonsOutlet.filter({ (button) -> Bool in
            button.tag == forStar
        }).first {
            if isSettingFirstTime {
                currentButton.isSelected = true
            }
            else {
                currentButton.isSelected = !currentButton.isSelected
            }
            currentButton.isHighlighted = false
            if HotelFilterVM.shared.ratingCount.contains(forStar) {
               HotelFilterVM.shared.ratingCount.remove(at:HotelFilterVM.shared.ratingCount.firstIndex(of: forStar)!)
            }
            else {
               HotelFilterVM.shared.ratingCount.append(forStar)
            }
        }
        if HotelFilterVM.shared.ratingCount.isEmpty || HotelFilterVM.shared.ratingCount.count == 5 {
            delay(seconds: 0.1) {
                for starBtn in self.starButtonsOutlet {
                    starBtn.isSelected = false
                    starBtn.isHighlighted = true
                }
            }
        } else {
            for starBtn in self.starButtonsOutlet {
                starBtn.isHighlighted = false
            }
        }
    }
    
    
    
    
    ///Get Star Rating
    private func getStarString(fromArr: [Int], maxCount: Int,isForStarRating: Bool = true) -> String {
        var arr = Array(Set(fromArr))
        arr.sort()
        var final = ""
        var start: Int?
        var end: Int?
        var prev: Int?
        
        if arr.isEmpty || arr.count == maxCount {
            final = isForStarRating ? "All \(LocalizedString.stars.localized)" : "All \(LocalizedString.Ratings.localized)"
            return final
        }
        else if arr.count == 1 {
            final = isForStarRating ? "\(arr[0]) \((arr[0] == 1) ? "\(LocalizedString.star.localized)" : "\(LocalizedString.stars.localized)")" : "\(arr[0]) \((arr[0] == 1) ? "\(LocalizedString.Rating.localized)" : "\(LocalizedString.Ratings.localized)")"
            return final
        }
        
        for (idx,value) in arr.enumerated() {
            let diff = value - (prev ?? 0)
            if diff == 1 {
                //number is successor
                if start == nil {
                    start = prev
                }
                end = value
            }
            else if diff > 1 {
                //number is not successor
                if start == nil {
                    
                    if let p = prev {
                        final += "\(p), "
                    }
                    
                    if idx == (arr.count - 1) {
                        final += "\(value), "
                    }
                }
                else {
                    if let s = start, let e = end {
                        final += (s != e) ? "\(s)-\(e), " : "\(s), "
                        start = nil
                        end = nil
                        prev = nil
                        if idx == (arr.count - 1) {
                            final += "\(value), "
                        }
                    }
                    else {
                        if idx == (arr.count - 1) {
                            final += "\(value), "
                        }
                    }
                }
            }
            prev = value
        }
        
        if let s = start, let e = end {
            final += (s != e) ? "\(s)-\(e), " : "\(s), "
            start = nil
            end = nil
        }
        final.removeLast(2)
        return isForStarRating ?  final + " \(LocalizedString.stars.localized)" :  final + " \(LocalizedString.Ratings.localized)"
    }
    
    /// Star Button State
    private func updateTripAdvisorRatingButtonState(forStar: Int, isSettingFirstTime: Bool = false) {
        guard 1...5 ~= forStar else { return }
        if let currentButton = self.tripAdvisorRatingButtons.filter({ (button) -> Bool in
            button.tag == forStar
        }).first {
            if isSettingFirstTime {
                currentButton.isSelected = true
            }
            else {
                currentButton.isSelected = !currentButton.isSelected
            }
            if HotelFilterVM.shared.tripAdvisorRatingCount.contains(forStar) {
                HotelFilterVM.shared.tripAdvisorRatingCount.remove(at: HotelFilterVM.shared.tripAdvisorRatingCount.firstIndex(of: forStar)!)
            }
            else {
                HotelFilterVM.shared.tripAdvisorRatingCount.append(forStar)
            }
        }
    }
}
