//
//  PassangerDetailsVC.swift
//  Aertrip
//
//  Created by Apple  on 06.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class PassengerDetailsVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var showPassportView: UIView!
//    @IBOutlet weak var passportTextView: UITextView!
    @IBOutlet weak var passengerTable: UITableView!
    
    var viewModel = PassengerDetailsVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.setupTextView()
        self.passengerTable.separatorStyle = .none
        self.passengerTable.delegate = self
        self.passengerTable.dataSource = self
        DispatchQueue.main.async {
            self.passengerTable.scrollToRow(at: self.viewModel.indexPath, at: .middle, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    private func registerCells(){
        
        self.passengerTable.register(UINib(nibName: "AddPassengerDetailsCell", bundle: nil), forCellReuseIdentifier: "AddPassengerDetailsCell")
        self.passengerTable.register(UINib(nibName: "MealPreferenceCell", bundle: nil), forCellReuseIdentifier: "MealPreferenceCell")
        self.passengerTable.register(UINib(nibName: "FlightEmptyCell", bundle: nil), forCellReuseIdentifier: "FlightEmptyCell")
    }
    
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        setupTextView()
//    }
    
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
        passportTextView.frame.size.width = UIScreen.width - 32
        passportTextView.frame.origin = CGPoint(x: 16.0, y: 0)
        passportTextView.sizeToFit()
        self.showPassportView.addSubview(passportTextView)
        
    }
    
    
    @IBAction func tapBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapDoneBtn(_ sender: UIButton) {
    }
    
    
   @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            print("Notification: Keyboard will show")
            self.passengerTable.setBottomInset(to: keyboardHeight + 10)
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        print("Notification: Keyboard will hide")
        self.passengerTable.setBottomInset(to: 0.0)
    }
    
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let vc  = PassportExampleVC.instantiate(fromAppStoryboard: .PassengersSelection)
        self.present(vc, animated: true, completion: nil)
        return false
    }
    
    
}

extension PassengerDetailsVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.passengerList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.viewModel.passengerList[section].isMoreOptionTapped{
            return (self.viewModel.passengerList[section].frequentFlyer.count + self.viewModel.passengerList[section].mealPreference.count) + 2
        }else{
            return 2
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.viewModel.passengerList[indexPath.section].isMoreOptionTapped{
            if indexPath.row == ((self.viewModel.passengerList[indexPath.section].frequentFlyer.count + self.viewModel.passengerList[indexPath.section].mealPreference.count) + 1){
                return 35
            }else{
                return UITableView.automaticDimension
            }
        }else{
            return (indexPath.row == 1) ? 35 : UITableView.automaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
    
    
    func getCellDetailsCell(with indexPath: IndexPath)-> UITableViewCell{
        
        guard let cell = self.passengerTable.dequeueReusableCell(withIdentifier: "AddPassengerDetailsCell") as? AddPassengerDetailsCell else { return UITableViewCell() }
        cell.passenger = self.viewModel.passengerList[indexPath.section]
        cell.configureCell(with: indexPath, journeyType: self.viewModel.journeyType)
        cell.delegate = self
        return cell
    }
    
    func getCellForMealPreference(with indexPath: IndexPath)-> UITableViewCell{
        
        guard let cell = self.passengerTable.dequeueReusableCell(withIdentifier: "MealPreferenceCell") as? MealPreferenceCell else { return UITableViewCell()}
        cell.configureForMealPreference(with: self.viewModel.passengerList[indexPath.section], at: indexPath)
        return cell
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
        self.viewModel.passengerList[indexPath.section].isMoreOptionTapped = true
        self.passengerTable.beginUpdates()
        self.passengerTable.reloadSections([indexPath.section], with: .automatic)
        self.passengerTable.endUpdates()
        
    }
    
}
