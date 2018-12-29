//
//  ViewProfileDetailVC.swift
//  AERTRIP
//
//  Created by apple on 19/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import MXParallaxHeader
import UIKit

class ViewProfileDetailVC: BaseVC {
    // MARK: - IB Outlets
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var headerLabel: UILabel!
    
    // MARK: - Variables
    
    let viewModel = ViewProfileDetailVM()
    var sections = [LocalizedString.EmailAddress, LocalizedString.ContactNumber, LocalizedString.Address, LocalizedString.MoreInformation]
    let moreInformation = [LocalizedString.Birthday, LocalizedString.Anniversary, LocalizedString.Notes]
    let contactNumber = [LocalizedString.Mobile]
    let address = [LocalizedString.Address]
    var mobile: [Mobile] = []
    var email: [Email] = []
    var social: [Social] = []
    var addresses: [Address] = []
    var frequentFlyer: [FrequentFlyer] = []
    var informations: [String] = []
    let passportDetaitTitle: [String] = [LocalizedString.passportNo.rawValue, LocalizedString.issueCountry.rawValue]
    let flightPreferencesTitle: [String] = [LocalizedString.seatPreference.rawValue, LocalizedString.mealPreference.rawValue]
    var passportDetails: [String] = []
    var flightDetails: [String] = []
    let tableViewHeaderViewIdentifier = "ViewProfileDetailTableViewSectionView"
    let cellIdentifier = "ViewProfileDetailTableViewCell"
    let multipleDetailCellIdentifier = "ViewProfileMultiDetailTableViewCell"
    var profileImageHeaderView: SlideMenuProfileImageHeaderView = SlideMenuProfileImageHeaderView()
    var travelData: TravelDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageHeaderView = SlideMenuProfileImageHeaderView.instanceFromNib(self)
        
        // Api calling
        viewModel.webserviceForGetTravelDetail()
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.tableView.origin.x = -200
            self?.profileImageHeaderView.profileImageViewHeightConstraint.constant = 121
            self?.profileImageHeaderView.layoutIfNeeded()
            self?.view.alpha = 1.0
        }
        doInitialSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func bindViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - IB Actions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let ob = EditProfileVC.instantiate(fromAppStoryboard: .Profile)
        ob.travelData = travelData
        navigationController?.pushViewController(ob, animated: true)
    }
    
    // MARK: - Helper method
    
    func doInitialSetUp() {
        view.bringSubviewToFront(headerView)
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: tableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: tableViewHeaderViewIdentifier)
        editButton.setTitle(LocalizedString.Edit.rawValue, for: .normal)
        setupParallaxHeader()
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.register(UINib(nibName: multipleDetailCellIdentifier, bundle: nil), forCellReuseIdentifier: multipleDetailCellIdentifier)
    }
    
    private func setupParallaxHeader() { // Parallax Header
        let parallexHeaderHeight = CGFloat(319) // UIScreen.width * 9 / 16 + 55
        
        let parallexHeaderMinHeight = navigationController?.navigationBar.bounds.height ?? 74
        
        profileImageHeaderView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: parallexHeaderHeight)
        
        tableView.parallaxHeader.view = profileImageHeaderView
        tableView.parallaxHeader.minimumHeight = parallexHeaderMinHeight // 64
        tableView.parallaxHeader.height = parallexHeaderHeight
        tableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        tableView.parallaxHeader.delegate = self
        
        let gradient = CAGradientLayer()
        gradient.frame = profileImageHeaderView.gradientView.bounds
        gradient.colors = [AppColors.viewProfileDetailTopGradientColor.cgColor, AppColors.viewProfileDetailBottomGradientColor.cgColor]
//        gradient.colors = [AppColors.themeRed.cgColor, AppColors.themeBlue.cgColor]
//        profileImageHeaderView.gradientView.layer.insertSublayer(gradient, at: 0)
        
        view.bringSubviewToFront(headerView)
    }
    
    private func setUpDataFromApi() {
        profileImageHeaderView.userNameLabel.text = (travelData?.firstName)! + " " + (travelData?.lastName)!
        profileImageHeaderView.familyButton.setTitle(travelData?.label, for: .normal)
        profileImageHeaderView.layoutIfNeeded()
        
        if travelData?.profileImage != "" {
            profileImageHeaderView.profileImageView.kf.setImage(with: URL(string: (travelData?.profileImage)!))
        } else {
            let string = "\((travelData?.firstName)!.firstCharacter)" + "\((travelData?.lastName)!.firstCharacter)"
            let image = AppGlobals.shared.getTextFromImage(string)
            profileImageHeaderView.profileImageView.image = image
            profileImageHeaderView.backgroundImageView.image = image
        }
        
        if let mobile = travelData?.contact.mobile {
            if mobile.count > 0 {
                self.mobile = mobile
            } else {
                let userData = UserModel(json: AppUserDefaults.value(forKey: .userData))
                var mobile = Mobile()
                mobile.label = "Default"
                mobile.value = userData.mobile
                self.mobile.append(mobile)
            }
        }
        if let address = travelData?.address {
            addresses = address
        }
        
        if let email = travelData?.contact.email {
            if email.count > 0 {
                self.email = email
            } else {
                let userData = UserModel(json: AppUserDefaults.value(forKey: .userData))
                var email = Email()
                email.label = "Default"
                email.value = userData.email
                self.email.append(email)
            }
        }
        if let social = travelData?.contact.social, social.count > 0 {
            self.social = social
            sections.append(LocalizedString.SocialAccounts)
        }
        informations.append(((travelData?.dob)!))
        informations.append((travelData?.doa)!)
        
        if travelData?.notes != "" {
            informations.append((travelData?.notes)!)
        }
        
        if travelData?.passportNumber != "" {
            passportDetails.append((travelData?.passportNumber)!)
            passportDetails.append((travelData?.passportCountryName)!)
            sections.append(LocalizedString.PassportDetails)
        }
        
        if travelData?.preferences != nil {
            sections.append(LocalizedString.FlightPreferences)
        }
        
        if let frequentFlyer = travelData?.frequestFlyer, frequentFlyer.count > 0 {
            self.frequentFlyer = frequentFlyer
        }
        
        let seatPreference = (travelData?.preferences.seat.name)! + "-" + (travelData?.preferences.seat.value)!
        let mealPreference = (travelData?.preferences.meal.name)! + "-" + (travelData?.preferences.meal.value)!
        flightDetails.append(seatPreference)
        flightDetails.append(mealPreference)
        
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource and Delegate methods

extension ViewProfileDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case LocalizedString.EmailAddress:
            return email.count
        case LocalizedString.MoreInformation:
            return informations.count
        case LocalizedString.ContactNumber:
            return contactNumber.count
        case LocalizedString.SocialAccounts:
            return social.count
        case LocalizedString.Address:
            return addresses.count
        case LocalizedString.PassportDetails:
            return 3
        case LocalizedString.FlightPreferences:
            if frequentFlyer.count > 0 {
                return 2 + frequentFlyer.count
            } else {
                return 2
            }
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ViewProfileDetailTableViewCell else {
            fatalError("ViewProfileDetailTableViewCell not found")
        }
        switch sections[indexPath.section] {
        case LocalizedString.EmailAddress:
            cell.configureCell(email[indexPath.row].label, email[indexPath.row].value)
            cell.separatorView.isHidden = (indexPath.row + 1 == email.count) ? true : false
            return cell
        case LocalizedString.MoreInformation:
            if informations[indexPath.row] != "" {
                cell.configureCell(moreInformation[indexPath.row].rawValue, informations[indexPath.row])
                return cell
            }
            cell.separatorView.isHidden = (indexPath.row + 1 == moreInformation.count) ? true : false
            return UITableViewCell()
            
        case LocalizedString.ContactNumber:
            for mobile in mobile {
                cell.configureCell(mobile.label, mobile.value)
                return cell
            }
            cell.separatorView.isHidden = (indexPath.row + 1 == contactNumber.count) ? true : false
            return UITableViewCell()
            
        case LocalizedString.SocialAccounts:
            cell.configureCell(social[indexPath.row].label, social[indexPath.row].value)
            cell.separatorView.isHidden = (indexPath.row + 1 == social.count) ? true : false
            return cell
        case LocalizedString.Address:
            let content = addresses[indexPath.row].line2 + "\n" + addresses[indexPath.row].line1
            cell.configureCell(addresses[indexPath.row].label, content)
            cell.separatorView.isHidden = (indexPath.row + 1 == addresses.count) ? true : false
            return cell
        case LocalizedString.PassportDetails:
            
            if indexPath.row >= 2 {
                guard let viewProfileMultiDetailcell = tableView.dequeueReusableCell(withIdentifier: multipleDetailCellIdentifier, for: indexPath) as? ViewProfileMultiDetailTableViewCell else {
                    fatalError("ViewProfileMultiDetailTableViewCell not found")
                }
                viewProfileMultiDetailcell.frequentFlyerView.isHidden = true
                viewProfileMultiDetailcell.cofigureCell((travelData?.passportIssueDate)!, (travelData?.passportExpiryDate)!)
                return viewProfileMultiDetailcell
                
            } else {
                cell.configureCell(passportDetaitTitle[indexPath.row], passportDetails[indexPath.row])
                return cell
            }
        case LocalizedString.FlightPreferences:
            if indexPath.row >= 2 {
                guard let viewProfileMultiDetailcell = tableView.dequeueReusableCell(withIdentifier: multipleDetailCellIdentifier, for: indexPath) as? ViewProfileMultiDetailTableViewCell else {
                    fatalError("ViewProfileMultiDetailTableViewCell not found")
                }
                viewProfileMultiDetailcell.secondTitleLabel.isHidden = true
                viewProfileMultiDetailcell.configureCellForFrequentFlyer(indexPath, frequentFlyer[indexPath.row - 2].logoUrl, frequentFlyer[indexPath.row - 2].airlineName, frequentFlyer[indexPath.row - 2].airlineCode)
                return viewProfileMultiDetailcell
                
            } else {
                cell.configureCell(flightPreferencesTitle[indexPath.row], flightDetails[indexPath.row])
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: tableViewHeaderViewIdentifier) as? ViewProfileDetailTableViewSectionView else {
            fatalError("ViewProfileDetailTableViewSectionView not found")
        }
        headerView.headerLabel.text = sections[section].rawValue
        return headerView
    }
}

// MARK: - MXParallaxHeaderDelegate methods

extension ViewProfileDetailVC: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        NSLog("progress %f", parallaxHeader.progress)
        
        if parallaxHeader.progress >= 0.6 {
            profileImageHeaderView.profileImageViewHeightConstraint.constant = 120 * parallaxHeader.progress
        }
        
        if parallaxHeader.progress <= 0.5 {
            UIView.animate(withDuration: 0.5) { [weak self] in
                // self?.view.bringSubviewToFront((self?.headerView)!)
                
                self?.headerView.backgroundColor = UIColor.white
                //                self?.drawableHeaderViewHeightConstraint.constant = 44
                //                self?.drawableHeaderView.backgroundColor = UIColor.white
                
                self?.editButton.setTitleColor(AppColors.themeGreen, for: .normal)
                
                // self?.view.bringSubviewToFront((self?.drawableHeaderView)!)
                
                let backImage = UIImage(named: "Back")
                let tintedImage = backImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                self?.backButton.setImage(tintedImage, for: .normal)
                self?.backButton.tintColor = AppColors.themeGreen
                print(parallaxHeader.progress)
                
                self?.headerLabel.text = self?.profileImageHeaderView.userNameLabel.text
            }
        } else {
            headerView.backgroundColor = UIColor.clear
            editButton.setTitleColor(UIColor.white, for: .normal)
            backButton.tintColor = UIColor.white
            headerLabel.text = ""
        }
        profileImageHeaderView.layoutIfNeeded()
        profileImageHeaderView.doInitialSetup()
    }
}

extension ViewProfileDetailVC: ViewProfileDetailVMDelegate {
    func willGetDetail() {
        //
    }
    
    func getSuccess(_ data: TravelDetailModel) {
        travelData = data
        setUpDataFromApi()
    }
    
    func getFail(errors: ErrorCodes) {
        //
    }
}
