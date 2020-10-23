//
//  PassangerDetailsVC.swift
//  Aertrip
//
//  Created by Apple  on 06.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit
import IQKeyboardManager

class PassengerDetailsVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var travellersTableView: ATTableView!
    @IBOutlet weak var passengerTable: ATTableView!
    @IBOutlet weak var travellerTableViewTop: NSLayoutConstraint!
    
    weak var delegate : HCSelectGuestsVCDelegate?
    var viewModel = PassengerDetailsVM()
    var isNeedToshowBottom = false
    var offsetPoint = CGPoint(x: 0, y: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passengerTable.contentInset = UIEdgeInsets(top: topNavigationView.height, left: 0, bottom: 0, right: 0)

        self.registerCells()
        //        self.setupTextView()
        self.doInitialSetup()
        GuestDetailsVM.shared.delegate = self
        titleLabel.text = "Passenger Details"
        titleLabel.font = AppFonts.SemiBold.withSize(18)
        self.doneButton.titleLabel?.font = AppFonts.SemiBold.withSize(18)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared().shouldResignOnTouchOutside = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
    }
    
    private func registerCells(){
        
        self.passengerTable.register(UINib(nibName: "AddPassengerDetailsCell", bundle: nil), forCellReuseIdentifier: "AddPassengerDetailsCell")
        self.passengerTable.register(UINib(nibName: "MealPreferenceCell", bundle: nil), forCellReuseIdentifier: "MealPreferenceCell")
        self.passengerTable.register(UINib(nibName: "FlightEmptyCell", bundle: nil), forCellReuseIdentifier: "FlightEmptyCell")
        self.travellersTableView.registerCell(nibName: TravellerListTableViewCell.reusableIdentifier)
        self.passengerTable.register(UINib(nibName: "SeeExampleHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SeeExampleHeaderView")
        self.travellersTableView.register(UINib(nibName: AppConstants.ktableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: AppConstants.ktableViewHeaderViewIdentifier)
    }
    
    private func doInitialSetup() {
        self.travellersTableView.separatorStyle = .none
        self.travellersTableView.dataSource = self
        self.travellersTableView.delegate = self
        self.travellersTableView.isHidden = true
        GuestDetailsVM.shared.resetData()
        self.travellersTableView.keyboardDismissMode = .none
        self.passengerTable.separatorStyle = .none
        self.passengerTable.delegate = self
        self.passengerTable.dataSource = self
        self.passengerTable.backgroundColor = AppColors.themeGray04
        DispatchQueue.main.async {
            self.passengerTable.scrollToRow(at: self.viewModel.indexPath, at: .middle, animated: true)
            self.passengerTable.reloadData()
        }
        //        addFooterViewToTravellerTableView()
    }
    
    private func addFooterViewToTravellerTableView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 400))
        customView.backgroundColor = AppColors.themeWhite
        
        travellersTableView.tableFooterView = customView
    }
    
    //    private func setupTextView(){
    //        let passportTextView = UITextView()
    //        let txt = "Enter names and info as they appear on your Passport/Government issued ID. See Example"
    //        let attributedText = NSMutableAttributedString(string: "")
    //        let attributedString = NSAttributedString(string: txt, attributes: [NSAttributedString.Key.font : AppFonts.Regular.withSize(14), .foregroundColor: AppColors.themeGray40])
    //        attributedText.append(attributedString)
    //        attributedText.addAttributes([.link: "hgf", .foregroundColor: AppColors.themeGreen], range: NSString(string: txt).range(of: "See Example"))
    //        passportTextView.attributedText = attributedText
    //        passportTextView.linkTextAttributes = [.font: AppFonts.Regular.withSize(14), .foregroundColor: AppColors.themeGreen]
    //        passportTextView.isEditable = false
    //        passportTextView.isScrollEnabled = false
    //        passportTextView.delegate = self
    //        passportTextView.sizeToFit()
    //        passportTextView.frame.size.width = UIScreen.width - 22
    //        passportTextView.frame.origin = CGPoint(x: 11.0, y: 0)
    //        passportTextView.sizeToFit()
    //        self.showPassportView.addSubview(passportTextView)
    //
    //    }
    
    
    private func editedGuest(_ travellerIndexPath: IndexPath) {
        if let indexPath = self.viewModel.editinIndexPath, let object = GuestDetailsVM.shared.contactForIndexPath(indexPath: travellerIndexPath) {
            self.viewModel.updatePassengerInfoWith(object, at: indexPath.section)
            self.setFFForSelected(object.ffp, index: indexPath.section)
            self.updateDob(at : indexPath.section)
            self.passengerTable.reloadData()
        }
    }
    
    private func setFFForSelected(_ passengerFF: [FFP]?, index:Int){
        guard let ffp = passengerFF, ffp.count != 0 else {return}
        for i in 0..<GuestDetailsVM.shared.guests[0][index].frequentFlyer.count{
            if let ff = ffp.first(where:{$0.airlineCode == GuestDetailsVM.shared.guests[0][index].frequentFlyer[i].airlineCode}){
                GuestDetailsVM.shared.guests[0][index].frequentFlyer[i].number = ff.ffNumber
            }
        }
    }
    
    //update dob if it not valid.
    private func updateDob(at index:Int){
        switch GuestDetailsVM.shared.guests[0][index].passengerType{
        case .Adult:break
        case .Child:
            if !calculateAge(with : GuestDetailsVM.shared.guests[0][index], year: 12){
                GuestDetailsVM.shared.guests[0][index].dob = ""
            }
        case .Infant:
            if !calculateAge(with : GuestDetailsVM.shared.guests[0][index], year: 2){
                GuestDetailsVM.shared.guests[0][index].dob = ""
            }
        }
    }
    
    private func calculateAge(with contact: ATContact, year:Int)-> Bool{
        let dob = contact.displayDob
        guard let date = dob.toDate(dateFormat: "dd MMM yyyy") else {return false}
        let component = Calendar.current.dateComponents([.year], from: date, to: Date())
        return (component.year ?? 0) < year
    }
    
    @IBAction func tapBackBtn(_ sender: UIButton) {
        GuestDetailsVM.shared.canShowSalutationError = true
        self.delegate?.didAddedContacts()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapDoneBtn(_ sender: UIButton) {
        let validation = self.viewModel.validationForPassenger()
        if validation.success{
            GuestDetailsVM.shared.canShowSalutationError = true
            self.delegate?.didAddedContacts()
            self.navigationController?.popViewController(animated: true)
        }else{
            GuestDetailsVM.shared.canShowSalutationError = true
            self.passengerTable.reloadData()
            AppToast.default.showToastMessage(message: validation.msg)
        }
        
    }
    
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            if self.isNeedToshowBottom{
                //                self.passengerTable.setBottomInset(to: keyboardHeight + 10)
            }
            self.viewModel.keyboardHeight = keyboardHeight
            self.viewModel.isKeyboardVisible = true
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if self.isNeedToshowBottom{
            //            self.passengerTable.setBottomInset(to: 0.0)
        }
        self.passengerTable.isScrollEnabled = true
        GuestDetailsVM.shared.resetData()
        self.travellersTableView.reloadData()
        self.travellersTableView.isHidden = GuestDetailsVM.shared.isDataEmpty
        self.viewModel.isKeyboardVisible = false
    }
    
    
    //    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    //        PassportExampleVC.showMe()
    ////        let vc  = PassportExampleVC.instantiate(fromAppStoryboard: .PassengersSelection)
    ////        self.present(vc, animated: true, completion: nil)
    //        return false
    //    }
    
    func presentPassportView(){
        let vc  = PassportExampleVC.instantiate(fromAppStoryboard: .PassengersSelection)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    
}

extension PassengerDetailsVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.passengerTable{
            return self.viewModel.passengerList.count
        }else{
            return 4
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.passengerTable{
            if self.viewModel.passengerList[section].isMoreOptionTapped{
                return (self.viewModel.passengerList[section].frequentFlyer.count + self.viewModel.passengerList[section].mealPreference.count) + 2
            }else{
                return 2
            }
        }else{
            return GuestDetailsVM.shared.numberOfRowsInSection(section: section)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.passengerTable{
            if self.viewModel.passengerList[indexPath.section].isMoreOptionTapped{
                if indexPath.row == ((self.viewModel.passengerList[indexPath.section].frequentFlyer.count + self.viewModel.passengerList[indexPath.section].mealPreference.count) + 1){
                    return 35
                }else{
                    return UITableView.automaticDimension
                }
            }else{
                return (indexPath.row == 1) ? 35 : UITableView.automaticDimension
            }
        }else{
            return 43.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView === self.passengerTable {
            //            if section == 0{
            return (section == 0) ? 62.0 : CGFloat.leastNonzeroMagnitude
            //            }else{
            //                return CGFloat.leastNonzeroMagnitude
            //            }
        } else {
            return GuestDetailsVM.shared.numberOfRowsInSection(section: section) > 0 ? 28.0 : CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView === self.passengerTable {
            if section == 0{
                let header = self.passengerTable.dequeueReusableHeaderFooterView(withIdentifier: "SeeExampleHeaderView") as? SeeExampleHeaderView
                header?.hanler = {[weak self] in
                    self?.presentPassportView()
                }
                return header
            }else{
                return nil
            }
        } else {
            guard let headerView = travellersTableView.dequeueReusableHeaderFooterView(withIdentifier: AppConstants.ktableViewHeaderViewIdentifier) as? ViewProfileDetailTableViewSectionView else {
                fatalError("ViewProfileDetailTableViewSectionView not found")
            }
            headerView.headerLabel.text = GuestDetailsVM.shared.titleForSection(section: section).uppercased()
            headerView.backgroundColor = AppColors.themeGray04
            headerView.containerView.backgroundColor = AppColors.themeGray04
            headerView.topDividerHeightConstraint.constant = 0.5
            headerView.bottomSeparatorView.isHidden = false
            headerView.clipsToBounds = true
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.passengerTable{
            if indexPath.row == 0{
                return getCellDetailsCell(with: indexPath)
            }else {
                if self.viewModel.passengerList[indexPath.section].isMoreOptionTapped{
                    if indexPath.row == ((self.viewModel.passengerList[indexPath.section].frequentFlyer.count + self.viewModel.passengerList[indexPath.section].mealPreference.count) + 1){
                        return getEmptyCell(with: indexPath)
                    }else if indexPath.row <=  self.viewModel.passengerList[indexPath.section].mealPreference.count{
                        return getCellForMealPreference(with: indexPath)
                    }else{
                        return getCellForFrequentFlyer(with: indexPath)
                    }
                }else{
                    return getEmptyCell(with: indexPath)
                }
            }
            
        }else{
            guard let cell = travellersTableView.dequeueReusableCell(withIdentifier: TravellerListTableViewCell.reusableIdentifier, for: indexPath) as? TravellerListTableViewCell else {
                printDebug("cell not found")
                return UITableViewCell()
            }
            cell.separatorView.isHidden = indexPath.row == 0
            cell.searchedText = self.viewModel.searchText
            cell.travellerModelData = GuestDetailsVM.shared.objectForIndexPath(indexPath: indexPath)
            return cell
            
        }
    }
    
    
    func getCellDetailsCell(with indexPath: IndexPath)-> UITableViewCell{
        guard let cell = self.passengerTable.dequeueReusableCell(withIdentifier: "AddPassengerDetailsCell") as? AddPassengerDetailsCell else { return UITableViewCell() }
        cell.cellIndexPath = indexPath
        cell.journeyType = self.viewModel.journeyType
        cell.canShowSalutationError = GuestDetailsVM.shared.canShowSalutationError
        cell.delegate = self
        cell.txtFldEditDelegate = self
        cell.allPaxInfoRequired = self.viewModel.isAllPaxInfoRequired
        cell.guestDetail = self.viewModel.passengerList[indexPath.section]
        cell.lastJourneyDate = self.viewModel.lastJourneyDate
        cell.journeyEndDate = self.viewModel.journeyEndDate
        return cell
    }
    
    func getCellForMealPreference(with indexPath: IndexPath)-> UITableViewCell{
        
        guard let cell = self.passengerTable.dequeueReusableCell(withIdentifier: "MealPreferenceCell") as? MealPreferenceCell else { return UITableViewCell()}
        cell.configureForMealPreference(with: self.viewModel.passengerList[indexPath.section], at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === self.travellersTableView {
            self.passengerTable.isScrollEnabled = true
            self.travellersTableView.isHidden = true
            let object = GuestDetailsVM.shared.contactForIndexPath(indexPath: indexPath)
            if let cellindexPath = self.viewModel.editinIndexPath, let obj = object {
                if let cell = self.passengerTable.cellForRow(at: cellindexPath) as? AddPassengerDetailsCell {
                    cell.firstNameTextField.text = obj.firstName
                    cell.lastNameTextField.text = obj.lastName
                }
            }
            self.editedGuest(indexPath)
            GuestDetailsVM.shared.resetData()
            GuestDetailsVM.shared.search(forText: "")
        }
    }
    
    
    func getCellForFrequentFlyer(with indexPath: IndexPath)-> UITableViewCell{
        
        guard let cell = self.passengerTable.dequeueReusableCell(withIdentifier: "MealPreferenceCell") as? MealPreferenceCell else { return UITableViewCell() }
        cell.configureForFlyer(with: self.viewModel.passengerList[indexPath.section], at: indexPath)
        return cell
    }
    
    func getEmptyCell(with indexPath: IndexPath)-> UITableViewCell{
        guard let cell = self.passengerTable.dequeueReusableCell(withIdentifier: "FlightEmptyCell") as? FlightEmptyCell else { return UITableViewCell() }
        cell.bottomDividerView.isHidden = ((self.viewModel.passengerList.count-1) == indexPath.section)
        cell.backgroundColor = AppColors.themeGray04
        return cell
        
    }
    
}

extension PassengerDetailsVC : UpdatePassengerDetailsDelegate{
    
    func countryCodeBtnTapped(_ sender: UIButton) {
        let pickerHeight = UIPickerView.pickerSize.height
        let itemPosition: CGPoint = sender.convert(CGPoint.zero, to: passengerTable)
        
        let itemPosInView = sender.convert(CGPoint.zero, to: view)
        
        if pickerHeight > passengerTable.size.height - itemPosInView.y {
            let pointToScroll = CGPoint(x: 0, y: itemPosition.y - ((passengerTable.size.height - 80) - pickerHeight))

            DispatchQueue.delay(0.3) { [weak self] in
                self?.passengerTable.setContentOffset(pointToScroll, animated: true)
            }
            
            DispatchQueue.delay(0.6) { [weak self] in
                if self?.passengerTable.contentOffset != pointToScroll {
                    self?.passengerTable.setContentOffset(pointToScroll, animated: true)
                }
            }
            
        }
    }
    
    func shouldSetupBottom(isNeedToSetUp: Bool) {
        self.isNeedToshowBottom = isNeedToSetUp
    }
    
    
    func tapOptionalDetailsBtn(at indexPath:IndexPath){
        GuestDetailsVM.shared.guests[0][indexPath.section].isMoreOptionTapped = true
        self.passengerTable.beginUpdates()
        self.passengerTable.reloadSections([indexPath.section], with: .automatic)
        self.passengerTable.endUpdates()
        if (GuestDetailsVM.shared.guests[0].filter{$0.isMoreOptionTapped}).count < 2{
            self.passengerTable.reloadData()
        }
        
    }
    
}
extension PassengerDetailsVC: GuestDetailTableViewCellDelegate {
    
    func textFieldWhileEditing(_ textField: UITextField) {
        self.viewModel.editinIndexPath = self.passengerTable.indexPath(forItem: textField)
        self.viewModel.searchText = textField.text ?? ""
        GuestDetailsVM.shared.search(forText: self.viewModel.searchText)
        if self.viewModel.searchText.isEmpty {
            GuestDetailsVM.shared.resetData()
        }
        self.travellersTableView.isHidden = GuestDetailsVM.shared.isDataEmpty
        self.travellersTableView.reloadData()
        if let cell = self.passengerTable.cell(forItem: textField) as? AddPassengerDetailsCell {
            switch textField {
            case cell.firstNameTextField:
                if let indexPath = self.viewModel.editinIndexPath {
                    if textField.text?.count ?? 0 < AppConstants.kFirstLastNameTextLimit {
                        GuestDetailsVM.shared.guests[0][indexPath.section].firstName = textField.text?.removeSpaceAsSentence ?? ""
                    } else {
                        AppToast.default.showToastMessage(message: "First Name should be less than 30 characters", spaceFromBottom : self.viewModel.keyboardHeight)
                        return
                    }
                }
                
            case cell.lastNameTextField:
                if let indexPath = self.viewModel.editinIndexPath {
                    if textField.text?.count ?? 0 < AppConstants.kFirstLastNameTextLimit {
                        GuestDetailsVM.shared.guests[0][indexPath.section].lastName = textField.text?.removeSpaceAsSentence ?? ""
                    } else {
                        AppToast.default.showToastMessage(message: "Last Name should be less than 30 characters", spaceFromBottom: self.viewModel.keyboardHeight)
                        return
                    }
                    
                }
                
            default:
                break
            }
        }
    }
    func textField(_ textField: UITextField){
                
        guard let cell = passengerTable.cell(forItem: textField) as? AddPassengerDetailsCell, textField == cell.firstNameTextField || textField == cell.lastNameTextField else {
            self.travellersTableView.isHidden = true
            return
        }
        
        self.travellersTableView.isHidden = GuestDetailsVM.shared.isDataEmpty
        self.travellersTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.offsetPoint = self.passengerTable.contentOffset
        self.viewModel.editinIndexPath = self.passengerTable.indexPath(forItem: textField)
        
        //  get item position
        let itemPosition: CGPoint = textField.convert(CGPoint.zero, to: passengerTable)
        
        if let indexPath = self.passengerTable.indexPath(for: cell){
            if indexPath.section == 0{
                self.travellerTableViewTop.constant = 198.5
            }else{
                self.travellerTableViewTop.constant = 228
            }
        }
        
        let pointToScroll = CGPoint(x: 0, y: itemPosition.y - (125 + self.passengerTable.contentInset.top))
        if passengerTable.contentOffset.y < pointToScroll.y {
            
            DispatchQueue.delay(0.3) { [weak self] in
                self?.passengerTable.setContentOffset(pointToScroll, animated: true)
            }
            DispatchQueue.delay(0.6) { [weak self] in
                if self?.passengerTable.contentOffset != pointToScroll {
                    self?.passengerTable.setContentOffset(pointToScroll, animated: true)
                }
            }
        }
        
        travellersTableView.reloadData()
        printDebug("item position is \(itemPosition)")
        
    }
    
    func textFieldEndEditing(_ textField: UITextField) {
        if self.viewModel.isKeyboardVisible {
            return
        }

        let contentPoint = passengerTable.contentSize.height - passengerTable.frame.size.height
        if passengerTable.contentOffset.y >= contentPoint {
            passengerTable.setContentOffset(CGPoint(x: 0, y: contentPoint < 0 ? 0 : contentPoint), animated: true)
        }
    }
}

extension PassengerDetailsVC: GuestDetailsVMDelegate {
    func searchDidComplete() {
        self.travellersTableView.isHidden = GuestDetailsVM.shared.isDataEmpty
        self.travellersTableView.reloadData()
    }
    
    func getFail(errors: ErrorCodes) {
        printDebug(errors)
    }
    
    
    func getSalutationResponse(salutations: [String]) {
        //
    }
}
