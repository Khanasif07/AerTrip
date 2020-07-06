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
    @IBOutlet weak var showPassportView: UIView!
    @IBOutlet weak var travellersTableView: ATTableView!
    @IBOutlet weak var passengerTable: UITableView!
    
    weak var delegate : HCSelectGuestsVCDelegate?
    var viewModel = PassengerDetailsVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.setupTextView()
        self.doInitialSetup()
        GuestDetailsVM.shared.delegate = self
        titleLabel.text = "Passenger Details"
        titleLabel.font = AppFonts.SemiBold.withSize(18)
        self.doneButton.titleLabel?.font = AppFonts.SemiBold.withSize(18)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        IQKeyboardManager.shared().isEnabled = true
    }

    
    
    private func registerCells(){
        
        self.passengerTable.register(UINib(nibName: "AddPassengerDetailsCell", bundle: nil), forCellReuseIdentifier: "AddPassengerDetailsCell")
        self.passengerTable.register(UINib(nibName: "MealPreferenceCell", bundle: nil), forCellReuseIdentifier: "MealPreferenceCell")
        self.passengerTable.register(UINib(nibName: "FlightEmptyCell", bundle: nil), forCellReuseIdentifier: "FlightEmptyCell")
        self.travellersTableView.registerCell(nibName: TravellerListTableViewCell.reusableIdentifier)
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
        }
        addFooterViewToTravellerTableView()
    }
    
    private func addFooterViewToTravellerTableView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 400))
        customView.backgroundColor = AppColors.themeWhite
        
        travellersTableView.tableFooterView = customView
    }
    
    private func setupTextView(){
        let passportTextView = UITextView()
        let txt = "Enter names and info as they appear on your Passport/Government issued ID. See Example"
        let attributedText = NSMutableAttributedString(string: "")
        let attributedString = NSAttributedString(string: txt, attributes: [NSAttributedString.Key.font : AppFonts.Regular.withSize(14), .foregroundColor: AppColors.themeGray40])
        attributedText.append(attributedString)
        attributedText.addAttributes([.link: "hgf", .foregroundColor: AppColors.themeGreen], range: NSString(string: txt).range(of: "See Example"))
        passportTextView.attributedText = attributedText
        passportTextView.linkTextAttributes = [.font: AppFonts.Regular.withSize(14), .foregroundColor: AppColors.themeGreen]
        passportTextView.isEditable = false
        passportTextView.isScrollEnabled = false
        passportTextView.delegate = self
        passportTextView.sizeToFit()
        passportTextView.frame.size.width = UIScreen.width - 22
        passportTextView.frame.origin = CGPoint(x: 11.0, y: 0)
        passportTextView.sizeToFit()
        self.showPassportView.addSubview(passportTextView)
        
    }
    
    
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
        case .child:
            if !calculateAge(with : GuestDetailsVM.shared.guests[0][index], year: 12){
                GuestDetailsVM.shared.guests[0][index].dob = ""
            }
        case .infant:
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
        GuestDetailsVM.shared.canShowSalutationError = true
        self.delegate?.didAddedContacts()
        self.navigationController?.popViewController(animated: true)
    }
    
    
   @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            self.passengerTable.setBottomInset(to: keyboardHeight + 10)
            self.viewModel.keyboardHeight = keyboardHeight
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        self.passengerTable.setBottomInset(to: 0.0)
        self.passengerTable.isScrollEnabled = true
        GuestDetailsVM.shared.resetData()
        self.travellersTableView.reloadData()
        self.travellersTableView.isHidden = GuestDetailsVM.shared.isDataEmpty
    }
    
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        PassportExampleVC.showMe()
//        let vc  = PassportExampleVC.instantiate(fromAppStoryboard: .PassengersSelection)
//        self.present(vc, animated: true, completion: nil)
        return false
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
            return CGFloat.leastNormalMagnitude
        } else {
            return GuestDetailsVM.shared.numberOfRowsInSection(section: section) > 0 ? 28.0 : CGFloat.leastNormalMagnitude
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView === self.passengerTable {
            return nil
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
                        return getEmptyCell()
                    }else if indexPath.row <=  self.viewModel.passengerList[indexPath.section].mealPreference.count{
                        return getCellForMealPreference(with: indexPath)
                    }else{
                        return getCellForFrequentFlyer(with: indexPath)
                    }
                }else{
                    return getEmptyCell()
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
    
    func getEmptyCell()-> UITableViewCell{
        guard let cell = self.passengerTable.dequeueReusableCell(withIdentifier: "FlightEmptyCell") as? FlightEmptyCell else { return UITableViewCell() }
        return cell
        
    }
    
}

extension PassengerDetailsVC : UpdatePassengerDetailsDelegate{
    
    func tapOptionalDetailsBtn(at indexPath:IndexPath){
        GuestDetailsVM.shared.guests[0][indexPath.section].isMoreOptionTapped = true
        self.passengerTable.beginUpdates()
        self.passengerTable.reloadSections([indexPath.section], with: .automatic)
        self.passengerTable.endUpdates()
        
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
        
        self.travellersTableView.isHidden = GuestDetailsVM.shared.isDataEmpty
        self.travellersTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.viewModel.editinIndexPath = self.passengerTable.indexPath(forItem: textField)
        if let _ = self.passengerTable.cell(forItem: textField) as? AddPassengerDetailsCell {
            //  get item position
            let itemPosition: CGPoint = textField.convert(CGPoint.zero, to: passengerTable)
            var  yValue = 62
            if let index = self.viewModel.editinIndexPath {
                yValue = index.section ==  GuestDetailsVM.shared.guests[0].count - 1 ? 63 : 65
                if self.viewModel.isAllPaxInfoRequired{
                    yValue += 3
                }
            }
            let offsetYValue = itemPosition.y - CGFloat(yValue)

            if self.passengerTable.contentOffset.y != offsetYValue {
            self.passengerTable.setContentOffset(CGPoint(x: self.passengerTable.origin.x, y: offsetYValue), animated: true)
            }
            self.passengerTable.isScrollEnabled = GuestDetailsVM.shared.isDataEmpty
            travellersTableView.reloadData()
            printDebug("item position is \(itemPosition)")
        } else {
            travellersTableView.isHidden = true
        }
        
    }
    
    func textFieldEndEditing(_ textField: UITextField) {
        
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
