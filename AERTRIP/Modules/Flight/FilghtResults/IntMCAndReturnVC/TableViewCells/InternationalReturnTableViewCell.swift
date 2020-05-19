//
//  SingleJourneyResultTableViewCell.swift
//  Aertrip
//
//  Created by  hrishikesh on 26/04/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit


class InternationalReturnTableViewCell: UITableViewCell
{
    //MARK:- Outlets
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var priceWidth: NSLayoutConstraint!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var smartIconCollectionView: UICollectionView!
    @IBOutlet weak var multiFlightsTableView: UITableView!
    @IBOutlet weak var multiFlighrsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var samePriceOptionsLabel: UILabel!
    @IBOutlet weak var samePriceOptionButton: UIButton!
    @IBOutlet weak var optionsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    var pinnedRoundedLayer : CALayer?
    var smartIconsArray : [String]?
    var baggageSuperScript : NSAttributedString?
    var numberOfInnerCells = 0
    var currentJourney = IntMultiCityAndReturnWSResponse.Results.J(JSON())
    
    //MARK:- Setup Methods
    fileprivate func setupBaseView() {
        backgroundColor = .clear // very important
        layer.masksToBounds = false
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        self.baseView.layer.cornerRadius = 10
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        setupBaseView()
//        dashedView.setupDashedView()
//        let img = #imageLiteral(resourceName: "BackWhite")
//        let templetImage = img.withRenderingMode(.alwaysTemplate)
//        arrowImage.image = templetImage
//        arrowImage.tintColor = AppColors.themeGreen
        self.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(3 * (Double.pi)/2))
        setupGradientView()
        setupCollectionView()
        setUpTableView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
        override func prepareForReuse() {

    //        logoOne.isHidden = false
    //        logoTwo.isHidden = false
    //        logoThree.isHidden = false
    //        self.immediateAirportWidth.constant = 100
    //        self.intermediateAirports.isHidden = false

            self.baseView.layer.borderWidth = 0.0
    //        durationTime.textColor = UIColor.ONE_ZORE_TWO_COLOR
            price.textColor = .black
            priceWidth.constant = 170
            pinnedRoundedLayer?.removeFromSuperlayer()
            super.prepareForReuse()
        }
    
    func setupCollectionView() {
        smartIconCollectionView.register(UINib(nibName: "SmartIconCell", bundle: nil), forCellWithReuseIdentifier: "SmartIconCell")
        smartIconCollectionView.register(UINib(nibName: "smartIconHeaderView" , bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:"smartIconHeaderView")
        smartIconCollectionView.isScrollEnabled = false
        smartIconCollectionView.allowsSelection = false
        smartIconCollectionView.dataSource = self
        smartIconCollectionView.delegate = self
    }

    func setUpTableView(){
        multiFlightsTableView.register(UINib(nibName: "InternationalReturnJourneyCell", bundle: nil), forCellReuseIdentifier: "InternationalReturnJourneyCell")
        multiFlightsTableView.separatorStyle = .none
//        multiFlightsTableView.estimatedRowHeight  = 50
        multiFlightsTableView.rowHeight = UITableView.automaticDimension
        multiFlightsTableView.separatorStyle = .none
        multiFlightsTableView.isScrollEnabled = false
        multiFlightsTableView.bounces = false
        multiFlightsTableView.dataSource = self
        multiFlightsTableView.delegate = self
    }
    
    fileprivate func setupGradientView( selectedColor : UIColor = UIColor.white)
    {
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
    
    func textToImage(drawText text: String, diameter: CGFloat, color: UIColor ) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "SourceSansPro-Semibold", size: 16)!
        
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
    
    func populateData(journey : IntMultiCityAndReturnDisplay, indexPath : IndexPath){
          currentJourney = journey.first
        if currentJourney.isPinned {
            setPinnedFlight()
          }
          self.price.text = currentJourney.priceAsString
          multiFlightsTableView.reloadData()
          self.multiFlighrsTableViewHeight.constant = CGFloat(66 * currentJourney.legsWithDetail.count)
          smartIconCollectionView.reloadData()
          self.optionsViewHeight.constant = journey.count > 1 ? 45 : 0
//        self.optionsViewHeight.constant = 45
          self.samePriceOptionsLabel.text = "\(journey.count) options at same price"
          price.textColor = journey.isCheapest ? .AERTRIP_ORAGE_COLOR : UIColor.black
          self.priceWidth.constant =  self.price.intrinsicContentSize.width
          smartIconsArray = currentJourney.smartIconArray
          baggageSuperScript = currentJourney.baggageSuperScript
          self.indexLabel.text = "\(indexPath.section).....\(indexPath.row)"
        self.indexLabel.isHidden = true
        
      }
    
}

//MARK:- Tableview DataSource , Delegate Methods
extension InternationalReturnTableViewCell : UITableViewDataSource , UITableViewDelegate {

     func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentJourney.legsWithDetail.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(Double.leastNonzeroMagnitude)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Double.leastNonzeroMagnitude)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return getSingleJourneyCell(indexPath: indexPath)
    }
    
    func getSingleJourneyCell (indexPath : IndexPath) -> UITableViewCell {
        guard let cell =  multiFlightsTableView.dequeueReusableCell(withIdentifier: "InternationalReturnJourneyCell") as? InternationalReturnJourneyCell else {
            return UITableViewCell() }
        
        cell.populateData(leg : currentJourney.legsWithDetail[indexPath.row])
        
        return cell
    }

}

extension InternationalReturnTableViewCell : UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        if section == 0 {
            if baggageSuperScript?.string == "?" || baggageSuperScript?.string == "0P" {
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
    
    
    @objc func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          referenceSizeForHeaderInSection section: Int) -> CGSize {
    if section == 0 {
        return .zero
    }else {
        if smartIconsArray?.count == 0  || baggageSuperScript?.string == "?" || baggageSuperScript?.string == "0P" {
            return .zero
        }
        return CGSize(width: 21.0, height:  23.0)
      }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
         let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "smartIconHeaderView", for: indexPath)
         return headerView
     }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = smartIconCollectionView.dequeueReusableCell(withReuseIdentifier: "SmartIconCell", for: indexPath) as! SmartIconCell
        if indexPath.section == 0 {
            cell.imageView.image = UIImage(named: "checkingBaggageKg")
            cell.superScript.attributedText = baggageSuperScript
        }else {
            guard let imageName = smartIconsArray?[indexPath.row] else { return UICollectionViewCell() }
            if  imageName == "fsr" {
                let color = UIColor(displayP3Red:1.0 , green: ( 88.0/255.0), blue:( 77.0/255.0) , alpha: 1.0)
                let seats = currentJourney.seats
                    let tempImage = textToImage(drawText: seats, diameter:20.0 , color: color)
                    cell.imageView.image = tempImage
            }else{
                cell.imageView.image = UIImage(named: imageName)
            }
            
            if imageName == "refundStatusPending" {
                cell.superScript.text = "?"
                cell.superScript.textColor = UIColor.AERTRIP_RED_COLOR
                cell.superScript.font = UIFont(name: "SourceSansPro-Bold", size: 10.0)
            }else {
                cell.superScript.text = ""
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
