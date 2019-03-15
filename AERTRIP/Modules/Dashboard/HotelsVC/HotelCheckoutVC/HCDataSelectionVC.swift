//
//  HCDataSelectionVC.swift
//  AERTRIP
//
//  Created by Admin on 12/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCDataSelectionVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet weak var hotelDetailsContainerView: UIView!
    @IBOutlet weak var continueContainerView: UIView!
    
    //continue
    @IBOutlet weak var fareDetailContainerView: UIView!
    @IBOutlet weak var fareDetailBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalFareLabel: UILabel!
    @IBOutlet weak var infoTextLabel: UILabel!
    @IBOutlet weak var upArrowImageView: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    //minimized hotel details
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var checkInOutDate: UILabel!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var fareBreakupTitleLabel: UILabel!
    @IBOutlet weak var fareDetailLabel: UILabel!
    @IBOutlet weak var totalPayableTextLabel: UILabel!
    @IBOutlet weak var totalFareAmountLabel: UILabel!
    
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = HCDataSelectionVM()
    
    //MARK:- Private
    private let hotelFormData = HotelsSearchVM.hotelFormData
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        
        registerXIBs()
        
        setupNavView()
        
        statusBarStyle = .default
        
        animateFareDetails(isHidden: true, animated: false)
        
        continueContainerView.addGredient(isVertical: false)
        
        fillData()
    }
    
    override func setupFonts() {
        
        //continue button
        totalFareLabel.font = AppFonts.SemiBold.withSize(20.0)
        infoTextLabel.font = AppFonts.Regular.withSize(14.0)
        continueButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
        
        //hotel details
        hotelNameLabel.font = AppFonts.SemiBold.withSize(18.0)
        checkInOutDate.font = AppFonts.Regular.withSize(16.0)
        detailsButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
        
        //fare breakup
        fareBreakupTitleLabel.font = AppFonts.SemiBold.withSize(16.0)
        fareDetailLabel.font = AppFonts.Regular.withSize(16.0)
        totalPayableTextLabel.font = AppFonts.Regular.withSize(20.0)
        totalFareAmountLabel.font = AppFonts.SemiBold.withSize(20.0)
    }
    
    override func setupTexts() {
        
        //continue button
        infoTextLabel.text = LocalizedString.Info.localized
        continueButton.setTitle(LocalizedString.Continue.localized, for: .normal)
        
        //hotel details
        detailsButton.setTitle(LocalizedString.Details.localized, for: .normal)
        
        //fare breakup
        fareBreakupTitleLabel.text = LocalizedString.FareBreakup.localized
        totalPayableTextLabel.text = LocalizedString.TotalPayableNow.localized
        
        //temp
        hotelNameLabel.text = "Grand Hyatt Hotel Mumbai, Maharastra, India"
        checkInOutDate.text = "22 Jul - 28 Jul"
    }
    
    override func setupColors() {
        
        //continue button
        totalFareLabel.textColor = AppColors.themeWhite
        infoTextLabel.textColor = AppColors.themeWhite
        continueButton.setTitleColor(AppColors.themeWhite, for: .normal)
        
        //hotel details
        hotelNameLabel.textColor = AppColors.themeBlack
        checkInOutDate.textColor = AppColors.themeGray40
        detailsButton.setTitleColor(AppColors.themeGreen, for: .normal)
    }
    
    override func bindViewModel() {
        viewModel.delegate = self
    }
    
    private func fillData() {
        viewModel.fetchConfirmItineraryData()
        totalFareLabel.text = "$ \((viewModel.itineraryData?.total_fare ?? 0.0).delimiter)"
        setupFareBreakup()
    }
    
    private func setupNavView() {
        topNavView.delegate = self
        topNavView.configureNavBar(title: LocalizedString.Guests.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        
        topNavView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "plusButton2"), selectedImage: #imageLiteral(resourceName: "plusButton2"))
    }
    
    private func registerXIBs() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = AppColors.themeGray04
        
        tableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        tableView.registerCell(nibName: TextEditableTableViewCell.reusableIdentifier)
        tableView.registerCell(nibName: ContactTableCell.reusableIdentifier)
        
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func setupFareBreakup() {
        let room = 1, night = 2
        let roomText = (room > 1) ? LocalizedString.Rooms.localized : LocalizedString.Room.localized
        let nightText = (night > 1) ? LocalizedString.Nights.localized : LocalizedString.Night.localized
        
        fareDetailLabel.text = "\(LocalizedString.For.localized) \(room) \(roomText) & \(night) \(nightText)"
        totalFareAmountLabel.text = "$ \((viewModel.itineraryData?.total_fare ?? 0.0))"
    }
    
    private func toggleFareDetailView() {
        animateFareDetails(isHidden: fareDetailBottomConstraint.constant >= 0, animated: true)
    }
    
    private func animateFareDetails(isHidden: Bool, animated: Bool) {
        
        let rotateTrans = isHidden ? CGAffineTransform.identity : CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        if !isHidden {
            self.fareDetailContainerView.isHidden = false
        }
        UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, animations: { [weak self] in
            guard let sSelf = self else {return}
            
            sSelf.fareDetailBottomConstraint.constant = isHidden ? -(sSelf.fareDetailContainerView.height) : 0.0
            sSelf.upArrowImageView.transform = rotateTrans
            
            sSelf.view.layoutIfNeeded()
            
            }, completion: { [weak self] (isDone) in
                if isHidden {
                    self?.fareDetailContainerView.isHidden = true
                }
        })
    }
    
    private func setupGuestArray() {
        for i in 0..<hotelFormData.adultsCount.count {
            for _ in 0..<hotelFormData.adultsCount[i] + hotelFormData.childrenCounts[i] {
                self.viewModel.guests[i].append(GuestModal())
            }
        }
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func fareInfoButtonAction(_ sender: UIButton) {
        toggleFareDetailView()
    }
    
    @IBAction func continueButtonAction(_ sender: UIButton) {
        FareUpdatedPopUpVC.showPopUp(isForIncreased: true, decreasedAmount: 0.0, increasedAmount: 30.0, totalUpdatedAmount: 12000.0, continueButtonAction: {
            print("continueButtonAction")
        }, goBackButtonAction: {
            print("goBackButtonAction")
        })
    }
    
    @IBAction func detailsButtonAction(_ sender: UIButton) {
        FareUpdatedPopUpVC.showPopUp(isForIncreased: false, decreasedAmount: 30.0, increasedAmount: 0, totalUpdatedAmount: 0, continueButtonAction: nil, goBackButtonAction: nil)
    }
}

extension HCDataSelectionVC: HCDataSelectionVMDelegate {
    func willFetchConfirmItineraryData() {
    }
    
    func fetchConfirmItineraryDataSuccess() {
        fillData()
    }
    
    func fetchConfirmItineraryDataFail() {
    }
}

extension HCDataSelectionVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        //back button action
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        //plus button action
        
    }
}


extension HCDataSelectionVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotelFormData.adultsCount.count + 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let newRow = indexPath.row - hotelFormData.adultsCount.count
        
        if newRow < 0 {
            //room data cell
            let totalCount = hotelFormData.adultsCount[indexPath.row] + hotelFormData.childrenCounts[indexPath.row]
            return (115.0 * ((totalCount <= 4) ? 1.0 : 2.0)) + 61.0
        }
        else {
            switch newRow {
            case 0, 2, 7 :
                //space
                return 35.0
                
            case 1 :
                //prefrences
                return 78.0
                
            case 3 :
                //contact details text
                return 54.0
                
            case 4 :
                //mobile number
                return 60.0
                
            case 5 :
                //email
                return 60.0
                
            case 6 :
                //text message
                return 60.0
                
            default:
                return 0.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let newRow = indexPath.row - hotelFormData.adultsCount.count
        
        if newRow < 0 {
            //room data cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HCDataSelectionRoomDetailCell.reusableIdentifier) as? HCDataSelectionRoomDetailCell else {
                return UITableViewCell()
            }
            
            cell.configData(forIndexPath: indexPath)
            
            return cell
        }
        else {
            switch newRow {
            case 0, 2, 7 :
                //space
                guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier) as? EmptyTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.contentView.backgroundColor = AppColors.themeGray04
                cell.backgroundColor = AppColors.themeGray04
                
                cell.bottomDividerView.isHidden = newRow == 7
                
                return cell
                
            case 1 :
                //prefrences
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HCDataSelectionPrefrencesCell.reusableIdentifier) as? HCDataSelectionPrefrencesCell else {
                    return UITableViewCell()
                }
                
                return cell
                
            case 3 :
                //contact details text
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HCDataSelectionTextLabelCell.reusableIdentifier) as? HCDataSelectionTextLabelCell else {
                    return UITableViewCell()
                }
                
                
                cell.titleLabel.font = AppFonts.SemiBold.withSize(18.0)
                cell.titleLabel.textColor = AppColors.themeBlack
                cell.titleLabel.text = "Contact Details"
                cell.topConstraint.constant = 16.0
                
                return cell
                
            case 4 :
                //mobile number
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableCell.reusableIdentifier) as? ContactTableCell else {
                    return UITableViewCell()
                }
                                
                return cell
                
            case 5 :
                //email
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TextEditableTableViewCell.reusableIdentifier) as? TextEditableTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.downArrowImageView.isHidden = true
                
                cell.titleLabel.font = AppFonts.Regular.withSize(18.0)
                cell.titleLabel.textColor = AppColors.themeGray20
                cell.titleLabel.text = LocalizedString.Email_ID.localized
                
                cell.editableTextField.isEnabled = UserInfo.loggedInUserId == nil
                cell.editableTextField.text = UserInfo.loggedInUser?.email
                cell.editableTextField.font = AppFonts.Regular.withSize(18.0)
                cell.editableTextField.textColor = UserInfo.loggedInUserId == nil ? AppColors.themeBlack : AppColors.themeGray40
                cell.editableTextField.keyboardType = .emailAddress
                cell.editableTextField.placeholder = LocalizedString.Email_ID.localized
                
                return cell
                
            case 6 :
                //text message
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HCDataSelectionTextLabelCell.reusableIdentifier) as? HCDataSelectionTextLabelCell else {
                    return UITableViewCell()
                }
                
                cell.topConstraint.constant = 6.0
                cell.configUI()
                
                return cell
                
            default:
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Redirect to Selection Preference VC
        if let _ = tableView.cellForRow(at: indexPath) as? HCDataSelectionPrefrencesCell, let specialRequests = self.viewModel.itineraryData?.special_requests {
            AppFlowManager.default.presentHCSpecialRequestsVC(specialRequests: specialRequests, delegate: self)
        }
    }
}


extension HCDataSelectionVC: HCSpecialRequestsDelegate {
    func didPassSelectedRequestsId(ids: [Int], preferences: String, request: String) {
        printDebug("\(ids),\t\(preferences),\t\(request)")
    }
}
