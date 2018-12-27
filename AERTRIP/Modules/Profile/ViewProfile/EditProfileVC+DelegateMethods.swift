//
//  EditProfileVC+DelegateMethods.swift
//  AERTRIP
//
//  Created by apple on 21/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UITableViewData Source and Delegate methods

extension EditProfileVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: tableViewHeaderViewIdentifier) as? ViewProfileDetailTableViewSectionView else {
            fatalError("ViewProfileDetailTableViewSectionView not found")
        }
        headerView.headerLabel.text = sections[section].rawValue
        return headerView
    }
}

// MARK: - EditProfileImageHeaderViewDelegate Methods

extension EditProfileVC: EditProfileImageHeaderViewDelegate {
    func salutationViewTapped() {
        let action = AKAlertController.actionSheet(nil, message: nil, sourceView: self.view, buttons: [LocalizedString.Title.localized, LocalizedString.Mr.localized, LocalizedString.Mrs.localized, LocalizedString.Ms.localized, LocalizedString.Miss.localized, LocalizedString.Mast.localized], tapBlock: { [weak self] alert, _ in
            if alert.title != LocalizedString.Cancel.localized {
                self?.editProfileImageHeaderView.salutaionLabel.text = alert.title
            }
        })
    }
    
    func editButtonTapped() {
        NSLog("edit buttn tapped")
        let action = AKAlertController.actionSheet(nil, message: nil, sourceView: self.view, buttons: [LocalizedString.TakePhoto.localized, LocalizedString.ChoosePhoto.localized, LocalizedString.ImportFromFacebook.localized, LocalizedString.ImportFromGoogle.localized, LocalizedString.RemovePhoto.localized], tapBlock: { [weak self] _, index in
            
            if index == 0 {
                NSLog("open camera")
                self?.openCamera()
            } else if index == 1 {
                NSLog("Open gallery")
                self?.openGallery()
            } else if index == 2 {
                NSLog("")
                self?.getPhotoFromFacebook()
            } else if index == 3 {
                self?.getPhotoFromGoogle()
            }
            
        })
    }
}

// MARK: - TextFieldDelegate methods

extension EditProfileVC {
    @objc func textFieldValueChanged(_ textField: UITextField) {
        self.editProfileImageHeaderView.firstNameTextField.text = textField.text ?? ""
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.editProfileImageHeaderView.firstNameTextField:
            self.editProfileImageHeaderView.firstNameTextField.resignFirstResponder()
        case self.editProfileImageHeaderView.lastNameTextField:
            self.editProfileImageHeaderView.lastNameTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}
