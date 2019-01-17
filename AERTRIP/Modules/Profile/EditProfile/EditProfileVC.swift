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

protocol EditProfileVCDelegate:class {
   func newTravellerCreated()
}

class EditProfileVC: BaseVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - IB Outlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    // MARK: - Variables
    
    // MARK: - Private
    var ffExtraCount: Int = 4
    
    // MARK: - Public
    
    let viewModel = EditProfileVM()
    var sections = [LocalizedString.EmailAddress.localized, LocalizedString.ContactNumber.localized, LocalizedString.Address.localized, LocalizedString.MoreInformation.localized]
    let tableViewHeaderViewIdentifier = "ViewProfileDetailTableViewSectionView"
    var editProfileImageHeaderView: EditProfileImageHeaderView = EditProfileImageHeaderView()
    var imagePicker = UIImagePickerController()
    var travelData: TravelDetailModel?
    
    var indexPath: IndexPath?
    var indexPathRow: Int = 0
    var informations: [String] = []
    var passportDetails: [String] = []
    
    let moreInformation = [LocalizedString.Birthday, LocalizedString.Anniversary, LocalizedString.Notes]
    let passportDetaitTitle: [String] = [LocalizedString.passportNo.rawValue, LocalizedString.issueCountry.rawValue]
    let flightPreferencesTitle: [String] = [LocalizedString.seatPreference.rawValue, LocalizedString.mealPreference.rawValue]
    
    var flightDetails: [String] = []
    
    // picker
    let pickerView: UIPickerView = UIPickerView()
    let pickerSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: 180.0)
    var pickerData: [String] = [String]()
    var pickerType: PickerType = .salutation
    
    // date picker
    let datePickerView: UIView = UIView()
    let datePicker = UIDatePicker()
    
    var viewType: ViewType = .leftView
    
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
    
    // MARK: - Helper Methods
    
    func doInitialSetUp() {
        cancelButton.setTitle(LocalizedString.Cancel.rawValue, for: .normal)
        cancelButton.setTitleColor(AppColors.themeGreen, for: .normal)
        saveButton.setTitle(LocalizedString.Save.rawValue, for: .normal)
        saveButton.setTitleColor(AppColors.themeGreen, for: .normal)
        
        editProfileImageHeaderView = EditProfileImageHeaderView.instanceFromNib()
        editProfileImageHeaderView.delegate = self
        

        
        tableView.separatorStyle = .none
        tableView.tableHeaderView = editProfileImageHeaderView
        
        datePickerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - PKCountryPickerSettings.pickerSize.width) / 2.0, y: UIScreen.main.bounds.size.height, width: PKCountryPickerSettings.pickerSize.width, height: (PKCountryPickerSettings.pickerSize.height + PKCountryPickerSettings.toolbarHeight))
        datePickerView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        
        pickerView.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - pickerSize.height, width: pickerSize.width, height: pickerSize.height)
        
        datePicker.frame = CGRect(x: 0.0, y: 0, width: pickerSize.width, height: pickerSize.height)
        
        datePickerView.addSubview(datePicker)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        pickerView.setValue(#colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1), forKey: "textColor")
        imagePicker.delegate = self
        
        addFooterView()
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
        tableView.register(UINib(nibName: addNotesTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier:    addNotesTableViewCellIdentifier)
        tableView.reloadData()
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
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
        
        if let loggedInUserEmail = UserInfo.loggedInUser?.email, let loggedInUserMobile = UserInfo.loggedInUser?.mobile, let isd = UserInfo.loggedInUser?.isd, viewModel.isFromTravellerList == false {
            var email = Email()
            email.label = "Default"
            email.type = "Email"
            email.value = loggedInUserEmail
            self.viewModel.email.append(email)
            self.viewModel.email.append(contentsOf: travel.contact.email)
            var mobile = Mobile()
            mobile.label = "Default"
            mobile.type = "Mobile"
            mobile.isd = isd
            mobile.value = loggedInUserMobile
            mobile.isValide = true
            self.viewModel.mobile.append(mobile)
            self.viewModel.mobile.append(contentsOf: travel.contact.mobile)
        }
        
        // viewModel.email = email
        viewModel.social = travel.contact.social
        viewModel.social = travel.contact.social
        sections.append(LocalizedString.SocialAccounts.localized)
        
        viewModel.mobile = travel.contact.mobile
        travel.dob = AppGlobals.shared.formattedDateFromString(dateString: travel.dob, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") ?? ""
        informations.append(travel.dob)
        viewModel.dob = travel.dob
        travel.doa = AppGlobals.shared.formattedDateFromString(dateString: travel.doa, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") ?? ""
        informations.append(travel.doa)
        viewModel.doa = travel.doa
        
        informations.append(travel.notes)
        
        passportDetails.append(travel.passportNumber)
        viewModel.passportNumber = travel.passportNumber
        
        passportDetails.append(travel.passportCountryName)
        viewModel.passportCountryName = travel.passportCountryName
        viewModel.passportCountry = travel.passportCountry
        travel.passportIssueDate = AppGlobals.shared.formattedDateFromString(dateString: travel.passportIssueDate, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") ?? ""
        viewModel.passportIssueDate = travel.passportIssueDate
        travel.passportExpiryDate = AppGlobals.shared.formattedDateFromString(dateString: travel.passportExpiryDate, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") ?? ""
        viewModel.passportExpiryDate = travel.passportExpiryDate
        sections.append(LocalizedString.PassportDetails.localized)
        
        viewModel.frequentFlyer = travel.frequestFlyer
        if travel.profileImage != "" {
            editProfileImageHeaderView.profileImageView.kf.setImage(with: URL(string: (travel.profileImage)))
        } else {
            if viewModel.isFromTravellerList {
                let string = "\("\(travel.firstName)".firstCharacter) \("\(travel.lastName)".firstCharacter)"
                let imageFromText: UIImage = AppGlobals.shared.getImageFromText(string)
                editProfileImageHeaderView.profileImageView.image = imageFromText
            } else {
                editProfileImageHeaderView.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder
            }
        }
        
        viewModel.seat = travel.preferences.seat.value
        viewModel.meal = travel.preferences.meal.value
        
        if travelData?.preferences != nil {
            sections.append(LocalizedString.FlightPreferences.localized)
        }
        
        viewModel.salutation = travel.salutation.isEmpty ? LocalizedString.Title.localized   : travel.salutation
        editProfileImageHeaderView.salutaionLabel.text = viewModel.salutation
        editProfileImageHeaderView.firstNameTextField.text = travel.firstName
        viewModel.firstName = travel.firstName
        editProfileImageHeaderView.lastNameTextField.text = travel.lastName
        viewModel.lastName = travel.lastName
        viewModel.addresses = travel.address
        viewModel.label = travel.label
        
        // hide select group view on EditProfileImageHeaderView
        editProfileImageHeaderView.selectGroupViewHeightConstraint.constant = 0
        
        tableView.reloadData()
    }
    
    private func setUpForNewTraveller() {
        
        guard let travel = travelData else {
            return
        }
        sections.append(contentsOf: [LocalizedString.PassportDetails.localized, LocalizedString.SocialAccounts.localized, LocalizedString.FlightPreferences.localized])
        passportDetails.append(contentsOf: ["", ""])
        informations.append(contentsOf: ["", ""])
        flightDetails.append(contentsOf: [LocalizedString.SelectMealPreference.localized, LocalizedString.SelectSeatPreference.localized])
        var email = Email()
        email.type = "Email"
        email.label = "Home"
        viewModel.email.append(email)
        
        if travel.firstName != " " && travelData?.lastName != " "{
            let string = "\("\(travel.firstName)".firstCharacter) \("\(travel.lastName)".firstCharacter)"
            let imageFromText: UIImage = AppGlobals.shared.getImageFromText(string)
            editProfileImageHeaderView.profileImageView.image = imageFromText
        } else {
            editProfileImageHeaderView.profileImageView.image = AppPlaceholderImage.profile
        }
       
        
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
        address.countryName = "Country"
        viewModel.addresses.append(address)
        tableView.reloadData()
    }
    
    private func setupToolBar() {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0.0, y: 0.0, width: PKCountryPickerSettings.pickerSize.width, height: PKCountryPickerSettings.toolbarHeight)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(donedatePicker))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        if PKCountryPickerSettings.appearance == .dark {
            toolbar.barTintColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
            cancelButton.tintColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
            doneButton.tintColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        } else {
            toolbar.barTintColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
            cancelButton.tintColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
            doneButton.tintColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        }
        
        let array = [cancelButton, spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        
        datePickerView.addSubview(toolbar)
    }
    
    func insertRowsAtIndexPaths(indexPaths: [NSIndexPath],
                                withRowAnimation animation: UITableView.RowAnimation) {
        let IndexPathOfLastRow = NSIndexPath(row: viewModel.email.count - 1, section: 0)
        tableView.insertRows(at: [IndexPathOfLastRow as IndexPath], with: UITableView.RowAnimation.top)
    }
    
    func openPicker() {
        pickerView.reloadAllComponents()
        
        let visibleFrame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - pickerSize.height, width: pickerSize.width, height: pickerSize.height)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.pickerView.frame = visibleFrame
            self.view.addSubview(self.pickerView)
        }) { _ in
        }
    }
    
    func closePicker() {
        let hiddenFrame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: pickerSize.width, height: pickerSize.height)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.pickerView.frame = hiddenFrame
        }) { _ in
            self.pickerView.removeFromSuperview()
        }
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
            formatter.date(from: self.viewModel.dob)
            showDatePicker(formatter.date(from: self.viewModel.dob), maximumDate: nil)
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
                openPicker()
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
    
    func showDatePicker(_ minimumDate: Date?, maximumDate : Date?) {
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
        
        closeDatePicker()
    }
    
    @objc func cancelDatePicker() {
        closeDatePicker()
    }
    
    func openDatePicker() {
        let visibleFrame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - pickerSize.height, width: pickerSize.width, height: pickerSize.height)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.datePickerView.frame = visibleFrame
            self.view.addSubview(self.datePickerView)
        }) { _ in
        }
    }
    
    func closeDatePicker() {
        let hiddenFrame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: pickerSize.width, height: pickerSize.height)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.datePickerView.frame = hiddenFrame
        }) { _ in
            self.datePickerView.removeFromSuperview()
        }
    }
    
    func addFooterView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2))
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
}
