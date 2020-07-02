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
    
    var selectMealsVM : SelectMealsVM!
    weak var delegate : SelectMealDelegate?
    
    lazy var noResultsemptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noMealsData
        return newEmptyView
    }()
    
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
        self.configureTableView()
        self.checkForNoData()
    }
    
    func initializeVm(selectMealsVM : SelectMealsVM){
        self.selectMealsVM = selectMealsVM
        
    }
    
    private func checkForNoData() {
        guard let _ = self.mealsTableView else { return }
        if selectMealsVM.getMeals().isEmpty {
            mealsTableView.backgroundView = noResultsemptyView
        } else {
            mealsTableView.backgroundView = nil
        }
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
    
    func reloadData(index : Int){
        self.mealsTableView.reloadRow(at: IndexPath(row: index, section: 0), with: UITableView.RowAnimation.none)
    }
    
    func reloadData(){
        guard let _ = self.mealsTableView else { return }
        self.mealsTableView.reloadData()
    }
    
}

extension SelectMealsdVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectMealsVM.getMeals().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectMealCell", for: indexPath) as? SelectMealCell else { fatalError("SelectMealCell not found") }
        cell.populateData(data: self.selectMealsVM.getMeals()[indexPath.row], index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectMealsVM.freeMeal && self.selectMealsVM.addonsDetails.addonsArray.count < 2 { return }
        self.delegate?.addPassengerToMeal(forAdon : self.selectMealsVM.getMeals()[indexPath.row] , vcIndex: self.selectMealsVM.getVcIndex(), currentFlightKey: self.selectMealsVM.getCurrentFlightKey(), mealIndex: indexPath.row, selectedContacts: self.selectMealsVM.getMeals()[indexPath.row].mealsSelectedFor)
    }
}

