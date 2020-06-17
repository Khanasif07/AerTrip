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
    
    typealias visibleRectMultipliers = (xMul: CGFloat, yMul: CGFloat, widthMul: CGFloat, heightMul: CGFloat)
        
    internal let viewModel = SeatMapVM()
    
    var onReloadPlaneLayoutCall: ((SeatMapModel.SeatMapFlight?) -> ())?
    var onScrollViewScroll: ((visibleRectMultipliers) -> ())?
    
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
    
    func setFlightData(_ model: SeatMapModel.SeatMapFlight) {
        viewModel.flightData = model
    }
    
    // MARK: IBActions
    
    @IBAction func mainDeckBtnAction(_ sender: UIButton) {
        if viewModel.curSelectedDeck == .main { return }
        toggleUpperDeck(false)
    }

    @IBAction func upperDeckBtnAction(_ sender: UIButton) {
        if viewModel.curSelectedDeck == .upper { return }
        toggleUpperDeck(true)
    }
    
    // MARK: Functions
    
    private func initialSetup() {
        setupCollView()
        deckSelectionView.isHidden = viewModel.flightData.ud.rows.isEmpty
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
            viewModel.curSelectedDeck = .upper
        } else {
            mainDeckBtn.backgroundColor = AppColors.themeGreen
            mainDeckBtn.setTitleColor(.white, for: .normal)
            mainDeckBtn.layer.borderWidth = 0
            upperDeckBtn.backgroundColor = .white
            upperDeckBtn.setTitleColor(AppColors.themeGreen, for: .normal)
            upperDeckBtn.layer.borderWidth = 1
            viewModel.curSelectedDeck = .main
        }
        seatMapCollView.reloadData()
        seatMapCollView.scrollRectToVisible(CGRect(origin: .zero, size: seatMapCollView.size), animated: true)
        onReloadPlaneLayoutCall?(nil)
    }
}
