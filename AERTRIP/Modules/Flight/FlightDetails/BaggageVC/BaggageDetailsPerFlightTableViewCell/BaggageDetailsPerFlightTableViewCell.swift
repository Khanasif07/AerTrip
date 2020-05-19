//
//  BaggageDetailsPerFlightTableViewCell.swift
//  Aertrip
//
//  Created by Monika Sonawane on 20/09/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class BaggageDetailsPerFlightTableViewCell: UITableViewCell
{
    @IBOutlet weak var airlineLogoImageView: UIImageView!
    @IBOutlet weak var journeyTitleLabel: UILabel!
    @IBOutlet weak var dimensionsButton: UIButton!
    
    @IBOutlet weak var dataDisplayViewHeight: NSLayoutConstraint!
    @IBOutlet weak var perAdultView: UIView!
    @IBOutlet weak var perAdultViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var perChildView: UIView!
    @IBOutlet weak var perChildViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var perInfantView: UIView!
    @IBOutlet weak var perInfantViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var perAdultCheckinLabel: UILabel!
    @IBOutlet weak var perChildCheckInLabel: UILabel!
    @IBOutlet weak var perInfantCheckInLabel: UILabel!
    
    @IBOutlet weak var perAdultCabinLabel: UILabel!
    @IBOutlet weak var perChildCabinLabel: UILabel!
    @IBOutlet weak var perInfantCabinLabel: UILabel!
    
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var notesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var notesLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var notesLabelTop: NSLayoutConstraint!
    
    @IBOutlet weak var bottomSeperator: UILabel!
    @IBOutlet weak var bottomSeperatorHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomSeperatorBottom: NSLayoutConstraint!
    @IBOutlet weak var topSeperatorView: UILabel!
    @IBOutlet weak var topSeperatorViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var flightDetailsView: UIView!
    @IBOutlet weak var flightDetailsViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var baggageDataDisplayView: UIView!
    @IBOutlet weak var baggageDataDisplayViewHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        airlineLogoImageView.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bottomSeperator.isHidden = true
    }
    
}
