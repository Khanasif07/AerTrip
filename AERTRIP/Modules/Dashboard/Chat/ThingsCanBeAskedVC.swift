//
//  ThingsCanBeAskedVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 10/04/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class ThingsCanBeAskedVC : BaseVC {

    @IBOutlet weak var closeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    

    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
