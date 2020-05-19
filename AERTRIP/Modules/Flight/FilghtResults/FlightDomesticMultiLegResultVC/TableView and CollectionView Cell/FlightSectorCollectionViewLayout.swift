//
//  FlightSectorCollectionViewLayout.swift
//  Aertrip
//
//  Created by  hrishikesh on 05/09/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit


struct UltravisualLayoutConstants {
    struct Cell {
        // The height of the non-featured cell
        static let partialWidth: CGFloat = UIScreen.main.bounds.size.width * 0.4
        // The height of the first visible cell
        static let halfScreenWidth: CGFloat = UIScreen.main.bounds.size.width * 0.5
    }
}

class FlightSectorCollectionViewLayout: UICollectionViewLayout {

    let dragOffset: CGFloat = UltravisualLayoutConstants.Cell.halfScreenWidth
    
    var cache: [UICollectionViewLayoutAttributes] = []

    
    var featuredItemIndex: Int {
        // Use max to make sure the featureItemIndex is never < 0
        return max(0, Int(collectionView!.contentOffset.x / dragOffset))
    }
    
    var nextItemPercentageOffset: CGFloat {
        return max(0, (collectionView!.contentOffset.x / dragOffset) - CGFloat(featuredItemIndex))
    }
    
    // Returns the height of the collection view
    var height: CGFloat {
        return collectionView!.bounds.height
    }
    
    // Returns the number of items in the collection view
    var numberOfItems: Int {
        return collectionView!.numberOfItems(inSection: 0)
    }
    
}

extension FlightSectorCollectionViewLayout {
    
    
    override var collectionViewContentSize : CGSize {
        let width = UltravisualLayoutConstants.Cell.halfScreenWidth * CGFloat(numberOfItems)
        return CGSize(width: width, height: height)
    }
    
    
    override func prepare() {
        cache.removeAll(keepingCapacity: false)
        
        
        if numberOfItems == 2 {
            returnJourneyLayoutAttributes()
        }else {
            multiLegLayoutAttributes()
        }
        
        
    }
    
    func returnJourneyLayoutAttributes() {
        
        let featuredWidth = UltravisualLayoutConstants.Cell.halfScreenWidth
        
        var frame = CGRect.zero
        var x: CGFloat = 0
        for item in 0..<numberOfItems {
            
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attributes.zIndex = item
            let width = featuredWidth
          
            frame = CGRect(x: x, y: 0, width: width, height: height)
            attributes.frame = frame
            cache.append(attributes)
            x = x + frame.width
        }
        
    }
    
    func multiLegLayoutAttributes() {
        
        
        let partialWidth = UltravisualLayoutConstants.Cell.partialWidth
        let halfScreenWidth = UltravisualLayoutConstants.Cell.halfScreenWidth
        
        var frame = CGRect.zero
        var x: CGFloat = 0
        for item in 0..<numberOfItems {
            // 1
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // 2
            attributes.zIndex = item
            var width = partialWidth
            
            if item == 0 {
                width = halfScreenWidth
            }
            else {
                width = partialWidth
            }
            
            frame = CGRect(x: x, y: 0, width: width, height: height)
            attributes.frame = frame
            cache.append(attributes)
            x = x + frame.width
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    // Return true so that the layout is continuously invalidated as the user scrolls
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        return  false
    }
}
