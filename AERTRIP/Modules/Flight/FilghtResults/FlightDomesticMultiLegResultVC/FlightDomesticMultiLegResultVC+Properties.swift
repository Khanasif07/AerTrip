//
//  FlightDomesticMultiLegResultVC.swift
//  Aertrip
//
//  Created by  hrishikesh on 22/04/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit
import SnapKit
import MessageUI

class FlightDomesticMultiLegResultVC: UIViewController , NoResultScreenDelegate , MFMailComposeViewControllerDelegate
{
    //MARK:- Outlets
    var bannerView : ResultHeaderView?
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var baseScrollView: UIScrollView!
    @IBOutlet weak var showPinnedSwitch: AertripSwitch!
    @IBOutlet weak var unpinnedAllButton: UIButton!
    @IBOutlet weak var emailPinnedFlights: UIButton!
    @IBOutlet weak var sharePinnedFilghts: UIButton!
    @IBOutlet weak var pinnedFlightOptionView: UIView!
    
    //MARK:- NSLayoutConstraints
    @IBOutlet weak var pinnedFlightOptionsTop: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var baseScrollViewTop: NSLayoutConstraint!
    @IBOutlet weak var headerCollectionViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var pinOptionsViewWidth: NSLayoutConstraint!
    @IBOutlet weak var unpinAllLeading: NSLayoutConstraint!
    @IBOutlet weak var emailPinnedFlightLeading: NSLayoutConstraint!
    @IBOutlet weak var sharePinnedFlightsLeading: NSLayoutConstraint!
    //MARK:- State Properties
    var resultsTableViewStates =  [ResultTableViewState]()
    var stateBeforePinnedFlight = [ResultTableViewState]()
    var showPinnedFlights = false
    var numberOfLegs : Int
    var results = [DomesticMultilegJourneyResultsArray]()
    var sortedJourneyArray = [[Journey]]()
    var sortOrder = Sort.Smart
    var comboResults = [CombinationJourney]()
    var journeyHeaderViewArray = [JourneyHeaderView]()
    var headerArray : [MultiLegHeader]
    
    var taxesResult : [String : String]!
    var airportDetailsResult : [String : AirportDetailsWS]!
    var airlineDetailsResult : [String : AirlineMasterWS]!

    var flightsResults  =  FlightsResults()
    var sid : String = ""
    var bookFlightObject = BookFlightObject()

    var titleString : NSAttributedString!
    var subtitleString : String!
    
    var testView = UIView()

    var flightSearchType : FlightSearchType
    var fareBreakupVC : FareBreakupVC?
    let journeyCompactViewHeight : CGFloat = 44.0
    var scrollviewInitialYOffset = CGFloat(0.0)
//    var debugVisibilityView = UIView()
//    var firstVisibleRectView = UIView()
    var statusBarHeight : CGFloat {
        return UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
    }
        
    var lastTargetContentOffsetX: CGFloat = 0
    //MARK:-  Initializers
    
    convenience init(numberOfLegs  : Int , headerArray : [MultiLegHeader] ) {
        self.init(nibName:nil, bundle:nil)
        self.numberOfLegs = numberOfLegs
        self.headerArray = headerArray
        self.flightSearchType = flightSearchType
        results = Array(repeating: DomesticMultilegJourneyResultsArray(sort: .Smart), count: numberOfLegs)
        sortedJourneyArray = Array(repeating: [Journey](), count: numberOfLegs)
        resultsTableViewStates =  Array(repeating: .showTemplateResults , count: numberOfLegs)
        stateBeforePinnedFlight = Array(repeating: .showRegularResults, count: numberOfLegs)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.numberOfLegs = 0
        self.headerArray = [MultiLegHeader]()
        self.flightSearchType = RETURN_JOURNEY
        results = Array(repeating: DomesticMultilegJourneyResultsArray(sort: .Smart), count: 0)
        sortedJourneyArray = Array(repeating: [Journey](), count: 0)
        resultsTableViewStates =  Array(repeating: .showTemplateResults , count: 0)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.numberOfLegs = 0
        self.flightSearchType = RETURN_JOURNEY
        self.headerArray = [MultiLegHeader]()
        results = Array(repeating: DomesticMultilegJourneyResultsArray(sort: .Smart), count: 0)
        sortedJourneyArray = Array(repeating: [Journey](), count: 0)
        resultsTableViewStates =  Array(repeating: .showTemplateResults , count: 0)

        super.init(coder: aDecoder)
    }
    
    
    //MARK:- View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupHeaderView()
        setupScrollView()
        setupPinnedFlightsOptionsView()
        showHintAnimation()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width =  UIScreen.main.bounds.size.width / 2.0
        let height = self.baseScrollView.frame.height + statusBarHeight + 88.0
        baseScrollView.contentSize = CGSize( width: (CGFloat(numberOfLegs) * width ), height:height)

        for view in self.baseScrollView.subviews
        {
            if view is JourneyHeaderView {
                continue
            }
            
            var frame = view.frame
            frame.size.height = height
            view.frame = frame
        }
    }

    //MARK:- Additional UI Methods

     func updateUIForTableviewAt(_ index: Int) {
        DispatchQueue.main.async {
            if let tableView = self.baseScrollView.viewWithTag( 1000 + index) as? UITableView {
                let selectedIndex = tableView.indexPathForSelectedRow
                tableView.reloadData()
                
                // setting up header for table view
                let width = UIScreen.main.bounds.size.width / 2.0
                let headerRect = CGRect(x: 0, y: 0, width: width, height: 138.0)
                tableView.tableHeaderView = UIView(frame: headerRect)
                
                
                //selecting tableview cell
                if (selectedIndex != nil) {
                    tableView.selectRow(at:selectedIndex, animated: false, scrollPosition: .none)
                }
                let indexPath : IndexPath
                if (self.results[index].suggestedJourneyArray.count > 0 ) {
                    indexPath = IndexPath(row: 0, section: 0)
                    tableView.selectRow(at: indexPath , animated: false, scrollPosition: .none)
                    self.hideHeaderCellAt(index: index)
                }
                else  {
                         if (self.results[index].expensiveJourneyArray.count > 0 ){
                        indexPath = IndexPath(row: 0, section: 1)
                        tableView.selectRow(at: indexPath , animated: false, scrollPosition: .none)
                        self.hideHeaderCellAt(index: index)
                    }
                         else {
                            print("Into Else else")
                    }
                }
                tableView.isScrollEnabled = true
            }
            
            //setting footer for table view
            if self.resultsTableViewStates[index] == .showExpensiveFlights {
                self.setExpandedStateFooterAt(index: index)
            }
            else {
                self.setGroupedFooterViewAt(index: index)
            }
            self.setTotalFare()
        }
    }
    
    func updateUI(index : Int , updatedArray : [Journey] , sortOrder : Sort) {
    
        results[index].journeyArray = updatedArray
        results[index].sort = sortOrder
        self.sortOrder = sortOrder
        sortedJourneyArray[index] = Array(results[index].sortedArray)
        
        let currentState =  resultsTableViewStates[index]
        if currentState == .showTemplateResults || currentState == .showNoResults {
            if updatedArray.count == 0 {
                return
            }
            resultsTableViewStates[index] = .showRegularResults
        }
        DispatchQueue.main.async {
            if let errorView = self.baseScrollView.viewWithTag( 500 + index) {
                if updatedArray.count > 0 {
                    errorView.removeFromSuperview()
                }
            }
                self.updateUIForTableviewAt(index)
                self.checkForOverlappingFlights()
        }
    }
    

    
    fileprivate func setTotalFare() {
        if let selectedJourneys = self.getSelectedJourneyForAllLegs() {
            
            if selectedJourneys.count == numberOfLegs {
                ShowFareBreakupView()
                let containsPinnedFlight = results.reduce(false) { $0 || $1.containsPinnedFlight }
                showPinnedFlightSwitch(containsPinnedFlight)
            }
        }
        else {
            hideFareBreakupView()
        }
        
    }
    
    func updateReceivedAt(index : Int , updatedArray : [Journey] , sortOrder : Sort) {
        animateTableBanner(index: index , updatedArray: updatedArray, sortOrder: sortOrder)
    }
    

    func showNoResultScreenAt(index: Int) {
        addErrorScreenAtIndex(index: index, forFilteredResults: false)
    }
    
    
    func showNoFilteredResults(index: Int) {
        addErrorScreenAtIndex(index: index, forFilteredResults: true)
    }
    
   
     //MARK:- Logical methods
    
     func  getSelectedJourneyForAllLegs() -> [Journey]? {
        
        var selectedJourneys = [Journey]()
        
        for index in 0 ..< numberOfLegs {
            
            let tableResultState = resultsTableViewStates[index]
            if tableResultState == .showTemplateResults {  return nil }
            
            if let tableView = baseScrollView.viewWithTag( 1000 + index ) as? UITableView {
                
                guard let selectedIndex = tableView.indexPathForSelectedRow else {
                    return nil }
                
                var currentJourney : Journey
                let currentArray : [Journey]
                switch tableResultState {
                case .showExpensiveFlights :
                    if selectedIndex.section == 1 {
                        currentArray = results[index].expensiveJourneyArray
                    }else {
                        currentArray = results[index].suggestedJourneyArray
                    }
                    
                    if selectedIndex.row < currentArray.count {
                        currentJourney = currentArray[selectedIndex.row]
                        selectedJourneys.append(currentJourney)
                    }
                    else {
                        return nil
                    }
                case .showPinnedFlights :   
                    
                    if selectedIndex.row > results[index].pinnedFlights.count {
                        return nil
                    }
                    
                    currentJourney = results[index].pinnedFlights[selectedIndex.row]
                    selectedJourneys.append(currentJourney)

                case .showRegularResults :
                    
                    let suggestedJourneyArray = results[index].suggestedJourneyArray
                    if suggestedJourneyArray?.count ?? 0 > 0 {
                        currentJourney = results[index].suggestedJourneyArray[selectedIndex.row]
                        selectedJourneys.append(currentJourney)
                    }
                    
                case .showTemplateResults :
                    assertionFailure("Invalid state")
                case .showNoResults:
                    return nil
                }
                
            }
        }
        if selectedJourneys.count == numberOfLegs {
            return selectedJourneys
        }
        print("getSelectedJourneyForAllLegs return five")
        return nil
    }
    
    
    fileprivate func setTextColorToHeader(_ color : UIColor , indexPath : Int ) {
        
        let index = IndexPath(item: indexPath, section: 0)
        if let headerCell =  headerCollectionView.cellForItem(at: index) as? FlightSectorHeaderCell
        {
                if color == .black {
                    headerCell.setBlackColoredTitles()
                }
                else {
                    headerCell.setRedColoredTitles()
                }
        }
    }

    
    func formatted(fare : Int ) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale.init(identifier: "en_IN")
        return formatter.string(from: NSNumber(value: fare)) ?? ""
    }
    
    func checkForComboFares() {
        
        if let selectedJourneys = getSelectedJourneyForAllLegs() {
            
            let fkArray = selectedJourneys.map( {
                return $0.fk
            })
            
            if let comboResultFiltered = comboResults.first(where: {$0.fk == fkArray }) {
                
                fareBreakupVC?.journeyCombo = [comboResultFiltered]
            }
        }
    }
    
    func checkForOverlappingFlights()
    {
        fareBreakupVC?.bookButton.isEnabled = true
        for i in 0 ..< numberOfLegs {
              setTextColorToHeader(.black, indexPath: i)
        }

        if let selectedJourneys = getSelectedJourneyForAllLegs() {
            
            if selectedJourneys.count >= 2 {
            
                for i in 0 ..< (selectedJourneys.count - 1) {
                    
                    let currentLegJourney = selectedJourneys[i]
                    let nextLegJourney = selectedJourneys[(i + 1)]
                    
                    let fsr = currentLegJourney.fsr + nextLegJourney.fsr

                    guard let currentLegArrival = currentLegJourney.arrivalDate else { return }
                    guard let nextLegDeparture = nextLegJourney.departureDate else { return }
                    
                    if nextLegDeparture < currentLegArrival {
                        if let parentVC = self.parent {
                            
                            var frame = parentVC.view.frame
                            let bottomInset = self.view.safeAreaInsets.bottom
                            let height = 50 + bottomInset
                            frame.size.height = frame.size.height - height
                            
                            if fsr > 0 {
                                frame.size.height = frame.size.height - 16
                            }
                            
                            //Gurpreet
                        AppToast.default.hideToast(parentVC, animated: false)
                            
                        delay(seconds: 0.3) {
                            AertripToastView.toast(in: parentVC.view , withText: "Flight timings are not compatible. Select a different flight." , parentRect: frame)
                            }
                            
//                            AppToast.default.showToastMessage(message: "Flight timings are not compatible. Select a different flight.", onViewController: parentVC, spaceFromBottom : bottomInset)

                            
                            setTextColorToHeader(.AERTRIP_RED_COLOR, indexPath: i)
                            setTextColorToHeader(.AERTRIP_RED_COLOR, indexPath: (i + 1 ))
                            fareBreakupVC?.bookButton.isEnabled = false
                            
                        }
                    }
                    else if nextLegDeparture.timeIntervalSince(currentLegArrival) <= 7200 {
                        if let parentVC = self.parent {

                            var frame = parentVC.view.frame
                            let bottomInset = self.view.safeAreaInsets.bottom
                            let height = 50 + bottomInset
                            frame.size.height = frame.size.height - height

                            if fsr > 0 {
                                frame.size.height = frame.size.height - 16
                            }
                            
                             //Gurpreet
                            AppToast.default.hideToast(parentVC, animated: false)

                            delay(seconds: 0.3) {
                                AertripToastView.toast(in: parentVC.view , withText: "Selected flights have less than 2 hrs of gap." , parentRect: frame)
                            }
                            
//                            AppToast.default.showToastMessage(message: "Selected flights have less than 2 hrs of gap.", onViewController: parentVC, spaceFromBottom : bottomInset)
                            
                        }
                    }
                    else {
                        setTextColorToHeader(.black, indexPath: i)
                        setTextColorToHeader(.black, indexPath: (i + 1 ))
                    }
                    
                }
            }
        }
    }
    
    
    //MARK:- Target  methods
    @IBAction func PinnedFlightSwitchTogged(_ sender: AertripSwitch) {
        
        
        if sender.isOn  {
            showPinnedFlights = true
            stateBeforePinnedFlight = resultsTableViewStates
            resultsTableViewStates = Array(repeating: .showPinnedFlights, count: numberOfLegs)
            for subView in self.baseScrollView.subviews {
                if let tableview = subView as? UITableView {
                    let index = tableview.tag - 1000
                    let count = results[index].pinnedFlights.count
                    
                    
                    if count > 0 {
                        tableview.reloadData()
                        tableview.tableFooterView = nil

                        let indexPath = IndexPath(row: 0, section: 0)
                        tableview.scrollToRow(at: indexPath, at: .top, animated: true)
                        tableview.selectRow(at: indexPath , animated: false, scrollPosition: .none)
                    }
                    else {
                        addErrorScreenAtIndex(index: index , forFilteredResults: true)
                    }
                }
            }
            self.baseScrollView.setContentOffset(.zero, animated: true)
            hidePinnedFlightOptions(false)
        }
        else {
            showPinnedFlights = false
            resultsTableViewStates = stateBeforePinnedFlight
            for index in 0 ..< numberOfLegs {
                if let errorView = self.baseScrollView.viewWithTag( 500 + index) {
                        errorView.removeFromSuperview()
                }
                self.updateUIForTableviewAt(index)
            }
            hidePinnedFlightOptions(true)
        }
        
        self.setTotalFare()
        let containsPinnedFlight = results.reduce(false) { $0 || $1.containsPinnedFlight }
        showPinnedFlightSwitch(containsPinnedFlight)
        self.checkForOverlappingFlights()

    }
    
    @IBAction func unpinnedAllTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Unpin All?", message: "This action will unpin all the pinned flights and cannot be undone.", preferredStyle: .alert)

        alert.view.tintColor = UIColor.AertripColor
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
              }))
        alert.addAction(UIAlertAction(title: "Unpin all", style: .destructive, handler: { action in
            self.performUnpinnedAllAction()
        }))


        self.present(alert, animated: true, completion: nil)
    }

    
    func performUnpinnedAllAction() {
        resultsTableViewStates  = stateBeforePinnedFlight
        
        for index in 0 ..< numberOfLegs {
            
            // unpinning of all flights in array
            var legArray = results[index]
            if var journeyArray = legArray.journeyArray {
                
                for j in 0 ..<  journeyArray.count {
                    let journey = journeyArray[j]
                    journey.isPinned = false
                    journeyArray[j] = journey
                }
                
                legArray.journeyArray = journeyArray
                results[index] = legArray
                
                // Removal of ErrorScreen if pinned flights were 0
                if let errorView = self.baseScrollView.viewWithTag( 500 + index) {
                    if journeyArray.count > 0 {
                        errorView.removeFromSuperview()
                    }
                }
            }
            
            // updating UITableview state
            self.updateUIForTableviewAt(index)
            
        }
        
        showPinnedSwitch.isOn = false
        showPinnedFlights = false
        hidePinnedFlightOptions(true)
        showPinnedFlightSwitch(showPinnedSwitch.isOn)
        self.setTotalFare()
        self.checkForOverlappingFlights()
    }
    
        //MARK:- Emailing Pinned Flights

    func showEmailViewController(body : String) {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            // Configure the fields of the interface.
            composeVC.setSubject("Checkout these great flights I pinned on Aertrip!")
            composeVC.setMessageBody(body, isHTML: true)
            self.present(composeVC, animated: true, completion: nil)
        }
    }

    @IBAction func emailPinnedFlights(_ sender: Any) {

        let pinnedFlightsArray = results.reduce([]) { $0 + $1.pinnedFlights }
        guard let postData = generatePostDataForEmail(for: pinnedFlightsArray) else { return }
        executeWebServiceForEmail(with: postData as Data, onCompletion:{ (view)  in
            
        DispatchQueue.main.async {
            self.showEmailViewController(body : view)
            }
        })
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func generatePostDataForEmail( for journey : [Journey] ) -> Data? {
        
        
        let flightAdultCount = bookFlightObject.flightAdultCount
         let flightChildrenCount = bookFlightObject.flightChildrenCount
         let flightInfantCount = bookFlightObject.flightInfantCount
         let isDomestic = bookFlightObject.isDomestic
         
        guard let firstJourney = journey.first else { return nil}
        
         let cc = firstJourney.cc
         let ap = firstJourney.ap
         
         let trip_type = "single"
         
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"
        let departDate = inputFormatter.string(from: bookFlightObject.onwardDate)
         
        var valueString = "https://beta.aertrip.com/flights?trip_type=\(trip_type)&adult=\(flightAdultCount)&child=\(flightChildrenCount)&infant=\(flightInfantCount)&origin=\(ap[0])&destination=\(ap[1])&depart=\(departDate)&cabinclass=\(cc)&pType=flight&isDomestic=\(isDomestic)"
        
        
        for i in 0 ..< journey.count {
            let tempJourney = journey[i]
            valueString = valueString + "&PF[\(i)]=\(tempJourney.fk)"
        }

        var parameters = [ "u": valueString , "sid": bookFlightObject.sid ]
     
        
        let fkArray = journey.map{ $0.fk }
        
        for i in 0 ..< fkArray.count {
            let key = "fk%5B\(i)%5D"
            parameters[key] = fkArray[i]
        }
        
        
        let parameterArray = parameters.map { (arg) -> String in
          let (key, value) = arg
         
        let percentEscapeString = self.percentEscapeString(value!)
          return "\(key)=\(percentEscapeString)"
        }
        
        let data = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
        return data
    }
    
    
    func percentEscapeString(_ string: String) -> String {
      var characterSet = CharacterSet.alphanumerics
      characterSet.insert(charactersIn: "-._* ")
      
      return string
        .addingPercentEncoding(withAllowedCharacters: characterSet)!
        .replacingOccurrences(of: " ", with: "+")
        .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }
    
      fileprivate func executeWebServiceForEmail(with postData: Data , onCompletion:@escaping (String) -> ()) {
          let webservice = WebAPIService()
          
          webservice.executeAPI(apiServive: .getEmailUrl(postData: postData ) , completionHandler: {    (receivedData) in
    
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            if let currentParsedResponse = parse(data: receivedData, into: getPinnedURLResponse.self, with:decoder) {
                let data = currentParsedResponse.data
                if let view = data["view"] {
                  onCompletion(view)
                }
            }
          } , failureHandler : { (error ) in
              print(error)
          })
      }
    
    func addToTrip(journey : Journey) {
            let tripListVC = TripListVC(nibName: "TripListVC", bundle: nil)
            tripListVC.journey = [journey]
            tripListVC.modalPresentationStyle = .overCurrentContext
            self.present(tripListVC, animated: true, completion: nil)
    }
    
    
    @IBAction func sharePinnedFlights(_ sender: Any) {
        
        let pinnedFlightsArray = results.reduce([]) { $0 + $1.pinnedFlights }
        shareFlights(journeyArray: pinnedFlightsArray)
    }
    
    func shareFlights( journeyArray : [Journey]) {
        
        guard let postData = generatePostData(for: journeyArray ) else { return }
        executeWebServiceForShare(with: postData as Data, onCompletion:{ (link)  in
                        
            DispatchQueue.main.async {
                let textToShare = [ link ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
            }
        })
    }
    
    //MARK:- Sharing Journey
    
    
    func generatePostData( for journey : [Journey]) -> NSData? {
        
        var valueString = "https://beta.aertrip.com/flights?trip_type=return"

        // Adding Passanger Count
        let flightAdultCount = bookFlightObject.flightAdultCount
        let flightChildrenCount = bookFlightObject.flightChildrenCount
        let flightInfantCount = bookFlightObject.flightInfantCount
        valueString = valueString + "adult=\(flightAdultCount)&child=\(flightChildrenCount)&infant=\(flightInfantCount)"
        

        guard let firstJourney = journey.first else { return nil}

        let ap = firstJourney.ap
        valueString = valueString + "&origin=\(ap[0])&destination=\(ap[1])"
        
        
        // Flight Date
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"
        let departDate = inputFormatter.string(from: bookFlightObject.onwardDate)
        let returnDate = inputFormatter.string(from: bookFlightObject.returnDate)
        valueString = valueString + "&depart=\(departDate)&return=\(returnDate)"
        
        // Flight Class and Types
        let isDomestic = bookFlightObject.isDomestic
        let cabinclass = firstJourney.cc
        valueString = valueString + "&cabinclass=\(cabinclass)&pType=flight&isDomestic=\(isDomestic)"
        
        
        let postData = NSMutableData()

        
        for i in 0 ..< journey.count {
            let tempJourney = journey[i]
            valueString = valueString + "&PF[\(i)]=\(tempJourney.fk)"
        }
        
        let parameters = [
            [
                "name": "u",
                "value": valueString
            ]
        ]
        
        let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
        
        var body = ""
        let _: NSError? = nil
        for param in parameters {
            let paramName = param["name"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if let filename = param["fileName"] {
                let contentType = param["content-type"]!
                let fileContent = try! String(contentsOfFile: filename, encoding: String.Encoding.utf8)
                body += "; filename=\"\(filename)\"\r\n"
                body += "Content-Type: \(contentType)\r\n\r\n"
                body += fileContent
            } else if let paramValue = param["value"] {
                body += "\r\n\r\n\(paramValue)"
            }
        }
        
        
        guard let bodyData = body.data(using: String.Encoding.utf8) else { return nil }
        postData.append(bodyData)
        
        return postData
    }
    
    
    fileprivate func executeWebServiceForShare(with postData: Data , onCompletion:@escaping (String) -> ()) {
        let webservice = WebAPIService()
        
        webservice.executeAPI(apiServive: .getShareUrl(postData: postData ) , completionHandler: {    (data) in
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
  
            if let currentParsedResponse = parse(data: data, into: getPinnedURLResponse.self, with:decoder) {
                
                let data = currentParsedResponse.data
                if let link = data["u"] {
                    onCompletion(link)
                }
            }
        } , failureHandler : { (error ) in
            print(error)
        })
    }
    
    func setPinnedFlightAt(flightKey : String , indexPath : IndexPath , isPinned : Bool , tableIndex : Int ) {
        
        guard var journeyArray = results[tableIndex].journeyArray else { return }
        guard let index = journeyArray.firstIndex(where: {
            $0.fk == flightKey
        }) else {
            return
        }
        
        let journeyToToggle = journeyArray[index]
        journeyToToggle.isPinned = isPinned
        journeyArray[index] = journeyToToggle
        results[tableIndex].journeyArray = journeyArray
        
        if isPinned {
            showPinnedFlightSwitch(true)
        }
        else {
            let containsPinnedFlight = results.reduce(false) { $0 || $1.containsPinnedFlight }
            showPinnedFlightSwitch(containsPinnedFlight)
            
            if !containsPinnedFlight {
                resultsTableViewStates = stateBeforePinnedFlight
                for index in 0 ..< numberOfLegs {
                    // Removal of ErrorScreen if pinned flights were 0
                    if let errorView = self.baseScrollView.viewWithTag( 500 + index) {
                        if journeyArray.count > 0 {
                            errorView.removeFromSuperview()
                        }
                    }
                    // updating UITableview state
                    self.updateUIForTableviewAt(index)
                }
                showPinnedSwitch.isOn = false
                showPinnedFlights = false
                hidePinnedFlightOptions(true)
            }
        }
        
        //Updating pinned flight indicator in tableview Cell after pin / unpin action
        guard let tableview = self.baseScrollView.viewWithTag(1000 + tableIndex) as? UITableView  else { return }
        guard let cell = tableview.cellForRow(at: indexPath) as? DomesticMultiLegCell else { return }
        cell.setPinnedFlight()
    }
}


//MARK:- Header CollectionView Method
extension FlightDomesticMultiLegResultVC : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfLegs
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionView", for: indexPath) as? FlightSectorHeaderCell {
            cell.setUI( headerArray[indexPath.row])
            if ( indexPath.row == (headerArray.count - 1)) {
                cell.veticalSeparator.isHidden = true
            }
            else {
                cell.veticalSeparator.isHidden = false
            }
             return cell
        }
        return UICollectionViewCell()
        
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = UIScreen.main.bounds.size
        size.height = 50
        
        if numberOfLegs > 2 {
        
            if indexPath.row == 1 {
                size.width = size.width * 0.4
            }else {
                size.width = size.width * 0.5
            }
        }
        else {
           size.width = size.width * 0.5
        }
        return size
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let visibleRect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)

        guard let theAttributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        var cellFrameInSuperview = collectionView.convert(theAttributes.frame, to: self.view)
        cellFrameInSuperview.origin.y = 0.0
        
        // if tapped cell is completely visible , return
        if visibleRect.contains(cellFrameInSuperview) {
            return
        }
        else {
            let width = baseScrollView.frame.size.width / 2.0
            let offset : CGFloat
            if cellFrameInSuperview.origin.x < 0 {
                // cell is located at left side of screen
                offset = CGFloat(indexPath.row ) * width
                
            }else {
                // cell is located at right side of screen
                offset = CGFloat(indexPath.row - 1) * width
            }
            baseScrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
    }
}

//MARK:- TableView Data source , Delegate Methods
extension  FlightDomesticMultiLegResultVC : UITableViewDataSource , UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let index = tableView.tag - 1000
        let tableState = resultsTableViewStates[index]

        switch tableState {
        case .showExpensiveFlights :
        if sortOrder == .Smart  {
                return 2
            }
            else {
                return 1
            }
        case .showPinnedFlights, .showTemplateResults, .showNoResults :
            return 1
        case .showRegularResults :
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let index = tableView.tag - 1000

        let tableState = resultsTableViewStates[index]
        
        switch tableState {
        case .showTemplateResults:
                return 10
        case .showPinnedFlights:
            return results[index].pinnedFlights.count
        case .showExpensiveFlights:
            
            if sortOrder == .Smart {
                if section == 0 {
                    return results[index].suggestedJourneyArray.count
                }
                if section == 1 {
                    return results[index].expensiveJourneyArray.count
                }
            }
            else {
                return results[index].journeyArray.count
            }
        case .showRegularResults :
            if sortOrder == .Smart  {
                return results[index].suggestedJourneyArray.count
            }
              else {
                return results[index].belowThresholdHumanScore
            }
        case .showNoResults:
            return 0
        }
        
        return 0
        
    }
    
    fileprivate func setPropertiesToCellAt( index: Int, _ indexPath: IndexPath,  cell: DomesticMultiLegCell, _ tableView: UITableView) {
      
        let tableState = resultsTableViewStates[index]
        var arrayForDisplay = results[index].suggestedJourneyArray
     
        if tableState == .showPinnedFlights {
            arrayForDisplay = results[index].pinnedFlights
        }
        else
            {
                if sortOrder == .Smart {
                    
                    if tableState == .showExpensiveFlights && indexPath.section == 1 {
                        arrayForDisplay = results[index].expensiveJourneyArray
                    }
                }
                else {
                    arrayForDisplay =  self.sortedJourneyArray[index]
                }
        }
        if let journey = arrayForDisplay?[indexPath.row] {
            cell.showDetailsFrom(journey:  journey)
            if let logoArray = journey.airlineLogoArray {
                
                switch logoArray.count {
                case 1 :
                    cell.iconTwo.isHidden = true
                    cell.iconThree.isHidden = true
                    setImageto(tableView: tableView, imageView: cell.iconOne, url:logoArray[0] , index:  indexPath.row)
                case 2 :
                    cell.iconThree.isHidden = true
                    setImageto(tableView: tableView, imageView: cell.iconOne, url:logoArray[0] , index:  indexPath.row)
                    setImageto(tableView: tableView, imageView: cell.iconTwo, url:logoArray[1] , index:  indexPath.row)
                    
                case 3 :
                    setImageto(tableView: tableView, imageView: cell.iconOne, url:logoArray[0] , index:  indexPath.row)
                    setImageto(tableView: tableView, imageView: cell.iconTwo, url:logoArray[1] , index:  indexPath.row)
                    setImageto(tableView: tableView, imageView: cell.iconThree, url:logoArray[2] , index:  indexPath.row)
                default:
                    break
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = tableView.tag - 1000
        let tableState = resultsTableViewStates[index]

        if tableState == .showTemplateResults {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DomesticMultiLegTemplateCell") as? DomesticMultiLegTemplateCell{
            cell.selectionStyle = .none
            return cell
            }
        }
        else {
        
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DomesticMultiLegCell") as? DomesticMultiLegCell{
                cell.selectionStyle = .none
                setPropertiesToCellAt(index:index, indexPath, cell: cell, tableView)
                
                if #available(iOS 13, *) {
                    let interaction = UIContextMenuInteraction(delegate: self)
                    cell.addInteraction(interaction)
                }
                return cell
                }
            }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 123.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        animateJourneyCompactView(for: tableView)
        
        if flightSearchType == RETURN_JOURNEY {
            checkForComboFares()
        }
        checkForOverlappingFlights()
        setTotalFare()
//        let containsPinnedFlight = results.reduce(false) { $0 || $1.containsPinnedFlight }
//        showPinnedFlightSwitch(containsPinnedFlight)
        setTableViewHeaderAfterSelection(tableView: tableView )
    }
    
    func setImageto(tableView: UITableView,  imageView : UIImageView , url : String , index : Int ) {
        if let image = tableView.resourceFor(urlPath: url , forView: index) {
            
            let resizedImage = image.resizeImage(24.0, opaque: false)
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage.roundedRectImageFromImage(image: resizedImage, imageSize: CGSize(width: 24.0, height: 24.0), cornerRadius: 2.0)
        }
    }
}
