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
    
    internal let viewModel = SeatMapVM()
    
    // MARK: IBOutlets
    
    @IBOutlet weak var deckSelectionView: UIView!
    @IBOutlet weak var mainDeckBtn: UIButton!
    @IBOutlet weak var upperDeckBtn: UIButton!
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
    
    @IBAction func mainDeckBtnAction(_ sender: UIButton) {
        toggleUpperDeck(false)
    }

    @IBAction func upperDeckBtnAction(_ sender: UIButton) {
        toggleUpperDeck(true)
    }
    
    // MARK: Functions
    
    private func initialSetup() {
        setupCollView()
        deckSelectionView.isHidden = !viewModel.hasUpperDeck
        mainDeckBtn.layer.borderColor = AppColors.themeGreen.cgColor
        mainDeckBtn.setTitle(LocalizedString.mainDeck.localized, for: .normal)
        mainDeckBtn.titleLabel?.font = AppFonts.SemiBold.withSize(14)
        mainDeckBtn.roundCorners(corners: [.topLeft, .bottomLeft], radius: 4)
        upperDeckBtn.layer.borderColor = AppColors.themeGreen.cgColor
        upperDeckBtn.setTitle(LocalizedString.upperDeck.localized, for: .normal)
        upperDeckBtn.titleLabel?.font = AppFonts.SemiBold.withSize(14)
        mainDeckBtn.roundCorners(corners: [.topRight, .bottomRight], radius: 4)
        toggleUpperDeck(false)
    }
    
    private func setupCollView() {
        seatMapCollView.register(UINib(nibName: "SeatCollCell", bundle: nil), forCellWithReuseIdentifier: "SeatCollCell")
        seatMapCollView.delegate = self
        seatMapCollView.dataSource = self
    }
    
    private func toggleUpperDeck(_ selected: Bool) {
        if selected {
            upperDeckBtn.backgroundColor = AppColors.themeGreen
            upperDeckBtn.setTitleColor(.white, for: .normal)
            upperDeckBtn.layer.borderWidth = 0
            mainDeckBtn.backgroundColor = .white
            mainDeckBtn.setTitleColor(AppColors.themeGreen, for: .normal)
            mainDeckBtn.layer.borderWidth = 1
        } else {
            mainDeckBtn.backgroundColor = AppColors.themeGreen
            mainDeckBtn.setTitleColor(.white, for: .normal)
            mainDeckBtn.layer.borderWidth = 0
            upperDeckBtn.backgroundColor = .white
            upperDeckBtn.setTitleColor(AppColors.themeGreen, for: .normal)
            upperDeckBtn.layer.borderWidth = 1
        }
    }
}
