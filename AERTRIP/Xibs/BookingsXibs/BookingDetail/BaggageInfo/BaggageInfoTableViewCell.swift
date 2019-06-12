//
//  BaggageInfoTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 10/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BaggageInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var baggageImageView: UIImageView!
    @IBOutlet weak var baggageTitleLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var baggageDetailLabel: UILabel!
    @IBOutlet weak var baggageAdditionalDetailLabel: UILabel!
    
    @IBOutlet weak var heightContainer: UIView!
    @IBOutlet weak var heightDataContainer: UIView!
    @IBOutlet weak var heightValueLabel: UILabel!
    @IBOutlet weak var heightTextLabel: UILabel!

    @IBOutlet weak var widthContainer: UIView!
    @IBOutlet weak var widthDataContainer: UIView!
    @IBOutlet weak var widthValueLabel: UILabel!
    @IBOutlet weak var widthTextLabel: UILabel!
    
    @IBOutlet weak var depthContainer: UIView!
    @IBOutlet weak var depthDataContainer: UIView!
    @IBOutlet weak var depthValueLabel: UILabel!
    @IBOutlet weak var depthTextLabel: UILabel!
    
    
    var dimension: Dimension? {
        didSet {
            self.setData()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.setUpFont()
        self.setUpTextColor()
        
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.heightDataContainer.cornerRadius = self.heightDataContainer.height / 2.0
        self.widthDataContainer.cornerRadius = self.widthDataContainer.height / 2.0
        self.depthDataContainer.cornerRadius = self.depthDataContainer.height / 2.0
    }
    
    
    // MARK: - Helper methods
    
    private func setUpFont() {
        self.baggageTitleLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.baggageDetailLabel.font = AppFonts.Regular.withSize(16.0)
        self.baggageAdditionalDetailLabel.font = AppFonts.Regular.withSize(16.0)
        
        
        self.heightValueLabel.font = AppFonts.SemiBold.withSize(14.0)
        self.heightTextLabel.font = AppFonts.Regular.withSize(12.0)
        
        self.widthValueLabel.font = AppFonts.SemiBold.withSize(14.0)
        self.widthTextLabel.font = AppFonts.Regular.withSize(12.0)
        
        self.depthValueLabel.font = AppFonts.SemiBold.withSize(14.0)
        self.depthTextLabel.font = AppFonts.Regular.withSize(12.0)
    }
    
    private func setUpTextColor() {
        self.baggageTitleLabel.textColor = AppColors.themeBlack
        self.baggageDetailLabel.textColor = AppColors.themeBlack
        self.baggageAdditionalDetailLabel.textColor = AppColors.themeGray60
        
        self.heightValueLabel.textColor = AppColors.themeWhite
        self.heightTextLabel.textColor = AppColors.themeWhite
        self.heightValueLabel.backgroundColor = AppColors.clear
        self.heightTextLabel.backgroundColor = AppColors.clear
        self.heightDataContainer.backgroundColor = AppColors.themeGray40
        
        self.widthValueLabel.textColor = AppColors.themeWhite
        self.widthTextLabel.textColor = AppColors.themeWhite
        self.widthValueLabel.backgroundColor = AppColors.clear
        self.widthTextLabel.backgroundColor = AppColors.clear
        self.widthDataContainer.backgroundColor = AppColors.themeGray40
        
        self.depthValueLabel.textColor = AppColors.themeWhite
        self.depthTextLabel.textColor = AppColors.themeWhite
        self.depthValueLabel.backgroundColor = AppColors.clear
        self.depthTextLabel.backgroundColor = AppColors.clear
        self.depthDataContainer.backgroundColor = AppColors.themeGray40
        
        
        let widthArrow = UIBezierPath.arrow(from: self.widthContainer.bounds.origin, to: CGPoint(x: self.widthContainer.bounds.size.width, y: self.widthContainer.bounds.size.height), tailWidth: 2.0, headWidth: 2.0, headLength: 2.0)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = widthArrow.cgPath
        shapeLayer.fillColor = AppColors.themeGray40.cgColor
        shapeLayer.strokeColor = AppColors.themeGray40.cgColor
        shapeLayer.lineWidth = 0.0
        self.widthContainer.layer.insertSublayer(shapeLayer, at: 0)
        self.widthContainer.backgroundColor = AppColors.clear
    }
 
    private func setData() {
        
        self.heightTextLabel.text = "cm"
        self.widthTextLabel.text = "cm"
        self.depthTextLabel.text = "cm"
        
        if let obj = self.dimension?.cm?.height {
            self.heightValueLabel.text = "\(obj)"
        }
        else {
            self.heightValueLabel.text = LocalizedString.dash.localized
        }
        
        if let obj = self.dimension?.cm?.width {
            self.widthValueLabel.text = "\(obj)"
        }
        else {
            self.widthValueLabel.text = LocalizedString.dash.localized
        }
        
        if let obj = self.dimension?.cm?.depth {
            self.depthValueLabel.text = "\(obj)"
        }
        else {
            self.depthValueLabel.text = LocalizedString.dash.localized
        }
    }
}


extension UIBezierPath {
    
    class func arrow(from start: CGPoint, to end: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> Self {
        let length = hypot(end.x - start.x, end.y - start.y)
        let tailLength = length - headLength
        
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        let points: [CGPoint] = [
            p(0, tailWidth / 2),
            p(tailLength, tailWidth / 2),
            p(tailLength, headWidth / 2),
            p(length, 0),
            p(tailLength, -headWidth / 2),
            p(tailLength, -tailWidth / 2),
            p(0, -tailWidth / 2)
        ]
        
        let cosine = (end.x - start.x) / length
        let sine = (end.y - start.y) / length
        let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
        
        let path = CGMutablePath()
        path.addLines(between: points, transform: transform)
        path.closeSubpath()
        
        return self.init(cgPath: path)
    }
    
}
