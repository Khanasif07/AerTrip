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
            self.recentCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
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
        self.recentSearchLabel.textColor =  AppColors.themeWhite.withAlphaComponent(0.5)
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
        self.delegate?.passRecentSearchesData(recentSearch: self.recentSearchesData?[indexPath.row] ?? RecentSearchesModel())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = CGSize(width: 278.0 , height: collectionView.frame.height)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}
