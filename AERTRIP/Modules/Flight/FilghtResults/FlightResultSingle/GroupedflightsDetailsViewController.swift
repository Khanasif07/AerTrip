//
//  GroupedFlightsDetailsViewController.swift
//  Aertrip
//
//  Created by  hrishikesh on 30/05/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit


protocol  GroupedFlightVCDelegate : AnyObject {
    func reloadRowAtIndex(indexPath: IndexPath , with  journeyDisplay: JourneyOnewayDisplay )
}

class GroupedFlightsDetailsViewController: UIViewController, UITableViewDataSource , UITableViewDelegate
{
    //MARK:- Outlets
    @IBOutlet weak var logoOne: UIImageView!
    @IBOutlet weak var logoTwo: UIImageView!
    @IBOutlet weak var logoThree: UIImageView!
    @IBOutlet weak var airlogoName: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var baseTimeView: UIView!
    @IBOutlet weak var FlightsCountBaseView: UIView!
    @IBOutlet weak var resultTableView: UITableView!
    
    //MARK:- Pinnned Flight Options Outlets
    @IBOutlet weak var pinnedFlightsOptionsView : UIView!
    @IBOutlet weak var showPinnedSwitch: AertripSwitch!
    @IBOutlet weak var unpinnedAllButton: UIButton!
    @IBOutlet weak var emailPinnedFlights: UIButton!
    @IBOutlet weak var sharePinnedFilghts: UIButton!
    @IBOutlet weak var pinnedFlightViewTop : NSLayoutConstraint!
    
    //MARK:- State Properties
    weak var delegate : GroupedFlightVCDelegate?
    var titleString : NSAttributedString!
    var subtitleString : String!
    var journeyGroupIndexPath : IndexPath!
    var resultTitle : UILabel!
    var resultsubTitle: UILabel!
    var journeyGroup: JourneyOnewayDisplay!
    var showPinnedFlights = false
    
    var airportDetailsResult : [String : AirportDetailsWS]!
    var airlineDetailsResult : [String : AirlineMasterWS]!
    var taxesResult : [String : String]!
    
    var flightsResults  =  FlightsResults()
    var sid : String = ""
    var bookFlightObject = BookFlightObject()
    var isJourneyPinned = false
    
    
    var pinnedFlights : [Journey] {
        return journeyGroup.journeyArray.filter{ $0.isPinned ?? false  }
    }
    
    //MARK:- View Controller Methods
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resultTitle.removeFromSuperview()
        resultsubTitle.removeFromSuperview()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationController?.navigationBar.addSubview(resultTitle)
        self.navigationController?.navigationBar.addSubview(resultsubTitle)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstJourney = journeyGroup.first
        self.airlogoName.text = firstJourney.airlinesSubString
        
        setHeaderText()
        
        resultTableView.register(UINib(nibName: "SingleJourneyResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SingleJourneyResultTableViewCell")
        resultTableView.separatorStyle = .none
        
        setTimeDotsView()
        addTitleToNavigationController()
        addSubTitleToNavigationController()
        setupPinnedFlightsOptionsView()
        
        if let logoArray = firstJourney.airlineLogoArray {
            
            switch logoArray.count {
            case 1 :
                logoTwo.isHidden = true
                logoThree.isHidden = true
                setImageFromPath(urlPath : logoArray[0] , to: logoOne)
            case 2 :
                logoThree.isHidden = true
                setImageFromPath(urlPath : logoArray[0] , to: logoOne)
                setImageFromPath(urlPath : logoArray[1] , to: logoTwo)
            case 3 :
                setImageFromPath(urlPath : logoArray[0] , to: logoOne)
                setImageFromPath(urlPath : logoArray[1] , to: logoTwo)
                setImageFromPath(urlPath : logoArray[2] , to: logoThree)
                
            default:
                break
            }
        }
        
        pinnedFlightViewTop.constant = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showPinnedFlightsOption(journeyGroup.containsPinnedFlight)
        
    }
    
    //MARK:- Additional UI methods
    
    fileprivate func setHeaderText() {
        var journeyArray = journeyGroup.journeyArray
        
        if showPinnedFlights {
            journeyArray = pinnedFlights
        }
        
        let sortedByDuration =   journeyArray.sorted(by: { $0.duration < $1.duration })
        let fastestFlight = sortedByDuration.first!
        
        if journeyArray.count == 1 {
            let summaryText = String(journeyArray.count) + " option found from " + fastestFlight.durationTitle
            summaryLabel.text = summaryText
        }
        else {
            let summaryText = String(journeyArray.count) + " options found from " + fastestFlight.durationTitle
            summaryLabel.text = summaryText
        }
    }
    
    
    fileprivate func setTimeDotsView() {
        
        
        for view in baseTimeView.subviews {
            view.removeFromSuperview()
        }
        
        
        var journeyArray = journeyGroup.journeyArray
        
        if showPinnedFlights {
            journeyArray = pinnedFlights
        }
        
        let groupedTimeDictionary = Dictionary(grouping: journeyArray , by: {$0.startTimePercentile})
        let sortedKeys = groupedTimeDictionary.keys.sorted(by: < )
        
        for key in sortedKeys {
            
            guard let journeyArray = groupedTimeDictionary[key] else { continue }
            guard let journey = journeyArray.first else { continue }
            
            let timeView = roudedView(isPined: journey.isPinned ?? false )
            var timeViewFrame = timeView.frame
            
            let leadingSpaceForBaseTimeView = CGFloat(125.0)
            let trailingSpaceForBaseTimeView = CGFloat(39.0)
            let width = UIScreen.main.bounds.size.width - leadingSpaceForBaseTimeView - trailingSpaceForBaseTimeView
            let xCoordinate = journeyArray.first!.startTimePercentile * CGFloat(width) - 5
            timeViewFrame.origin.x = xCoordinate
            timeView.frame = timeViewFrame
            baseTimeView.addSubview(timeView)
            
            
            if journeyArray.count > 1 {
                let count = String("\(journeyArray.count)")
                let countLabel = getFlightLabelWith(count: count)
                
                countLabel.center = CGPoint(x:timeView.center.x , y: 9.0)
                baseTimeView.addSubview(countLabel)
            }
        }
    }
    
    func getFlightLabelWith( count : String) -> UILabel
    {
        
        let label = UILabel(frame: CGRect(x:0 , y: 0, width: 20,  height: 18))
        label.textAlignment = .center
//        label.font = UIFont(name: "SourceSansPro-regular", size: 14)!
        label.font = AppFonts.Regular.withSize(14)

        label.textColor = .AertripColor
        label.text = count
        return label
    }
    
    func addTitleToNavigationController() {
        
        resultTitle = UILabel(frame: CGRect(x:0 , y: 1, width: UIScreen.main.bounds.size.width, height: 23))
//        resultTitle.font = UIFont(name: "SourceSansPro-semibold", size: 18)!
        resultTitle.font = AppFonts.SemiBold.withSize(18)

        resultTitle.attributedText = titleString
        resultTitle.textAlignment = .center
        
    }
    
    
    func addSubTitleToNavigationController() {
        
        
        resultsubTitle = UILabel(frame: CGRect(x:0 , y: 23, width: UIScreen.main.bounds.size.width, height: 17))
//        resultsubTitle.font = UIFont(name: "SourceSansPro-regular", size: 13)!
        resultsubTitle.font = AppFonts.Regular.withSize(13)

        resultsubTitle.text = subtitleString
        resultsubTitle.textAlignment = .center
        
    }
    
    func roudedView(isPined :Bool) -> UIView {
        
        let view = UIView(frame: CGRect(x: 0, y: 18 , width: 12, height: 12))
        view.backgroundColor = .white
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 6.0
        
        
        if isPined {
            view.layer.borderColor = UIColor.AERTRIP_RED_COLOR.cgColor
            
        }else {
            view.layer.borderColor = UIColor.AertripColor.cgColor
        }
        
        return view
    }
    
    func setupPinnedFlightsOptionsView() {
        
        showPinnedSwitch.offTintColor = UIColor.TWO_THREE_ZERO_COLOR
        showPinnedSwitch.tintColor = UIColor.TWO_ZERO_FOUR_COLOR
        showPinnedSwitch.isOn = false
        showPinnedSwitch.setupUI()
        hidePinnedFlightOptions(true)
        
        addShadowTo(showPinnedSwitch)
        addShadowTo(unpinnedAllButton)
        addShadowTo(emailPinnedFlights)
        addShadowTo(sharePinnedFilghts)
        
    }
    
    func showPinnedFlightsOption(_ show  : Bool) {
        
        let offsetFromBottom = show ? 60.0 : 0
        self.pinnedFlightViewTop.constant = CGFloat(offsetFromBottom)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    
    func addShadowTo(_ view : UIView) {
        
        view.layer.shadowOpacity = 0.2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    
    
    fileprivate func hidePinnedFlightOptions( _ hide : Bool)
    {
        //*******************Haptic Feedback code********************
           let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
           selectionFeedbackGenerator.selectionChanged()
        //*******************Haptic Feedback code********************

        printDebug("hide=\(hide)")
        if hide{
            
            //true - hideOption
            
            UIView.animate(withDuration: TimeInterval(0.4), delay: 0, options: .curveEaseOut, animations: { [weak self] in
                self?.showPinnedSwitch.isUserInteractionEnabled = false

                   self?.unpinnedAllButton.alpha = 0.0
                   self?.emailPinnedFlights.alpha = 0.0
                   self?.sharePinnedFilghts.alpha = 0.0
                   self?.unpinnedAllButton.transform = CGAffineTransform(translationX: 0, y: 0)
                   self?.emailPinnedFlights.transform = CGAffineTransform(translationX: 0, y: 0)
                   self?.sharePinnedFilghts.transform = CGAffineTransform(translationX: 0, y: 0)
                   }, completion: { [weak self] (success)
            in
                       self?.unpinnedAllButton.isHidden = true
                       self?.emailPinnedFlights.isHidden = true
                       self?.sharePinnedFilghts.isHidden = true
                       self?.unpinnedAllButton.alpha = 1.0
                       self?.emailPinnedFlights.alpha = 1.0
                       self?.sharePinnedFilghts.alpha = 1.0
                    self?.showPinnedSwitch.isUserInteractionEnabled = true
               })
        }else{
            //false - showOption
            self.unpinnedAllButton.alpha = 0.0
            self.emailPinnedFlights.alpha = 0.0
            self.sharePinnedFilghts.alpha = 0.0
            UIView.animate(withDuration: TimeInterval(0.4), delay: 0, options: [.curveEaseOut, ], animations: { [weak self] in
                self?.showPinnedSwitch.isUserInteractionEnabled = false

                self?.unpinnedAllButton.isHidden = false
                self?.emailPinnedFlights.isHidden = false
                self?.sharePinnedFilghts.isHidden = false

                self?.unpinnedAllButton.alpha = 1.0
                self?.emailPinnedFlights.alpha = 1.0
                self?.sharePinnedFilghts.alpha = 1.0
                self?.unpinnedAllButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self?.emailPinnedFlights.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self?.sharePinnedFilghts.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self?.emailPinnedFlights.transform = CGAffineTransform(translationX: 60, y: 0)
                self?.sharePinnedFilghts.transform = CGAffineTransform(translationX: 114, y: 0)
                self?.unpinnedAllButton.transform = CGAffineTransform(translationX: 168, y: 0)
                }, completion: { [weak self] (success)
                    in
                    self?.showPinnedSwitch.isUserInteractionEnabled = true
            })
        }
    }
//    {
//
//        let opacity : CGFloat =  hide ? 0.0 : 1.0
//        UIView.animate(withDuration: 0.5, delay: 0.0 ,
//                       options: UIView.AnimationOptions.curveEaseOut
//            , animations: {
//
//                self.emailPinnedFlights.alpha = opacity
//                self.unpinnedAllButton.alpha = opacity
//                self.sharePinnedFilghts.alpha = opacity
//
//        }) { (onCompletion) in
//
//            self.emailPinnedFlights.isHidden = hide
//            self.unpinnedAllButton.isHidden = hide
//            self.sharePinnedFilghts.isHidden = hide
//        }
//    }
    
    //MARK:- Image download methods
    func setImageto( imageView : UIImageView , url : String , index : Int ) {
        if let image = resultTableView.resourceFor(urlPath: url , forView: index) {
            
            let resizedImage = image.resizeImage(24.0, opaque: false)
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage.roundedRectImageFromImage(image: resizedImage, imageSize: CGSize(width: 24.0, height: 24.0), cornerRadius: 2.0)
        }
    }
    
    func setImageFromPath(urlPath : String  , to imageView : UIImageView) {
        
        guard  let urlobj = URL(string: urlPath) else { return }
        
        let urlRequest = URLRequest(url: urlobj)
        if let responseObj = URLCache.shared.cachedResponse(for: urlRequest) {
            
            let image = UIImage(data: responseObj.data)
            imageView.image = image
        }
    }
    
    
    
    // MARK:-  Actions to be performed on Journey objects
    
    func addToTripFlightAt(_ indexPath : IndexPath){
        
    }
    
    func shareFlightAt(_ indexPath : IndexPath) {
        
    }
    fileprivate func setPinnedFlightAt(_ indexPath: IndexPath , isPinned : Bool) {
        isJourneyPinned = isPinned
        let journey = journeyGroup.journeyArray[indexPath.row]
        journeyGroup.setPinned(isPinned, atIndex: indexPath.row)
        journeyGroup.journeyArray[indexPath.row] = journey
        resultTableView.reloadRows(at: [indexPath], with: .none)
        setTimeDotsView()
        
        showPinnedFlightsOption(journeyGroup.containsPinnedFlight)
        
        self.delegate?.reloadRowAtIndex(indexPath: journeyGroupIndexPath , with: journeyGroup )
        
    }
    
    func reloadRowAtIndexPath(index:[IndexPath], isPinned:Bool, fk: [String])
    {
        for indx in index{
            setPinnedFlightAt(indx , isPinned:  isPinned)
            
            //self.resultTableView.reloadRows(at: [indx], with: .none)
            
        }
    }
    
    
    //MARK:- Pinned Flights Action Methods
    @IBAction func PinnedFlightSwitchTogged(_ sender: AertripSwitch) {
        
        showPinnedFlights = sender.isOn
        hidePinnedFlightOptions(!sender.isOn)
        
        
        setTimeDotsView()
        setHeaderText()
        resultTableView.reloadData()
    }
    
    @IBAction func unpinnedAllTapped(_ sender: Any) {
        
        journeyGroup.journeyArray =  journeyGroup.journeyArray.map{
            //class to structure
            var journey = $0
            journey.isPinned = false
            return journey
        }
        showPinnedFlightsOption(false)
        showPinnedSwitch.isOn = false
        showPinnedFlights = false
        setTimeDotsView()
        setHeaderText()
        resultTableView.reloadData()
        self.delegate?.reloadRowAtIndex(indexPath: journeyGroupIndexPath , with: journeyGroup )
    }
    
    @IBAction func emailPinnedFlights(_ sender: Any) {
    }
    
    @IBAction func sharePinnedFlights(_ sender: Any) {
    }
    
    //MARK:-  Methods for TableviewCell Swipe Implementation
    //    fileprivate func createSwipeActionForLeftOrientation(_ indexPath: IndexPath) -> [UIContextualAction] {
    //
    //         let journey = journeyGroup.journeyArray[indexPath.row]
    //        if journey.isPinned ==  true {
    //
    //            let pinAction = UIContextualAction(style: .normal, title: nil , handler: { [weak self] (action, view , completionHandler) in
    //
    //                if let strongSelf = self {
    //                    strongSelf.setPinnedFlightAt(indexPath , isPinned:  false)
    //                }
    //                completionHandler(true)
    //            })
    //            pinAction.backgroundColor = .white
    //
    //            if let cgImageX =  UIImage(named: "Unpin")?.cgImage {
    //                pinAction.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
    //            }
    //            return [pinAction]
    //
    //        }
    //        else {
    //
    //            let pinAction = UIContextualAction(style: .normal, title: nil , handler: { [weak self] (action, view , completionHandler)  in
    //
    //                if let strongSelf = self {
    //                    strongSelf.setPinnedFlightAt(indexPath , isPinned:  true)
    //                }
    //                completionHandler(true)
    //            })
    //
    //            pinAction.backgroundColor = .white
    //
    //            if let cgImageX =  UIImage(named: "Pin")?.cgImage {
    //                pinAction.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
    //            }
    //
    //            return [pinAction]
    //
    //        }
    //    }
    //
    //    fileprivate func createSwipeActionsForRightOrientation(_ indexPath: IndexPath) -> [UIContextualAction] {
    //        let shareAction = UIContextualAction(style: .normal, title: nil , handler: { [weak self] (action, view , completionHandler) in
    //
    //            if let strongSelf = self {
    //                strongSelf.shareFlightAt(indexPath)
    //            }
    //            completionHandler(true)
    //        })
    //
    //        if let cgImageX =  UIImage(named: "Share")?.cgImage {
    //            shareAction.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
    //        }
    //        shareAction.backgroundColor = .white
    //
    //
    //        let addToTripAction = UIContextualAction(style: .normal, title: nil , handler: { [weak self]  (action, view , completionHandler) in
    //
    //            if let strongSelf = self {
    //                strongSelf.addToTripFlightAt(indexPath)
    //            }
    //            completionHandler(true)
    //        })
    //        addToTripAction.backgroundColor = .white
    //
    //        if let cgImageX =  UIImage(named: "AddToTrip")?.cgImage {
    //            addToTripAction.image = ImageWithoutRender(cgImage: cgImageX, scale: UIScreen.main.nativeScale, orientation: .up)
    //        }
    //
    //        return [addToTripAction, shareAction]
    //    }
    //
    //
    //    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //
    //        let configuration = UISwipeActionsConfiguration(actions: createSwipeActionForLeftOrientation(indexPath))
    //        return configuration
    //
    //    }
    //
    //    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //
    //        let configuration = UISwipeActionsConfiguration(actions: createSwipeActionsForRightOrientation(indexPath))
    //        return configuration
    //    }
    
    
    //MARK:- Tableview DataSource , Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if showPinnedFlights {
            return pinnedFlights.count
        }
        
        return journeyGroup.journeyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let cell =  resultTableView.dequeueReusableCell(withIdentifier: "SingleJourneyResultTableViewCell") as? SingleJourneyResultTableViewCell{
            cell.selectionStyle = .none
            
            var journeyArray = journeyGroup.journeyArray
            
            if showPinnedFlights {
                journeyArray = pinnedFlights
            }
            
            let singleJourney = journeyArray[indexPath.row]
            cell.setTitlesFrom( journey : singleJourney)
            
            if let logoArray = singleJourney.airlineLogoArray {
                
                switch logoArray.count {
                case 1 :
                    cell.logoTwo.isHidden = true
                    cell.logoThree.isHidden = true
                    setImageto(imageView: cell.logoOne, url:logoArray[0] , index:  indexPath.row)
                case 2 :
                    cell.logoThree.isHidden = true
                    setImageto(imageView: cell.logoOne, url:logoArray[0] , index:  indexPath.row)
                    setImageto(imageView: cell.logoTwo, url:logoArray[1] , index:  indexPath.row)
                    
                case 3 :
                    setImageto(imageView: cell.logoOne, url:logoArray[0] , index:  indexPath.row)
                    setImageto(imageView: cell.logoTwo, url:logoArray[1] , index:  indexPath.row)
                    setImageto(imageView: cell.logoThree, url:logoArray[2] , index:  indexPath.row)
                default:
                    break
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 123.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "FlightDetailsBaseVC", bundle: nil)
        let flightDetailsVC:FlightDetailsBaseVC =
            storyboard.instantiateViewController(withIdentifier: "FlightDetailsBaseVC") as! FlightDetailsBaseVC
        
        var journeyArray = journeyGroup.journeyArray
        
        if showPinnedFlights {
            journeyArray = pinnedFlights
        }
        flightDetailsVC.selectedIndex = indexPath
        flightDetailsVC.bookFlightObject = self.bookFlightObject
        flightDetailsVC.taxesResult = self.taxesResult
        flightDetailsVC.sid = sid
        flightDetailsVC.journey = [journeyArray[indexPath.row]]
        flightDetailsVC.titleString = titleString
        let selectedJourney = [journeyArray[indexPath.row]]
        for i in 0..<selectedJourney.count{
            let fk = selectedJourney[i].fk
            flightDetailsVC.selectedJourneyFK.append(fk)
        }
        
        flightDetailsVC.airportDetailsResult = airportDetailsResult
        flightDetailsVC.airlineDetailsResult = airlineDetailsResult
        self.present(flightDetailsVC, animated: true, completion: nil)
        
    }
}
