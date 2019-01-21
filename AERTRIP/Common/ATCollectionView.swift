//
//  ATCollectionView.swift
//  AERTRIP
//
//  Created by Admin on 19/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit


class ATCollectionView: UICollectionView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.intitalSetup()
    }
    
    private func intitalSetup() {
        self.keyboardDismissMode = .onDrag
    }
}
