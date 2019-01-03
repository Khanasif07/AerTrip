//
//  PreferStarCategoryCell.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 31/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class PreferStarCategoryCell: UITableViewCell {
    
    //    var swipeGesture  = UISwipeGestureRecognizer()
    
    var ratingCount = [Int]()
    
    @IBOutlet weak var oneStarButton: UIButton!
    @IBOutlet weak var twoStarButton: UIButton!
    @IBOutlet weak var threeStarButton: UIButton!
    @IBOutlet weak var fiveStarButton: UIButton!
    @IBOutlet weak var fourStarButton: UIButton!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourthView: UIView!
    @IBOutlet weak var fifthView: UIView!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
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
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            if sender === self.oneStarButton {
                
                if !self.ratingCount.contains(1) {
                    self.ratingCount.append(1)
                }
                
            } else  if sender === self.twoStarButton {
                
                if !self.ratingCount.contains(2) {
                    self.ratingCount.append(2)
                }
                
            } else  if sender === self.threeStarButton {
                
                if !self.ratingCount.contains(3) {
                    self.ratingCount.append(3)
                }
            } else if sender === self.fourStarButton {
                
                if !self.ratingCount.contains(4) {
                    self.ratingCount.append(4)
                }
            } else {
                
                if !self.ratingCount.contains(5) {
                    self.ratingCount.append(5)
                }
            }
            
        } else {
            
            
            if sender === self.oneStarButton {
                
                if self.ratingCount.contains(1) {
                    
                    self.ratingCount = self.ratingCount.filter{$0 != 1}
                }
            } else if sender === self.twoStarButton {
                
                if self.ratingCount.contains(2) {
                    
                    self.ratingCount = self.ratingCount.filter{$0 != 2}
                }
            } else if sender === self.threeStarButton {
                
                if self.ratingCount.contains(3) {
                    
                    self.ratingCount = self.ratingCount.filter{$0 != 3}
                }
            } else if sender === self.fourStarButton {
                
                if self.ratingCount.contains(4) {
                    
                    self.ratingCount = self.ratingCount.filter{$0 != 4}
                }
            } else {
                
                if self.ratingCount.contains(5) {
                    
                    self.ratingCount = self.ratingCount.filter{$0 != 5}
                }
            }
        }
        self.starCountLabel.text = self.getStarString(fromArr: self.ratingCount, maxCount: 5)
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
        self.starCountLabel.text = self.getStarString(fromArr: self.ratingCount, maxCount: 5)
        self.setupButtonSelectedState()
        //        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left]
        //        for direction in directions {
        //
        //            let firstSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipwFirstView(_:)))
        //            firstView.addGestureRecognizer(firstSwipeGesture)
        //            firstSwipeGesture.direction = direction
        //
        //           let  secondSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipwSecondView(_:)))
        //            secondView.addGestureRecognizer(secondSwipeGesture)
        //            secondSwipeGesture.direction = direction
        //
        //            let  thirdSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipwThirdView(_:)))
        //            thirdView.addGestureRecognizer(thirdSwipeGesture)
        //            thirdSwipeGesture.direction = direction
        //
        //            let  fourthSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipwFourthView(_:)))
        //            fourthView.addGestureRecognizer(fourthSwipeGesture)
        //            fourthSwipeGesture.direction = direction
        //
        //            let  fifthSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipwFifthView(_:)))
        //            fifthView.addGestureRecognizer(fifthSwipeGesture)
        //            fifthSwipeGesture.direction = direction
        //        }
    }
    
    func setupButtonSelectedState() {
        
        self.oneStarButton.setImage(UIImage(named: "starRatingFilled"), for: .selected)
        self.oneStarButton.setImage(UIImage(named: "starRatingUnfill"), for: .normal)
        
        self.twoStarButton.setImage(UIImage(named: "starRatingFilled"), for: .selected)
        self.twoStarButton.setImage(UIImage(named: "starRatingUnfill"), for: .normal)
        
        self.threeStarButton.setImage(UIImage(named: "starRatingFilled"), for: .selected)
        self.threeStarButton.setImage(UIImage(named: "starRatingUnfill"), for: .normal)
        
        self.fourStarButton.setImage(UIImage(named: "starRatingFilled"), for: .selected)
        self.fourStarButton.setImage(UIImage(named: "starRatingUnfill"), for: .normal)
        
        self.fiveStarButton.setImage(UIImage(named: "starRatingFilled"), for: .selected)
        self.fiveStarButton.setImage(UIImage(named: "starRatingUnfill"), for: .normal)
    }
    
    //    @objc func swipwFirstView(_ sender : UISwipeGestureRecognizer){
    //
    //        UIView.animate(withDuration: 0.5) {
    //            if sender.direction == .right {
    //
    //                self.oneStarButton.isSelected = true
    //            }else if sender.direction == .left{
    //                self.oneStarButton.isSelected = false
    //            }
    //        }
    //    }
    //
    //    @objc func swipwSecondView(_ sender : UISwipeGestureRecognizer){
    //
    //        UIView.animate(withDuration: 0.5) {
    //            if sender.direction == .right {
    //
    //                self.twoStarButton.isSelected = true
    //            }else if sender.direction == .left{
    //                self.twoStarButton.isSelected = false
    //            }
    //        }
    //    }
    //
    //    @objc func swipwThirdView(_ sender : UISwipeGestureRecognizer){
    //
    //        UIView.animate(withDuration: 0.5) {
    //            if sender.direction == .right {
    //
    //                self.threeStarButton.isSelected = true
    //            }else if sender.direction == .left{
    //                self.threeStarButton.isSelected = false
    //            }
    //        }
    //    }
    //
    //    @objc func swipwFourthView(_ sender : UISwipeGestureRecognizer){
    //
    //        UIView.animate(withDuration: 0.5) {
    //            if sender.direction == .right {
    //
    //                self.fourStarButton.isSelected = true
    //            }else if sender.direction == .left{
    //                self.fourStarButton.isSelected = false
    //            }
    //        }
    //    }
    //
    //    @objc func swipwFifthView(_ sender : UISwipeGestureRecognizer){
    //
    //        UIView.animate(withDuration: 0.5) {
    //            if sender.direction == .right {
    //
    //                self.fiveStarButton.isSelected = true
    //            }else if sender.direction == .left{
    //                self.fiveStarButton.isSelected = false
    //            }
    //        }
    //    }
    
    func getStarString(fromArr: [Int], maxCount: Int) -> String {
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
