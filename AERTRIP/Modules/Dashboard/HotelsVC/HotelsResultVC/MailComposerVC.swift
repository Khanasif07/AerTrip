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
    @IBOutlet weak var acitivityIndicatorView: UIActivityIndicatorView!
    
    // MARK: Variables
    
    let cellIdenitifer = "HotelMailComposerCardViewTableViewCell"
    var mailComposerHeaderView: EmailComposerHeaderView = EmailComposerHeaderView()
    var mailComposerFooterView: EmailComposerFooterView = EmailComposerFooterView()
    var selectedMails: [String] = []
    let viewModel = MailComposerVM()
    var selectedUserEmail = ""
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doInitialSetup()
        self.setupEmail()
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
        self.acitivityIndicatorView.color = AppColors.themeGreen
        self.acitivityIndicatorView.isHidden = true
        self.topNavView.backgroundColor = AppColors.clear
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.EmailFavouriteHotelInfo.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        self.topNavView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.CancelWithSpace.localized, selectedTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
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
        self.updateHeightOfHeader(mailComposerHeaderView, mailComposerHeaderView.toEmailTextView)
    }
    
    private func setUpFooter() {
        self.mailComposerFooterView = EmailComposerFooterView.instanceFromNib()
        self.tableView.tableFooterView = self.mailComposerFooterView
    }
    
    private func getAttributedBoldText(text: String, boldText: String) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(30.0), .foregroundColor: AppColors.themeBlack])
        attString.addAttributes([
            .font: AppFonts.Bold.withSize(30.0),
            .foregroundColor: AppColors.themeGray20
        ], range: (text as NSString).range(of: boldText))
        return attString
    }
    
    private func setUpCheckInOutView() {
        // get all value in a format
        let checkInDate = Date.getDateFromString(stringDate: self.viewModel.hotelSearchRequest?.requestParameters.checkIn ?? "", currentFormat: "yyyy-mm-dd", requiredFormat: "dd MMM")
        let checkOutDate = Date.getDateFromString(stringDate: self.viewModel.hotelSearchRequest?.requestParameters.checkOut ?? "", currentFormat: "yyyy-mm-dd", requiredFormat: "dd MMM")
        
        let totalNights = (self.viewModel.hotelSearchRequest?.requestParameters.checkOut.toDate(dateFormat: "yyyy-mm-dd")! ?? Date()).daysFrom(viewModel.hotelSearchRequest?.requestParameters.checkIn.toDate(dateFormat: "yyyy-mm-dd")! ?? Date())
        
        let checkInDay = Date.getDateFromString(stringDate: self.viewModel.hotelSearchRequest?.requestParameters.checkIn ?? "", currentFormat: "yyyy-mm-dd", requiredFormat: "EEEE")
        let checkOutDay = Date.getDateFromString(stringDate: self.viewModel.hotelSearchRequest?.requestParameters.checkOut ?? "", currentFormat: "yyyy-mm-dd", requiredFormat: "EEEE")
        
        // setup the text
        self.mailComposerHeaderView.checkInDateLabel.text = checkInDate
        self.mailComposerHeaderView.checkOutDateLabel.text = checkOutDate
        self.mailComposerHeaderView.numberOfNightsLabel.text = (totalNights == 1) ? "\(totalNights) Night" : "\(totalNights) Nights"
        self.mailComposerHeaderView.checkInDayLabel.text = checkInDay
        self.mailComposerHeaderView.checkOutDayLabel.text = checkOutDay
    }
    
    private func setupEmail() {
        if let email = UserInfo.loggedInUser?.email {
            self.viewModel.fromEmails = [email]
        }
    }
}

// MARK: - Top Navigation Bar Delegate methods

extension MailComposerVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        printDebug("Send mail")
        let mail = self.mailComposerHeaderView.toEmailTextView.text
        let mailsArray = mail?.components(separatedBy: ",") ?? []
        self.viewModel.pinnedEmails = mailsArray.filter({ $0 != " " })
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

    func updateHeightOfHeader(_ headerView: EmailComposerHeaderView, _ textView: UITextView) {
        let minHeight = textView.font!.lineHeight * 1.0
        let maxHeight = textView.font!.lineHeight * 5.0
        //for email textView (screenW-62)
        //for message textView (screenW-32)

        var emailHeight = headerView.toEmailTextView.text.sizeCount(withFont: textView.font!, bundingSize:         CGSize(width: (UIDevice.screenWidth - 62.0), height: 10000.0)).height

        var msgHeight = headerView.messageSubjectTextView.text.sizeCount(withFont: textView.font!, bundingSize:         CGSize(width: (UIDevice.screenWidth - 22.0), height: 10000.0)).height

        emailHeight = max(minHeight, emailHeight)
        emailHeight = min(maxHeight, emailHeight)

        msgHeight = max(minHeight, msgHeight)
        msgHeight = min(maxHeight, msgHeight)

        self.tableView.tableHeaderView?.frame = CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: (577.0 + emailHeight + msgHeight))

        UIView.animate(withDuration: 0.3, animations: {
            headerView.emailHeightConatraint.constant = emailHeight
            headerView.subjectHeightConstraint.constant = msgHeight
            self.view.layoutIfNeeded()
        }, completion: { (isDone) in
            headerView.toEmailTextView.isScrollEnabled = emailHeight >= maxHeight
            headerView.messageSubjectTextView.isScrollEnabled = msgHeight >= maxHeight
        })
    }
    
    func textViewText(_ textView: UITextView) {
        self.viewModel.subject = textView.text ?? ""
    }
    
    func openContactScreen() {
        printDebug("open Contact Screen")
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
            [CNContactEmailAddressesKey]
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    
    func startLoading() {
        acitivityIndicatorView.isHidden = false
        acitivityIndicatorView.startAnimating()
        topNavView.firstRightButton.isHidden = true
    }
    
    func stopLoading() {
        acitivityIndicatorView.isHidden = true
        acitivityIndicatorView.stopAnimating()
        topNavView.firstRightButton.isHidden = false
    }
}

// MARK: Contact picker Delegate methods

extension MailComposerVC: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        picker.dismiss(animated: true, completion: nil)
        if let _mail = contact.emailAddresses.first?.value as String? {
            printDebug("mail is \(_mail)")
                printDebug("mail is \(_mail)")
                self.mailComposerHeaderView.toEmailTextView.text.append(_mail)
                self.mailComposerHeaderView.toEmailTextView.layoutIfNeeded()
                self.updateHeightOfHeader(mailComposerHeaderView,mailComposerHeaderView.toEmailTextView)
                self.selectedUserEmail = _mail
        } else {
            AppToast.default.showToastMessage(message: LocalizedString.UnableToGetMail.localized, title:"", onViewController: self, duration: 0.6, buttonTitle: "", buttonImage: nil)
        }
       
    }
}

// MARK: - Viewmodel delegates methods

extension MailComposerVC: MailComoserVMDelegate {
    func willSendEmail() {
        startLoading()
    }
    
    func didSendEmailSuccess() {
        stopLoading()
        dismiss(animated: true, completion: nil)
    }
    
    func didSendemailFail(_ error: ErrorCodes) {
        AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .hotelsSearch)
        stopLoading()
    }
}
