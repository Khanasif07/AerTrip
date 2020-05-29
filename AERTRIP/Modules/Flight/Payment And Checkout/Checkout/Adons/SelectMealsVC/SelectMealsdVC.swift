//
//  SelectMealsdVC.swift
//  Aertrip
//
//  Created by Appinventiv on 18/05/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit


class SelectMealsdVC: UIViewController {
    
    @IBOutlet weak var mealsTableView: UITableView!
    
    let selectMealsVM = SelectMealsVM()
    weak var delegate : SelectMealDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
     func setupFonts() {
          
    }
      
    func setupTexts() {
          
      }
      
    func setupColors() {
          
    }
      
    func initialSetup() {
        self.selectMealsVM.extractUsefullData()
        self.configureTableView()
      }
    
}

extension SelectMealsdVC {
    
        private func configureTableView(){
            self.mealsTableView.register(UINib(nibName: "SelectMealCell", bundle: nil), forCellReuseIdentifier: "SelectMealCell")
            self.mealsTableView.separatorStyle = .none
            self.mealsTableView.estimatedRowHeight = 200
            self.mealsTableView.rowHeight = UITableView.automaticDimension
            self.mealsTableView.dataSource = self
            self.mealsTableView.delegate = self
            self.mealsTableView.reloadData()
            
        }
    
}


extension SelectMealsdVC : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectMealsVM.currentAdonsData.meal.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectMealCell", for: indexPath) as? SelectMealCell else { fatalError("SelectMealCell not found") }
             
              // cell.populateData(type: AdonsVM.AdonsType(rawValue: indexPath.row) ?? AdonsVM.AdonsType.meals)
               
//            cell.populateData(index: indexPath.row)
        
        cell.populateData(data: self.selectMealsVM.currentAdonsData.meal[indexPath.row], index: indexPath.row)
        
               return cell
        }
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        self.delegate?.mealUpdated(vcIndex: self.selectMealsVM.vcIndex)
    
    }
    
}

