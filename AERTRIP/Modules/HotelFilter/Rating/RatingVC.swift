//
//  RatingVC.swift
//  AERTRIP
//
//  Created by apple on 05/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class RatingVC: BaseVC {
    
    // MARK:- IB Outlets
    
    @IBOutlet weak var starRatingTitleLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var includeRatedTitleLabel: UILabel!
    @IBOutlet weak var includeRatedStatusButton: UIButton!
    
    @IBOutlet weak var tripAdvisorTitleLabel: UILabel!
    @IBOutlet weak var tripAdvisorStarLabel: UILabel!
    @IBOutlet var starButtonsOutlet: [UIButton]!
    @IBOutlet var tripAdvisorRatingButtons: [UIButton]!
    
  
    
    // MARK: - Variables
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func bindViewModel() {
    
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

    
    @IBAction func starButtonsAction(_ sender: UIButton) {
        self.updateStarButtonState(forStar: sender.tag)
        self.starLabel.text = self.getStarString(fromArr: HotelFilterVM.shared.ratingCount, maxCount: 5)
        sender.setImage(#imageLiteral(resourceName: "starRatingUnfill"), for: .normal)
        sender.setImage(#imageLiteral(resourceName: "starRatingFilled"), for: .selected)
    }
    
    
    @IBAction func tripAdvisorRatingButtonsAction(_ sender: UIButton) {
        self.updateTripAdvisorRatingButtonState(forStar: sender.tag)
        self.tripAdvisorStarLabel.text = self.getStarString(fromArr: HotelFilterVM.shared.tripAdvisorRatingCount, maxCount: 5)
        sender.setImage(#imageLiteral(resourceName: "deselectedAdvisorRating"), for: .normal)
        sender.setImage(#imageLiteral(resourceName: "selectedAdvisorRating"), for: .selected)
    }
    
    
   
    @IBAction func includeUnratedAction(_ sender: UIButton) {
        if !HotelFilterVM.shared.isIncludeUnrated {
            includeRatedStatusButton.setImage(UIImage(named: "tick"), for: .normal)
            HotelFilterVM.shared.isIncludeUnrated = true
        } else {
             HotelFilterVM.shared.isIncludeUnrated = false
             includeRatedStatusButton.setImage(UIImage(named: "untick"), for: .normal)
        }
       
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
            if HotelFilterVM.shared.ratingCount.contains(forStar) {
                HotelFilterVM.shared.ratingCount.remove(at: HotelFilterVM.shared.ratingCount.firstIndex(of: forStar)!)
            }
            else {
                HotelFilterVM.shared.ratingCount.append(forStar)
                
            }
        }
    }
    
    ///Get Star Rating
    private func getStarString(fromArr: [Int], maxCount: Int) -> String {
        var arr = Array(Set(fromArr))
        arr.sort()
        var final = ""
        var start: Int?
        var end: Int?
        var prev: Int?
        
        if arr.isEmpty {
            final = "0 \(LocalizedString.stars.localized)"
            return final
        }
        else if arr.count == maxCount {
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
    
    ///Star Button State
    private func updateTripAdvisorRatingButtonState(forStar: Int, isSettingFirstTime: Bool = false) {
        guard 1...5 ~= forStar else {return}
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
