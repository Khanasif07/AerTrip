//
//  SelectOtherAdonsVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 27/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SelectOtherAdonsVC: UIViewController {
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var specialRequestTextView: UITextView!
    @IBOutlet weak var specialRequestLabel: UILabel!
    @IBOutlet weak var specialRequestInfoLabel: UILabel!
    @IBOutlet weak var otherAdonsTableView: UITableView!
    @IBOutlet weak var specialRequestPlaceHolderLabel: UILabel!
    
    var otherAdonsVm : SelectOtherAdonsVM!
    weak var delegate : SelectOtherDelegate?
    
    lazy var noResultsemptyView: EmptyScreenView = {
         let newEmptyView = EmptyScreenView()
         newEmptyView.vType = .noOthersData
         return newEmptyView
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
     func setupFonts() {
        self.specialRequestLabel.font = AppFonts.Regular.withSize(14)
        self.clearButton.titleLabel?.font = AppFonts.Regular.withSize(14)
        self.specialRequestTextView.font = AppFonts.Regular.withSize(18)
        self.specialRequestInfoLabel.font = AppFonts.Regular.withSize(14)
        self.specialRequestPlaceHolderLabel.font = AppFonts.Regular.withSize(18)
    }
      
    func setupTexts() {
        self.specialRequestPlaceHolderLabel.text = LocalizedString.Special_Request_If_Any.localized
    }
      
    func setupColors() {
        self.specialRequestLabel.textColor = AppColors.themeGray40
        self.clearButton.setTitleColor(AppColors.themeGreen, for: UIControl.State.normal)
        self.specialRequestInfoLabel.textColor = AppColors.themeGray40
        self.specialRequestPlaceHolderLabel.textColor = AppColors.themeGray20
    }
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        self.specialRequestTextView.text = ""
        self.clearButton.isHidden = true
        self.otherAdonsVm.specialRequest = ""
        self.delegate?.specialRequestUpdated()
//        self.specialRequestPlaceHolderLabel.isHidden = false
        self.showHideClearButton()
    }
}

extension SelectOtherAdonsVC {
    
    private func initialSetup() {
        self.setupTexts()
        self.setupFonts()
        self.setupColors()
        self.configureTableView()
        self.showHideClearButton()
        self.configureTextView()
        self.showHideClearButton()
    }
    
    private func checkForNoData() {
            guard let _ = self.otherAdonsTableView else { return }
            if otherAdonsVm.getOthers().isEmpty {
                 otherAdonsTableView.backgroundView = noResultsemptyView
             } else {
                 otherAdonsTableView.backgroundView = nil
             }
         }
    
    private func configureTextView() {
        self.specialRequestTextView.delegate = self
        self.specialRequestTextView.text = self.otherAdonsVm.specialRequest
    }
    
        private func configureTableView(){
            self.otherAdonsTableView.register(UINib(nibName: "SelectBagageCell", bundle: nil), forCellReuseIdentifier: "SelectBagageCell")
            self.otherAdonsTableView.register(UINib(nibName: "BagageSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "BagageSectionHeaderView")

            self.otherAdonsTableView.separatorStyle = .none
            self.otherAdonsTableView.estimatedRowHeight = 200

            self.otherAdonsTableView.rowHeight = UITableView.automaticDimension
            self.otherAdonsTableView.dataSource = self
            self.otherAdonsTableView.delegate = self
        }
    
        func initializeVm(otherAdonsVm : SelectOtherAdonsVM){
           self.otherAdonsVm = otherAdonsVm
       }
    
    func reloadData(){
        guard let _ = self.otherAdonsTableView else { return }
        self.otherAdonsTableView.reloadData()
    }
    
    private func showHideClearButton(){
         guard let txt = specialRequestTextView.text else { return  }
         self.clearButton.isHidden = txt.isEmpty
        
        UIView.animate(withDuration: 0.3, animations: {
            
            if txt.isEmpty{
                self.specialRequestPlaceHolderLabel.alpha = 1
                self.specialRequestLabel.alpha = 0
            }else{
                self.specialRequestPlaceHolderLabel.alpha = 0
                self.specialRequestLabel.alpha = 1
            }
            
        }) { (success) in
        
        }
        
     }
    
}

extension SelectOtherAdonsVC : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.otherAdonsVm.getOthers().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectBagageCell", for: indexPath) as? SelectBagageCell else { fatalError("SelectBagageCell not found") }
        
        cell.populateOtherAdonsData(data: self.otherAdonsVm.getOthers()[indexPath.row], index: indexPath.row)
                
        return cell
        
    }
                
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.addPassengerToMeal(forAdon: self.otherAdonsVm.getOthers()[indexPath.row], vcIndex: self.otherAdonsVm.getVcIndex(), currentFlightKey: self.otherAdonsVm.getCurrentFlightKey(), othersIndex: indexPath.row, selectedContacts: self.otherAdonsVm.getOthers()[indexPath.row].othersSelectedFor )
        
    }
    
}

extension SelectOtherAdonsVC : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.showHideClearButton()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let txt = textView.text else { return }
        self.otherAdonsVm.specialRequest = txt
        self.delegate?.specialRequestUpdated()
    }
    
}
