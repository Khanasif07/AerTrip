//
//  AddRoomCell.swift
//  AERTRIP
//
//  Created by Admin on 22/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol ExpandedCellDelegate: class {
    func plusButtonTouched(indexPath: IndexPath)
    func cancelButtonTouched(indexPath: IndexPath)
}

class AddRoomCell: UICollectionViewCell {

    //Mark:- Variables
    //================
    internal weak var delegate: ExpandedCellDelegate?
    internal var indexPath:IndexPath!
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var addRoomLabel: UILabel!
    @IBOutlet weak var addRoomBtnOutlet: UIButton!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.configureUI()
    }
    
    //Mark:- IBActions
    //================
    @IBAction func addRoomBtnAction(_ sender: UIButton) {
        if let delegate = self.delegate{
            delegate.plusButtonTouched(indexPath: indexPath)
        }
    }
    
    //Mark:- Functions
    //================
    //Mark:- Private
    //==============
    private func configureUI() {
        self.addRoomBtnOutlet.isUserInteractionEnabled = false
        self.addRoomLabel.font = AppFonts.Regular.withSize(14.0)
        self.addRoomLabel.textColor = AppColors.textFieldTextColor51
        self.addRoomLabel.text = LocalizedString.AddRoom.localized
    }
}
