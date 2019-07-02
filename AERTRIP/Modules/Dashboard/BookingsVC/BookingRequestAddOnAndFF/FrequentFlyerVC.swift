//
//  FrequentFlyerVC.swift
//  AERTRIP
//
//  Created by apple on 21/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FrequentFlyerVC: BaseVC {
    // MARK: - IBOutlet
    
    @IBOutlet var frequentFlyerTableView: ATTableView!
    
    // MARK: - Variables
    
    let footerViewIdentifier = "BookingInfoEmptyFooterView"
    let headerViewIdentifier = "BookingFrequentFlyerHeaderView"
    let pickerView: UIPickerView = UIPickerView()
    let pickerSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: 261.0)
    // GenericPickerView
    let genericPickerView: UIView = UIView()
    
    override func initialSetup() {
        registerXib()
        frequentFlyerTableView.dataSource = self
        frequentFlyerTableView.delegate = self
        frequentFlyerTableView.reloadData()
        
        setUpGenericPicker()
        setUpToolBarForGenericPickerView()
    }
    
    // MARK: Helper methods
    
    func registerXib() {
        frequentFlyerTableView.register(UINib(nibName: footerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: footerViewIdentifier)
        frequentFlyerTableView.register(UINib(nibName: headerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: headerViewIdentifier)
        frequentFlyerTableView.registerCell(nibName: BookingFFMealTableViewCell.reusableIdentifier)
        frequentFlyerTableView.registerCell(nibName: BookingFFAirlineTableViewCell.reusableIdentifier)
    }
    
    func getCellForSection(_ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0, 1:
            guard let arilineCell = self.frequentFlyerTableView.dequeueReusableCell(withIdentifier: "BookingFFAirlineTableViewCell") as? BookingFFAirlineTableViewCell else {
                fatalError("BookingFFAirlineTableViewCell not found")
            }
//            arilineCell.cofigureCell(airlineImage: self.viewModel.ffAirlineData[indexPath.row].airlineImage, airlineName: self.viewModel.ffAirlineData[indexPath.row].airlineName)
            return arilineCell
        //        case 2:
        ////
        ////            guard let cell = self.frequentFlyerTableView.dequeueReusableCell(withIdentifier: "BookingFFMealTableViewCell") as? BookingFFMealTableViewCell else {
        ////                fatalError("BookingFFMealTableViewCell not found")
        ////            }
        ////            cell.dividerView.isHidden = true
        ////
        ////            return cell
        default:
            return UITableViewCell()
        }
    }
    
    private func setUpToolBarForGenericPickerView() {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0.0, y: -10, width: PKCountryPickerSettings.pickerSize.width, height: PKCountryPickerSettings.toolbarHeight)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelGenericPicker))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneGenericPicker))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.backgroundColor = AppColors.themeRed
        toolbar.barTintColor = #colorLiteral(red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
        cancelButton.tintColor = AppColors.themeGreen
        doneButton.tintColor = AppColors.themeGreen
        
        let array = [cancelButton, spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        
        genericPickerView.addSubview(toolbar)
    }
    
    private func setUpGenericPicker() {
        // Generic Picker View
        genericPickerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - PKCountryPickerSettings.pickerSize.width) / 2.0, y: UIScreen.main.bounds.size.height, width: PKCountryPickerSettings.pickerSize.width, height: (261 + PKCountryPickerSettings.toolbarHeight))
        genericPickerView.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
        
        pickerView.frame = CGRect(x: 0.0, y: 0, width: pickerSize.width, height: pickerSize.height)
        pickerView.selectRow(0, inComponent: 0, animated: true)
        genericPickerView.addSubview(pickerView)
        
//        pickerView.delegate = self
//        pickerView.dataSource = self
        
        pickerView.setValue(#colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1), forKey: "textColor")
    }
    
    @objc func cancelGenericPicker() {
        closePicker(completion: nil)
    }
    
    @objc func doneGenericPicker() {
        closePicker(completion: nil)
    }
    
    func openPicker(withSelection: String) {
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
        }) { isDone in
            self.genericPickerView.removeFromSuperview()
            completion?(isDone)
        }
    }
}

extension FrequentFlyerVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return BookingRequestAddOnsFFVM.shared.bookingDetails?.frequentFlyerData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return BookingRequestAddOnsFFVM.shared.bookingDetails?.bookingDetail?.leg[section].pax.count ?? 0
      
        return BookingRequestAddOnsFFVM.shared.bookingDetails?.frequentFlyerData[section].flights.count ?? 0
        //  return [3,3,3,3][section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let arilineCell = self.frequentFlyerTableView.dequeueReusableCell(withIdentifier: "BookingFFAirlineTableViewCell") as? BookingFFAirlineTableViewCell else {
            fatalError("BookingFFAirlineTableViewCell not found")
        }
       
        arilineCell.flightData = BookingRequestAddOnsFFVM.shared.bookingDetails?.frequentFlyerData[indexPath.section].flights[indexPath.row]
        arilineCell.leftDividerView.isHidden = indexPath.row == (BookingRequestAddOnsFFVM.shared.bookingDetails?.frequentFlyerData[indexPath.section].flights.count ?? 0) - 1
          arilineCell.rightDividerView.isHidden = indexPath.row == (BookingRequestAddOnsFFVM.shared.bookingDetails?.frequentFlyerData[indexPath.section].flights.count ?? 0) - 1
        
        arilineCell.delegate = self
        return arilineCell
      
       // return UITableViewCell()
//        switch indexPath.section {
//        case 0:
//            return getCellForSection(indexPath)
//        case 1:
//            return getCellForSection(indexPath)
//        case 2:
//            return getCellForSection(indexPath)
//        case 3:
//            return getCellForSection(indexPath)
//        default:
//            return UITableViewCell()
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 76.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = frequentFlyerTableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerViewIdentifier) as? BookingFrequentFlyerHeaderView else {
            fatalError(" BookingFrequentFlyerHeaderView not  found")
        }
        
        guard let passenger = BookingRequestAddOnsFFVM.shared.bookingDetails?.frequentFlyerData[section].passenger else {
            printDebug("passenger not found")
            return UIView()
        }
        
        let name = "\(passenger.salutation) \(passenger.paxName)"
        headerView.configureCell(profileImage: passenger.profileImage, salutationImage: passenger.salutationImage, passengerName: name)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = self.frequentFlyerTableView.dequeueReusableHeaderFooterView(withIdentifier: self.footerViewIdentifier) as? BookingInfoEmptyFooterView else {
            fatalError("BookingInfoFooterView not found")
        }
        return footerView
    }
    
    
}

// MARK: - UIPickerViewDelegate and UIPickerViewDataSource methods

//
// extension FrequentFlyerVC: UIPickerViewDataSource, UIPickerViewDelegate {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return self.viewModel.pickerData.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return self.viewModel.pickerData[row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        printDebug("selected data \(self.viewModel.pickerData[row])")
//    }
// }


// MARK: -  BookingAirlineTableViewCell Delgate methods

extension FrequentFlyerVC: BookingFFAirlineTableViewCellDelegate {
    func textFieldText(_ textField: UITextField) {
        guard let indexPath = self.frequentFlyerTableView.indexPath(forItem: textField) else {
            printDebug("indexPath not found")
            return
        }
        BookingRequestAddOnsFFVM.shared.bookingDetails?.frequentFlyerData[indexPath.section].flights[indexPath.row].frequentFlyerNumber = textField.text ?? ""
        
        
        
        
    }
    
    
}
