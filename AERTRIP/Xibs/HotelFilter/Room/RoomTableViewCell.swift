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
    @IBOutlet weak var statusButton: UIButton!
    
    
    var meal : ATMeal? {
        didSet {
            self.populateData()
        }
    }
    
    var cancellationPolicy : ATCancellationPolicy? {
        didSet {
           self.populateCancellationPolicyData()
        }
    }
    
    var others : ATOthers? {
        didSet {
            self.populateOthersData()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
    private func populateData() {
        self.titleLabel.text = meal?.title
    }
    
    private func populateCancellationPolicyData() {
        self.titleLabel.text = cancellationPolicy?.title
    }
    
    private func populateOthersData() {
        self.titleLabel.text = others?.title
    }
}
