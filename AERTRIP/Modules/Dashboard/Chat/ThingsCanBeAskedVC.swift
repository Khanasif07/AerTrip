//
//  ThingsCanBeAskedVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 10/04/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import IQKeyboardManager

class ThingsCanBeAskedVC : BaseVC {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var thingsCanBeAskedTableView: UITableView!
    
    
    let thingsCanBeAskedVm = ThingsCanBeAskedVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        self.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.statusBarStyle = .darkContent
    }
    
    override func setupFonts() {
        super.setupFonts()
        self.titleLabel.font = AppFonts.SemiBold.withSize(18)
    }
    
    override func setupTexts() {
        super.setupTexts()
        titleLabel.text = LocalizedString.ThingsYouCanAsk.localized
    }
    
    override func setupColors() {
        super.setupColors()
        
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension ThingsCanBeAskedVC {
    
    
   private func initialSetUp(){
        configureTableView()
    }
    
      private func configureTableView(){
          self.thingsCanBeAskedTableView.register(UINib(nibName: "ThingsCanBeAskedCell", bundle: nil), forCellReuseIdentifier: "ThingsCanBeAskedCell")
        
        self.thingsCanBeAskedTableView.register(UINib(nibName: "ThingsToAskHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ThingsToAskHeader")

        

        
        self.thingsCanBeAskedTableView.rowHeight = 100
        self.thingsCanBeAskedTableView.estimatedRowHeight = UITableView.automaticDimension
          self.thingsCanBeAskedTableView.dataSource = self
          self.thingsCanBeAskedTableView.delegate = self
      }
    
}

extension ThingsCanBeAskedVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.thingsCanBeAskedVm.dataSource[section]?.count ?? 1 : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? UITableView.automaticDimension  : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 39.5 : 69.5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(Double.leastNonzeroMagnitude)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                          
             guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ThingsToAskHeader") as? ThingsToAskHeader else {
                 fatalError("ThingsToAskHeader not found")
             }
            headerView.populateData(section: section)
             return headerView
         }
         
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThingsCanBeAskedCell", for: indexPath) as? ThingsCanBeAskedCell else { fatalError("ThingsCanBeAskedCell not found") }
        cell.populateData(indexpath: indexPath, data: self.thingsCanBeAskedVm.dataSource[indexPath.section] ?? [])
        return cell
    }
    
}
