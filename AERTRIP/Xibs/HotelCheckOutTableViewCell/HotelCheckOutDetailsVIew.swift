//
//  HotelCheckOutDetailsVIew.swift
//  AERTRIP
//
//  Created by Admin on 29/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelCheckOutDetailsVIew: UIView {
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var hotelDetailsTableView: ATTableView! {
        didSet {
            self.hotelDetailsTableView.delegate = self
            self.hotelDetailsTableView.dataSource = self
        }
    }
    
    
    //Mark:- LifeCycle
    //================
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetUp()
    }
    
    //Mark:- PrivateFunctions
    //=======================
    //.InitialSetUp
    private func initialSetUp() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "HotelCheckOutDetailsVIew", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.configureUI()
    }
    
    ///ConfigureUI
    private func configureUI() {

    }
}

extension HotelCheckOutDetailsVIew: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
