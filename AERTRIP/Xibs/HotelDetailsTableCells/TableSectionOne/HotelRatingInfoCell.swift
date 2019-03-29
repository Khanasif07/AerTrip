//
//  HotelRatingInfoCell.swift
//  AERTRIP
//
//  Created by Admin on 11/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelRatingInfoCell: UITableViewCell {

    //Mark:- Variables
    //================
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
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
    }

        
    internal func configureCell(hotelData: HotelSearched , placeData: PlaceModel) {
        self.hotelNameLabel.text = hotelData.hotelName
        let modeImage: String//UIImage
        if placeData.durationValue/60 <= 10 {
            modeImage = " •🚶🏻 " //#imageLiteral(resourceName: "people")
        } else {
            modeImage = " •🚘 " //#imageLiteral(resourceName: "car")
        }
//        self.distanceLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "\(placeData.distanceText)  •", image: modeImage , endText: "  \((Double(placeData.durationValue)/60.0).roundTo(places: 1)) mins", font: AppFonts.Regular.withSize(16.0))
        self.distanceLabel.text = "\(placeData.distanceText)  \(modeImage)  \((Double(placeData.durationValue)/60.0).roundTo(places: 1)) mins"
        self.distanceLabel.isHidden = (self.distanceLabel.text ?? "").isEmpty
        self.deviderView.isHidden = false
        self.hotelRatingView.rating = hotelData.star
        self.hotelDotsView.rating = hotelData.rating
    }
    
    //Mark:- IBActions
    //================
    @IBAction func shareButtonAction(_ sender: UIButton) {
        if let parentVC = self.parentViewController as? HotelDetailsVC {
            AppGlobals.shared.shareWithActivityViewController(VC: parentVC , shareData: "https://beta.aertrip.com")
        }
    }
}
