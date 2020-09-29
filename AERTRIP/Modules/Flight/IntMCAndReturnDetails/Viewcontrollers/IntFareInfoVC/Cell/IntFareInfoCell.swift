//
//  IntFareInfoCell.swift
//  Aertrip
//
//  Created by Apple  on 12.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class IntFareInfoCell: UITableViewCell {
    @IBOutlet weak var topSeperatorLabel: UILabel!
    @IBOutlet weak var topSeperatorLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleView: UIView!
//    @IBOutlet weak var titleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fareRulesButton: UIButton!
    
    @IBOutlet weak var nonReschedulableView: UIView!
    @IBOutlet weak var nonReschedulableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nonRefundableView: UIView!
    @IBOutlet weak var nonRefundableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cancellationNoteDisplayView: UIView!
    @IBOutlet weak var cancellationNoteDisplayViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bottomSeparatorLabel: UILabel!
    @IBOutlet weak var bottomSeparatorLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomSeparatorLabelLeading: NSLayoutConstraint!
    
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var seperatorViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var journeyNameLabel: UILabel!
    @IBOutlet weak var carrierImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        carrierImgView.layer.cornerRadius = 3.0

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAirlineImage(with url: String){
        
        if let urlobj = URL(string: url){
            let urlRequest = URLRequest(url: urlobj)
            if let responseObj = URLCache.shared.cachedResponse(for: urlRequest) {
                let image = UIImage(data: responseObj.data)
                self.carrierImgView.image = image
            }else{
                self.carrierImgView.setImageWithUrl(url, placeholder: UIImage(), showIndicator: true)
            }
        }else{
            self.carrierImgView.setImageWithUrl(url, placeholder: UIImage(), showIndicator: true)
        }

    }
    
}
