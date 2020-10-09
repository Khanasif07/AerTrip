//
//  FlightDetailsTableViewCell.swift
//  Aertrip
//
//  Created by Monika Sonawane on 16/09/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class FlightDetailsTableViewCell: UITableViewCell
{
    //MARK:- Outlets

    @IBOutlet weak var dashedView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var flightNameView: UIView!
    @IBOutlet weak var airlineImageView: UIImageView!
    @IBOutlet weak var flightNameLabel: UILabel!
    @IBOutlet weak var operatorLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var classNameLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var onArrivalPerformanceLabel: UILabel!
    @IBOutlet weak var onArrivalPerformanceView: UIView!
    @IBOutlet weak var onArrivalPerformanceViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var flightDetailsView: UIView!
    @IBOutlet weak var departureTimeLbl: UILabel!
    @IBOutlet weak var departureAirportLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!
    @IBOutlet weak var departureAirportAddressLabel: UILabel!
    @IBOutlet weak var departureTerminalLabel: UILabel!
    
    @IBOutlet weak var travellingTimeImageView: UIImageView!
    @IBOutlet weak var travelingtimeLabel: UILabel!
    @IBOutlet weak var equipmentsLabel: UILabel!
    
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var arrivalAirportLabel: UILabel!
    @IBOutlet weak var arrivalDateLabel: UILabel!
    @IBOutlet weak var arrivalAirportAddressLabel: UILabel!
    @IBOutlet weak var arrivalTerminalLabel: UILabel!

    @IBOutlet weak var arrivalPerformaceButton: UIButton!
    @IBOutlet weak var amenitiesDisplayView: UIView!
    @IBOutlet weak var amenitiesDisplayViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var amenitiesCollectionView: UICollectionView!
    @IBOutlet weak var onTimePerformanceSubView: UIView!
    @IBOutlet weak var onTimePerformanceSubViewWidth: NSLayoutConstraint!
    @IBOutlet weak var delayedPerformanceSubView: UIView!
    @IBOutlet weak var delayedPerformanceSubViewWidth: NSLayoutConstraint!
    @IBOutlet weak var cancelledPerformanceSubView: UIView!
    @IBOutlet weak var cancelledPerformanceSubViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var topSeperatorView: UILabel!
    @IBOutlet weak var topSeperatorViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomSeperatorView: UILabel!
    @IBOutlet weak var displayViewBottom: NSLayoutConstraint!
    
    //MARK:- Variable Declaration
    var amenitiesData = [String]()
    weak var amenitiesDelegate:getSelectedAmenitiesDelegate?
    
    var flightIndex = 0
    var flights : [FlightDetail]?
    var journey: Journey!
    var airportDetailsResult : [String : AirportDetailsWS]!

    var onTimePerformanceInPercent = 0
    var delayedPerformanceInPercent = 0
    var cancelledPerformanceInPercent = 0
    
    
    var count = -1
    var halt = ""
    var durationTitle = ""
    var ovgtf = -1
    var travellingTiming = ""
    
    var journeyTitle = ""
    //MARK:- Init Methods

    override func awakeFromNib() {
        super.awakeFromNib()

        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = UIColor.ONE_ZORE_TWO_COLOR.cgColor
        caShapeLayer.lineWidth = 0.5
        caShapeLayer.lineDashPattern = [2,3]
        let cgPath = CGMutablePath()
        let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: 0)]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        dashedView.layer.addSublayer(caShapeLayer)
        
        amenitiesCollectionView.delegate = self
        amenitiesCollectionView.dataSource = self

        onArrivalPerformanceView.clipsToBounds = true
        onArrivalPerformanceView.layer.cornerRadius = 1.5
        
        self.amenitiesCollectionView.register(UINib.init(nibName: "FlightAmenitiesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FlightAmenitiesCell")
        
        airlineImageView.layer.cornerRadius = 3

        arrivalDateLabel.layer.cornerRadius = 3
        arrivalAirportLabel.layer.cornerRadius = 3
        arrivalTerminalLabel.layer.cornerRadius = 3

        departureDateLabel.layer.cornerRadius = 3
        departureAirportLabel.layer.cornerRadius = 3
        departureTerminalLabel.layer.cornerRadius = 3
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        topSeperatorView.isHidden = true
        topSeperatorViewHeight.constant = 0        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAirlineImage(with url: String)
    {
        if let urlobj = URL(string: url){
            let urlRequest = URLRequest(url: urlobj)
            if let responseObj = URLCache.shared.cachedResponse(for: urlRequest) {
                let image = UIImage(data: responseObj.data)
                self.airlineImageView.image = image
            }else{
                self.airlineImageView.setImageWithUrl(url, placeholder: UIImage(), showIndicator: true)
            }
        }else{
            self.airlineImageView.setImageWithUrl(url, placeholder: UIImage(), showIndicator: true)
        }
    }
    
    
    func setTravellingTime(){
        var travellingTime = NSAttributedString()
        if count == 1{
            if halt != ""{
                if halt.contains(","){
                    halt = halt.replacingOccurrences(of: ",", with: ", ")
                }
                let main_string111 = "  \(durationTitle) \n   Via \(halt)  ."
                let string_to_color111 = "   Via \(halt)  "
                
                let arrivalAirportRange = (main_string111 as NSString).range(of: string_to_color111)
                let haltAtAttributedString = NSMutableAttributedString(string:main_string111)
                haltAtAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.clear , range: (main_string111 as NSString).range(of: "."))

                haltAtAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: arrivalAirportRange)
                haltAtAttributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(displayP3Red: 254.0/255.0, green: 242.0/255.0, blue: 199.0/255.0, alpha: 1.0), range: arrivalAirportRange)
                haltAtAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SourceSansPro-Regular", size: 14.0)! , range: (main_string111 as NSString).range(of: main_string111))

                travellingTime = haltAtAttributedString
            }else{
                travellingTime = NSAttributedString(string: durationTitle)
            }
        }else{
            if halt != ""{
                let main_string111 = "\(travellingTiming) \n    Via \(halt)  ."
                let string_to_color111 = "   Via \(halt)  "
                
                let arrivalAirportRange = (main_string111 as NSString).range(of: string_to_color111)
                let haltAtAttributedString = NSMutableAttributedString(string:main_string111)
                haltAtAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: arrivalAirportRange)
                haltAtAttributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(displayP3Red: 254.0/255.0, green: 242.0/255.0, blue: 199.0/255.0, alpha: 1.0), range: arrivalAirportRange)
                haltAtAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.clear , range: (main_string111 as NSString).range(of: "."))
                haltAtAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SourceSansPro-Regular", size: 14.0)! , range: (main_string111 as NSString).range(of: main_string111))

                travellingTime = haltAtAttributedString
            }else{
                travellingTime = NSAttributedString(string:travellingTiming)
            }
        }
        
        if ovgtf == 1{
            let displayText = NSMutableAttributedString(string: "  ")
            displayText.append(travellingTime)
            let completeText = NSMutableAttributedString(string: "")
            
            let imageAttachment =  NSTextAttachment()
            
            imageAttachment.image = UIImage(named:"overnight.png")
            let imageOffsetY:CGFloat = -2.0;
            imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: 12, height: 12)
            let attachmentString = NSAttributedString(attachment: imageAttachment)
            completeText.append(attachmentString)
            
            completeText.append(displayText)
            travelingtimeLabel.attributedText = completeText
        }else{
            travelingtimeLabel.attributedText = travellingTime
        }
        
        travelingtimeLabel.textAlignment = .center
    }
    
    
    
    func setJourneyTitle(){
        if journeyTitle != ""{
            titleLabelHeight.constant = 25
            titleLabel.text = journeyTitle
        }else{
            titleLabelHeight.constant = 0
            titleLabel.text = ""
        }
    }
    
    
    func setArrivalAirportAddress(mainString:String,stringToColor:String)
    {
        let range = (mainString as NSString).range(of: stringToColor)
        
        let attribute = NSMutableAttributedString.init(string: mainString)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColors.themeBlack , range: range)
        arrivalAirportAddressLabel.attributedText = attribute
    }
    
    func setDepartureAirportAddress(mainString:String,stringToColor:String)
    {
        let range = (mainString as NSString).range(of: stringToColor)
        
        let attribute = NSMutableAttributedString(string: mainString, attributes: [.font: AppFonts.Regular.withSize(14), .foregroundColor: AppColors.themeGray40])
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range)
        departureAirportAddressLabel.attributedText = attribute
    }
    
    
    func addAttributsForRange(_ text: String, coloredString:String, color: UIColor, isForground:Bool = false)-> NSAttributedString{
        
        let range = (text as NSString).range(of: coloredString)
        let attribute = NSMutableAttributedString.init(string: text)
        if isForground{
             attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        }else{
             attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: color , range: range)
        }
       
        return attribute
    }
    
    
    func setDepartureDate(str:String,str1:String){
        let deptDateRange = (str as NSString).range(of: str1)
        let deptDateAttrStr = NSMutableAttributedString(string:str)
        deptDateAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: deptDateRange)
        deptDateAttrStr.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(displayP3Red: 254.0/255.0, green: 242.0/255.0, blue: 199.0/255.0, alpha: 1.0), range: deptDateRange)
        deptDateAttrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.clear , range: (str as NSString).range(of: "."))
        departureDateLabel.attributedText = deptDateAttrStr
    }
    
    
    func setClassNameLabelWidth(){
        let fontAttributes = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14)]
        let myText = classNameLabel.text
        let size = (myText! as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        classNameLabelWidth.constant = size.width

    }
    
    func dateConverter(dateStr:String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateStr){
            dateFormatter.dateFormat = "E, d MMM yyyy"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
}

extension FlightDetailsTableViewCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    //MARK:- CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return amenitiesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let amenitiesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlightAmenitiesCell", for: indexPath) as! FlightAmenitiesCollectionViewCell
        
        amenitiesCell.amenitiTitleLabel.textColor = AppColors.themeGray60
        amenitiesCell.amenitiTitleLabel.text = amenitiesData[indexPath.row]
        if amenitiesData[indexPath.row].contains(find: "Cabbin"){
            amenitiesCell.amenitiesImageView.image = UIImage(named: "cabinBaggage")
        }else if amenitiesData[indexPath.row].contains(find: "Check-in"){
            amenitiesCell.amenitiesImageView.image = UIImage(named: "checkingBaggageKg")
        }else{
            amenitiesCell.amenitiesImageView.image = nil
        }
        
        return amenitiesCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        amenitiesDelegate?.getSelectedAmenities(amenitiesData: ["amenityName":amenitiesData[indexPath.row]], index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width/3-10, height: collectionView.frame.size.height)
    }
}
