//
//  EditProfileVC.swift
//  AERTRIP
//
//  Created by apple on 21/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

enum PickerType {
    case salutation
    case email
    case contactNumber
    case social
    case seatPreference
    case mealPreference
    case country
    case addressTypes
    case groups
}

enum ViewType {
    case leftView
    case rightView
}

protocol EditProfileVCDelegate: class {
    func newTravellerCreated()
}

class EditProfileVC: BaseVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - IB Outlets
    
    @IBOutlet var tableView: ATTableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var deleteTravellerView: UIView!
    @IBOutlet var deleteButton: UIButton!
    
    // MARK: - Variables
    
    // MARK: - Private
    
    var ffExtraCount: Int = 4
    
    // MARK: - Public
    
    let viewModel = EditProfileVM()
    var sections = [LocalizedString.EmailAddress.localized, LocalizedString.ContactNumber.localized, LocalizedString.Address.localized, LocalizedString.MoreInformation.localized]
    let tableViewHeaderViewIdentifier = "ViewProfileDetailTableViewSectionView"
    var editProfileImageHeaderView: EditProfileImageHeaderView = EditProfileImageHeaderView()
    var travelData: TravelDetailModel?
    
    var indexPath: IndexPath?
    var indexPathRow: Int = 0
    var informations: [String] = []
    var passportDetails: [String] = []
    var pickerTitle: String = ""
    
    let moreInformation = [LocalizedString.Birthday, LocalizedString.Anniversary, LocalizedString.Notes]
    let passportDetaitTitle: [String] = [LocalizedString.passportNo.rawValue, LocalizedString.issueCountry.rawValue]
    let flightPreferencesTitle: [String] = [LocalizedString.seatPreference.rawValue, LocalizedString.mealPreference.rawValue]
    
    var flightDetails: [String] = []
    
    // picker
    let pickerView: UIPickerView = UIPickerView()
    let pickerSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: 216.0)
    var pickerData: [String] = [String]()
    var pickerType: PickerType = .salutation
    
    // date picker
    let datePickerView: UIView = UIView()
    let datePicker = UIDatePicker()
    
    var viewType: ViewType = .leftView
    
    // GenericPickerView
    let genericPickerView: UIView = UIView()
    
    // cell Identifier
    let editTwoPartCellIdentifier = "EditProfileTwoPartTableViewCell"
    let editThreePartCellIdentifier = "EditProfileThreePartTableViewCell"
    let addActionCellIdentifier = "TableViewAddActionCell"
    let textEditableCellIdentifier = "TextEditableTableViewCell"
    let twoPartEditTableViewCellIdentifier = "TwoPartEditTableViewCell"
    let addressTextEditTableCellIdentier = "AddressTextEditTableViewCell"
    let addAddressTableViewCellIdentifier = "AddAddressTableViewCell"
    let addNotesTableViewCellIdentifier = "AddNotesTableViewCell"
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Api calling
        viewModel.webserviceForGetDropDownkeys()
        viewModel.webserviceForGetPreferenceList()
        viewModel.webserviceForGetCountryList()
        viewModel.webserviceForGetDefaultAirlines()
        
        doInitialSetUp()
        if viewModel.isFromTravellerList, !viewModel.isFromViewProfile {
            setUpForNewTraveller()
        } else {
            setUpData()
        }
        
        registerXib()
        setupToolBar()
        setUpToolBarForGenericPickerView()
    }
    
    override func viewDidLayoutSubviews() {
        guard let headerView = tableView.tableHeaderView else {
            return
        }
        
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableView.tableHeaderView = headerView
            tableView.layoutIfNeeded()
        }
    }
    
    override func bindViewModel() {
        viewModel.delegate = self
    }
    
    override func keyboardWillShow(notification: Notification) {
        closePicker(completion: nil)
        closeDatePicker(completion: nil)
        PKCountryPicker.default.closePicker()
    }
    
    // MARK: - IB Actions
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        if viewModel.isFromTravellerList, !viewModel.isFromViewProfile {
            dismiss(animated: true, completion: nil)
        } else {
            AppFlowManager.default.popViewController(animated: true)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        NSLog("save button tapped")
        view.endEditing(true)
        viewModel.dob = AppGlobals.shared.formattedDateFromString(dateString: viewModel.dob, inputFormat: "dd MMMM yyyy", withFormat: "yyyy-MM-dd") ?? ""
        viewModel.doa = AppGlobals.shared.formattedDateFromString(dateString: viewModel.doa, inputFormat: "dd MMMM yyyy", withFormat: "yyyy-MM-dd") ?? ""
        viewModel.passportIssueDate = AppGlobals.shared.formattedDateFromString(dateString: viewModel.passportIssueDate, inputFormat: "dd MMMM yyyy", withFormat: "yyyy-MM-dd") ?? ""
        viewModel.passportExpiryDate = AppGlobals.shared.formattedDateFromString(dateString: viewModel.passportExpiryDate, inputFormat: "dd MMMM yyyy", withFormat: "yyyy-MM-dd") ?? ""
        if viewModel.isValidateData(vc: self) {
            viewModel.webserviceForSaveProfile()
        }
    }
    
    @IBAction func deleteTravellButtonTapped(_ sender: Any) {
          printDebug("delete from Traveller")
          viewModel.callDeleteTravellerAPI()
    }
    
    
    
    // MARK: - Helper Methods
    
    func doInitialSetUp() {
        cancelButton.setTitle(LocalizedString.Cancel.rawValue, for: .normal)
        cancelButton.setTitleColor(AppColors.themeGreen, for: .normal)
        saveButton.setTitle(LocalizedString.Save.rawValue, for: .normal)
        saveButton.setTitleColor(AppColors.themeGreen, for: .normal)
        
//        deleteTravellerView.isHidden = self.viewModel.paxId == UserInfo.loggedInUser?.paxId ? true : false
        deleteTravellerView.isHidden = true
        deleteButton.setTitle(LocalizedString.DeleteFromTraveller.localized, for: .normal)
        deleteButton.setTitleColor(AppColors.themeRed, for: .normal)
        deleteButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
        
        editProfileImageHeaderView = EditProfileImageHeaderView.instanceFromNib()
        editProfileImageHeaderView.delegate = self
        
        tableView.separatorStyle = .none
        tableView.tableHeaderView = editProfileImageHeaderView
        
        datePickerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - PKCountryPickerSettings.pickerSize.width) / 2.0, y: UIScreen.main.bounds.size.height, width: PKCountryPickerSettings.pickerSize.width, height: (PKCountryPickerSettings.pickerSize.height + PKCountryPickerSettings.toolbarHeight))
        datePickerView.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
        
        // Generic Picker View
        genericPickerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - PKCountryPickerSettings.pickerSize.width) / 2.0, y: UIScreen.main.bounds.size.height, width: PKCountryPickerSettings.pickerSize.width, height: (PKCountryPickerSettings.pickerSize.height + PKCountryPickerSettings.toolbarHeight))
        genericPickerView.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
        
        pickerView.frame = CGRect(x: 0.0, y: 0, width: pickerSize.width, height: pickerSize.height)
        
        datePicker.frame = CGRect(x: 0.0, y: 0, width: pickerSize.width, height: pickerSize.height)
        
        datePickerView.addSubview(datePicker)
        genericPickerView.addSubview(pickerView)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        datePicker.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        
        pickerView.setValue(#colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1), forKey: "textColor")
        
        //  addFooterView()
    }
    
    func registerXib() {
        tableView.register(UINib(nibName: tableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: tableViewHeaderViewIdentifier)
        tableView.register(UINib(nibName: editTwoPartCellIdentifier, bundle: nil), forCellReuseIdentifier: editTwoPartCellIdentifier)
        tableView.register(UINib(nibName: editThreePartCellIdentifier, bundle: nil), forCellReuseIdentifier: editThreePartCellIdentifier)
        tableView.register(UINib(nibName: addActionCellIdentifier, bundle: nil), forCellReuseIdentifier: addActionCellIdentifier)
        tableView.register(UINib(nibName: textEditableCellIdentifier, bundle: nil), forCellReuseIdentifier: textEditableCellIdentifier)
        
        tableView.register(UINib(nibName: twoPartEditTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: twoPartEditTableViewCellIdentifier)
        tableView.register(UINib(nibName: addressTextEditTableCellIdentier, bundle: nil), forCellReuseIdentifier: addressTextEditTableCellIdentier)
        tableView.register(UINib(nibName: addAddressTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: addAddressTableViewCellIdentifier)
        tableView.register(UINib(nibName: addNotesTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: addNotesTableViewCellIdentifier)
        tableView.reloadData()
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            self.checkAndOpenCamera(delegate: self)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        self.checkAndOpenLibrary(delegate: self)
    }
    
    func getPhotoFromFacebook() {
        let socialModel = SocialLoginVM()
        socialModel.fbLogin(vc: self) { [weak self] success in
            if success {
                self?.editProfileImageHeaderView.profileImageView.setImageWithUrl(socialModel.userData.picture, placeholder: AppPlaceholderImage.profile, showIndicator: true)
                self?.viewModel.profilePicture = socialModel.userData.picture
                self?.viewModel.imageSource = "facebook"
            }
        }
    }
    
    func getPhotoFromGoogle() {
        let socialModel = SocialLoginVM()
        socialModel.googleLogin(vc: self) { [weak self] success in
            if success {
                let placeHolder = UIImage(named: "group")
                self?.editProfileImageHeaderView.profileImageView.setImageWithUrl(socialModel.userData.picture, placeholder: placeHolder!, showIndicator: true)
                self?.viewModel.profilePicture = socialModel.userData.picture
                self?.viewModel.imageSource = "google"
            } else {}
        }
    }
    
    func setUpData() {
        guard var travel = travelData else {
            return
        }
        
        if let loggedInUserEmail = UserInfo.loggedInUser?.email, let loggedInUserMobile = UserInfo.loggedInUser?.mobile, let isd = UserInfo.loggedInUser?.isd, travel.id == UserInfo.loggedInUser?.paxId {
            var email = Email()
            email.label = LocalizedString.Default.localized
            email.type = LocalizedString.Email.localized
            email.value = loggedInUserEmail
            viewModel.email.append(email)
            
            var mobile = Mobile()
            mobile.label = LocalizedString.Default.localized
            mobile.type = LocalizedString.Mobile.localized
            mobile.isd = isd
            mobile.value = loggedInUserMobile
            mobile.isValide = true
            viewModel.mobile.append(mobile)
        }
        if travel.contact.email.isEmpty {
            var email = Email()
            email.label = LocalizedString.Home.localized
            viewModel.email.append(email)
        }
        viewModel.email.append(contentsOf: travel.contact.email)
        if travel.contact.mobile.isEmpty {
            var mobile = Mobile()
            mobile.label = LocalizedString.Home.localized
            mobile.isd = LocalizedString.IndiaIsdCode.localized
            viewModel.mobile.append(mobile)
        }
        viewModel.mobile.append(contentsOf: travel.contact.mobile)
        
        if travel.contact.social.isEmpty {
            var social = Social()
            social.label = LocalizedString.Facebook.localized
            viewModel.social.append(social)
        }
        
        if travel.address.isEmpty {
            var address = Address()
            address.label = "Home"
            address.countryName = LocalizedString.selectedCountry.localized
            viewModel.addresses.append(address)
        }
        viewModel.addresses.append(contentsOf: travel.address)
        viewModel.social.append(contentsOf: travel.contact.social)
        sections.append(LocalizedString.SocialAccounts.localized)
        
        travel.dob = AppGlobals.shared.formattedDateFromString(dateString: travel.dob, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") ?? ""
        informations.append(travel.dob.isEmpty ? LocalizedString.SelectDate.localized : travel.dob)
        viewModel.dob = travel.dob
        travel.doa = AppGlobals.shared.formattedDateFromString(dateString: travel.doa, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") ?? ""
        informations.append(travel.doa.isEmpty ? LocalizedString.SelectDate.localized : travel.doa)
        viewModel.doa = travel.doa
        
        informations.append(travel.notes)
        
        passportDetails.append(travel.passportNumber)
        viewModel.passportNumber = travel.passportNumber
        
        passportDetails.append(travel.passportCountryName.isEmpty ? LocalizedString.selectedCountry.localized : travel.passportCountryName)
        viewModel.passportCountryName = travel.passportCountryName
        viewModel.passportCountry = travel.passportCountry.isEmpty ? LocalizedString.selectedCountry.localized : travel.passportCountry
        travel.passportIssueDate = AppGlobals.shared.formattedDateFromString(dateString: travel.passportIssueDate, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") ?? ""
        viewModel.passportIssueDate = travel.passportIssueDate
        travel.passportExpiryDate = AppGlobals.shared.formattedDateFromString(dateString: travel.passportExpiryDate, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") ?? ""
        viewModel.passportExpiryDate = travel.passportExpiryDate
        sections.append(LocalizedString.PassportDetails.localized)
        let string = "\("\(travel.firstName)".firstCharacter)\("\(travel.lastName)".firstCharacter)"
        let imageFromText: UIImage = AppGlobals.shared.getImageFromText(string)
        viewModel.frequentFlyer = travel.frequestFlyer
        if travel.profileImage != "" {
            editProfileImageHeaderView.profileImageView.setImageWithUrl(travel.profileImage, placeholder: imageFromText, showIndicator: false)
          //  editProfileImageHeaderView.profileImageView.kf.setImage(with: URL(string: (travel.profileImage)))
            viewModel.profilePicture = travel.profileImage
        } else {
            if viewModel.isFromTravellerList {
                editProfileImageHeaderView.profileImageView.image = imageFromText
            } else {
                editProfileImageHeaderView.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder()
            }
        }
        
        viewModel.seat = travel.preferences.seat.value
        viewModel.meal = travel.preferences.meal.value
        
        if travelData?.preferences != nil {
            sections.append(LocalizedString.FlightPreferences.localized)
        }
        
        viewModel.salutation = travel.salutation.isEmpty ? LocalizedString.Title.localized : travel.salutation
        editProfileImageHeaderView.salutaionLabel.text = "\(viewModel.salutation)"
        editProfileImageHeaderView.firstNameTextField.text = travel.firstName
        viewModel.firstName = travel.firstName
        editProfileImageHeaderView.lastNameTextField.text = travel.lastName
        viewModel.lastName = travel.lastName
        viewModel.label = travel.label
        
        // hide select group view on EditProfileImageHeaderView
        if viewModel.paxId == UserInfo.loggedInUser?.paxId  {
              editProfileImageHeaderView.selectGroupViewHeightConstraint.constant = 0
        }
        tableView.reloadData()
    }
    
    private func setUpForNewTraveller() {
        sections.append(contentsOf: [LocalizedString.PassportDetails.localized, LocalizedString.SocialAccounts.localized, LocalizedString.FlightPreferences.localized])
        passportDetails.append(contentsOf: ["", LocalizedString.selectedCountry.localized])
        informations.append(contentsOf: [LocalizedString.SelectDate.localized, LocalizedString.SelectDate.localized, ""])
        flightDetails.append(contentsOf: [LocalizedString.SelectMealPreference.localized, LocalizedString.SelectSeatPreference.localized])
        var email = Email()
        email.type = "Email"
        email.label = "Home"
        viewModel.email.append(email)
        
        var mobile = Mobile()
        mobile.type = "Mobile"
        mobile.label = "Home"
        if let isd = UserInfo.loggedInUser?.isd {
            mobile.isd = isd
        }
        viewModel.mobile.append(mobile)
        
        var social = Social()
        social.type = "Facebook"
        social.label = "Facebook"
        viewModel.social.append(social)
        
        var address = Address()
        address.label = "Home"
        address.countryName = LocalizedString.selectedCountry.localized
        viewModel.addresses.append(address)
        tableView.reloadData()
    }
    
    private func setupToolBar() {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0.0, y: -10, width: PKCountryPickerSettings.pickerSize.width, height: PKCountryPickerSettings.toolbarHeight)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(donedatePicker))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.backgroundColor = AppColors.themeGray40
        toolbar.barTintColor = #colorLiteral(red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
        cancelButton.tintColor = AppColors.themeGreen
        doneButton.tintColor = AppColors.themeGreen
        
        let array = [cancelButton, spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        
        datePickerView.addSubview(toolbar)
    }
    
    private func setUpToolBarForGenericPickerView() {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0.0, y: -10, width: PKCountryPickerSettings.pickerSize.width, height: PKCountryPickerSettings.toolbarHeight)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelGenericPicker))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneGenericPicker))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.backgroundColor = AppColors.themeGray40
        toolbar.barTintColor = #colorLiteral(red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
        cancelButton.tintColor = AppColors.themeGreen
        doneButton.tintColor = AppColors.themeGreen
        
        let array = [cancelButton, spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        
        genericPickerView.addSubview(toolbar)
    }
    
    func insertRowsAtIndexPaths(indexPaths: [NSIndexPath],
                                withRowAnimation animation: UITableView.RowAnimation) {
        let IndexPathOfLastRow = NSIndexPath(row: viewModel.email.count - 1, section: 0)
        tableView.insertRows(at: [IndexPathOfLastRow as IndexPath], with: UITableView.RowAnimation.top)
    }
    
    func openPicker() {
        dismissKeyboard()
        pickerView.reloadAllComponents()
        
        self.closeDatePicker(completion: nil)
        PKCountryPicker.default.closePicker()
        
        let visibleFrame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - pickerSize.height, width: pickerSize.width, height: pickerSize.height)
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.genericPickerView.frame = visibleFrame
            self.view.addSubview(self.genericPickerView)
        }) { _ in
        }
    }
    
    func closePicker(completion: ((Bool) -> Void)?) {
        
        let hiddenFrame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: pickerSize.width, height: pickerSize.height)
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.genericPickerView.frame = hiddenFrame
        }) { (isDone) in
            self.genericPickerView.removeFromSuperview()
            completion?(isDone)
        }
    }
    
    func closeGenricAndDatePicker(completion: ((Bool) -> Void)?) {
        
        let genricFrame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: pickerSize.width, height: pickerSize.height)
        
        let dateFrame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: pickerSize.width, height: pickerSize.height)
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.genericPickerView.frame = genricFrame
            self.datePickerView.frame = dateFrame

        }) { (isDone) in
            self.genericPickerView.removeFromSuperview()
            self.datePickerView.removeFromSuperview()
            completion?(isDone)
        }
    }
    
    func closeAllPicker(completion: ((Bool) -> Void)?) {
        dismissKeyboard()
        PKCountryPicker.default.closePicker()
        self.closeGenricAndDatePicker(completion: nil)
    }
    
    @objc func cancelGenericPicker() {
        closePicker(completion: nil)
    }
    
    @objc func doneGenericPicker() {
        switch pickerType {
        case .salutation:
            editProfileImageHeaderView.salutaionLabel.text = "\(pickerTitle)"
            viewModel.salutation = pickerTitle
        case .email:
            if let indexPath = self.indexPath {
                guard let cell = self.tableView.cellForRow(at: indexPath) as? EditProfileTwoPartTableViewCell else {
                    fatalError("EditProfileTwoPartTableViewCell not found")
                }
                cell.leftTitleLabel.text = pickerTitle
                viewModel.email[indexPath.row].label = pickerTitle
            }
            
        case .contactNumber:
            if let indexPath = self.indexPath {
                guard let cell = self.tableView.cellForRow(at: indexPath) as? EditProfileThreePartTableViewCell else {
                    fatalError("EditProfileThreePartTableViewCell not found")
                }
                cell.leftTitleLabel.text = pickerTitle
                viewModel.mobile[indexPath.row].label = pickerTitle
            }
            
        case .social:
            if let indexPath = self.indexPath {
                guard let cell = self.tableView.cellForRow(at: indexPath) as? EditProfileTwoPartTableViewCell else {
                    fatalError("EditProfileTwoPartTableViewCell not found")
                }
                viewModel.social[indexPath.row].label = pickerTitle
                cell.leftTitleLabel.text = pickerTitle
            }
        case .seatPreference:
            if let indexPath = self.indexPath {
                guard let cell = self.tableView.cellForRow(at: indexPath) as? TextEditableTableViewCell else { fatalError("TextEditableTableViewCell not found") }
                cell.editableTextField.text = pickerTitle
                viewModel.seat = pickerTitle
            }
            
        case .mealPreference:
            if let indexPath = self.indexPath {
                guard let cell = self.tableView.cellForRow(at: indexPath) as? TextEditableTableViewCell else { fatalError("TextEditableTableViewCell not found") }
                cell.editableTextField.text = pickerTitle
                viewModel.meal = pickerTitle
            }
            
        case .country:
            if sections[(self.indexPath?.section)!] == LocalizedString.PassportDetails.localized {
                let indexPath = IndexPath(row: (self.indexPath?.row)!, section: (self.indexPath?.section)!)
                guard let cell = self.tableView.cellForRow(at: indexPath) as? TextEditableTableViewCell else { fatalError("TextEditableTableViewCell not found") }
                cell.editableTextField.text = pickerTitle
                viewModel.passportCountryName = pickerTitle
                if let countryCode = self.viewModel.countries.someKey(forValue: pickerTitle) {
                    viewModel.passportCountry = countryCode
                }
                
                passportDetails[self.indexPath?.row ?? 1] = pickerTitle
            } else {
                let indexPath = IndexPath(row: (self.indexPath?.row)!, section: (self.indexPath?.section)!)
                guard let cell = self.tableView.cellForRow(at: indexPath) as? AddAddressTableViewCell else { fatalError("AddAddressTableViewCell not found") }
                cell.countryLabel.text = pickerTitle
                viewModel.addresses[indexPath.row].countryName = pickerTitle
                viewModel.addresses[indexPath.row].country = viewModel.countries.someKey(forValue: pickerTitle)!
            }
            
        case .addressTypes:
            if let indexPath = self.indexPath {
                guard let cell = self.tableView.cellForRow(at: indexPath) as? AddAddressTableViewCell else { fatalError("AddAddressTableViewCell not found") }
                cell.addressTypeLabel.text = pickerTitle
                viewModel.addresses[indexPath.row].label = pickerTitle
            }
        case .groups:
            editProfileImageHeaderView.groupLabel.text = pickerTitle
            viewModel.label = pickerTitle
        }
        closePicker(completion: nil)
    }
    
    func handleMoreInformationSectionSelection(_ indexPath: IndexPath) {
        self.indexPath = indexPath
        switch indexPath.row {
        case 0:
            NSLog("date of birth")
            showDatePicker(nil, maximumDate: Date())
            
        case 1:
            NSLog("date of aniversary")
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy"
            formatter.date(from: viewModel.dob)
            showDatePicker(formatter.date(from: viewModel.dob), maximumDate: Date())
        case 2:
            NSLog("show notes ")
            
        default:
            break
        }
    }
    
    func handlePassportDetailSectionSelection(_ indexPath: IndexPath) {
        self.indexPath = indexPath
        
        switch indexPath.row {
        case 1:
            if viewModel.countries.count > 0 {
                pickerType = .country
                let countries = Array(viewModel.countries.values)
                pickerData = countries
                //   openPicker()
                PKCountryPickerSettings.shouldShowCountryCode = false
                UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
                PKCountryPicker.default.chooseCountry(onViewController: self) { [weak self] selectedCountry in
                    printDebug("selected country data: \(selectedCountry)")
                    
                    guard let cell = self?.tableView.cellForRow(at: indexPath) as? TextEditableTableViewCell else {
                        fatalError("TextEditableTableViewCell not found")
                    }
                    cell.editableTextField.text = selectedCountry.countryEnglishName
                    self?.viewModel.passportCountryName = selectedCountry.countryEnglishName
                    self?.viewModel.passportCountry = selectedCountry.ISOCode
                    self?.passportDetails[self?.indexPath?.row ?? 1] = selectedCountry.countryEnglishName
                }
            }
            
            break
            
        default:
            break
        }
    }
    
    func handleFlightPreferencesSectionSelection(_ indexPath: IndexPath) {
        self.indexPath = indexPath
        switch indexPath.row {
        case 0:
            if viewModel.seatPreferences.count > 0 {
                pickerType = .seatPreference
                let seatPreferences = Array(viewModel.seatPreferences.values)
                pickerData = seatPreferences
                openPicker()
            }
        case 1:
            if viewModel.mealPreferences.count > 0 {
                pickerType = .mealPreference
                let mealPreferences = Array(viewModel.mealPreferences.values)
                pickerData = mealPreferences
                openPicker()
            }
        default:
            break
        }
    }
    
    func showDatePicker(_ minimumDate: Date?, maximumDate: Date?) {
        // Formate Date
//        var components = DateComponents()
//        components.year = -100
//        if minimumDate == nil {
//              let minDate = Calendar.current.date(byAdding: components, to: Date())
//        }
//
//
//        let calendar = Calendar.current
//        let maxDateComponent = calendar.dateComponents([.day,.month,.year], from: Date())
        
        var minDate: Date? = minimumDate
        if minimumDate == nil {
            var components = DateComponents()
            components.year = -100
            minDate = Calendar.current.date(byAdding: components, to: Date())
        }
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maximumDate
        
        datePicker.datePickerMode = .date
        datePicker.setDate(Date(), animated: false)
        openDatePicker()
    }
    
    @objc func donedatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        switch sections[(self.indexPath?.section)!] {
        case LocalizedString.MoreInformation.localized:
            let indexPath = IndexPath(row: (self.indexPath?.row)!, section: (self.indexPath?.section)!)
            guard let cell = tableView.cellForRow(at: indexPath) as? TextEditableTableViewCell else {
                printDebug("TextEditableTableViewCell not found")
                return
            }
            cell.editableTextField.text = formatter.string(from: datePicker.date)
            if indexPath.row == 1 {
                viewModel.doa = formatter.string(from: datePicker.date)
                informations[indexPath.row] = viewModel.doa
            } else {
                viewModel.dob = formatter.string(from: datePicker.date)
                informations[indexPath.row] = viewModel.dob
            }
        case LocalizedString.PassportDetails.localized:
            let indexPath = IndexPath(row: (self.indexPath?.row)!, section: (self.indexPath?.section)!)
            guard let cell = tableView.cellForRow(at: indexPath) as? TwoPartEditTableViewCell else {
                fatalError("TextEditableTableViewCell not found")
            }
            if viewType == .leftView {
                cell.leftTextField.text = formatter.string(from: datePicker.date)
                viewModel.passportIssueDate = formatter.string(from: datePicker.date)
                
            } else {
                cell.rightTextField.text = formatter.string(from: datePicker.date)
                viewModel.passportExpiryDate = formatter.string(from: datePicker.date)
            }
            
        default:
            break
        }
        
        closeDatePicker(completion: nil)
    }
    
    @objc func cancelDatePicker() {
        closeDatePicker(completion: nil)
    }
    
    func openDatePicker() {
        dismissKeyboard()
        self.closePicker(completion: nil)
        PKCountryPicker.default.closePicker()
        
        let visibleFrame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - pickerSize.height, width: pickerSize.width, height: pickerSize.height)
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.datePickerView.frame = visibleFrame
            self.view.addSubview(self.datePickerView)
        }) { _ in
        }
    }
    
    func closeDatePicker(completion: ((Bool) -> Void)?) {
        let hiddenFrame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: pickerSize.width, height: pickerSize.height)
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.datePickerView.frame = hiddenFrame
        }) { (isDone) in
            self.datePickerView.removeFromSuperview()
            completion?(isDone)
        }
    }
    
    func addFooterView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        customView.backgroundColor = AppColors.themeGray04
        
        tableView.tableFooterView = customView
    }
    
    func compressAndSaveImage(_ image: UIImage, name: String) -> String? {
        let imageData = image.jpegData(compressionQuality: 0.2)
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let imageURL = docDir.appendingPathComponent(name)
        try! imageData?.write(to: imageURL)
        
        return imageURL.absoluteString
    }
    
    func setUpProfilePhotoInitials() {
        var imageFromText: UIImage = UIImage()
        if viewModel.profilePicture == "" {
            if viewModel.firstName != "" {
                let string = "\("\(viewModel.firstName.capitalizedFirst())".firstCharacter)"
                imageFromText = AppGlobals.shared.getImageFromText(string)
                
            } else if viewModel.lastName != "" {
                let string = "\("\(viewModel.lastName.capitalizedFirst())".firstCharacter)"
                imageFromText = AppGlobals.shared.getImageFromText(string)
            }
            
            if viewModel.firstName != "", viewModel.lastName != "" {
                let string = "\("\(viewModel.firstName.capitalizedFirst())".firstCharacter)\("\(viewModel.lastName.capitalizedFirst())".firstCharacter)"
                imageFromText = AppGlobals.shared.getImageFromText(string)
            }
            
            if viewModel.firstName == "", viewModel.lastName == "" {
                editProfileImageHeaderView.profileImageView.image = AppPlaceholderImage.profile
            } else {
                editProfileImageHeaderView.profileImageView.image = imageFromText
            }
        }
    }
    
    
}
