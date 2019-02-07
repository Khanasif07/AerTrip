//
//  AddressTextEditTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 27/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class AddressTextEditTableViewCell: UITableViewCell {
    
    //MARK: - IB Outlets
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var downArrow: UIImageView!
    @IBOutlet weak var separatorArrow: ATDividerView!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(_ indexPath:IndexPath,_ text:String){
        textField.text = text
    }
    
    @IBAction func deleteSectionTapped(_ sender: Any) {
    }
    
}
