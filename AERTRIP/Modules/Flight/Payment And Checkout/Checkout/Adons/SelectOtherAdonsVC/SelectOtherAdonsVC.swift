//
//  SelectOtherAdonsVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 27/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit


class SelectOtherAdonsVC: UIViewController {
    
    @IBOutlet weak var otherAdonsTableView: UITableView!
    
    let otherAdonsVm = SelectOtherAdonsVM()
    
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
    
}

extension SelectOtherAdonsVC {
    
 
        private func configureTableView(){
            self.otherAdonsTableView.register(UINib(nibName: "SelectBagageCell", bundle: nil), forCellReuseIdentifier: "SelectBagageCell")
            self.otherAdonsTableView.register(UINib(nibName: "BagageSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "BagageSectionHeaderView")

            self.otherAdonsTableView.separatorStyle = .none
            self.otherAdonsTableView.estimatedRowHeight = 200

            self.otherAdonsTableView.rowHeight = UITableView.automaticDimension
            self.otherAdonsTableView.dataSource = self
            self.otherAdonsTableView.delegate = self
        }
    
}


extension SelectOtherAdonsVC : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.otherAdonsVm.otherAdonsDataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectBagageCell", for: indexPath) as? SelectBagageCell else { fatalError("SelectBagageCell not found") }
        
        cell.populateOtherAdonsData(data: self.otherAdonsVm.otherAdonsDataSource[indexPath.row])
        
        return cell
        
    }
                
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
