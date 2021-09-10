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
        
        self.heightDataContainer.cornerradius = self.heightDataContainer.height / 2.0
        self.widthDataContainer.cornerradius = self.widthDataContainer.height / 2.0
        self.depthDataContainer.cornerradius = self.depthDataContainer.height / 2.0
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
        
        
        let fromH = CGPoint(x: self.heightContainer.bounds.size.width/2.0, y: 0.0)
        let toH = CGPoint(x: self.heightContainer.bounds.size.width/2.0, y: self.heightContainer.bounds.size.height)
        let heightArrowPath = PKBezierPathHelper.shared.arrow(from: fromH, to: toH, tailWidth: 1.0, headWidth: 4.0, headLength: 5.0, arrowType: .both)
        
        let shapeLayerH = CAShapeLayer()
        shapeLayerH.path = heightArrowPath.cgPath
        shapeLayerH.fillColor = AppColors.themeGray40.cgColor
        shapeLayerH.strokeColor = AppColors.themeGray40.cgColor
        shapeLayerH.lineWidth = 0.0
        self.heightContainer.layer.insertSublayer(shapeLayerH, at: 0)
        
        
        let fromW = CGPoint(x: 0.0, y: 0.0)
        let toW = CGPoint(x: self.widthContainer.bounds.size.width, y: self.widthContainer.bounds.size.height)
        let widthArrowPath = PKBezierPathHelper.shared.arrow(from: fromW, to: toW, tailWidth: 1.0, headWidth: 4.0, headLength: 5.0, arrowType: .both)
        
        let shapeLayerW = CAShapeLayer()
        shapeLayerW.path = widthArrowPath.cgPath
        shapeLayerW.fillColor = AppColors.themeGray40.cgColor
        shapeLayerW.strokeColor = AppColors.themeGray40.cgColor
        shapeLayerW.lineWidth = 0.0
        self.widthContainer.layer.insertSublayer(shapeLayerW, at: 0)
        
        
        let fromD = CGPoint(x: 0.0, y: self.depthContainer.bounds.size.height)
        let toD = CGPoint(x: self.depthContainer.bounds.size.width, y: 0.0)
        let depthArrowPath = PKBezierPathHelper.shared.arrow(from: fromD, to: toD, tailWidth: 1.0, headWidth: 4.0, headLength: 5.0, arrowType: .both)
        
        let shapeLayerD = CAShapeLayer()
        shapeLayerD.path = depthArrowPath.cgPath
        shapeLayerD.fillColor = AppColors.themeGray40.cgColor
        shapeLayerD.strokeColor = AppColors.themeGray40.cgColor
        shapeLayerD.lineWidth = 0.0
        self.depthContainer.layer.insertSublayer(shapeLayerD, at: 0)
        
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


class PKBezierPathHelper {
    
    enum PKArrowType {
        case start
        case end
        case both
    }
    
    static let shared: PKBezierPathHelper = PKBezierPathHelper()
    private init() {}
    
    func arrow(from start: CGPoint, to end: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat, arrowType: PKArrowType = .both) -> UIBezierPath {
        
        let length = hypot(end.x - start.x, end.y - start.y)
        
        let multiplier: CGFloat = arrowType == .both ? CGFloat(2) : CGFloat(1)
        let tailLength = length - (headLength * multiplier)
        
        let headDiff = (headWidth - tailWidth) / 2.0
        
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        
        var points: [CGPoint] = []
        
        if arrowType == .both {
            ///both
            points = [
                p(0, 0),
                p(headLength, headWidth / 2),
                p(headLength, tailWidth / 2),
                p((tailLength + headLength), tailWidth / 2),
                p((tailLength + headLength), headWidth / 2),
                p(length, 0),
                p((tailLength + headLength), -headWidth / 2),
                p((tailLength + headLength), -tailWidth / 2),
                p(headLength, -tailWidth / 2),
                p(headLength, -headWidth / 2)
            ]
        }
        else if arrowType == .end {
            ///end
            points = [
                p(0, 0),
                p(0, tailWidth / 2),
                p(tailLength, tailWidth / 2),
                p(tailLength, headWidth / 2),
                p(length, 0),
                p(tailLength, -headWidth / 2),
                p(tailLength, -tailWidth / 2),
                p(0, -tailWidth / 2)
            ]
        }
        else {
            ///start
            points = [
                p(0, 0),
                p(headLength, headWidth / 2),
                p(headLength, tailWidth / 2),
                p(length, tailWidth / 2),
                p(length, -tailWidth / 2),
                p(headLength, -tailWidth / 2),
                p(headLength, -headWidth / 2)
            ]
        }
        
        let cosine = (end.x - start.x) / length
        let sine = (end.y - start.y) / length
        let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
        
        let path = CGMutablePath()
        path.addLines(between: points, transform: transform)
        path.closeSubpath()
        
        return UIBezierPath(cgPath: path)
    }
}
