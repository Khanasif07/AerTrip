//
//  HotelRatingInfoCell.swift
//  AERTRIP
//
//  Created by Admin on 11/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HotelRatingInfoCellDelegate: class {
    func shareButtonAction(_ sender: UIButton)
}

class HotelRatingInfoCell: UITableViewCell {

    //Mark:- Variables
    //================
    internal var delegate: HotelRatingInfoCellDelegate?
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var hotelNameAndDistanceStackView: UIStackView!
    @IBOutlet weak var allStackView: UIStackView!
    @IBOutlet weak var hotelRatingView: FloatRatingView!
    @IBOutlet weak var tripadviserImageView: UIImageView!
    @IBOutlet weak var hotelDotsView: FloatRatingView!
    @IBOutlet weak var shareButtonOutlet: UIButton!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var deviderView: UIView!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    //Mark:- Methods
    //==============
    private func configureUI() {
        //Color
        self.hotelNameLabel.textColor = AppColors.themeBlack
        self.distanceLabel.textColor = AppColors.themeGray60
        self.deviderView.backgroundColor = AppColors.divider.color
        
        //Size
        self.hotelNameLabel.font = AppFonts.SemiBold.withSize(22.0)
        self.distanceLabel.font = AppFonts.Regular.withSize(16.0)
        
        //UI SetUp
        self.distanceLabel.isHidden = true
        self.deviderView.isHidden = true
        self.hotelRatingView.isHidden = true
        self.hotelDotsView.isHidden = true
        self.tripadviserImageView.isHidden = true
    }
    
    private func textSetUp(hotelName: String , distanceText: String, durationValue: Int, starRating: Double , tripAdvisorRating: Double) {
        self.hotelRatingView.isHidden = false
        self.hotelNameLabel.text = hotelName
        let modeImage: String
        if durationValue/60 <= 10 {
            modeImage = "• 🚶🏻 "
            self.distanceLabel.text = "\(distanceText) \(modeImage) \((Double(durationValue)/60.0).roundTo(places: 1)) mins"
        } else {
            self.distanceLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "\(distanceText) • ", image: #imageLiteral(resourceName: "car"), endText: " \((Double(durationValue)/60.0).roundTo(places: 1)) mins", font: AppFonts.Regular.withSize(16.0))
        }
        self.distanceLabel.isHidden = (self.distanceLabel.text ?? "").isEmpty
        self.deviderView.isHidden = false
        self.hotelRatingView.rating = starRating
        self.hotelDotsView.rating = tripAdvisorRating
        self.hotelRatingView.isHidden = starRating.isZero
        self.hotelDotsView.isHidden = tripAdvisorRating.isZero
        self.tripadviserImageView.isHidden = tripAdvisorRating.isZero
        if starRating.isZero , tripAdvisorRating.isZero {
            self.ratingStackView.isHidden = true
        }
        if hotelName.isEmpty , (self.distanceLabel.text ?? "").isEmpty {
            self.hotelNameAndDistanceStackView.isHidden = true
        }
    }

        
    internal func configureCell(hotelData: HotelSearched , placeData: PlaceModel) {
//        self.textSetUp(hotelName: hotelData.hotelName ?? "", distanceText: placeData.distanceText , durationValue: placeData.durationValue, starRating: hotelData.star, tripAdvisorRating: hotelData.rating)
        
        //sending the distabce as we are getting from aertrip data base not from google API as discussed with Nitesh
        self.textSetUp(hotelName: hotelData.hotelName ?? "", distanceText: "\(hotelData.distance) km", durationValue: placeData.durationValue, starRating: hotelData.star, tripAdvisorRating: hotelData.rating)
    }
    
    internal func configHCDetailsCell(hotelData: HotelDetails , placeData: PlaceModel) {
        self.textSetUp(hotelName: hotelData.hname , distanceText: placeData.distanceText , durationValue: placeData.durationValue, starRating: hotelData.star, tripAdvisorRating: hotelData.rating)
    }
    
    //Mark:- IBActions
    //================
    @IBAction func shareButtonAction(_ sender: UIButton) {
        self.delegate?.shareButtonAction(sender)
    }
}
