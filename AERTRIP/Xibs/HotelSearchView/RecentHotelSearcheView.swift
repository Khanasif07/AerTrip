//
//  RecentHotelSearcheView.swift
//  AERTRIP
//
//  Created by Admin on 14/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol RecentHotelSearcheViewDelegate: class {
    func passRecentSearchesData(recentSearch: RecentSearchesModel)
}

class RecentHotelSearcheView: UIView {
    
    //Mark:- Variables
    //================
    internal var recentSearchesData: [RecentSearchesModel]?
    weak var delegate: RecentHotelSearcheViewDelegate?
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var recentCollectionView: UICollectionView! {
        didSet {
            self.recentCollectionView.delegate = self
            self.recentCollectionView.dataSource = self
            self.recentCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 14.0, bottom: 0.0, right: 16.0)
        }
    }
    @IBOutlet weak var recentSearchLabel: UILabel!
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //Mark:- Function
    //===============
    private func initialSetUp() {
        //.InitialSetUp
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RecentHotelSearcheView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.configureUI()
        self.registerNib()
    }
    
    private func configureUI() {
        self.recentSearchLabel.textColor =  AppColors.whiteColorForButton.withAlphaComponent(0.6)
        self.recentSearchLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    private func registerNib() {
        let recentHotelNib = UINib(nibName: "RecentHotelSearchCollectionViewCell", bundle: nil)
        self.recentCollectionView.register(recentHotelNib, forCellWithReuseIdentifier: "RecentHotelSearchCollectionViewCell")
    }
}


extension RecentHotelSearcheView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentSearchesData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentHotelSearchCollectionViewCell", for: indexPath) as? RecentHotelSearchCollectionViewCell else { return UICollectionViewCell()
        }
        if let safeRecentData = self.recentSearchesData {
            cell.configureCell(recentSearchesData: safeRecentData[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var recentSerach = self.recentSearchesData?[indexPath.row] ?? RecentSearchesModel()
        if indexPath.row == 0{
            recentSerach.currentIndexInList = 0
        }
        self.delegate?.passRecentSearchesData(recentSearch: recentSerach)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let recentSearchesData = self.recentSearchesData?[indexPath.row] ?? RecentSearchesModel()
        let width: CGFloat = recentSearchesData.getTextWidth(collectionView.frame.height)
        let textWidth = width + 86

        let cellWidth = textWidth > 275 ? 275 : textWidth
        printDebug("width: \(width)")
        printDebug("textWidth: \(textWidth)")
        printDebug("cellWidth: \(cellWidth)")

        let itemSize = CGSize(width: cellWidth , height: collectionView.frame.height)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}
