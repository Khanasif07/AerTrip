//
//  DomesticMultiLegCell.swift
//  Aertrip
//
//  Created by  hrishikesh on 15/07/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class DomesticMultiLegCell: UITableViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet weak var iconOne: UIImageView!
    @IBOutlet weak var iconTwo: UIImageView!
    @IBOutlet weak var iconThree: UIImageView!
    @IBOutlet weak var flightCode: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var departureAirportCode: UILabel!
    @IBOutlet weak var arrivalAirportCode: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var dashedView: UIView!
    @IBOutlet weak var stopCountLabel: UILabel!
    @IBOutlet weak var stopsBackgroundView: UIView!
    @IBOutlet weak var priceWidth: NSLayoutConstraint!
    @IBOutlet weak var stopBackgroundViewWidth: NSLayoutConstraint!
    @IBOutlet weak var arrivalTimeWidth: NSLayoutConstraint!
    @IBOutlet weak var smartIconCollectionView: UICollectionView!
    @IBOutlet weak var gradientView: UIView!
    var pinnedTriangleLayer : CALayer?
    var smartIconsArray : [String]?
    var baggageSuperScript : NSAttributedString?
    var currentJourney : Journey?
    
    //MARK:- Override methods
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        let selectedStateBGColor = UIColor(displayP3Red: (236.0/255.0), green: (253.0/255.0), blue: (244.0/255.0), alpha: 1.0)
//
//        let backgroundColor = selected ? selectedStateBGColor : .white
//
//        if ( duration.isHidden == false) {
//            self.backgroundColor = backgroundColor
//            stopsBackgroundView.backgroundColor = backgroundColor
//            price.backgroundColor = backgroundColor
//            setupGradientView(selectedColor: backgroundColor)
//        }
//
//    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dashedView.setupDashedView()
        setupCollectionView()
        setupGradientView()
    }
    
    func setupCollectionView() {
        smartIconCollectionView.register(UINib(nibName: "SmartIconCell", bundle: nil), forCellWithReuseIdentifier: "SmartIconCell")
        smartIconCollectionView.register(UINib(nibName: "smartIconHeaderView" , bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:"smartIconHeaderView")
        smartIconCollectionView.isScrollEnabled = false
        smartIconCollectionView.allowsSelection = false
        smartIconCollectionView.dataSource = self
        smartIconCollectionView.delegate = self
    }
    
    //MARK:- Methods
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
    
    func setPinnedFlight() {
        
        guard let isPinned = currentJourney?.isPinned else { return }
        
        if isPinned {
            if pinnedTriangleLayer == nil {
                
                let pinnedRoundedLayer = CAShapeLayer()
                
                pinnedRoundedLayer.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                pinnedRoundedLayer.fillColor = UIColor.AertripColor.cgColor
                
                let path = CGMutablePath()
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 20, y: 0))
                path.addLine(to: CGPoint(x: 0, y: 20))
                path.addLine(to: CGPoint(x: 0, y: 0))
                pinnedRoundedLayer.path = path
                
                self.pinnedTriangleLayer = pinnedRoundedLayer
            }
            
            if let triangleLayer = pinnedTriangleLayer {
                self.layer.addSublayer(triangleLayer)
            }
            
            self.layer.borderColor = UIColor.AertripColor.cgColor
            self.layer.borderWidth = 0.5
            
            
        }
        else {
            pinnedTriangleLayer?.removeFromSuperlayer()
            self.layer.borderWidth = 0
        }
    }
    
    
    
    func showTemplateView() {
        
        duration.isHidden = true
        stopCountLabel.isHidden = true
        self.addShimmerEffect(to: [iconOne ,flightCode ,departureTime , arrivalTime ,departureAirportCode , arrivalAirportCode , price ] )
    }
    
    
    fileprivate func setStopsUI(_ journey: Journey) {
        let stopsCount = journey.loap.count
        switch stopsCount {
        case 0 :
            dashedView.isHidden = false
            stopCountLabel.isHidden = true
            stopsBackgroundView.isHidden = true
        case 1 :
            dashedView.isHidden = false
            stopsBackgroundView.isHidden = false
            stopCountLabel.isHidden = true
            addStopsRoundedView(count: 1)
        case 2 :
            dashedView.isHidden = false
            stopsBackgroundView.isHidden = false
            stopCountLabel.isHidden = true
            addStopsRoundedView(count: 2)
        default :
            stopsBackgroundView.isHidden = true
            dashedView.isHidden = true
            stopCountLabel.text = "\(stopsCount) Stops"
            stopCountLabel.textColor = UIColor.ONE_FIVE_THREE_COLOR
        }
    }
    
    func addStopsRoundedView(count : Int ) {
        
        stopsBackgroundView.subviews.forEach { $0.removeFromSuperview() }
        
        
        if count == 1 {
            
            let view1 = UIView(frame: CGRect(x: 6, y: 0, width: 6 , height: 6))
            view1.backgroundColor = UIColor.AertripColor
            view1.layer.cornerRadius = 3.0
            stopBackgroundViewWidth.constant = 18
            stopsBackgroundView.addSubview(view1)
            
        }
        
        if count == 2 {
            
            let view1 = UIView(frame: CGRect(x: 6, y: 0, width: 6 , height: 6))
            view1.backgroundColor = UIColor.AertripColor
            view1.layer.cornerRadius = 3.0
            
            let view2 = UIView(frame: CGRect(x: 20, y: 0, width: 6 , height: 6))
            view2.backgroundColor = UIColor.AertripColor
            view2.layer.cornerRadius = 3.0
            
            stopBackgroundViewWidth.constant = 32.0
            stopsBackgroundView.addSubview(view1)
            stopsBackgroundView.addSubview(view2)
        }
        
    }
    
    func showDetailsFrom(journey : Journey, selectedJourney : Journey?) {
        
        currentJourney = journey
        if journey.isPinned ?? false {
            setPinnedFlight()
        }
        
        duration.isHidden = false
        stopCountLabel.isHidden = false
        if journey.al.count == 1 {
            flightCode.text = journey.flightCode
        }
        else {
            flightCode.isHidden = true
        }
        departureTime.text = journey.startTime
        arrivalTime.attributedText = journey.endTime16size
        arrivalTimeWidth.constant = arrivalTime.intrinsicContentSize.width
        
        arrivalAirportCode.text = journey.destinationIATACode
        departureAirportCode.text = journey.originIATACode
        //        self.price.text = journey.priceAsString
        
//        let amountText = NSMutableAttributedString.init(string: journey.priceAsString)
//
//
//        amountText.setAttributes([NSAttributedString.Key.font: AppFonts.Regular.withSize(14)], range: NSMakeRange(0, 1))
//
//        self.price.attributedText = amountText
        
        
        self.price.attributedText = journey.farepr.getConvertedAmount(using: AppFonts.SemiBold.withSize(18))

        
        self.priceWidth.constant =  self.price.intrinsicContentSize.width
        self.duration.text = journey.durationTitle
        
        if journey.isFastest ?? false  {
            duration.textColor = .AERTRIP_ORAGE_COLOR
        }
        
        if journey.isCheapest ?? false {
            price.textColor = .AERTRIP_ORAGE_COLOR
        }
        
        baggageSuperScript = journey.baggageSuperScript
        smartIconsArray = journey.smartIconArray
        smartIconCollectionView.reloadData()
        
        setStopsUI(journey)
        
        showSelection(journey: journey, selectedJourney: selectedJourney)
        
    }
    
    func showSelection(journey : Journey, selectedJourney : Journey?){
    
        var isSelected = false
        
        if let sselJourney = selectedJourney, sselJourney.fk == journey.fk  {
            isSelected = true
        } else {
            isSelected = false
        }
        
        let selectedStateBGColor = AppColors.calendarSelectedGreen//AppColors.themeGreenishWhite//UIColor(displayP3Red: (236.0/255.0), green: (253.0/255.0), blue: (244.0/255.0), alpha: 1.0)
        
        let backgroundColor = isSelected ? selectedStateBGColor : AppColors.themeWhiteDashboard
        
               // if ( duration.isHidden == false) {
                    self.backgroundColor = backgroundColor
                    stopsBackgroundView.backgroundColor = backgroundColor
                    price.backgroundColor = backgroundColor
                    setupGradientView(selectedColor: backgroundColor)
              //  }
        
    }
    
    
    override func prepareForReuse() {
        
        self.layer.borderWidth = 0
        
        pinnedTriangleLayer?.removeFromSuperlayer()
        duration.textColor = AppColors.themeBlack
        price.textColor = AppColors.themeBlack
        dashedView.isHidden = false
        stopCountLabel.isHidden = true
        flightCode.isHidden = false
        stopCountLabel.textColor = UIColor.ONE_FIVE_THREE_COLOR
        
        priceWidth.constant = 100
        stopsBackgroundView.subviews.forEach { $0.removeFromSuperview() }
        super.prepareForReuse()
    }
    
    
    func textToImage(drawText text: String, diameter: CGFloat, color: UIColor ) -> UIImage {
        let textColor = UIColor.white
//        let textFont = UIFont(name: "SourceSansPro-Semibold", size: 16)!
        
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


extension DomesticMultiLegCell : UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if section == 0 {
            if baggageSuperScript?.string.uppercased() == "0P" || baggageSuperScript?.string == "0" {
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
            cell.imageView.image = AppImages.checkingBaggageKg
            cell.superScript.attributedText = baggageSuperScript
            cell.superScriptWidth.constant = 14
            cell.imageViewLeading.constant = 0
        }
        else {
            guard let imageName = smartIconsArray?[indexPath.row] else { return UICollectionViewCell() }
            
            if  imageName.lowercased() == "fsr" {
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
            
            if imageName.lowercased() == "refundStatusPending".lowercased() {
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
//        headerView.frame = CGRect(x: 0, y: 5, width: 1.0, height: collectionView.frame.height)
        
//        headerView.backgroundColor = UIColor.yellow
        
//        headerView.backgroundColor = UIColor(displayP3Red: ( 204.0 / 255.0), green: ( 204.0 / 255.0), blue: ( 204 / 255.0), alpha: 1.0)

        
        return headerView
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .zero
        }else {
            if smartIconsArray?.count == 0  || baggageSuperScript?.string.lowercased() == "0p" || baggageSuperScript?.string == "0" {
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
