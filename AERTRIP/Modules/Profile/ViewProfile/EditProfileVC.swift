//
//  EditProfileVC.swift
//  AERTRIP
//
//  Created by apple on 21/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class EditProfileVC: BaseVC {
    // MARK: - IB Outlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    // MARK: - Variables
    
    var sections = [LocalizedString.EmailAddress, LocalizedString.ContactNumber, LocalizedString.Address, LocalizedString.MoreInformation]
    
    let tableViewHeaderViewIdentifier = "ViewProfileDetailTableViewSectionView"
    var editProfileImageHeaderView: EditProfileImageHeaderView = EditProfileImageHeaderView()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doInitialSetUp()
        registerXib()
    }
    
    // MARK: - IB Actions
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        NSLog("save button tapped")
    }
    
    // MARK: - Helper Methods
    
    func doInitialSetUp() {
        cancelButton.setTitle(LocalizedString.Cancel.rawValue, for: .normal)
        cancelButton.setTitleColor(AppColors.themeGreen, for: .normal)
        saveButton.setTitle(LocalizedString.Save.rawValue, for: .normal)
        saveButton.setTitleColor(AppColors.themeGreen, for: .normal)
        
        editProfileImageHeaderView = EditProfileImageHeaderView.instanceFromNib()
        editProfileImageHeaderView.delegate = self
        
        editProfileImageHeaderView.firstNameTextField.delegate = self
        editProfileImageHeaderView.lastNameTextField.delegate = self
        
        tableView.separatorStyle = .none
        tableView.tableHeaderView = editProfileImageHeaderView
    }
    
    func registerXib() {
        tableView.register(UINib(nibName: tableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: tableViewHeaderViewIdentifier)
        tableView.reloadData()
    }
    
    func openCamera() {}
    
    func openGallery() {}
    
    func getPhotoFromFacebook() {
        let socialModel = SocialLoginVM()
//        let userData =  socialModel.userData
        socialModel.fbLogin(vc: self) { success in
            if success {
                let placeHolder = UIImage(named: "group")
                self.editProfileImageHeaderView.profileImageView.setImageWithUrl(socialModel.userData.picture, placeholder: placeHolder!, showIndicator: true)
            } else {}
        }
    }
    
    func getPhotoFromGoogle() {}
}
