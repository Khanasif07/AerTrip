//
//  HotelsSearchVC.swift
//  AERTRIP
//
//  Created by Admin on 11/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelsSearchVC: BaseVC {
    
    //MARK:- Properties
    //MARK:-
    internal var checkInOutView: CheckInOutView?
    private var previousOffSet = CGPoint.zero
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var whereContainerView: UIView!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var addRoomView: UIView!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var whereBtnOutlet: UIButton!
    @IBOutlet weak var firstLineView: UIView!
    @IBOutlet weak var secondLineView: UIView!
    @IBOutlet weak var thirdLineView: UIView!
    @IBOutlet weak var fourthLineView: UIView!
    @IBOutlet weak var numberOfRoomLabel: UILabel!
    @IBOutlet weak var numOfPersonLbl: UILabel!
    @IBOutlet weak var addPersonBtn: UIButton!
    @IBOutlet weak var addRoomBtn: UIButton!
    @IBOutlet weak var addRoomLbl: UILabel!
    @IBOutlet weak var starRatingLabel: UILabel!
    @IBOutlet weak var allStarLabel: UILabel!
    @IBOutlet weak var oneStarLabel: UILabel!
    @IBOutlet weak var twoStarLabel: UILabel!
    @IBOutlet weak var threeStarLabel: UILabel!
    @IBOutlet weak var fourStarLabel: UILabel!
    @IBOutlet weak var fiveStarLabel: UILabel!
    @IBOutlet weak var firstStarImgView: UIImageView!
    @IBOutlet weak var secondStarImgView: UIImageView!
    @IBOutlet weak var thirdStarImgView: UIImageView!
    @IBOutlet weak var fourStarImgView: UIImageView!
    @IBOutlet weak var fiveStarImgView: UIImageView!
    @IBOutlet weak var searchBtnOutlet: ATButton!
    @IBOutlet weak var bulkBookingsLbl: UILabel!
    
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetups()
    }
    
    override func viewDidLayoutSubviews() {
        if let view = self.checkInOutView {
            view.frame = self.datePickerView.bounds
        }
    }
    
    override func setupFonts() {
        let regularFontSize16 = AppFonts.Regular.withSize(16.0)
        self.whereBtnOutlet.titleLabel?.font = AppFonts.Regular.withSize(20.0)
        self.numberOfRoomLabel.font = regularFontSize16
        self.numOfPersonLbl.font = AppFonts.SemiBold.withSize(18.0)
        self.starRatingLabel.font = regularFontSize16
        self.allStarLabel.font = AppFonts.Regular.withSize(14.0)
        self.addRoomLbl.font = AppFonts.Regular.withSize(14.0)
        self.oneStarLabel.font = regularFontSize16
        self.twoStarLabel.font = regularFontSize16
        self.threeStarLabel.font = regularFontSize16
        self.fourStarLabel.font = regularFontSize16
        self.fiveStarLabel.font = regularFontSize16
    }
    
    override func setupColors() {
        self.whereBtnOutlet.setTitleColor(AppColors.themeGray40, for: .normal)
        self.firstLineView.backgroundColor = AppColors.themeGray10
        self.secondLineView.backgroundColor = AppColors.themeGray10
        self.thirdLineView.backgroundColor = AppColors.themeGray10
        self.fourthLineView.backgroundColor = AppColors.themeGray10
        self.numberOfRoomLabel.textColor = AppColors.themeGray40
        self.starRatingLabel.textColor = AppColors.themeGray40
        self.addRoomLbl.textColor = AppColors.textFieldTextColor51
        self.allStarLabel.textColor = AppColors.themeGray40
        self.oneStarLabel.textColor = AppColors.themeGray40
        self.twoStarLabel.textColor = AppColors.themeGray40
        self.threeStarLabel.textColor = AppColors.themeGray40
        self.fourStarLabel.textColor = AppColors.themeGray40
        self.fiveStarLabel.textColor = AppColors.themeGray40
        self.attributeLabelSetUp()
    }
    
    private func attributeLabelSetUp() {
        let attributedString = NSMutableAttributedString()
        let grayAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeGray40] as [NSAttributedString.Key : Any]
        let greenAtrribute = [NSAttributedString.Key.font: AppFonts.SemiBold.withSize(14.0), NSAttributedString.Key.foregroundColor: AppColors.themeGreen]
        let greyAttributedString = NSAttributedString(string: "Want more rooms?", attributes: grayAttribute)
        let greenAttributedString = NSAttributedString(string: " Request Bulk Booking", attributes: greenAtrribute)
        attributedString.append(greyAttributedString)
        attributedString.append(greenAttributedString)
        self.bulkBookingsLbl.attributedText = attributedString
    }
    
    //ScrollViewDidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //dont do anything if bouncing
        let difference = scrollView.contentOffset.y - previousOffSet.y
        
        if let parent = parent as? DashboardVC{
            if difference > 0{
                //check if reached bottom
                if parent.mainScrollView.contentOffset.y + parent.mainScrollView.height < parent.mainScrollView.contentSize.height{
                    if scrollView.contentOffset.y > 0.0{
                        parent.mainScrollView.contentOffset.y = min(parent.mainScrollView.contentOffset.y + difference, parent.mainScrollView.contentSize.height - parent.mainScrollView.height)
                        scrollView.contentOffset = CGPoint.zero
                    }
                }
            }else{
                if parent.mainScrollView.contentOffset.y > 0.0{
                    if scrollView.contentOffset.y <= 0.0{
                        parent.mainScrollView.contentOffset.y = max(parent.mainScrollView.contentOffset.y + difference, 0.0)
                    }
                }
            }
        }
        
        previousOffSet = scrollView.contentOffset
        
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.containerView.cornerRadius = 10
        self.containerView.clipsToBounds = true
        self.scrollView.delegate = self
        self.searchBtnOutlet.layer.cornerRadius = 25.0
        self.configureCheckInOutView()
    }
    
    ///ConfigureCheckInOutView
    private func configureCheckInOutView() {
        self.checkInOutView = CheckInOutView(frame: self.datePickerView.bounds)
        if let view = self.checkInOutView {
            self.datePickerView.addSubview(view)
        }
    }
    
    //MARK:- Public
    
    //MARK:- Action
}

