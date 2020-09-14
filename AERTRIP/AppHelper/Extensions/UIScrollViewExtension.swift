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
