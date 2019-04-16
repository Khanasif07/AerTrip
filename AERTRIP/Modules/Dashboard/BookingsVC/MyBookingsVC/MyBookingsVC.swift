//
//  MyBookingsVC.swift
//  AERTRIP
//
//  Created by Admin on 15/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class MyBookingsVC: BaseVC {
    
    //Mark:- Variables
    //================
    private var selectedButton: Int = 0
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var topNavBar: TopNavigationView! {
        didSet {
            self.topNavBar.delegate = self
        }
    }
    @IBOutlet weak var emptyStateImageView: UIImageView!
    @IBOutlet weak var emptyStateTitleLabel: UILabel!
    @IBOutlet weak var emptyStateSubTitleLabel: UILabel!
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
        self.topNavBar.configureNavBar(title: LocalizedString.MyBookings.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: true, isDivider: false)
        self.topNavBar.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "ic_hotel_filter"), selectedImage: #imageLiteral(resourceName: "ic_hotel_filter"))
        self.topNavBar.configureSecondRightButton(normalImage: #imageLiteral(resourceName: "swipeArrow"), selectedImage: #imageLiteral(resourceName: "swipeArrow"))
    }
    
    override func setupTexts() {
        self.emptyStateImageView.image = #imageLiteral(resourceName: "booking_Emptystate")
        self.emptyStateTitleLabel.text = LocalizedString.NoBookingsYet.localized
        self.emptyStateSubTitleLabel.text = LocalizedString.StartYourWanderlustJourneyWithUs.localized
    }
    
    override func setupFonts() {
        self.topNavBar.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.emptyStateTitleLabel.font = AppFonts.Regular.withSize(22.0)
        self.emptyStateSubTitleLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.emptyStateTitleLabel.textColor = AppColors.themeBlack
        self.emptyStateSubTitleLabel.textColor = AppColors.themeGray60
        self.topNavBar.navTitleLabel.textColor = AppColors.textFieldTextColor51

    }
    
    override func bindViewModel() {
        
    }
    
    //Mark:- Functions
    //================
    private func filterOptionsPopUp() {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.TravelDate.localized,LocalizedString.EventType.localized,LocalizedString.BookingDate.localized], colors: [AppColors.themeGreen,AppColors.themeGreen,AppColors.themeGreen])
        _ = PKAlertController.default.presentActionSheetWithTextAllignMentAndImage(nil, message: nil, sourceView: view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton , textAlignment: CATextLayerAlignmentMode.center , selectedButtonIndex: self.selectedButton) { _, index in
            switch index {
            case 0:
                self.selectedButton = index
                printDebug(LocalizedString.TravelDate.localized)
            case 1:
                self.selectedButton = index
                printDebug(LocalizedString.EventType.localized)
            case 2:
                self.selectedButton = index
                printDebug(LocalizedString.BookingDate.localized)
            default:
                printDebug("default")
            }
        }
    }
    
    //Mark:- IBActions
    //================
}

//Mark:- Extensions
//=================
extension MyBookingsVC: TopNavigationViewDelegate {
    
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        printDebug("topNavBarFirstRightButtonAction")
        AppFlowManager.default.showBookingFilterVC(self)
    }
    
    func topNavBarSecondRightButtonAction(_ sender: UIButton) {
        printDebug("topNavBarSecondRightButtonAction")
        self.filterOptionsPopUp()
    }
    
}
