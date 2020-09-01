//
//  FiltersCustomPagingView.swift
//  AERTRIP
//
//  Created by Rishabh on 25/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Parchment
import Foundation

class CustomPagingView : PagingView {
  override func setupConstraints() {
    pageView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      pageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      pageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      pageView.topAnchor.constraint(equalTo: topAnchor, constant: 45),
      pageView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.heightAnchor.constraint(equalToConstant: 50),
    ])
  }
}

class FiltersCustomPagingViewController : PagingViewController {
  override func loadView() {
    view = CustomPagingView(
      options: options,
      collectionView: collectionView,
      pageView: pageViewController.view)
  }
}
