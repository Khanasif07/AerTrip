//
//  SeatMapVC.swift
//  AERTRIP
//
//  Created by Rishabh on 22/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SeatMapVC: UIViewController {

    // MARK: Properties
    
    
    // MARK: IBOutlets
    
    @IBOutlet weak var seatMapCollView: UICollectionView!
    @IBOutlet weak var seatMapCollViewFlowLayout: StickyGridCollectionViewLayout! {
           didSet {
            seatMapCollViewFlowLayout.stickyRowsCount = 1
            seatMapCollViewFlowLayout.stickyColumnsCount = 1
           }
       }
    
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: IBActions
    
    
    
    // MARK: Functions
    
    private func initialSetup() {
        setupCollView()
    }
    
    private func setupCollView() {
        seatMapCollView.register(UINib(nibName: "SeatCollCell", bundle: nil), forCellWithReuseIdentifier: "SeatCollCell")
        seatMapCollView.delegate = self
        seatMapCollView.dataSource = self
    }
}
