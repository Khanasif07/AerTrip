//
//  SingleJourneyResultTableViewCell.swift
//  Aertrip
//
//  Created by  hrishikesh on 26/04/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit


class SingleJourneyResultTableViewCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var logoOne: UIImageView!
    @IBOutlet weak var logoTwo: UIImageView!
    @IBOutlet weak var logoThree: UIImageView!
    
    @IBOutlet weak var singleairlineLogo: UIImageView!
    @IBOutlet weak var airlineTitleWidth: NSLayoutConstraint!
    @IBOutlet weak var airlineTitle: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    
    @IBOutlet weak var departureAirports: UILabel!
    @IBOutlet weak var arrivalAirports: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var immediateAirportWidth: NSLayoutConstraint!
    @IBOutlet weak var durationTime: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var dashedView: UIView!
    
    @IBOutlet weak var intermediateAirports: UILabel!
    @IBOutlet weak var priceWidth: NSLayoutConstraint!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var smartIconCollectionView: UICollectionView!
    var pinnedRoundedLayer : CALayer?
    
    var smartIconsArray : [String]?
    var baggageSuperScript : NSAttributedString?
    var currentJourney : Journey?
    
    //MARK:- Setup Methods
    fileprivate func setupBaseView() {
        backgroundColor = .clear // very important
//        layer.masksToBounds = false
//        layer.shadowOpacity = 0.5
//        layer.shadowRadius = 4
//        layer.shadowOffset = CGSize(width: 0, height: 0)
//        layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
//        self.baseView.layer.cornerRadius = 10
        self.baseView.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.masksToBounds = false
        setupBaseView()
        dashedView.setupDashedView()
        setupGradientView()
        setupCollectionView()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCollectionView() {
        smartIconCollectionView.register(UINib(nibName: "SmartIconCell", bundle: nil), forCellWithReuseIdentifier: "SmartIconCell")
        smartIconCollectionView.register(UINib(nibName: "smartIconHeaderView" , bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:"smartIconHeaderView")
        smartIconCollectionView.isScrollEnabled = false
        smartIconCollectionView.allowsSelection = false
        smartIconCollectionView.dataSource = self
        smartIconCollectionView.delegate = self
    }
    
    //MARK:-
    fileprivate func setupGradientView( selectedColor : UIColor = UIColor.white) {
        let gradient = CAGradientLayer()
        let gradientViewRect = gradientView.bounds
        
        gradient.frame =  gradientViewRect
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.colors = [selectedColor.withAlphaComponent(0.0).cgColor,selectedColor.withAlphaComponent(1.0).cgColor,selectedColor.withAlphaComponent(1.0).cgColor]
        gradient.locations = [NSNumber(value: 0.0),NSNumber(value: 0.5),NSNumber(value: 1.0)]
        gradientView.layer.backgroundColor = UIColor.clear.cgColor
        
        gradientView.layer.sublayers = nil
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    fileprivate func setPinnedFlight() {
        self.baseView.layer.borderColor = UIColor.AertripColor.cgColor
        self.baseView.layer.borderWidth = 1.0
        
        if pinnedRoundedLayer == nil
        {
            let pinnedRoundedLayer = CAShapeLayer()
            
            pinnedRoundedLayer.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            pinnedRoundedLayer.fillColor = UIColor.AertripColor.cgColor
            
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 10, y: 0))
            path.addLine(to: CGPoint(x: 20, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 20))
            path.addArc(tangent1End: CGPoint(x: 0, y: 0), tangent2End: CGPoint(x: 20, y: 0), radius: 10)
            pinnedRoundedLayer.path = path
            
            self.pinnedRoundedLayer = pinnedRoundedLayer
        }
        
        if let triangleLayer = pinnedRoundedLayer {
            self.baseView.layer.addSublayer(triangleLayer)
        }
    }
    
    
    func setTitlesFrom( journey : Journey?) {
        guard let journey = journey else { return }
        
        currentJourney = journey
        if journey.isPinned ?? false {
            setPinnedFlight()
        }
        
        self.departureAirports.text = journey.originIATACode
        self.arrivalAirports.text = journey.destinationIATACode
        self.departureTime.text = journey.startTime
        self.arrivalTime.attributedText = journey.endTime18Size
        self.durationTime.text = journey.durationTitle
//        self.price.text = journey.priceAsString
        let amountText = NSMutableAttributedString.init(string: journey.priceAsString)

//        amountText.setAttributes([NSAttributedString.Key.font: UIFont(name: "SourceSansPro-Regular", size: 16)!], range: NSMakeRange(0, 1))
        
        amountText.setAttributes([NSAttributedString.Key.font: AppFonts.Regular.withSize(16)], range: NSMakeRange(0, 1))
        self.price.attributedText = amountText

        self.priceWidth.constant =  self.price.intrinsicContentSize.width
        self.airlineTitle.text = journey.airlinesSubString
        
        
//        if airlineTitle.text!.count > 20 {
//            airlineTitleWidth.constant = 110
//        }else if airlineTitle.text!.count > 15 {
//            airlineTitleWidth.constant = 90
//        }else if airlineTitle.text!.count > 12 {
//            airlineTitleWidth.constant = 85
//        }else{
//            airlineTitleWidth.constant = 70
//        }

        
        if journey.isFastest ?? false  {
            durationTime.textColor = .AERTRIP_ORAGE_COLOR
        }
        
        if journey.isCheapest ?? false {
            price.textColor = .AERTRIP_ORAGE_COLOR
        }
        
        if journey.intermediateAirports.count == 0 {
            self.intermediateAirports.isHidden = true
        }else{
            self.intermediateAirports.text = journey.intermediateAirports
//            if let font = UIFont(name: "SourceSansPro-Regular", size: 14 ) {
            
//            let fontAttributes = [NSAttributedString.Key.font: font]
//                let myText = journey.intermediateAirports
//                let size = (myText as NSString).size(withAttributes: fontAttributes)
//                self.immediateAirportWidth.constant = size.width + 20
//            }
            
            
                let font = AppFonts.Regular.withSize(14)
                let fontAttributes = [NSAttributedString.Key.font: font]
                let myText = journey.intermediateAirports
                let size = (myText as NSString).size(withAttributes: fontAttributes)
                self.immediateAirportWidth.constant = size.width + 20

        }
        
        baggageSuperScript = journey.baggageSuperScript
        
        
        smartIconsArray = journey.smartIconArray
        smartIconCollectionView.reloadData()

    }
    
    override func prepareForReuse() {
        
        logoOne.isHidden = false
        logoTwo.isHidden = false
        logoThree.isHidden = false
        
        logoOne.image = nil
        logoTwo.image = nil
        logoTwo.image = nil

        self.immediateAirportWidth.constant = 100
        self.intermediateAirports.isHidden = false
        
        self.baseView.layer.borderWidth = 0.0
        durationTime.textColor = UIColor.ONE_ZORE_TWO_COLOR
        price.textColor = .black
        priceWidth.constant = 170
        pinnedRoundedLayer?.removeFromSuperlayer()
        super.prepareForReuse()
    }
    
    
    func textToImage(drawText text: String, diameter: CGFloat, color: UIColor ) -> UIImage {
        let textColor = UIColor.white
//        let textFont = UIFont(name: "SourceSansPro-Semibold", size: 16)!
//
        let textFont = AppFonts.SemiBold.withSize(16)
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, scale)
        let ctx = UIGraphicsGetCurrentContext()!
        
        var rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.paragraphStyle : titleParagraphStyle
            ] as [NSAttributedString.Key : Any]
        rect = CGRect(x: 0, y: -1, width: diameter, height: 16)
        
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}



extension SingleJourneyResultTableViewCell : UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if section == 0 {
            if baggageSuperScript?.string == "0P" || baggageSuperScript?.string == "0" {
                return 0
            }
            else {
                return 1
            }
        }
        else {
            return smartIconsArray?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = smartIconCollectionView.dequeueReusableCell(withReuseIdentifier: "SmartIconCell", for: indexPath) as! SmartIconCell
        
        if indexPath.section == 0 {
            cell.imageView.image = UIImage(named: "checkingBaggageKg")
            cell.superScript.attributedText = baggageSuperScript
//                    printDebug("baggageSuperScript...\(baggageSuperScript?.string)")
//            cell.superScript.backgroundColor = UIColor.yellow
//            cell.contentView.backgroundColor = UIColor.red
            cell.superScriptWidth.constant = 14
            cell.imageViewLeading.constant = 0
        } else {
            
            guard let imageName = smartIconsArray?[indexPath.row] else { return UICollectionViewCell() }
            
            if  imageName == "fsr" {
                let color = UIColor(displayP3Red:1.0 , green: ( 88.0/255.0), blue:( 77.0/255.0) , alpha: 1.0)
                if let seats = currentJourney?.seats {
                    let tempImage = textToImage(drawText: seats, diameter:20.0 , color: color)
                    cell.imageView.image = tempImage
                    cell.superScriptWidth.constant = 0
                    cell.imageViewLeading.constant = 3
                }
            }else{
                cell.imageView.image = UIImage(named: imageName)
                cell.superScriptWidth.constant = 0
                cell.imageViewLeading.constant = 3
            }
            
            if imageName == "refundStatusPending" {
                cell.superScript.text = "?"
                cell.superScript.textColor = UIColor.AERTRIP_RED_COLOR
//                cell.superScript.font = UIFont(name: "SourceSansPro-Bold", size: 10.0)
                cell.superScript.font = AppFonts.Bold.withSize(10)
                cell.superScriptWidth.constant = 10
                if indexPath.row == 0{
                    cell.imageViewLeading.constant = 0
                }else{
                    cell.imageViewLeading.constant = 3
                }
            }
            else {
                cell.superScript.text = ""
                cell.superScriptWidth.constant = 0
            }
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {


        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                               withReuseIdentifier: "smartIconHeaderView",
                               for: indexPath)
        
//        headerView.frame = CGRect(x: 33, y: 5, width: 1.0, height: collectionView.frame.height)
//        headerView.backgroundColor = UIColor(displayP3Red: ( 204.0 / 255.0), green: ( 204.0 / 255.0), blue: ( 204 / 255.0), alpha: 1.0)

        return headerView
    }

    @objc func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          referenceSizeForHeaderInSection section: Int) -> CGSize {

    if section == 0 {
        return .zero
    }
    else {
        if smartIconsArray?.count == 0  || baggageSuperScript?.string == "0P" || baggageSuperScript?.string == "0" {
            return .zero
        }
        return CGSize(width: 16.0, height:  23.0)
    }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: indexPath.section == 0 ? 30 : 26, height: 23)
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
