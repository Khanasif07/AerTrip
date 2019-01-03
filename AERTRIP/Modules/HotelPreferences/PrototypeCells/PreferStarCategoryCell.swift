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
//        self.setupSelectedStars()
        
    }
    
    
}

//MARK:- Extension InitialSetups
//MARK:-
extension PreferStarCategoryCell {
    
    func initialSetups() {
        
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
    
    func setupSelectedStars()  {
        
        self.ratingCount = self.ratingCount.sorted()
        
        if self.ratingCount.count > 1 {
            
            var oldValue   = self.ratingCount[0]
            var newValue = self.ratingCount[1]
            var show = ""
            var near  = ""
            
            for index in 1..<self.ratingCount.count {
                
                if newValue - oldValue == 1 {
                    near += "\(oldValue)"
                } else {
                    show += "\(oldValue),"
                }
               oldValue  = self.ratingCount[index]
                if index < self.ratingCount.count - 1 {
                    newValue = self.ratingCount[index + 1]
                }
           }
        }
    }
    
}
