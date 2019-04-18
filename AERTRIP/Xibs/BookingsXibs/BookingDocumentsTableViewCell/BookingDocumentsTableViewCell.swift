//
//  BookingDocumentsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 17/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol BookingDocumentsTableViewCellDelegate: class {
    func  downloadDocument(url: String , tableIndex: IndexPath , collectionIndex: IndexPath)
}

class BookingDocumentsTableViewCell: UITableViewCell {

    weak var delegate: BookingDocumentsTableViewCellDelegate?
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var documentsLabel: UILabel!
    @IBOutlet weak var documentsCollectionView: UICollectionView! {
        didSet {
            self.documentsCollectionView.delegate = self
            self.documentsCollectionView.dataSource = self
            self.documentsCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 25.0, bottom: 0.0, right: 0.0)
        }
    }
    @IBOutlet weak var dividerView: ATDividerView!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Functions
    //================
    private func configUI() {
        self.documentsLabel.font = AppFonts.Regular.withSize(14.0)
        self.documentsLabel.textColor = AppColors.themeGray40
        self.documentsLabel.text = LocalizedString.Documents.localized
        self.documentsCollectionView.registerCell(nibName: BookingDocumentsCollectionViewCell.reusableIdentifier)
    }
    
    //Mark:- IBActions
    //================
    
}

extension BookingDocumentsTableViewCell: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookingDocumentsCollectionViewCell.reusableIdentifier, for: indexPath) as? BookingDocumentsCollectionViewCell else { return UICollectionViewCell() }
        cell.configCell(name: "Govind.pdf", imageUrl: "", documentsSize: "293.03 KB")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let superVw = self.superview as? UITableView , let index = superVw.indexPath(for: self) , let safeDelegate = self.delegate {
            safeDelegate.downloadDocument(url: "https://www.tutorialspoint.com/swift/swift_tutorial.pdf", tableIndex: index, collectionIndex: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 109.0, height: 177.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}
