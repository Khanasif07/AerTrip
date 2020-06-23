//
//  PostBookingAddonsPaymentStatusVC.swift
//  AERTRIP
//
//  Created by Apple  on 19.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class PostBookingAddonsPaymentStatusVC: BaseVC {

    @IBOutlet weak var paymentTable: ATTableView!
    @IBOutlet weak var returnHomeButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.returnHomeButton.addGredient(isVertical: false)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientView.addGredient(isVertical: false)
    }
   

}
