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
    
    var otherAdonsVm : SelectOtherAdonsVM!
    weak var delegate : SelectOtherDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
     func setupFonts() {
        self.specialRequestLabel.font = AppFonts.Regular.withSize(14)
        self.clearButton.titleLabel?.font = AppFonts.Regular.withSize(14)
        self.specialRequestTextView.font = AppFonts.Regular.withSize(18)
        self.specialRequestInfoLabel.font = AppFonts.Regular.withSize(14)
    }
      
    func setupTexts() {
          
    }
      
    func setupColors() {
        self.specialRequestLabel.textColor = AppColors.themeGray40
        self.clearButton.setTitleColor(AppColors.themeGreen, for: UIControl.State.normal)
        self.specialRequestInfoLabel.textColor = AppColors.themeGray40
    }
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        self.specialRequestTextView.text = ""
    }
    
}

extension SelectOtherAdonsVC {
    
    private func initialSetup() {
        self.setupFonts()
        self.setupColors()
        configureTableView()
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
