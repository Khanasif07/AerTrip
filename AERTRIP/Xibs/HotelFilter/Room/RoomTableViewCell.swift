//
//  RoomTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell  {
    
    // MARK : - IB Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    var room : (title: String,status:Int)? {
        didSet {
            self.populateData()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
    private func populateData() {
        self.titleLabel.text = room?.title
    }
}
