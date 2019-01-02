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

}

//MARK:- Extension InitialSetups
//MARK:-
extension PreferStarCategoryCell {
    
    func initialSetups() {
        
        self.setupButtonSelectedState()
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left]
        for direction in directions {
            
            let firstSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipwFirstView(_:)))
            firstView.addGestureRecognizer(firstSwipeGesture)
            firstSwipeGesture.direction = direction
            
           let  secondSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipwSecondView(_:)))
            secondView.addGestureRecognizer(secondSwipeGesture)
            secondSwipeGesture.direction = direction
            
            let  thirdSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipwThirdView(_:)))
            thirdView.addGestureRecognizer(thirdSwipeGesture)
            thirdSwipeGesture.direction = direction
            
            let  fourthSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipwFourthView(_:)))
            fourthView.addGestureRecognizer(fourthSwipeGesture)
            fourthSwipeGesture.direction = direction
            
            let  fifthSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipwFifthView(_:)))
            fifthView.addGestureRecognizer(fifthSwipeGesture)
            fifthSwipeGesture.direction = direction
        }
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
    
    @objc func swipwFirstView(_ sender : UISwipeGestureRecognizer){
        
        UIView.animate(withDuration: 0.5) {
            if sender.direction == .right {
                
                self.oneStarButton.isSelected = true
            }else if sender.direction == .left{
                self.oneStarButton.isSelected = false
            }
        }
    }
    
    @objc func swipwSecondView(_ sender : UISwipeGestureRecognizer){
        
        UIView.animate(withDuration: 0.5) {
            if sender.direction == .right {
                
                self.twoStarButton.isSelected = true
            }else if sender.direction == .left{
                self.twoStarButton.isSelected = false
            }
        }
    }
    
    @objc func swipwThirdView(_ sender : UISwipeGestureRecognizer){
        
        UIView.animate(withDuration: 0.5) {
            if sender.direction == .right {
                
                self.threeStarButton.isSelected = true
            }else if sender.direction == .left{
                self.threeStarButton.isSelected = false
            }
        }
    }
    
    @objc func swipwFourthView(_ sender : UISwipeGestureRecognizer){
        
        UIView.animate(withDuration: 0.5) {
            if sender.direction == .right {
                
                self.fourStarButton.isSelected = true
            }else if sender.direction == .left{
                self.fourStarButton.isSelected = false
            }
        }
    }
    
    @objc func swipwFifthView(_ sender : UISwipeGestureRecognizer){
        
        UIView.animate(withDuration: 0.5) {
            if sender.direction == .right {
                
                self.fiveStarButton.isSelected = true
            }else if sender.direction == .left{
                self.fiveStarButton.isSelected = false
            }
        }
    }
}
