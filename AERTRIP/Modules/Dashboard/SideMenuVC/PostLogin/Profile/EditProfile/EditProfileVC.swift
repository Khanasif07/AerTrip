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
    
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var deleteTravellerView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Variables
    
    // MARK: - Private
    
    var ffExtraCount: Int = 3
    private var defaultPlaceHolder: UIImage = AppGlobals.shared.getImageFor(firstName: nil, lastName: nil, offSet: CGPoint(x: 0.0, y: 9.0))
    
    // MARK: - Public
    
    let viewModel = EditProfileVM()
    var sections = [LocalizedString.EmailAddress.localized, LocalizedString.ContactNumber.localized, LocalizedString.Address.localized, LocalizedString.MoreInformation.localized]
    var editProfileImageHeaderView: EditProfileImageHeaderView = EditProfileImageHeaderView()
    
    var indexPath: IndexPath?
    var indexPathRow: Int = 0
    var pickerTitle: String = ""
    
    let moreInformation = [LocalizedString.Birthday, LocalizedString.Anniversary, LocalizedString.Notes]
    let passportDetaitTitle: [String] = [LocalizedString.passportNo.rawValue, LocalizedString.issueCountry.rawValue]
    let flightPreferencesTitle: [String] = [LocalizedString.seatPreference.rawValue, LocalizedString.mealPreference.rawValue]
    
    // picker
    var pickerView: UIPickerView? = nil
    let pickerSize: CGSize = UIPickerView.pickerSize
    var pickerData: [String] = [String]()
    var pickerType: PickerType = .salutation
    
    // date picker
    var datePickerView: UIView? = nil
    var datePicker:UIDatePicker? = nil
    
    var viewType: ViewType = .leftView
    
    // GenericPickerView
    var genericPickerView: UIView? = nil
    
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
        
        registerXib()
        // Api calling
        viewModel.webserviceForGetDropDownkeys()
        viewModel.webserviceForGetPreferenceList()
        viewModel.webserviceForGetCountryList()
        viewModel.webserviceForGetDefaultAirlines()
//
        doInitialSetUp()
        if viewModel.currentlyUsinfFor == .addNewTravellerList {
            setUpForNewTraveller()
        } else {
            setUpData()
        }
        
        registerXib()
        setupToolBar()
        setUpToolBarForGenericPickerView()
      //  self.tableView.estimatedRowHeight = 44.0
       self.startLoading()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        statusBarStyle = .default
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        delay(seconds: 0.3) { [weak self] in
            guard let sSelf = self else {
                return
            }
            if sSelf.pickerView == nil {
                sSelf.pickerView = UIPickerView()
                sSelf.datePicker = UIDatePicker()
                
                sSelf.datePickerView = UIView()
                sSelf.genericPickerView = UIView()
                
                sSelf.setupPickers()
            }
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.stopLoading()
        self.tableView.reloadData()
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
    
    @IBAction func deleteTravellButtonTapped(_ sender: Any) {
        printDebug("delete from Traveller")
        viewModel.callDeleteTravellerAPI()
    }
    
    // MARK: - Helper Methods
    
    func doInitialSetUp() {
        activityIndicatorView.color = AppColors.themeGreen
        activityIndicatorView.isHidden = true
        topNavView.delegate = self
        topNavView.configureNavBar(title: "", isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        topNavView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.SaveWithSpace.localized, selectedTitle: LocalizedString.SaveWithSpace.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
        topNavView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.CancelWithSpace.localized, selectedTitle: LocalizedString.CancelWithSpace.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        
//        deleteTravellerView.isHidden = self.viewModel.paxId == UserInfo.loggedInUser?.paxId ? true : false
        deleteTravellerView.isHidden = true
        deleteButton.setTitle(LocalizedString.DeleteFromTraveller.localized, for: .normal)
        deleteButton.setTitleColor(AppColors.themeRed, for: .normal)
        deleteButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
        
        editProfileImageHeaderView = EditProfileImageHeaderView.instanceFromNib()
        
        editProfileImageHeaderView.editButton.isHidden = (self.viewModel.paxId != UserInfo.loggedInUser?.paxId)
        editProfileImageHeaderView.delegate = self
        
        tableView.separatorStyle = .none
        tableView.tableHeaderView = editProfileImageHeaderView

    }
    
    func setupPickers() {
        
        datePickerView?.frame = CGRect(x: (UIScreen.main.bounds.size.width - PKCountryPickerSettings.pickerSize.width) / 2.0, y: UIScreen.main.bounds.size.height, width: PKCountryPickerSettings.pickerSize.width, height: (PKCountryPickerSettings.pickerSize.height + PKCountryPickerSettings.toolbarHeight))
       // datePickerView?.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
        
        // Generic Picker View
        //genericPickerView?.frame = CGRect(x: (UIScreen.main.bounds.size.width - PKCountryPickerSettings.pickerSize.width) / 2.0, y: UIScreen.main.bounds.size.height, width: PKCountryPickerSettings.pickerSize.width, height: (PKCountryPickerSettings.pickerSize.height + PKCountryPickerSettings.toolbarHeight))
       // genericPickerView?.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
        
        pickerView?.frame = CGRect(x: 0.0, y: 0, width: pickerSize.width, height: pickerSize.height)
        pickerView?.selectRow(0, inComponent: 0, animated: true)
        
        datePicker?.frame = CGRect(x: 0.0, y: 0, width: pickerSize.width, height: pickerSize.height)
        
        datePickerView?.addSubview(datePicker!)
        genericPickerView?.addSubview(pickerView!)
        
        datePicker?.addTarget(self, action: #selector(valueChangedDatePicker), for: .valueChanged)
        pickerView?.delegate = self
        pickerView?.dataSource = self
       // datePicker?.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        
        pickerView?.setValue(#colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1), forKey: "textColor")
        setupToolBar()
        setUpToolBarForGenericPickerView()
    }
    
    func registerXib() {
        tableView.register(UINib(nibName: AppConstants.ktableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: AppConstants.ktableViewHeaderViewIdentifier)
        tableView.register(UINib(nibName: editTwoPartCellIdentifier, bundle: nil), forCellReuseIdentifier: editTwoPartCellIdentifier)
        tableView.register(UINib(nibName: editThreePartCellIdentifier, bundle: nil), forCellReuseIdentifier: editThreePartCellIdentifier)
        tableView.register(UINib(nibName: addActionCellIdentifier, bundle: nil), forCellReuseIdentifier: addActionCellIdentifier)
        tableView.register(UINib(nibName: textEditableCellIdentifier, bundle: nil), forCellReuseIdentifier: textEditableCellIdentifier)
        
        tableView.register(UINib(nibName: twoPartEditTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: twoPartEditTableViewCellIdentifier)
        tableView.register(UINib(nibName: addressTextEditTableCellIdentier, bundle: nil), forCellReuseIdentifier: addressTextEditTableCellIdentier)
        tableView.register(UINib(nibName: addAddressTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: addAddressTableViewCellIdentifier)
        tableView.register(UINib(nibName: addNotesTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: addNotesTableViewCellIdentifier)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            checkAndOpenCamera(delegate: self)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        checkAndOpenLibrary(delegate: self)
    }
    
    func getPhotoFromFacebook() {
        let socialModel = SocialLoginVM()
        socialModel.fbLogin(vc: self) { [weak self] success in
            guard let sSelf = self else { return }
            if success {
                sSelf.editProfileImageHeaderView.profileImageView.setImageWithUrl(socialModel.userData.picture, placeholder: sSelf.defaultPlaceHolder, showIndicator: true)
                sSelf.viewModel.profilePicture = socialModel.userData.picture
                sSelf.viewModel.imageSource = "facebook"
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
        guard var travel = self.viewModel.travelData else {
            return
        }
        
        
        if travel.id == UserInfo.loggedInUser?.paxId,let userEmail = UserInfo.loggedInUser?.email {
            var email = Email()
            email.label = LocalizedString.Default.localized
            email.value = userEmail
            viewModel.email.append(email)
        } else if travel.contact.email.isEmpty {
            var email = Email()
            email.label = LocalizedString.Home.localized
            viewModel.email.append(email)
        }
        
        for travel in travel.contact.email {
            if travel.label.lowercased() != LocalizedString.Default.localized.lowercased() {
                viewModel.email.append(travel)
            }
        }
        
        
       
        if travel.id == UserInfo.loggedInUser?.paxId,let userMobile = UserInfo.loggedInUser?.mobile {
            var mobile = Mobile()
            mobile.label = LocalizedString.Default.localized
            mobile.value = userMobile
            mobile.isd = UserInfo.loggedInUser?.isd ?? LocalizedString.IndiaIsdCode.localized
            viewModel.mobile.append(mobile)
        } else if travel.contact.mobile.isEmpty {
            var mobile = Mobile()
            mobile.label = LocalizedString.Home.localized
            mobile.isd = LocalizedString.IndiaIsdCode.localized
            viewModel.mobile.append(mobile)
        }
        
        for travel in travel.contact.mobile {
            if travel.label.lowercased() != LocalizedString.Default.localized.lowercased() {
                viewModel.mobile.append(travel)
            }
        }
      
        
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
        viewModel.dob = travel.dob.isEmpty ? LocalizedString.SelectDate.localized : travel.dob
        
        travel.doa = AppGlobals.shared.formattedDateFromString(dateString: travel.doa, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") ?? ""
        viewModel.doa = travel.doa.isEmpty ? LocalizedString.SelectDate.localized : travel.doa
        
        viewModel.notes = travel.notes
        
        viewModel.passportNumber = travel.passportNumber
        
        viewModel.passportCountryName = travel.passportCountryName.isEmpty ? LocalizedString.selectedCountry.localized : travel.passportCountryName
        viewModel.passportCountryCode = travel.passportCountry.isEmpty ? LocalizedString.selectedCountry.localized : travel.passportCountry
        
        travel.passportIssueDate = AppGlobals.shared.formattedDateFromString(dateString: travel.passportIssueDate, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") ?? ""
        viewModel.passportIssueDate = travel.passportIssueDate
        
        travel.passportExpiryDate = AppGlobals.shared.formattedDateFromString(dateString: travel.passportExpiryDate, inputFormat: "yyyy-MM-dd", withFormat: "dd MMMM yyyy") ?? ""
        viewModel.passportExpiryDate = travel.passportExpiryDate
        
        sections.append(LocalizedString.PassportDetails.localized)
        
        let imageFromText: UIImage = AppGlobals.shared.getImageFor(firstName: travel.firstName, lastName: travel.lastName, offSet: CGPoint(x: 0.0, y: 9.0))
        viewModel.frequentFlyer = travel.frequestFlyer
        ffExtraCount = viewModel.frequentFlyer.isEmpty ? 4 : 3
        
        if travel.profileImage != "" {
            editProfileImageHeaderView.profileImageView.setImageWithUrl(travel.profileImage, placeholder: imageFromText, showIndicator: false)
            viewModel.profilePicture = travel.profileImage
        } else {
            if viewModel.currentlyUsinfFor != .viewProfile {
                editProfileImageHeaderView.profileImageView.image = imageFromText
            } else {
                editProfileImageHeaderView.profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder()
            }
        }
        
        viewModel.seat = travel.preferences.seat.value
        viewModel.meal = travel.preferences.meal.value
        editProfileImageHeaderView.groupLabel.text = travel.label.isEmpty ? "Others" : travel.label.capitalizedFirst()
        if viewModel.travelData?.preferences != nil {
            sections.append(LocalizedString.FlightPreferences.localized)
        }
        
        if !travel.salutation.isEmpty{
            viewModel.salutation = travel.salutation
            if  AppConstants.kMaleSalutaion.contains(viewModel.salutation) {
                editProfileImageHeaderView.unicodeSwitch.setSelectedIndex(index: 0, animated: true)
            } else {
                editProfileImageHeaderView.unicodeSwitch.setSelectedIndex(index: 1, animated: true)
            }
        }
        
        editProfileImageHeaderView.firstNameTextField.text = travel.firstName
        viewModel.firstName = travel.firstName
        editProfileImageHeaderView.lastNameTextField.text = travel.lastName
        viewModel.lastName = travel.lastName
        viewModel.label = travel.label
        
        // hide select group view on EditProfileImageHeaderView
        if viewModel.paxId == UserInfo.loggedInUser?.paxId {
            editProfileImageHeaderView.selectGroupDownArrow.isHidden = true
            editProfileImageHeaderView.selectGroupViewHeightConstraint.constant = 0
        }
//        UIView.transition(with: tableView,
//                          duration: 5,
//                          options: .transitionCurlDown,
//                          animations: { self.tableView.reloadData() }) // left out the unnecessary syntax in the completion block and the optional completion parameter
//        tableView.reloadData()
        
       self.tableView.reloadWithEaseInAnimation()
        
    }
    
    private func setUpForNewTraveller() {
        sections.append(contentsOf: [LocalizedString.PassportDetails.localized, LocalizedString.SocialAccounts.localized, LocalizedString.FlightPreferences.localized])
        
        viewModel.passportNumber = ""
        viewModel.passportCountryName = LocalizedString.selectedCountry.localized
        
        viewModel.dob = LocalizedString.SelectDate.localized
        viewModel.doa = LocalizedString.SelectDate.localized
        viewModel.notes = ""
        
        viewModel.seat = LocalizedString.SelectSeatPreference.localized
        viewModel.meal = LocalizedString.SelectMealPreference.localized
        
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
        
        viewModel.label = "Others"
        
        ffExtraCount = 3
        
        var emptyFF = FrequentFlyer(json: [:])
        emptyFF.airlineName = LocalizedString.SelectAirline.localized
        viewModel.frequentFlyer.append(emptyFF)
        
        setUpProfilePhotoInitials()
        tableView.reloadData()
    }
    
    private func setupToolBar() {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0.0, y: -10, width: PKCountryPickerSettings.pickerSize.width, height: PKCountryPickerSettings.toolbarHeight)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(donedatePicker))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.backgroundColor = AppColors.secondarySystemFillColor
        toolbar.barTintColor = AppColors.secondarySystemFillColor
        cancelButton.tintColor = AppColors.themeGreen
        doneButton.tintColor = AppColors.themeGreen
        
        let array = [ spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        
        
        datePickerView?.addBlurEffect(backgroundColor: AppColors.quaternarySystemFillColor, style: .dark, alpha: 1.0)
        datePickerView?.addSubview(toolbar)
    }
    
    private func setUpToolBarForGenericPickerView() {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0.0, y: -10, width: PKCountryPickerSettings.pickerSize.width, height: PKCountryPickerSettings.toolbarHeight)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelGenericPicker))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneGenericPicker))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.backgroundColor = AppColors.secondarySystemFillColor
        toolbar.barTintColor = AppColors.secondarySystemFillColor
        cancelButton.tintColor = AppColors.themeGreen
        doneButton.tintColor = AppColors.themeGreen
        
        let array = [ spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        
        genericPickerView?.addBlurEffect(backgroundColor: AppColors.quaternarySystemFillColor, style: .dark, alpha: 1.0)
        genericPickerView?.addSubview(toolbar)
    }
    
    func insertRowsAtIndexPaths(indexPaths: [NSIndexPath],
                                withRowAnimation animation: UITableView.RowAnimation) {
        let IndexPathOfLastRow = NSIndexPath(row: viewModel.email.count - 1, section: 0)
        tableView.insertRows(at: [IndexPathOfLastRow as IndexPath], with: UITableView.RowAnimation.top)
    }
    
    func openPicker(withSelection: String) {
        dismissKeyboard()
        pickerView?.reloadAllComponents()
        
        closeDatePicker(completion: nil)
        PKCountryPicker.default.closePicker()
        
        let visibleFrame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - pickerSize.height, width: pickerSize.width, height: pickerSize.height)
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.genericPickerView?.frame = visibleFrame
            self.view.addSubview(self.genericPickerView!)
        }) { _ in
            let index = self.pickerData.firstIndex(of: withSelection) ?? 0
            self.pickerView?.selectRow(index, inComponent: 0, animated: true)
        }
    }
    
    func closePicker(completion: ((Bool) -> Void)?) {
        let hiddenFrame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: pickerSize.width, height: pickerSize.height)
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.genericPickerView?.frame = hiddenFrame
        }) { isDone in
            self.genericPickerView?.removeFromSuperview()
            self.pickerView?.selectRow(0, inComponent: 0, animated: true)
            completion?(isDone)
        }
    }
    
    func closeGenricAndDatePicker(completion: ((Bool) -> Void)?) {
        let genricFrame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: pickerSize.width, height: pickerSize.height)
        
        let dateFrame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: pickerSize.width, height: pickerSize.height)
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.genericPickerView?.frame = genricFrame
            self.datePickerView?.frame = dateFrame
            
        }) { isDone in
            self.genericPickerView?.removeFromSuperview()
            self.datePickerView?.removeFromSuperview()
            completion?(isDone)
        }
    }
    
    func closeAllPicker(completion: ((Bool) -> Void)?) {
        dismissKeyboard()
        PKCountryPicker.default.closePicker()
        closeGenricAndDatePicker(completion: nil)
    }
    
    @objc func cancelGenericPicker() {
        closePicker(completion: nil)
    }
    
    @objc func doneGenericPicker() {
        valueChangedGenericPicker()
        self.closePicker(completion: nil)
    }
    @objc func valueChangedGenericPicker() {
        switch pickerType {
        case .salutation:
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
                    viewModel.passportCountryCode = countryCode
                }
                
                viewModel.passportCountryName = pickerTitle
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
    }
    
    func handleMoreInformationSectionSelection(_ indexPath: IndexPath) {
        self.indexPath = indexPath
        switch indexPath.row {
        case 0:
            printDebug("date of birth")
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy"
            showDatePicker(formatter.date(from: viewModel.dob) ?? formatter.date(from: viewModel.doa),nil , maximumDate: formatter.date(from: viewModel.doa) ?? Date())            
        case 1:
            printDebug("date of aniversary")
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy"
            showDatePicker(formatter.date(from: viewModel.doa), formatter.date(from: viewModel.dob), maximumDate: Date())
        case 2:
            printDebug("show notes ")
            closeAllPicker(completion: nil)
            
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
                
                closeGenricAndDatePicker(completion: nil)
                PKCountryPickerSettings.shouldShowCountryCode = false
                UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
                let prevSectdContry = PKCountryPicker.default.getCountryData(forISOCode: self.viewModel.passportCountryCode.isEmpty ? AppConstants.kIndianCountryCode : self.viewModel.passportCountryCode)
                PKCountryPicker.default.chooseCountry(onViewController: self, preSelectedCountry: prevSectdContry) { [weak self] (selectedCountry,closePicker) in
                    printDebug("selected country data: \(selectedCountry)")
                    
                    guard let cell = self?.tableView.cellForRow(at: indexPath) as? TextEditableTableViewCell else {
                        fatalError("TextEditableTableViewCell not found")
                    }
                    cell.editableTextField.text = selectedCountry.countryEnglishName
                    self?.viewModel.passportCountryName = selectedCountry.countryEnglishName
                    self?.viewModel.passportCountryCode = selectedCountry.ISOCode
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
                openPicker(withSelection: viewModel.seat)
            }
        case 1:
            if viewModel.mealPreferences.count > 0 {
                pickerType = .mealPreference
                let mealPreferences = Array(viewModel.mealPreferences.values)
                pickerData = mealPreferences
                openPicker(withSelection: viewModel.meal)
            }
        default:
            break
        }
    }
    
    func showDatePicker(_ pickerDate: Date?, _ minimumDate: Date?, maximumDate: Date?) {
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
        
        datePicker?.minimumDate = minDate
        datePicker?.maximumDate = maximumDate
        
        datePicker?.datePickerMode = .date
        datePicker?.setDate(pickerDate ?? Date(), animated: false)
        openDatePicker()
    }
    
     @objc func donedatePicker() {
        valueChangedDatePicker()
        closeDatePicker(completion: nil)
    }
    
    @objc func valueChangedDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        switch sections[(self.indexPath?.section)!] {
        case LocalizedString.MoreInformation.localized:
            let indexPath = IndexPath(row: (self.indexPath?.row)!, section: (self.indexPath?.section)!)
            guard let cell = tableView.cellForRow(at: indexPath) as? TextEditableTableViewCell else {
                printDebug("TextEditableTableViewCell not found")
                return
            }
            cell.editableTextField.text = formatter.string(from: datePicker?.date ?? Date())
            if indexPath.row == 1 {
                viewModel.doa = formatter.string(from: datePicker?.date ?? Date())
            } else {
                viewModel.dob = formatter.string(from: datePicker?.date ?? Date())
            }
        case LocalizedString.PassportDetails.localized:
            let indexPath = IndexPath(row: (self.indexPath?.row)!, section: (self.indexPath?.section)!)
            guard let cell = tableView.cellForRow(at: indexPath) as? TwoPartEditTableViewCell else {
                fatalError("TextEditableTableViewCell not found")
            }
            if viewType == .leftView {
                cell.leftTextField.text = formatter.string(from: datePicker?.date ?? Date())
                viewModel.passportIssueDate = formatter.string(from: datePicker?.date ?? Date())

            } else {
                cell.rightTextField.text = formatter.string(from: datePicker?.date ?? Date())
                viewModel.passportExpiryDate = formatter.string(from: datePicker?.date ?? Date())
            }

        default:
            break
        }
        
    }
    
    @objc func cancelDatePicker() {
        closeDatePicker(completion: nil)
    }
    
    func openDatePicker() {
        dismissKeyboard()
        closePicker(completion: nil)
        PKCountryPicker.default.closePicker()
        
        let visibleFrame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - pickerSize.height, width: pickerSize.width, height: pickerSize.height)
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.datePickerView?.frame = visibleFrame
            self.view.addSubview(self.datePickerView!)
        }) { _ in
        }
    }
    
    func closeDatePicker(completion: ((Bool) -> Void)?) {
        let hiddenFrame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: pickerSize.width, height: pickerSize.height)
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.datePickerView?.frame = hiddenFrame
        }) { isDone in
            self.datePickerView?.removeFromSuperview()
            completion?(isDone)
        }
    }
    
    
    func compressAndSaveImage(_ image: UIImage, name: String) -> String? {
        let imageData = image.jpegData(compressionQuality: 0.2)
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let imageURL = docDir.appendingPathComponent(name)
        try! imageData?.write(to: imageURL)
        
        return imageURL.absoluteString
    }
    
    func setUpProfilePhotoInitials() {
        if viewModel.profilePicture.isEmpty {
            var flText = ""
            if !viewModel.firstName.isEmpty, !viewModel.lastName.isEmpty {
                flText = "\(viewModel.firstName.firstCharacter)\(viewModel.lastName.firstCharacter)"
            } else if !viewModel.firstName.isEmpty, viewModel.lastName.isEmpty {
                flText = "\(viewModel.firstName.firstCharacter)"
            } else if viewModel.firstName.isEmpty, !viewModel.lastName.isEmpty {
                flText = "\(viewModel.lastName.firstCharacter)"
            }
            
            if flText.isEmpty {
                editProfileImageHeaderView.profileImageView.image = defaultPlaceHolder
            } else {
                editProfileImageHeaderView.profileImageView.image = AppGlobals.shared.getImageFromText(flText.uppercased(), offSet: CGPoint(x: 0.0, y: 9.0)) }
        }
    }
}

extension EditProfileVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        if viewModel.currentlyUsinfFor == .addNewTravellerList {
            dismiss(animated: true, completion: nil)
        } else {
            AppFlowManager.default.popViewController(animated: true)
        }
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        NSLog("save button tapped")
        view.endEditing(true)
        viewModel.dob = AppGlobals.shared.formattedDateFromString(dateString: viewModel.dob, inputFormat: "dd MMMM yyyy", withFormat: "yyyy-MM-dd") ?? ""
        viewModel.doa = AppGlobals.shared.formattedDateFromString(dateString: viewModel.doa, inputFormat: "dd MMMM yyyy", withFormat: "yyyy-MM-dd") ?? ""
        viewModel.passportIssueDate = AppGlobals.shared.formattedDateFromString(dateString: viewModel.passportIssueDate, inputFormat: "dd MMMM yyyy", withFormat: "yyyy-MM-dd") ?? ""
        viewModel.passportExpiryDate = AppGlobals.shared.formattedDateFromString(dateString: viewModel.passportExpiryDate, inputFormat: "dd MMMM yyyy", withFormat: "yyyy-MM-dd") ?? ""
        if self.viewModel.isValidateData(vc: self) {
            viewModel.webserviceForSaveProfile()
        } else if self.viewModel.salutation.isEmpty {
            editProfileImageHeaderView.containerView.layer.borderColor = AppColors.themeRed.cgColor
            editProfileImageHeaderView.containerView.layer.borderWidth = 1.0
        }
    }
}
