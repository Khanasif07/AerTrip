//
//  RecentHotelSearcheView.swift
//  AERTRIP
//
//  Created by Admin on 14/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class RecentHotelSearcheView: UIView {
    
    //Mark:- Variables
    //================
    
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var recentCollectionView: UICollectionView!
    
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
        self.registerNib()
    }
    
    private func registerNib() {
        let recentHotelNib = UINib(nibName: "RecentHotelSearchCollectionViewCell", bundle: nil)
        self.recentCollectionView.register(recentHotelNib, forCellWithReuseIdentifier: "RecentHotelSearchCollectionViewCell")
    }
}


extension RecentHotelSearcheView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentHotelSearchCollectionViewCell", for: indexPath) as? RecentHotelSearchCollectionViewCell else { return UICollectionViewCell()
        }
        return cell
    }
    
}
