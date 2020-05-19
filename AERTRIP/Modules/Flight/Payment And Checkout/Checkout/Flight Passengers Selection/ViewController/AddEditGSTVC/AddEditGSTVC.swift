//
//  AddEditGSTVC.swift
//  Aertrip
//
//  Created by Apple  on 14.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class AddEditGSTVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = AddEditGSTVM()
    var doneBtn = UIButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "SingleTextFieldCell", bundle: Bundle(identifier: "SingleTextFieldCell")), forCellReuseIdentifier: "SingleTextFieldCell")
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = AppColors.themeGray04
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [.font: AppFonts.SemiBold.withSize(18), .foregroundColor: AppColors.themeBlack]
        self.navigationController?.title = (!self.viewModel.isEditingGST) ? "New Company" : "Edit Company"
        self.title = (!self.viewModel.isEditingGST) ? "New Company" : "Edit Company"
        self.setupNavigation()
    }
    
    private func setupNavigation(){
        
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.tag = 0
        cancelBtn.addTarget(self, action: #selector(tapCancel), for: .touchUpInside)
        cancelBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 44)
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.titleLabel?.font = AppFonts.Regular.withSize(18)
        cancelBtn.setTitleColor(AppColors.themeGreen, for: .normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelBtn)
        doneBtn.tag = 1
        doneBtn.addTarget(self, action: #selector(tapCancel), for: .touchUpInside)
        doneBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 44)
        doneBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.titleLabel?.font = AppFonts.SemiBold.withSize(18)
        doneBtn.setTitleColor(AppColors.themeGreen, for: .normal)
        doneBtn.setTitleColor(AppColors.themeGray220, for: .disabled)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneBtn)
        self.doneBtn.isEnabled = self.viewModel.validateInfo()
    }
    
    @objc func tapCancel(_ sender: UIButton){
        if sender.tag == 1{
            self.viewModel.updateGst?(self.viewModel.gst)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AddEditGSTVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "SingleTextFieldCell") as? SingleTextFieldCell else {return UITableViewCell()}
        cell.configureCellForGST(at: indexPath, with:self.viewModel.gst)
        cell.textField.delegate = self
        cell.textField.addTarget(self, action: #selector(changedText), for: .editingChanged)
        cell.textField.tag = indexPath.row
        return cell
    }
    
}

extension AddEditGSTVC: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            self.viewModel.gst.billingName = textField.text ?? ""
        case 1:
            self.viewModel.gst.companyName = textField.text ?? ""
        case 2:
            self.viewModel.gst.GSTInNo = textField.text ?? ""
        default:
            break
        }
    }
    
    @objc func changedText(_ textField: UITextField){
        if textField.text!.replacingOccurrences(of: " ", with: "").isEmpty{
            textField.text = ""
        }
        switch textField.tag {
        case 0:
            self.viewModel.gst.billingName = textField.text ?? ""
        case 1:
            self.viewModel.gst.companyName = textField.text ?? ""
        case 2:
            self.viewModel.gst.GSTInNo = textField.text ?? ""
        default:
            break
        }
        self.doneBtn.isEnabled = self.viewModel.validateInfo()
    }
    
}
