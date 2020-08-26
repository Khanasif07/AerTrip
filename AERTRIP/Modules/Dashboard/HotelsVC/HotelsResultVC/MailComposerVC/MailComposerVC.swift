//
//  MailComposerVC.swift
//  AERTRIP
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//


import UIKit
import Contacts
import ContactsUI

class MailComposerVC: BaseVC {
    // MARK: IB Outlets
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var tableView: UITableView!
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
        self.updateSendButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.statusBarColor = AppColors.clear
        self.statusBarStyle = .default
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.statusBarColor = AppColors.clear
        self.statusBarStyle = .default
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
        self.tableView.contentInsetAdjustmentBehavior = .always
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
        self.topNavView.firstLeftButtonLeadingConst.constant = 5.0
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.EmailFavouriteHotelInfo.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        self.topNavView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.CancelWithSpace.localized, selectedTitle: LocalizedString.Cancel.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        self.topNavView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.SendWithSpace.localized, selectedTitle: LocalizedString.SendWithSpace.rawValue, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen)
        self.topNavView.firstRightButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
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
        var userFirstName = UserInfo.loggedInUser?.firstName ?? ""
        userFirstName = userFirstName.substring(to: 11)
        let text = "\(userFirstName) \(LocalizedString.SharedMessage.localized)"
        mailComposerHeaderView.sharedStatusLabel.numberOfLines = 3
        mailComposerHeaderView.sharedStatusLabel.attributedText = getAttributedBoldText(text: text, boldText: "\(userFirstName)")
        mailComposerHeaderView.sharedStatusLabel.textAlignment = .center
        self.setUpCheckInOutView()
        self.tableView.tableHeaderView = mailComposerHeaderView
        self.updateHeightOfHeader(mailComposerHeaderView, mailComposerHeaderView.messageSubjectTextView)
        mailComposerHeaderView.seeRatesButton.isUserInteractionEnabled = false
        mailComposerHeaderView.clipsToBounds = true
    }
    
    private func setUpFooter() {
        self.mailComposerFooterView = EmailComposerFooterView.instanceFromNib()
        self.mailComposerFooterView.seeRatesButton.isUserInteractionEnabled = false
        self.tableView.tableFooterView = self.mailComposerFooterView
    }
    
    private func getAttributedBoldText(text: String, boldText: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(30.0), .foregroundColor: AppColors.themeBlack, .paragraphStyle: paragraphStyle])
        attString.addAttributes([
            .font: AppFonts.SemiBold.withSize(30.0),
            .foregroundColor: AppColors.themeBlack
        ], range: (text as NSString).range(of: boldText))
        return attString
    }
    
    private func setUpCheckInOutView() {
        // get all value in a format
        let currentFormat = "yyyy-MM-dd"
        let checkInDate = Date.getDateFromString(stringDate: self.viewModel.hotelSearchRequest?.requestParameters.checkIn ?? "", currentFormat: currentFormat, requiredFormat: "dd MMM")
        let checkOutDate = Date.getDateFromString(stringDate: self.viewModel.hotelSearchRequest?.requestParameters.checkOut ?? "", currentFormat: currentFormat, requiredFormat: "dd MMM")
        
        let totalNights = (self.viewModel.hotelSearchRequest?.requestParameters.checkOut.toDate(dateFormat: currentFormat)! ?? Date()).daysFrom(viewModel.hotelSearchRequest?.requestParameters.checkIn.toDate(dateFormat: currentFormat)! ?? Date())
        
        let checkInDay = Date.getDateFromString(stringDate: self.viewModel.hotelSearchRequest?.requestParameters.checkIn ?? "", currentFormat: currentFormat, requiredFormat: "EEEE")
        let checkOutDay = Date.getDateFromString(stringDate: self.viewModel.hotelSearchRequest?.requestParameters.checkOut ?? "", currentFormat: currentFormat, requiredFormat: "EEEE")
        
        // setup the text
        self.mailComposerHeaderView.checkInDateLabel.text = checkInDate
        self.mailComposerHeaderView.checkOutDateLabel.text = checkOutDate
        self.mailComposerHeaderView.numberOfNightsLabel.text = (totalNights == 1) ? "\(totalNights) Night" : "\(totalNights) Nights"
        self.mailComposerHeaderView.checkInDayLabel.text = checkInDay
        self.mailComposerHeaderView.checkOutDayLabel.text = checkOutDay
    }
    
    
    private func updateSendButton(){
        
        let mailsArray = self.mailComposerHeaderView.tagsField.tags.map { (tag) -> String in
            return tag.text
        }
       // let mailsArray = mail?.components(separatedBy: ",") ?? []
        let emails = mailsArray.filter({ $0 != " " &&  $0 != ""})
        var isEmailValid = false
        for email in emails{
            isEmailValid = email.trimmingCharacters(in: .whitespacesAndNewlines).checkValidity(.Email)
            if !isEmailValid{
                self.topNavView.firstRightButton.isEnabled = false
                self.topNavView.firstRightButton.setTitleColor(AppColors.themeGray40, for: .normal)
                return
            }
        }
        
        if !isEmailValid || self.viewModel.subject.isEmpty{
            
            //            self.email.checkValidity(.Email)
            self.topNavView.firstRightButton.isEnabled = false
            self.topNavView.firstRightButton.setTitleColor(AppColors.themeGray40, for: .normal)
        }else{
            self.topNavView.firstRightButton.isEnabled = true
            self.topNavView.firstRightButton.setTitleColor(AppColors.themeGreen, for: .normal)
        }
        
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
        self.view.endEditing(true)
        //let mail = self.mailComposerHeaderView.toEmailTextView.text
        let mailsArray = self.mailComposerHeaderView.tagsField.tags.map { (tag) -> String in
            return tag.text
        }
        //let mailsArray = mail?.components(separatedBy: ",") ?? []
        self.viewModel.pinnedEmails = mailsArray.filter({ $0 != " " })
        if self.viewModel.pinnedEmails.contains("") {
            AppToast.default.showToastMessage(message: LocalizedString.PleaseEnterEmail.localized)
        } else {
            self.viewModel.callSendEmailMail()
        }
        
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
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
}

// MARK: -  Mail Composer Header View Delegate methods

extension MailComposerVC: EmailComposeerHeaderViewDelegate {
    func emailTagAddedOrRemoved() {
       self.updateSendButton()
    }
    
    func textViewText(emailTextViewHeight: CGFloat) {
        mailComposerHeaderView.emailContainerViewHeightConstraint.constant = emailTextViewHeight
        updateHeightOfHeader(mailComposerHeaderView, mailComposerHeaderView.messageSubjectTextView)
    }
    
    
    func updateHeightOfHeader(_ headerView: EmailComposerHeaderView, _ textView: UITextView) {
        let minHeight = textView.font!.lineHeight * 1.0
        let maxHeight = textView.font!.lineHeight * 5.0
        //for email textView (screenW-62)
        //for message textView (screenW-32)
        
        var emailHeight = headerView.emailContainerViewHeightConstraint.constant//headerView.toEmailTextView.text.sizeCount(withFont: textView.font!, bundingSize:         CGSize(width: (UIDevice.screenWidth - 62.0), height: 10000.0)).height
        
        var msgHeight = headerView.messageSubjectTextView.text.sizeCount(withFont: textView.font!, bundingSize:         CGSize(width: (UIDevice.screenWidth - 22.0), height: 10000.0)).height
        
        var labelHeight = headerView.messageSubjectTextView.text.sizeCount(withFont: AppFonts.Italic.withSize(18.0), bundingSize:         CGSize(width: (UIDevice.screenWidth - 32), height: 10000.0)).height
        if labelHeight < 25 {
            labelHeight = 25
        }
        emailHeight = max(minHeight, emailHeight)
        emailHeight = min(maxHeight, emailHeight)
        
        msgHeight = max(minHeight, msgHeight)
        msgHeight = min(maxHeight, msgHeight)
        
        print("headerView.checkOutMessageLabel.frame")
        print(headerView.checkOutMessageLabel.frame)
        //let value = headerView.checkOutMessageLabel.numberOfLines * 23
        self.tableView.tableHeaderView?.frame = CGRect(x: 0.0, y: 0.0, width: UIDevice.screenWidth, height: (607.0 + emailHeight + msgHeight + labelHeight))
        
        UIView.animate(withDuration: 0.3, animations: {
           // headerView.emailContainerViewHeightConstraint.constant = emailHeight
            //headerView.tagsField.maxHeight = emailHeight
            headerView.subjectHeightConstraint.constant = msgHeight
            headerView.checkOutMessageLabelHeightConstraint.constant = labelHeight
            self.view.layoutIfNeeded()
        }, completion: { (isDone) in
            //headerView.tagsField.enableScrolling = emailHeight >= maxHeight
            headerView.messageSubjectTextView.isScrollEnabled = msgHeight >= maxHeight
        })
    }
    func textViewText(emailTextView: UITextView) {
        delay(seconds: 0.2) {[weak self] in
            self?.updateSendButton()
        }
        
        
    }
    
    func textViewText(messageTextView: UITextView) {
        self.viewModel.subject = messageTextView.text ?? ""
        self.updateSendButton()
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
            self.mailComposerHeaderView.tagsField.addTag(_mail)
           // self.mailComposerHeaderView.toEmailTextView.layoutIfNeeded()
            self.updateHeightOfHeader(mailComposerHeaderView,mailComposerHeaderView.messageSubjectTextView)
            self.selectedUserEmail = _mail
        } else {
            AppToast.default.showToastMessage(message: LocalizedString.UnableToGetMail.localized, title:"", onViewController: self, duration: 0.6)
        }
        self.updateSendButton()
        
    }
}

// MARK: - Viewmodel delegates methods

extension MailComposerVC: MailComoserVMDelegate {
    func willSendEmail() {
        startLoading()
    }
    
    func didSendEmailSuccess() {
        stopLoading()
        self.view.isUserInteractionEnabled = false
        self.dismiss(animated: true, completion: nil)
        delay(seconds: 0.5) {
            AppToast.default.showToastMessage(message: LocalizedString.FavoriteHotelsInfoSentMessage.localized)
        }
    }
    
    func didSendemailFail(_ error: ErrorCodes) {
        AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .hotelsSearch)
        stopLoading()
    }
}


