//
//  UIScrollViewExtension.swift
//  AERTRIP
//
//  Created by Appinventiv  on 09/09/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation


extension UIScrollView {
  var isBouncing: Bool {
    return isBouncingTop || isBouncingLeft || isBouncingBottom || isBouncingRight
  }
  var isBouncingTop: Bool {
    return contentOffset.y < -contentInset.top
  }
  var isBouncingLeft: Bool {
    return contentOffset.x < -contentInset.left
  }
  var isBouncingBottom: Bool {
    let contentFillsScrollEdges = contentSize.height + contentInset.top + contentInset.bottom >= bounds.height
    return contentFillsScrollEdges && contentOffset.y > contentSize.height - bounds.height + contentInset.bottom
  }
  var isBouncingRight: Bool {
    let contentFillsScrollEdges = contentSize.width + contentInset.left + contentInset.right >= bounds.width
    return contentFillsScrollEdges && contentOffset.x > contentSize.width - bounds.width + contentInset.right
  }
}
extension UIScrollView {

    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }

    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }

    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }

    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }

}
