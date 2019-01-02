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
}

enum ViewType {
    case leftView
    case rightView
}

class EditProfileVC: BaseVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - IB Outlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    // MARK: - Variables
    
    let viewModel = EditProfileVM()
    var sections = [LocalizedString.EmailAddress, LocalizedString.ContactNumber, LocalizedString.Address, LocalizedString.MoreInformation]
    let tableViewHeaderViewIdentifier = "ViewProfileDetailTableViewSectionView"
    var editProfileImageHeaderView: EditProfileImageHeaderView = EditProfileImageHeaderView()
    var imagePicker = UIImagePickerController()
    var travelData: TravelDetailModel?
    var email: [Email] = []
    var social: [Social] = []
    var mobile: [Mobile] = []
    var addresses: [Address] = []
    var seatPreferences = [String: String]()
    var mealPreferences = [String: String]()
    var countries = [String: String]()
    var emailTypes: [String] = []
    var mobileTypes: [String] = []
    var addressTypes: [String] = []
    var salutationTypes: [String] = []
    var socialTypes: [String] = []
    var indexPath: IndexPath?
    var indexPathRow: Int = 0
    var informations: [String] = []
    var passportDetails: [String] = []
    
    let moreInformation = [LocalizedString.Birthday, LocalizedString.Anniversary, LocalizedString.Notes]
    let passportDetaitTitle: [String] = [LocalizedString.passportNo.rawValue, LocalizedString.issueCountry.rawValue]
    let flightPreferencesTitle: [String] = [LocalizedString.seatPreference.rawValue, LocalizedString.mealPreference.rawValue]
    var frequentFlyer: [FrequentFlyer] = []
    var flightDetails: [String] = []
    var defaultAirlines: [FlyerModel] = []
    
    let pickerView: UIPickerView = UIPickerView()
    let pickerSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: 180.0)
    var pickerData: [String] = [String]()
    var pickerType: PickerType = .salutation
    
    let datePickerView: UIView = UIView()
    let datePicker = UIDatePicker()
    
    var viewType: ViewType = .leftView
    let editTwoPartCellIdentifier = "EditProfileTwoPartTableViewCell"
    let editThreePartCellIdentifier = "EditProfileThreePartTableViewCell"
    let addActionCellIdentifier = "TableViewAddActionCell"
    let textEditableCellIdentifier = "TextEditableTableViewCell"
    let twoPartEditTableViewCellIdentifier = "TwoPartEditTableViewCell"
    let addressTextEditTableCellIdentier = "AddressTextEditTableViewCell"
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Api calling
        viewModel.webserviceForGetDropDownkeys()
        viewModel.webserviceForGetPreferenceList()
        viewModel.webserviceForGetCountryList()
        viewModel.webserviceForGetDefaultAirlines()
        
        doInitialSetUp()
        setUpData()
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
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        NSLog("save button tapped")
        view.endEditing(true)
        
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
        
        editProfileImageHeaderView.firstNameTextField.delegate = self
        editProfileImageHeaderView.lastNameTextField.delegate = self
        
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
        socialModel.fbLogin(vc: self) { success in
            if success {
                self.editProfileImageHeaderView.profileImageView.setImageWithUrl(socialModel.userData.picture, placeholder: AppPlaceholderImage.profile, showIndicator: true)
            }
        }
    }
    
    func getPhotoFromGoogle() {
        let socialModel = SocialLoginVM()
        socialModel.googleLogin(vc: self) { success in
            if success {
                let placeHolder = UIImage(named: "group")
                self.editProfileImageHeaderView.profileImageView.setImageWithUrl(socialModel.userData.picture, placeholder: placeHolder!, showIndicator: true)
            } else {}
        }
    }
    
    func setUpData() {
        
        guard let travel = travelData else {
            return
        }
        
        self.email = travel.contact.email
        
        self.social = travel.contact.social
        viewModel.social = travel.contact.social
        sections.append(LocalizedString.SocialAccounts)

        self.mobile = travel.contact.mobile
        viewModel.mobile = travel.contact.mobile
        
        informations.append(travel.dob)
        informations.append(travel.doa)
        
        informations.append(travel.notes)
        
        passportDetails.append(travel.passportNumber)
        passportDetails.append(travel.passportCountryName)
        sections.append(LocalizedString.PassportDetails)

        self.frequentFlyer = travel.frequestFlyer
        
        flightDetails.append(travel.preferences.seat.name + "-" + travel.preferences.seat.value)
        flightDetails.append(travel.preferences.meal.name + "-" + travel.preferences.meal.value)
        
        if travelData?.preferences != nil {
            sections.append(LocalizedString.FlightPreferences)
        }
        
        self.addresses = travel.address
        
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
        let IndexPathOfLastRow = NSIndexPath(row: email.count - 1, section: 0)
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
            showDatePicker()
            
        case 1:
            NSLog("date of aniversary")
            showDatePicker()
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
            if countries.count > 0 {
                pickerType = .country
                let countries = Array(self.countries.values)
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
            if seatPreferences.count > 0 {
                pickerType = .seatPreference
                let seatPreferences = Array(self.seatPreferences.values)
                pickerData = seatPreferences
                openPicker()
            }
        case 1:
            if mealPreferences.count > 0 {
                pickerType = .mealPreference
                let mealPreferences = Array(self.mealPreferences.values)
                pickerData = mealPreferences
                openPicker()
            }
        default:
            break
        }
    }
    
    func showDatePicker() {
        // Formate Date
        datePicker.datePickerMode = .date
        datePicker.setDate(Date(), animated: false)
        openDatePicker()
    }
    
    @objc func donedatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        switch sections[(self.indexPath?.section)!] {
        case LocalizedString.MoreInformation:
            let indexPath = IndexPath(row: (self.indexPath?.row)!, section: (self.indexPath?.section)!)
            guard let cell = tableView.cellForRow(at: indexPath) as? TextEditableTableViewCell else {
                fatalError("TextEditableTableViewCell not found")
            }
            cell.editableTextField.text = formatter.string(from: datePicker.date)
            if indexPath.row == 1 {
                viewModel.dob = formatter.string(from: datePicker.date)
            } else {
                viewModel.doa = formatter.string(from: datePicker.date)
            }
            
        case LocalizedString.PassportDetails:
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
}
