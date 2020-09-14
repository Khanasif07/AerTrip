//
//  PhotoGalleryBottomView.swift
//  AERTRIP
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class PhotoGalleryBottomView: UIView {

   @IBOutlet weak var topDividerView: ATDividerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var bottomDividerView: ATDividerView!
    @IBOutlet var containerView: UIView!
    
    var handeler:(()->())?
    
    //MARK:- View Life Cycle
    //MARK:-
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetup() {
        
        Bundle.main.loadNibNamed("PhotoGalleryBottomView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        containerView.backgroundColor = .clear
        bottomDividerView.isHidden = true
        topDividerView.isHidden = true

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
