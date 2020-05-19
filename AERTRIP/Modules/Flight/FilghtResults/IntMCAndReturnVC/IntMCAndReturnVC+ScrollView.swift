//
//  FlightInternationalMultiLegResultVC+ScrollView.swift
//  Aertrip
//
//  Created by Appinventiv on 24/04/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation



extension IntMCAndReturnVC {
    
    //MARK:- Scroll related methods
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        scrollviewInitialYOffset = scrollView.contentOffset.y
    }
    
    fileprivate func hideHeaderBlurView(_ offsetDifference: CGFloat) {
        DispatchQueue.main.async {
            
            var yCordinate : CGFloat
            yCordinate = max (  -self.visualEffectViewHeight ,  -offsetDifference )
            yCordinate = min ( 0,  yCordinate)
            
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
                
                if let blurEffectView = self.navigationController?.view.viewWithTag(500) {
                    var rect = blurEffectView.frame
                    let yCordinateOfView = rect.origin.y
                    if ( yCordinateOfView  > yCordinate ) {
                        rect.origin.y = yCordinate
                        blurEffectView.frame = rect
                    }
                }
            } ,completion: nil)
        }
    }
    
    fileprivate func revealBlurredHeaderView(_ invertedOffset: CGFloat) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseInOut], animations: {
                if let blurEffectView = self.navigationController?.view.viewWithTag(500) {
                    var rect = blurEffectView.frame
                    var yCordinate = rect.origin.y + invertedOffset
                    yCordinate = min ( 0,  yCordinate)
                    rect.origin.y = yCordinate
                    blurEffectView.frame = rect
                }
            } ,completion: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let contentSize = scrollView.contentSize
        let scrollViewHeight = contentSize.height
        let viewHeight = self.view.frame.height
        
        if scrollViewHeight < (viewHeight + visualEffectViewHeight) {
            return
        }
        
        let contentOffset = scrollView.contentOffset
        let offsetDifference = contentOffset.y - scrollviewInitialYOffset
        if offsetDifference > 0 {
            hideHeaderBlurView(offsetDifference)
        }
        else {
            let invertedOffset = -offsetDifference
            revealBlurredHeaderView(invertedOffset)
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView){
        
        if let blurEffectView = self.navigationController?.view.viewWithTag(500) {
            var rect = blurEffectView.frame
            rect.origin.y = 0
            // Animatioon to move the blurEffectView
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
                blurEffectView.frame = rect
            } ,completion: nil)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        snapToTopOrBottomOnSlowScrollDragging(scrollView)
        //        scrollviewInitialYOffset = 0.0
    }
    
    fileprivate func snapToTopOrBottomOnSlowScrollDragging(_ scrollView: UIScrollView) {
        
        if let blurEffectView = self.navigationController?.view.viewWithTag(500) {
            var rect = blurEffectView.frame
            let yCoordinate = rect.origin.y * ( -1 )
            
            // After dragging if blurEffectView is at top or bottom position , snapping animation is not required
            if yCoordinate == 0 || yCoordinate == ( -visualEffectViewHeight){
                return
            }
            
            // If blurEffectView yCoodinate is close to top of the screen
            if  ( yCoordinate > ( visualEffectViewHeight / 2.0 ) ){
                rect.origin.y = -visualEffectViewHeight
                
                if scrollView.contentOffset.y < 100 {
                    let zeroPoint = CGPoint(x: 0, y: 96.0)
                    scrollView.setContentOffset(zeroPoint, animated: true)
                }
            }
            else {  //If blurEffectView yCoodinate is close to fully visible state of blurView
                rect.origin.y = 0
            }
            
            // Animatioon to move the blurEffectView
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
                blurEffectView.frame = rect
            } ,completion: nil)
        }
    }
}


