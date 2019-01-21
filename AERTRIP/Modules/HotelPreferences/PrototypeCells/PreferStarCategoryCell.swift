//
//  PreferStarCategoryCell.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 31/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol PreferStarCategoryCellDelegate: class {
    func starSelectionUpdate(updatedStars: [Int])
}

class PreferStarCategoryCell: UITableViewCell {
        
    var ratingCount: [Int] = []

    @IBOutlet var starsButton: [UIButton]!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate: PreferStarCategoryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialSetups()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func starButtonAction(_ sender: UIButton) {
        self.updateStarButtonState(forStar: sender.tag)

        self.starCountLabel.text = self.getStarString(fromArr: self.ratingCount, maxCount: 5)
        self.delegate?.starSelectionUpdate(updatedStars: self.ratingCount)
    }
    
    private func updateStarButtonState(forStar: Int, isSettingFirstTime: Bool = false) {
        guard 1...5 ~= forStar else {return}
        if let currentButton = self.starsButton.filter({ (button) -> Bool in
            button.tag == forStar
        }).first {
            if isSettingFirstTime {
                currentButton.isSelected = true
            }
            else {
                currentButton.isSelected = !currentButton.isSelected
            }
            if self.ratingCount.contains(forStar) {
                self.ratingCount.remove(at: self.ratingCount.firstIndex(of: forStar)!)
            }
            else {
                self.ratingCount.append(forStar)
            }
        }
    }
}

//MARK:- Extension InitialSetups
//MARK:-
extension PreferStarCategoryCell {
    func setupText() {
        self.titleLabel.textColor = AppColors.themeBlack
        self.titleLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.titleLabel.text = LocalizedString.PreferredStarCategory.localized
    }
    
    func initialSetups() {
        self.setupText()
    }
    
    func setPreviousStars(stars: [Int], isSettingFirstTime: Bool = false) {
        //if previously selected then set it.
        self.ratingCount = stars
        for star in self.ratingCount {
            self.updateStarButtonState(forStar: star, isSettingFirstTime: isSettingFirstTime)
        }
        self.ratingCount = stars
        self.starCountLabel.text = self.getStarString(fromArr: self.ratingCount, maxCount: 5)
    }
    
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
}
