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
    
    @IBOutlet weak var starRatingTitleLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var includeRatedTitleLabel: UILabel!
    @IBOutlet weak var includeRatedStatusButton: UIButton!
    
    @IBOutlet weak var tripAdvisorTitleLabel: UILabel!
    @IBOutlet weak var tripAdvisorStarLabel: UILabel!
    @IBOutlet var starButtonsOutlet: [UIButton]!
    @IBOutlet var tripAdvisorRatingButtons: [UIButton]!
    @IBOutlet weak var includeUnrateViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var includeUnratedViewBottomConstraint: NSLayoutConstraint!
    
    
    // MARK: - Variables
    
    var filterApplied: UserInfo.HotelFilter = UserInfo.HotelFilter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if HotelFilterVM.shared.showIncludeUnrated {
            self.includeUnrateViewHeightConstraint.constant = 44
            self.includeUnratedViewBottomConstraint.constant = 16
        } else {
            self.includeUnrateViewHeightConstraint.constant = 0
            self.includeUnratedViewBottomConstraint.constant = 0
        }
        self.setFilterValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setFilterValues()
    }
    
    override func setupTexts() {
        self.starRatingTitleLabel.text = LocalizedString.StarRating.localized
    }
    
    override func setupColors() {
        self.starRatingTitleLabel.textColor = AppColors.themeGray40
        self.starLabel.textColor = AppColors.themeGray40
        self.tripAdvisorTitleLabel.textColor = AppColors.themeGray40
        self.tripAdvisorStarLabel.textColor = AppColors.themeGray40
    }
    
    override func setupFonts() {
        self.starRatingTitleLabel.font = AppFonts.Regular.withSize(16.0)
        self.starLabel.font = AppFonts.Regular.withSize(14.0)
        self.tripAdvisorTitleLabel.font = AppFonts.Regular.withSize(16.0)
        self.tripAdvisorStarLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    func setFilterValues() {
        guard let filter = UserInfo.hotelFilter else {
            printDebug("filter not found")
            HotelFilterVM.shared.resetToDefault()
            //HotelFilterVM.shared.ratingCount.removeAll()
            self.doInitialSetup()
            return
        }
        self.filterApplied = filter
        HotelFilterVM.shared.ratingCount = self.filterApplied.ratingCount
        HotelFilterVM.shared.tripAdvisorRatingCount = self.filterApplied.tripAdvisorRatingCount
        self.doInitialSetup()
    }
    
    private func doInitialSetup() {
        //guard let _ = self.view.window else { return }
        //setting stars
        
        HotelFilterVM.shared.ratingCount.removeAll()
        HotelFilterVM.shared.tripAdvisorRatingCount.removeAll()
        
        //reset all the buttons first
        for btn in self.starButtonsOutlet ?? [] {
            //btn.adjustsImageWhenHighlighted = false
            btn.isSelected = false
            btn.setImage(#imageLiteral(resourceName: "starRatingFilled"), for: .normal)
            btn.setImage(nil, for: .selected)
            btn.setImage(nil, for: .highlighted)
        }
        
        for btn in self.tripAdvisorRatingButtons ?? [] {
            //btn.adjustsImageWhenHighlighted = false
            btn.isSelected = false
            btn.setImage(#imageLiteral(resourceName: "selectedAdvisorRating"), for: .normal)
            btn.setImage(nil, for: .selected)
            btn.setImage(nil, for: .highlighted)
        }
        
        for star in self.filterApplied.ratingCount {
            self.updateStarButtonState(forStar: star)
        }
        
        for rating in self.filterApplied.tripAdvisorRatingCount {
            self.updateTAStarButtonState(forStar: rating)
            //self.tripAdvisorRatingButtons?[rating - 1].isSelected = true
        }
        
        self.starLabel?.text = self.getStarString(fromArr: HotelFilterVM.shared.ratingCount, maxCount: 5)
        self.tripAdvisorStarLabel?.text = self.getTARatingString(fromArr: HotelFilterVM.shared.tripAdvisorRatingCount, maxCount: 5)
        self.includeRatedStatusButton?.isSelected = self.filterApplied.isIncludeUnrated
    }
    
    @IBAction func starButtonsAction(_ sender: UIButton) {
        printDebug("sender.isSelected: \(sender.isSelected)")
        if HotelFilterVM.shared.ratingCount.count == 5 {
            HotelFilterVM.shared.ratingCount.removeAll()
        }
        self.updateStarButtonState(forStar: sender.tag)
        self.starLabel.text = self.getStarString(fromArr: HotelFilterVM.shared.ratingCount, maxCount: 5)
        HotelFilterVM.shared.delegate?.updateFiltersTabs()
    }
    
    @IBAction func tripAdvisorRatingButtonsAction(_ sender: UIButton) {
        printDebug("sender.isSelected: \(sender.isSelected)")
        if HotelFilterVM.shared.tripAdvisorRatingCount.count == 5 {
            HotelFilterVM.shared.tripAdvisorRatingCount.removeAll()
        }
        self.updateTAStarButtonState(forStar: sender.tag)
        self.tripAdvisorStarLabel.text = self.getTARatingString(fromArr: HotelFilterVM.shared.tripAdvisorRatingCount, maxCount: 5)
        HotelFilterVM.shared.delegate?.updateFiltersTabs()
        printDebug("size: \(sender.size)")
    }
    
    @IBAction func includeUnratedAction(_ sender: UIButton) {
        self.includeRatedStatusButton.isSelected = !sender.isSelected
        HotelFilterVM.shared.isIncludeUnrated = sender.isSelected
        HotelFilterVM.shared.delegate?.updateFiltersTabs()
    }
    
    ///Star Button State
    private func updateStarButtonState(forStar: Int, isSettingFirstTime: Bool = false) {
        guard 1...5 ~= forStar else {return}
        printDebug("ratingCount: \(HotelFilterVM.shared.ratingCount)")
        
        
        
        //updating the selection array
        if let idx = HotelFilterVM.shared.ratingCount.firstIndex(of: forStar) {
            HotelFilterVM.shared.ratingCount.remove(at: idx)
        }
        else {
            HotelFilterVM.shared.ratingCount.append(forStar)
        }
        
        if HotelFilterVM.shared.ratingCount.isEmpty || HotelFilterVM.shared.ratingCount.count == 5 {
            HotelFilterVM.shared.ratingCount.removeAll()
            // HotelFilterVM.shared.ratingCount = HotelFilterVM.shared.defaultRatingCount
            for starBtn in self.starButtonsOutlet ?? [] {
                starBtn.isSelected = false
                // starBtn.setImage(#imageLiteral(resourceName: "UnselectedStar"), for: .normal)
                starBtn.setImage(#imageLiteral(resourceName: "starRatingFilledHollow"), for: .normal)
                //                starBtn.setImage(#imageLiteral(resourceName: "starRatingFilled"), for: .normal)
            }
        }
        else {
            
            for starBtn in self.starButtonsOutlet ?? [] {
                
                if starBtn.tag == forStar {
                    starBtn.isSelected = isSettingFirstTime ? true : !starBtn.isSelected
                    let img = starBtn.isSelected ? #imageLiteral(resourceName: "starRatingFilled") : #imageLiteral(resourceName: "starRatingUnfill")
                    starBtn.setImage(img, for: starBtn.isSelected ? .selected : .normal)
                }
                else
                    if HotelFilterVM.shared.ratingCount.contains(starBtn.tag) {
                        starBtn.isSelected = true
                        starBtn.setImage(#imageLiteral(resourceName: "starRatingFilled"), for: .selected)
                    }
                    else {
                        starBtn.isSelected = false
                        starBtn.setImage(#imageLiteral(resourceName: "starRatingUnfill"), for: .normal)
                }
            }
        }
        //        printDebug("starButtonsOutlet")
        //        printDebug("ratingCount: \(HotelFilterVM.shared.ratingCount)")
        //        for starBtn in self.starButtonsOutlet ?? [] {
        //            printDebug("btn Tag: \(starBtn.tag) btn isSelected: \(starBtn.isSelected)")
        //        }
    }
    
    private func updateTAStarButtonState(forStar: Int, isSettingFirstTime: Bool = false) {
        guard 1...5 ~= forStar else {return}
        printDebug("tripAdvisorRatingCount: \(HotelFilterVM.shared.tripAdvisorRatingCount)")
        
        //updating the selection array
        if let idx = HotelFilterVM.shared.tripAdvisorRatingCount.firstIndex(of: forStar) {
            HotelFilterVM.shared.tripAdvisorRatingCount.remove(at: idx)
        }
        else {
            HotelFilterVM.shared.tripAdvisorRatingCount.append(forStar)
        }
        
        if HotelFilterVM.shared.tripAdvisorRatingCount.isEmpty || HotelFilterVM.shared.tripAdvisorRatingCount.count == 5 {
            HotelFilterVM.shared.tripAdvisorRatingCount.removeAll()
            // HotelFilterVM.shared.ratingCount = HotelFilterVM.shared.defaultRatingCount
            for starBtn in self.tripAdvisorRatingButtons ?? [] {
                starBtn.isSelected = false
                // starBtn.setImage(#imageLiteral(resourceName: "UnselectedStar"), for: .normal)
                starBtn.setImage(#imageLiteral(resourceName: "selectedAdvisorRating"), for: .normal)
            }
        }
        else {
            
            for starBtn in self.tripAdvisorRatingButtons ?? [] {
                
                if starBtn.tag == forStar {
                    starBtn.isSelected = isSettingFirstTime ? true : !starBtn.isSelected
                    let img = starBtn.isSelected ? #imageLiteral(resourceName: "selectedAdvisorRating") : #imageLiteral(resourceName: "deselectedAdvisorRating")
                    starBtn.setImage(img, for: starBtn.isSelected ? .selected : .normal)
                }
                else
                    if HotelFilterVM.shared.tripAdvisorRatingCount.contains(starBtn.tag) {
                        starBtn.isSelected = true
                        starBtn.setImage(#imageLiteral(resourceName: "selectedAdvisorRating"), for: .selected)
                    }
                    else {
                        starBtn.isSelected = false
                        starBtn.setImage(#imageLiteral(resourceName: "deselectedAdvisorRating"), for: .normal)
                }
            }
        }
        
        //        printDebug("tripAdvisorRatingButtons")
        //        printDebug("tripAdvisorRatingCount: \(HotelFilterVM.shared.tripAdvisorRatingCount)")
        //        for starBtn in self.tripAdvisorRatingButtons ?? [] {
        //            printDebug("btn Tag: \(starBtn.tag) btn isSelected: \(starBtn.isSelected)")
        //        }
    }
    
    
    ///Get Star Rating
    private func getTARatingString(fromArr arr: [Int], maxCount: Int) -> String {
        var final = ""
        var start: Int?
        var end: Int?
        var prev: Int?
        
        if arr.isEmpty  || arr.count == maxCount {
            final = "All \(LocalizedString.Ratings.localized)"
            return final
        }
            //        else if arr.count == maxCount {
            //            final = "All \(LocalizedString.Ratings.localized)"
            //            return final
            //        }
        else if arr.count == 1 {
            final = "\(arr[0]) \((arr[0] == 1) ? "\(LocalizedString.Rating.localized)" : "\(LocalizedString.Ratings.localized)")"
            return final
        }
        
        for (idx,value) in arr.sorted().enumerated() {
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
        if !final.isEmpty {
            final.removeLast(2)
        }
        return final + " \(LocalizedString.Ratings.localized)"
        
    }
    
    private func getStarString(fromArr: [Int], maxCount: Int) -> String {
        var arr = Array(Set(fromArr))
        arr.sort()
        var final = ""
        var start: Int?
        var end: Int?
        var prev: Int?
        
        if arr.isEmpty || arr.count == maxCount {
            final = "All \(LocalizedString.stars.localized)"
            return final
        }
        else if arr.count == 1 {
            final = "\(arr[0]) \((arr[0] == 1) ? "\(LocalizedString.star.localized)" : "\(LocalizedString.stars.localized)")"
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
        return final + " \(LocalizedString.stars.localized)"
    }
    
    /// Star Button State
    /*
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
     */
}
