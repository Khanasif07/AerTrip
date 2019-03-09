//
//  HotelDetailsOverviewVC.swift
//  AERTRIP
//
//  Created by Admin on 06/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import WebKit

class HotelDetailsOverviewVC: BaseVC {
    
    //Mark:- Variables
    //================
    let overViewText: String = ""
    let viewModel = HotelDetailsOverviewVM()
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var overViewTextViewOutlet: UITextView! {
        didSet {
            self.overViewTextViewOutlet.contentInset = UIEdgeInsets(top: 28.0, left: 16.0, bottom: 20.0, right: 16.0)
            self.overViewTextViewOutlet.delegate = self
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stickyTitleLabel: UILabel!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeBlack
        self.stickyTitleLabel.alpha = 0.0
        self.stickyTitleLabel.textColor = AppColors.themeBlack
    }
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.SemiBold.withSize(22.0)
        self.stickyTitleLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupTexts() {
        self.titleLabel.text = LocalizedString.Overview.localized
        self.stickyTitleLabel.text = LocalizedString.Overview.localized
    }
    
    override func initialSetup() {
        self.overViewTextViewOutlet.attributedText = self.viewModel.overViewInfo.htmlToAttributedString
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        if scrollView.contentOffset.y > 10.0 {
        //            self.stickyTitleLabel.text = "Overview"
        //            self.titleLabel.origin.y -= scrollView.contentOffset.y
        //        } else {
        //            self.stickyTitleLabel.text = ""
        //            self.titleLabel.origin.y += scrollView.contentOffset.y
        //        }
        scrollView.contentInsetAdjustmentBehavior = .automatic
        print(scrollView.contentOffset)
    }
    
    //Mark:- Functions
    //================
    private func configUI() {
        
        //        self.overViewTextViewOutlet.text = """
        //        Property Location
        //        Located in Mumbai (Mumbai Suburban), Trident Bandra Kurla Mumbai is minutes from U.S. Consulate General and Bandra Kurla Complex. This 5-star hotel is within close proximity of MMRDA Grounds and University of Mumbai.
        //
        //        Rooms
        //        Make yourself at home in one of the 436 individually furnished guestrooms, featuring MP3 docking stations and minibars. 32-inch LCD televisions with satellite programming provide entertainment, while complimentary wireless Internet access keeps you connected. Private bathrooms with shower/tub combinations feature deep soaking bathtubs and rainfall showerheads. Conveniences include laptop-compatible safes and desks, and housekeeping is provided daily.
        //
        //        Amenities
        //        Pamper yourself with a visit to the spa, which offers massages, body treatments, and facials. If you're looking for recreational opportunities, you'll find an outdoor pool and a fitness center. Additional amenities at this hotel include complimentary wireless Internet access, concierge services, and babysitting/childcare (surcharge). Getting to nearby attractions is a breeze with the area shuttle (surcharge) that operates within 2 meters.
        //
        //        Dining
        //        Enjoy a meal at one of the hotel's dining establishments, which include 3 restaurants and a coffee shop/cafe. From your room, you can also access 24-hour room service. Relax with your favorite drink at a bar/lounge or a poolside bar. Full breakfasts are available daily from 7 AM to 10:30 AM for a fee.
        //
        //        Business, Other Amenities
        //        Featured amenities include complimentary wired Internet access, a 24-hour business center, and express check-in. Planning an event in Mumbai? This hotel has 3746 square feet (348 square meters) of space consisting of a conference center and meeting rooms. A shuttle from the airport to the hotel is provided for a surcharge (available 24 hours), and free valet parking is available onsite.
        //        """
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
