//
//  AddOnsVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 22/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class AddOnsVC : BaseVC {

    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var adonsTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetups()
    }
    
    

    override func setupColors() {
       
    }

    override func setupTexts() {
        
    }

}

//MARK:- Methods
extension AddOnsVC {

    private func initialSetups() {
        configureTableView()
    }
    
    func configureNavigation(){
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.Settings.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false,isDivider : true)
    }
    
    private func configureTableView(){
        self.adonsTableView.register(UINib(nibName: "AdonsCell", bundle: nil), forCellReuseIdentifier: "AdonsCell")
        self.adonsTableView.dataSource = self
        self.adonsTableView.delegate = self
    }
}

extension AddOnsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}

extension AddOnsVC : UITableViewDelegate, UITableViewDataSource {
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdonsCell", for: indexPath) as? AdonsCell else { fatalError("AdonsCell not found") }
      
        return cell
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
    }
    
}
