//
//  SearchVC.swift
//  AERTRIP
//
//  Created by apple on 26/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SearchVCDelegate:class {
    func frequentFlyerSelected(_ flyer:FlyerModel)
}

class SearchVC: BaseVC {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTextField: SearchTextField!
    @IBOutlet weak var headerTitleLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
   
    // MARK: - Variable
    let cellIdentifier = "SearchTableViewCell"
    var searchData : [FlyerModel] = []
    var defaultAirlines : [FlyerModel] = []
    let viewModel = SearchVM()
    weak var delgate:SearchVCDelegate?
    
    
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTextField.textFieldButtonTap = { [weak self] (status) in
            if status {
                print("Cross button tapped")
                self?.searchTextField.text = nil
                self?.searchData.removeAll()
                    self?.searchData = (self?.defaultAirlines)!
                self?.tableView.reloadData()
                
            }
        }
        self.searchTextField.rightButton.setImage(nil, for: .normal)
        self.searchTextField.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        self.searchTextField.layer.borderColor = UIColor.clear.cgColor
        self.searchTextField.layer.cornerRadius = 10.0
        self.searchTextField.delegate = self
        
        doInitialSetUp()
        registerXib()
    }
    
    //
    
    override func bindViewModel() {
      viewModel.delegate = self
    }
    

    // MARK: - Helper Methods
    func doInitialSetUp(){
      
        cancelButton.setTitle(LocalizedString.Cancel.localized, for: .normal)
        self.headerTitleLabel.text = LocalizedString.FrequentFlyer.localized
        self.searchData = self.defaultAirlines
        self.tableView.reloadData()
    }
    
    func registerXib() {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
    }
    
    private func searchForText(_ searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(performSearchForText(_:)), with: searchText, afterDelay: 0.5)
    }
    
    @objc private func performSearchForText(_ searchText: String) {
        if let text: String = searchText as? String {
            searchData.removeAll()
           viewModel.webserviceForGetTravelDetail(searchText)
        }
    }
    
    // MARK: - IB Actions
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}


// MARK: - UITableViewDataSource methods

extension SearchVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchTableViewCell else {
            fatalError("SearchTableViewCell not found")
        }
        if searchData.count > 0 {
                cell.configureCell(searchData[indexPath.row].logoUrl, searchData[indexPath.row].label, searchData[indexPath.row].iata)
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       self.delgate?.frequentFlyerSelected(searchData[indexPath.row])
         dismiss(animated: true, completion: nil)
    }
    
    
    
}


extension SearchVC  {
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchTextField.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        
        let newTextToSearch = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        NSLog("Search for this text after delay \(newTextToSearch)")
        searchForText(newTextToSearch)
        return true
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}


extension SearchVC:SearchVMDelegate {
    func willGetDetail() {
        //
    }
    
    func getSuccess(_ data: [FlyerModel]) {
        self.searchData  = data
        self.tableView.reloadData()
    }
    
    func getFail(errors: ErrorCodes) {
       //
    }
    
    
}

