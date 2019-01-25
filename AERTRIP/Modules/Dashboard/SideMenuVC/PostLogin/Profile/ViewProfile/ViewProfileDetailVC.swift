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
    @IBOutlet var tableView: ATTableView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var headerLabel: UILabel!
    
    // MARK: - Variables
    
    let viewModel = ViewProfileDetailVM()
    var sections = [LocalizedString.EmailAddress, LocalizedString.ContactNumber, LocalizedString.MoreInformation]
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
        
        profileImageHeaderView = SlideMenuProfileImageHeaderView.instanceFromNib(isFamily: false)

        UIView.animate(withDuration: AppConstants.kAnimationDuration) { [weak self] in
            self?.tableView.origin.x = -200
//            self?.profileImageHeaderView.profileImageViewHeightConstraint.constant = 121
//            self?.profileImageHeaderView.layoutIfNeeded()
            self?.view.alpha = 1.0
        }
        doInitialSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Api calling
        viewModel.webserviceForGetTravelDetail()
    }
    
    override func bindViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - IB Actions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let ob = EditProfileVC.instantiate(fromAppStoryboard: .Profile)
        ob.travelData = travelData
        ob.viewModel.isFromTravellerList = viewModel.isFromTravellerList
        ob.viewModel.isFromViewProfile = true
        ob.viewModel.paxId = viewModel.paxId
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
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2))
        tableView.tableFooterView = footerView
        setUpDataFromApi()
    }
    
    private func setupParallaxHeader() { // Parallax Header
       let parallexHeaderHeight = CGFloat(UIDevice.screenHeight * 0.45) // UIScreen.width * 9 / 16 + 55
        
        let parallexHeaderMinHeight = navigationController?.navigationBar.bounds.height ?? 74
        
        profileImageHeaderView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 0)
        
        tableView.parallaxHeader.view = profileImageHeaderView
        tableView.parallaxHeader.minimumHeight = parallexHeaderMinHeight // 64
        tableView.parallaxHeader.height = parallexHeaderHeight
        tableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        tableView.parallaxHeader.delegate = self
        
        let gradient = CAGradientLayer()
        gradient.frame = profileImageHeaderView.gradientView.bounds
        gradient.colors = [AppColors.viewProfileDetailTopGradientColor.cgColor, AppColors.viewProfileDetailBottomGradientColor.cgColor]
        profileImageHeaderView.gradientView.layer.insertSublayer(gradient, at: 0)
        profileImageHeaderView.dividerView.isHidden = true
        
        view.bringSubviewToFront(headerView)
    }
    
    private func setUpDataFromApi() {
        guard let travel = travelData else {
            return
        }
        profileImageHeaderView.userNameLabel.text = (travel.firstName) + " " + (travel.lastName)
        profileImageHeaderView.emailIdLabel.text = ""
        profileImageHeaderView.mobileNumberLabel.text = ""
        profileImageHeaderView.familyButton.isHidden = false
        profileImageHeaderView.familyButton.setTitle(travel.label.isEmpty ? "Others" : travel.label.capitalizedFirst(), for: .normal)
        profileImageHeaderView.layoutIfNeeded()
        profileImageHeaderView.profileImageView.image = UIImage(named: "profilePlaceholder")
        if travel.profileImage != "" {
            profileImageHeaderView.profileImageView.kf.setImage(with: URL(string: (travel.profileImage)))
          self.profileImageHeaderView.backgroundImageView.kf.setImage(with: URL(string: travel.profileImage))
            
        } else {
            if viewModel.isFromTravellerList {
                let string = "\("\(travel.firstName)".firstCharacter) \("\(travel.lastName)".firstCharacter)"
                let imageFromText: UIImage = AppGlobals.shared.getImageFromText(string)
                profileImageHeaderView.profileImageView.image = imageFromText
                profileImageHeaderView.backgroundImageView.image = imageFromText
            } else {
                profileImageHeaderView.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder
                profileImageHeaderView.backgroundImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder
            }
        }
        mobile.removeAll()
        if travel.id == UserInfo.loggedInUser?.paxId ?? ""{
            var mobile = Mobile()
            mobile.label = "Default"
            mobile.value = "\(UserInfo.loggedInUser?.isd ?? "") \(UserInfo.loggedInUser?.mobile ?? "")"
            self.mobile = [mobile]
        }
        
        mobile.append(contentsOf: travel.contact.mobile)
        
        if travel.address.count > 0 {
            addresses = travel.address
            sections.append(LocalizedString.Address)
        }
        
        if travel.id == UserInfo.loggedInUser?.paxId ?? "" {
            var email = Email()
            email.label = "Default"
            email.value = UserInfo.loggedInUser?.email ?? ""
            self.email = [email]
        }
        email.append(contentsOf: travel.contact.email)
        let social = travel.contact.social
        
        sections.removeAll()
        if email.count > 0 {
            sections.append(LocalizedString.EmailAddress)
        }
        if mobile.count > 0 {
            sections.append(LocalizedString.ContactNumber)
        }
        if social.count > 0 {
            self.social = social
            sections.append(LocalizedString.SocialAccounts)
        }
      
        informations.removeAll()
        if !travel.dob.isEmpty {
            informations.append(AppGlobals.shared.formattedDateFromString(dateString: travel.dob, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") ?? "")
              sections.append(LocalizedString.MoreInformation)
        }
        if !travel.doa.isEmpty {
            informations.append(AppGlobals.shared.formattedDateFromString(dateString: travel.doa, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") ?? "")
        }
        if !travel.notes.isEmpty {
            informations.append(travel.notes)
        }
        passportDetails.removeAll()
        if travel.passportNumber != "" {
            passportDetails.append((travel.passportNumber))
            passportDetails.append((travel.passportCountryName))
            sections.append(LocalizedString.PassportDetails)
        }
        
        if travel.preferences.seat.value != "" || travel.preferences.meal.value != "" {
            sections.append(LocalizedString.FlightPreferences)
        }
        
        let frequentFlyer = travel.frequestFlyer
        if frequentFlyer.count > 0 {
            self.frequentFlyer = frequentFlyer
        }
        
        let seatPreference = (travel.preferences.seat.value)
        let mealPreference = (travel.preferences.meal.value)
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
            return mobile.count
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
            cell.configureCell(moreInformation[indexPath.row].rawValue, informations[indexPath.row])
            cell.separatorView.isHidden = (indexPath.row + 1 == informations.count) ? true : false
            return cell
        case LocalizedString.ContactNumber:
            cell.configureCell(mobile[indexPath.row].label, "\(mobile[indexPath.row].isd) \(mobile[indexPath.row].value)")
            cell.separatorView.isHidden = (indexPath.row + 1 == mobile.count) ? true : false
            return cell
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
                if let issueDate = travelData?.passportIssueDate, let expiryDate = travelData?.passportExpiryDate {
                    viewProfileMultiDetailcell.cofigureCell(AppGlobals.shared.formattedDateFromString(dateString: issueDate, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") ?? "", AppGlobals.shared.formattedDateFromString(dateString: expiryDate, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") ?? "")
                }
                viewProfileMultiDetailcell.separatorView.isHidden = true
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
                viewProfileMultiDetailcell.configureCellForFrequentFlyer(indexPath, frequentFlyer[indexPath.row - 2].logoUrl, frequentFlyer[indexPath.row - 2].airlineName, frequentFlyer[indexPath.row - 2].number)
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
        headerView.headerLabel.text = sections[section].localized
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
            UIView.animate(withDuration: AppConstants.kAnimationDuration) { [weak self] in
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
