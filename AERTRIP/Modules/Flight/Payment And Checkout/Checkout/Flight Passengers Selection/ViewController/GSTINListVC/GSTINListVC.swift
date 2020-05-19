//
//  GSTINListVC.swift
//  Aertrip
//
//  Created by Apple  on 14.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class GSTINListVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewCompanyButton: UIButton!
    
    var viewModel = GSTINListVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "GSTINListCell", bundle: Bundle(identifier: "GSTINListCell")), forCellReuseIdentifier: "GSTINListCell")
        self.tableView.separatorStyle = .none
        self.setupView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [.font: AppFonts.SemiBold.withSize(18), .foregroundColor: AppColors.themeBlack]
        self.navigationController?.title = "Billing Company"
        self.title = "Billing Company"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [.font: AppFonts.SemiBold.withSize(18), .foregroundColor: AppColors.themeBlack]
        self.navigationController?.title = "Billing Company"
        self.title = "Billing Company"
    }

    @IBAction func tappedAddNewButton(_ sender: UIButton) {
        let vc = AddEditGSTVC.instantiate(fromAppStoryboard: .PassengersSelection)
        vc.viewModel.isEditingGST = false
        vc.viewModel.updateGst = {[weak self] gst in
            guard let self = self else {return}
            var newGst = gst
            newGst.id = "\((Int(self.viewModel.gSTList.last?.id ?? "0") ?? 0)+1)"
            self.tableView.beginUpdates()
            self.viewModel.gSTList.append(newGst)
            self.tableView.insertRows(at: [IndexPath(row: self.viewModel.gSTList.count - 1, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupView(){
        self.addNewCompanyButton.setTitle("Add New Company", for: .normal)
        self.addNewCompanyButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.addNewCompanyButton.titleLabel?.font = AppFonts.Regular.withSize(18)
        
    }
    
    
}

extension GSTINListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.gSTList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GSTINListCell") as? GSTINListCell else {return UITableViewCell()}
        cell.configureCell(with: self.viewModel.gSTList[indexPath.row])
        cell.editButton.addTarget(self, action: #selector(tapEditBtn), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.returnGSTIN?(self.viewModel.gSTList[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func tapEditBtn(_ sender: UIButton){
        let vc = AddEditGSTVC.instantiate(fromAppStoryboard: .PassengersSelection)
        vc.viewModel.gst = self.viewModel.gSTList[sender.tag]
        vc.viewModel.isEditingGST = true
        vc.viewModel.updateGst = {[weak self] gst in
            self?.viewModel.gSTList[sender.tag] = gst
            self?.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
