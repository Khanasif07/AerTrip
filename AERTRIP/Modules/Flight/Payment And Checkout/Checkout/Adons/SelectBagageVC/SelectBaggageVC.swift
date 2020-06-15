//
//  SelectBagageVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit


class SelectBaggageVC: UIViewController {
    
    @IBOutlet weak var bagageTableView: UITableView!
    
    var selectBaggageVM : SelectBaggageVM!
    weak var delegate : SelectBaggageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
     func setupFonts() {
          
    }
      
    func setupTexts() {
          
      }
      
    func setupColors() {
          
    }
      
    func initialSetup() {
          configureTableView()
         
      }
    
    func initializeVm(selectBaggageVM : SelectBaggageVM){
           self.selectBaggageVM = selectBaggageVM
       }
    
    func reloadData(index : Int = 0){
        self.bagageTableView.reloadData()
//          self.bagageTableView.reloadRow(at: IndexPath(row: index, section: 0), with: UITableView.RowAnimation.none)
    }
    
}

extension SelectBaggageVC {
    
        private func configureTableView(){
            self.bagageTableView.register(UINib(nibName: "SelectBagageCell", bundle: nil), forCellReuseIdentifier: "SelectBagageCell")
            self.bagageTableView.register(UINib(nibName: "BagageSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "BagageSectionHeaderView")
            self.bagageTableView.separatorStyle = .none
            self.bagageTableView.estimatedRowHeight = 200
            self.bagageTableView.rowHeight = UITableView.automaticDimension
            self.bagageTableView.dataSource = self
            self.bagageTableView.delegate = self
        }
    
}


extension SelectBaggageVC : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.selectBaggageVM.sagrigatedData.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectBaggageVM.sagrigatedData[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 28
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                    
          guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BagageSectionHeaderView") as? BagageSectionHeaderView else {
              fatalError("BagageSectionHeaderView not found")
          }
        headerView.headingLabel.font = AppFonts.Regular.withSize(14)
        headerView.headingLabel.text = section == 0 ? LocalizedString.DomesticCheckIn.localized : LocalizedString.InternationalCheckIn.localized
        headerView.contentView.backgroundColor = AppColors.greyO4
        headerView.headingLabel.textColor = AppColors.themeGray60
        return headerView
      }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectBagageCell", for: indexPath) as? SelectBagageCell else { fatalError("SelectBagageCell not found") }
        
        let cellData = self.selectBaggageVM.sagrigatedData[indexPath.section]
        
        cell.populateData(data: cellData?[indexPath.row] ?? AddonsDataCustom(), index: indexPath.row)
            return cell
        }
                
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let cellData = self.selectBaggageVM.sagrigatedData[indexPath.section]
        self.delegate?.addPassengerToBaggage(forAdon: cellData?[indexPath.row] ?? AddonsDataCustom(), vcIndex: self.selectBaggageVM.getVcIndex(), currentFlightKey: self.selectBaggageVM.getCurrentFlightKey(), baggageIndex: indexPath.row, selectedContacts: self.selectBaggageVM.getBaggage()[indexPath.row].bagageSelectedFor)
    }
}
