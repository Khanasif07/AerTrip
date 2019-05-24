//
//  BookingAddOnRequestVC.swift
//  AERTRIP
//
//  Created by apple on 16/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingAddOnRequestVC: BaseVC {
    // MARK: - IBOutlet
    
    @IBOutlet weak var makePaymentButton: UIButton!
    @IBOutlet weak var topNavigationView: TopNavigationView!
    @IBOutlet weak var requestTableView: ATTableView!
    @IBOutlet weak var priceLabel: UILabel!
     @IBOutlet weak var makePaymentLabel: UILabel!
    
    @IBOutlet weak var priceView: UIView!
    // MARK: - Variables
    
    var hotelData: HotelDetails = HotelDetails()
    
    // MARK: - View Life Cyle
    
    override func initialSetup() {
        self.registerXib()
        self.requestTableView.dataSource = self
        self.requestTableView.delegate = self
        self.setUpNavBar()
        self.requestTableView.reloadData()
        self.addFooterView()
    }
    
    private func setUpNavBar() {
        self.topNavigationView.configureNavBar(title: LocalizedString.AddOnRequest.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        self.topNavigationView.delegate = self
        self.topNavigationView.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.topNavigationView.navTitleLabel.textColor = AppColors.textFieldTextColor51
        self.topNavigationView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "popOverMenuIcon"), selectedImage: #imageLiteral(resourceName: "popOverMenuIcon"), normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
        self.priceView.addGredient(isVertical: false)
    }
    
    private func registerXib() {
        self.requestTableView.registerCell(nibName: BookingRequestNoteTableViewCell.reusableIdentifier)
        self.requestTableView.registerCell(nibName: BookingRequestRouteTableViewCell.reusableIdentifier)
        self.requestTableView.registerCell(nibName: BookingRequestAddOnTableViewCell.reusableIdentifier)
        self.requestTableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        self.requestTableView.registerCell(nibName: BookingRequestStateTableViewCell.reusableIdentifier)
        self.requestTableView.registerCell(nibName: BookingRequestStatusTableViewCell.reusableIdentifier)
    }
    
    override func setupFonts() {
        self.priceLabel.font = AppFonts.SemiBold.withSize(20.0)
          self.makePaymentLabel.font = AppFonts.SemiBold.withSize(20.0)
    }
    
    override func setupTexts() {
//        self.priceLabel.text = AppConstants.kRuppeeSymbol + "\(Double(67000).delimiter)"
        self.makePaymentLabel.text = LocalizedString.MakePayment.localized
    }
    
    override func setupColors() {
        self.priceLabel.textColor = AppColors.themeWhite
        self.makePaymentLabel.textColor = AppColors.themeWhite
    }
    
    @IBAction func makePaymentAction(_ sender: Any) {
        
    }
    
    
    
    
    private func addFooterView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 50))
        customView.backgroundColor = AppColors.themeGray04
        self.requestTableView.tableFooterView = customView
    }
    
    
}

// MARK: Top Navigation View delegate methods

extension BookingAddOnRequestVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.AbortThisRequest.localized], colors: [AppColors.themeRed])

        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton) {  _, index in

            if index == 0 {
                printDebug("Abort this request tapped")
                 AppFlowManager.default.moveToAbortRequestVC()
            }
        }
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate methods

extension BookingAddOnRequestVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 18
    }
     // height for Row at 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return [30,65, 36,30,30,30,30,30,30,30,30,30,36,30, 116, 30,108,30][indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let requestStatusCell = self.requestTableView.dequeueReusableCell(withIdentifier: "BookingRequestStateTableViewCell") as? BookingRequestStateTableViewCell else {
            fatalError("BookingRequestStateTableViewCell not found ")
        }
        switch indexPath.row {
            
        case 0 :
            
            guard let requestStatusCell = self.requestTableView.dequeueReusableCell(withIdentifier: "BookingRequestStatusTableViewCell") as? BookingRequestStatusTableViewCell else  {
                fatalError("BookingRequestStatusTableViewCell not found ")
            }
            requestStatusCell.configureCell("Review the quotation and make payment")
            return requestStatusCell
            
        case 1: // Route Cell
            guard let bookingRouteCell = self.requestTableView.dequeueReusableCell(withIdentifier: "BookingRequestRouteTableViewCell") as? BookingRequestRouteTableViewCell else {
                fatalError("BookingRequestRouteTableViewCell not found")
            }
            return bookingRouteCell
            
        case 2, 13, 15, 17: // Empty cell
            guard let emptyTableViewCell = self.requestTableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell") as? EmptyTableViewCell else {
                fatalError("EmptyTableViewCell not found")
            }
            return emptyTableViewCell
            
        case 3:
            requestStatusCell.configureCell(title: "Case Status", descriptor: "", status: .inProcess)
            requestStatusCell.containerTopConstraint.constant = 0
            return requestStatusCell
            
        case 4:
            requestStatusCell.configureCell(title: "Agent", descriptor: "AO/17-17/252524542", status: .none)
            
            return requestStatusCell
        case 5:
            requestStatusCell.configureCell(title: "Requested on", descriptor: "AO/17-17/252524542", status: .none)
            
            return requestStatusCell
        case 6:
            requestStatusCell.configureCell(title: "Associate Booking ID", descriptor: "AO/17-17/252524542", status: .none)
            
            return requestStatusCell
        case 7:
            requestStatusCell.configureCell(title: "Reference Case ID", descriptor: "AO/17-17/252524542", status: .none)
            
            return requestStatusCell
        case 8:
            requestStatusCell.configureCell(title: "Associate Voucher No.", descriptor: "AO/17-17/252524542", status: .none)
            
            return requestStatusCell
        case 9:
            requestStatusCell.configureCell(title: "", descriptor: "AO/17-17/252524542", status: .none)
            
            return requestStatusCell
        case 10:
            requestStatusCell.configureCell(title: "", descriptor: "AO/17-17/252524542", status: .none)
            
            return requestStatusCell
        case 11:
            requestStatusCell.configureCell(title: "", descriptor: "AO/17-17/252524542", status: .none)
            
            return requestStatusCell
            
        case 12:
            requestStatusCell.configureCell(title: "", descriptor: "AO/17-17/252524542", status: .none)
            requestStatusCell.containerBottomContraint.constant = 6
            return requestStatusCell
            
        case 14: // Notes cell
            guard let noteCell = self.requestTableView.dequeueReusableCell(withIdentifier: "BookingRequestNoteTableViewCell") as? BookingRequestNoteTableViewCell else {
                fatalError("BookingRequestNoteTableViewCell not found")
            }
            noteCell.configureNoteCell(hotelData: self.hotelData)
            return noteCell
        case 16: // Add On cell
            guard let bookingAddOnCell = self.requestTableView.dequeueReusableCell(withIdentifier: "BookingRequestAddOnTableViewCell") as? BookingRequestAddOnTableViewCell else {
                fatalError("BookingRequestAddOnTableViewCell not found")
            }
            bookingAddOnCell.configureCell()
            return bookingAddOnCell
        default:
            return UITableViewCell()
        }
    }
}
