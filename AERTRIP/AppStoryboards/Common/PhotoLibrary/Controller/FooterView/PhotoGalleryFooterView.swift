//
//  PhotoGalleryFooterView.swift
//  AERTRIP
//
//  Created by Apple  on 30.07.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class PhotoGalleryFooterView: UICollectionReusableView {

    @IBOutlet weak var topDividerView: ATDividerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var bottomDividerView: ATDividerView!
    
    var handeler:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    var productType:ProductType = .hotel{
        didSet{
            self.setupView()
        }
    }
    
    func setupView(){
        self.titleLabel.font = AppFonts.Regular.withSize(18)
        self.titleLabel.textColor = AppColors.themeWhite
        self.arrowImage.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        self.arrowImage.tintColor = AppColors.themeGray20
        switch self.productType {
        case .hotel:
            self.titleLabel.text = LocalizedString.viewMorePhoto.localized
        default:
            self.titleLabel.text = LocalizedString.viewMorePhoto.localized
        }
        
    }
    
    @IBAction func tapTripAvdiser(_ sender: UIButton) {
        self.handeler?()
    }
}
