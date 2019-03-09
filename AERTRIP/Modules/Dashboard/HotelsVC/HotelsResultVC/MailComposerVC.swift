//
//  MailComposerVC.swift
//  AERTRIP
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Contacts
import ContactsUI
import UIKit

class MailComposerVC: BaseVC {
    // MARK: IB Outlets
    
    @IBOutlet var topNavView: TopNavigationView!
    @IBOutlet var tableView: UITableView!
    
    // MARK: Variables
    
    let cellIdenitifer = "HotelMailComposerCardViewTableViewCell"
    var mailComposerHeaderView: EmailComposerHeaderView = EmailComposerHeaderView()
    var mailComposerFooterView: EmailComposerFooterView = EmailComposerFooterView()
    var selectedMails: [String] = []
    let viewModel = MailComposerVM()
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doInitialSetup()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        guard let headerView = tableView.tableHeaderView else {
            return
        }
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            self.tableView.tableHeaderView = headerView
            self.tableView.layoutIfNeeded()
        }
        
        guard let footerView = tableView.tableFooterView else {
            return
        }
        
        let footerSize = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if footerView.frame.size.height != footerSize.height {
            footerView.frame.size.height = footerSize.height
            self.tableView.tableFooterView = footerView
            self.tableView.layoutIfNeeded()
        }
    }
    
    // MARK: - Helper methods
    
    private func doInitialSetup() {
        self.navBarSetUp()
        self.tableViewSetup()
        self.registerXib()
        self.setupHeader()
        self.setUpFooter()
    }
    
    private func navBarSetUp() {
        self.topNavView.backgroundColor = AppColors.clear
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.EmailFavouriteHotelInfo.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        self.topNavView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Cancel.localized, selectedTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        self.topNavView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.Send.localized, selectedTitle: LocalizedString.Send.rawValue, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen)
    }
    
    private func tableViewSetup() {
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func registerXib() {
        self.tableView.register(UINib(nibName: self.cellIdenitifer, bundle: nil), forCellReuseIdentifier: self.cellIdenitifer)
    }
    
    private func setupHeader() {
        self.mailComposerHeaderView = EmailComposerHeaderView.instanceFromNib()
        self.mailComposerHeaderView.delegate = self
        let text = "\(UserInfo.loggedInUser?.firstName ?? "") \(UserInfo.loggedInUser?.lastName ?? "") \(LocalizedString.SharedMessage.localized)"
        mailComposerHeaderView.sharedStatusLabel.attributedText = getAttributedBoldText(text: text, boldText: "\(UserInfo.loggedInUser?.firstName ?? "") \(UserInfo.loggedInUser?.lastName ?? "")")
        self.setUpCheckInOutView()
        self.tableView.tableHeaderView = mailComposerHeaderView
    }
    
    private func setUpFooter() {
        self.mailComposerFooterView = EmailComposerFooterView.instanceFromNib()
        self.tableView.tableFooterView = self.mailComposerFooterView
    }
    
    private func getAttributedBoldText(text: String, boldText: String) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(30.0), .foregroundColor: AppColors.themeBlack])
        attString.addAttributes([
            .font: AppFonts.Regular.withSize(30.0),
            .foregroundColor: AppColors.themeGray20
        ], range: (text as NSString).range(of: boldText))
        return attString
    }
    
    private func setUpCheckInOutView() {
        // get all value in a format
        let checkInDate = Date.getDateFromString(stringDate: self.viewModel.hotelSearchRequest?.requestParameters.checkIn ?? "", currentFormat: "yyyy-mm-dd", requiredFormat: "dd MMM")
        let checkOutDate = Date.getDateFromString(stringDate: self.viewModel.hotelSearchRequest?.requestParameters.checkOut ?? "", currentFormat: "yyyy-mm-dd", requiredFormat: "dd MMM")
        let totalNights = Date().daysBetweenDate(toDate: self.viewModel.hotelSearchRequest?.requestParameters.checkOut.toDate(dateFormat: "yyyy-mm-dd")! ?? Date(), endDate: viewModel.hotelSearchRequest?.requestParameters.checkIn.toDate(dateFormat: "yyyy-mm-dd")! ?? Date())
        let checkInDay = Date.getDateFromString(stringDate: self.viewModel.hotelSearchRequest?.requestParameters.checkIn ?? "", currentFormat: "yyyy-mm-dd", requiredFormat: "EEEE")
        let checkOutDay = Date.getDateFromString(stringDate: self.viewModel.hotelSearchRequest?.requestParameters.checkOut ?? "", currentFormat: "yyyy-mm-dd", requiredFormat: "EEEE")
        
        // setup the text
        self.mailComposerHeaderView.checkInDateLabel.text = checkInDate
        self.mailComposerHeaderView.checkOutDateLabel.text = checkOutDate
        self.mailComposerHeaderView.numberOfNightsLabel.text = (totalNights == 1) ? "\(totalNights) Night" : "\(totalNights) Nights"
        self.mailComposerHeaderView.checkInDayLabel.text = checkInDay
        self.mailComposerHeaderView.checkOutDayLabel.text = checkOutDay
    }
}

// MARK: - Top Navigation Bar Delegate methods

extension MailComposerVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        printDebug("Send mail")
        self.viewModel.callSendEmailMail()
    }
}

// MARK: - TableViewDataSource and TableViewDelegate methods

extension MailComposerVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.favouriteHotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdenitifer, for: indexPath) as? HotelMailComposerCardViewTableViewCell else {
            printDebug("cell not found")
            return UITableViewCell()
        }
        cell.favHotel = self.viewModel.favouriteHotels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 395
    }
}

// MARK: -  Mail Composer Header View Delegate methods

extension MailComposerVC: EmailComposeerHeaderViewDelegate {
    func textFieldText(_ textfield: UITextField) {
        //  mailComposerHeaderView.toEmailTextView.text = textfield.text
    }
    
    func textViewText(_ textView: UITextView) {
        //
    }
    
    func openContactScreen() {
        printDebug("open Contact Screen")
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
            [CNContactEmailAddressesKey]
        self.present(contactPicker, animated: true, completion: nil)
    }
}

// MARK: Contact picker Delegate methods

extension MailComposerVC: CNContactPickerDelegate {
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
//        picker.dismiss(animated: true, completion: nil)
//
//        let email = CNContactFormatter.string(from: contact, style: <#T##CNContactFormatterStyle#>)
//        for number in contact.phoneNumbers {
//            let mobile = number.value.value(forKey: "digits") as? String
//            if (mobile?.count)! > 7 {
//                // your code goes here
//            }
//        }
//    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        picker.dismiss(animated: true, completion: nil)
        if let _mail = contact.emailAddresses.first?.value as String? {
            printDebug("mail is \(_mail)")
            self.selectedMails.append(_mail)
        }
        var mailString: String = ""
        for mail in self.selectedMails {
            mailString += mail + " "
        }
        
        self.mailComposerHeaderView.toEmailTextView.text = mailString
    }
}

// MARK: - Viewmodel delegates methods

extension MailComposerVC: MailComoserVMDelegate {
    func willSendEmail() {
        //
    }
    
    func didSendEmailSuccess() {
        dismiss(animated: true, completion: nil)
    }
    
    func didSendemailFail() {
        //
    }
}
