//
//  WhySmartSortView.swift
//  Aertrip
//
//  Created by Rishabh on 02/05/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class WhySmartSortView: UIView {

    // MARK: IBOutlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    var onLearnMoreTap: ((UITapGestureRecognizer) -> ())?
    
    // MARK: View Life Cycle
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit()
    {
        Bundle.main.loadNibNamed("WhySmartSortView", owner: self, options: nil)
        contentView.frame = self.bounds
        addSubview(contentView!)
        setupViews()
        let height = titleLbl.frame.height + descLbl.frame.height + 65
        self.frame = CGRect(x: 0, y: 0, width: superview?.frame.width ?? 0, height: height)
    }
    
    // MARK: Functions
    private func setupViews() {
        setupSortDescription()
    }
    
    fileprivate func setupSortDescription() {
        
        let attributedString = NSMutableAttributedString(string: "Smart Sort enables you to select your flight from just the first few results. Flights are sorted after comparing price, duration and various other factors. Learn more", attributes: [
//            .font: UIFont(name: "SourceSansPro-Regular", size: 16.0)!,
            .font: AppFonts.Regular.withSize(16),
            .foregroundColor: UIColor.black,
            .kern: 0.0
            ])
        attributedString.addAttributes([
//            .font: UIFont(name: "SourceSansPro-Semibold", size: 16.0)!,
            .font: AppFonts.SemiBold.withSize(16),
            .foregroundColor: UIColor.appColor
            ], range: NSRange(location: 156, length: 10))
        descLbl.attributedText = attributedString
        descLbl.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self , action: #selector(tapLabel(gesture:)))
        
        descLbl.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer){
        onLearnMoreTap?(gesture)
    }
}
