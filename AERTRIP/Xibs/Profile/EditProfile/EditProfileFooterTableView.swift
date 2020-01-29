//
//  EditProfileFooterTableView.swift
//  AERTRIP
//
//  Created by Admin on 29/01/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class EditProfileFooterTableView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var deleteTravellerView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var deleteBtnHandler: (()->Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        if let handler = self.deleteBtnHandler {
            handler()
        }
    }
    
    private func initialSetup() {
    self.deleteButton.setTitle(LocalizedString.DeleteFromTraveller.localized, for: .normal)
        self.deleteButton.setTitleColor(AppColors.themeRed, for: .normal)
        self.deleteButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
    }
}
