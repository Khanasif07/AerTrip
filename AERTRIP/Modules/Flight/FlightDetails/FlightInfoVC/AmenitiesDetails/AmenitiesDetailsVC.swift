//
//  AmenitiesDetailsVC.swift
//  Aertrip
//
//  Created by Monika Sonawane on 19/09/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class AmenitiesDetailsVC: UIViewController
{
    @IBOutlet weak var dataDisplayView: UIView!
    @IBOutlet weak var amenitiesTitleLabel: UILabel!
    @IBOutlet weak var amenitiesImageView: UIImageView!
    @IBOutlet weak var notesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func closeButtonClicked(_ sender: Any)
    {
        self.view.removeFromSuperview()
    }
}
