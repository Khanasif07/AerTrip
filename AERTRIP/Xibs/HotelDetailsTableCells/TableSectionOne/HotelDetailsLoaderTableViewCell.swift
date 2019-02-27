//
//  LoaderTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 12/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelDetailsLoaderTableViewCell: UITableViewCell {

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
    }


    //Mark:- Methods
    //==============
    private func initialSetUps() {
        self.activityIndicator.size = CGSize(width: 31.0, height: 31.0)
    }
    
    internal func configUI() {
        self.activityIndicator.startAnimating()
    }
}
