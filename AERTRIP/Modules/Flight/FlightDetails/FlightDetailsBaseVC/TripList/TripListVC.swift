//
//  TripListVC.swift
//  Aertrip
//
//  Created by Monika Sonawane on 08/11/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class TripListVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //MARK:- outlets
    @IBOutlet weak var tripListTableView: UITableView!
    
    //MARK:- Variables
    var journey = [Journey]()
    
    var intMCAndReturnJourney = [IntMultiCityAndReturnWSResponse.Results.J]()
    var isIntOrMulticityFlight = false
    
    var tripName = ""
    var timezone = "Automatic"
    var trip_id = ""
    var tripListDict = [[String:String]]()
    var selectedTripIndex = -1
    
    //MARK:- init view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tripListTableView.register(UINib(nibName: "FareBreakupTableViewCell", bundle: nil), forCellReuseIdentifier: "FareBreakupCell")
        
        tripListApiCall()
    }
    
    //MARK:- Tableview Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripListDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let fareBreakupCell = tableView.dequeueReusableCell(withIdentifier: "FareBreakupCell") as! FareBreakupTableViewCell
        fareBreakupCell.selectionStyle = .none
        fareBreakupCell.passangersView.isHidden = true
        
        if tripListDict.count > 0{
            if let name = (tripListDict[indexPath.row] as AnyObject).value(forKey: "tripName") as? String{
                fareBreakupCell.titleLabel.text = name
            }else{
                fareBreakupCell.titleLabel.text = ""
            }
            
            if indexPath.row == selectedTripIndex{
                fareBreakupCell.greenTickImgView.isHidden = false
            }else{
                fareBreakupCell.greenTickImgView.isHidden = true
            }
            
        }else{
            fareBreakupCell.titleLabel.text = ""
        }
        
        return fareBreakupCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedTripIndex = indexPath.row
        tripListTableView.reloadData()
    }
    
    //MARK:- Button Actions
    @IBAction func createTripButtonClicked(_ sender: Any)
    {
        let alert = UIAlertController(title: "Create New Trip", message: "Name Your Trip", preferredStyle: .alert)
        
        let addButton = UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            
            let textField = alert?.textFields![0]
            if textField!.text != ""{
//                print("Text field: \(textField!.text!)")
                self.createTripAPICall(tripName: textField!.text!)
            }
        })
        
        alert.addAction(addButton)
        addButton.isEnabled = false
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Trip Name"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { (notification) in
                addButton.isEnabled = textField.text!.count > 0
            }
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any)
    {
        if selectedTripIndex == -1{
            AertripToastView.toast(in: self.view, withText: "Please select Trip")
        }else{
            saveTripAPICall()
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:-API Call
    func tripListApiCall(){
        let webservice = WebAPIService()
        webservice.executeAPI(apiServive: .tripList(ass: ""), completionHandler: { (data) in
            do{
                let jsonResult:AnyObject?  = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                
                DispatchQueue.main.async {
                    if let result = jsonResult as? [String: AnyObject] {
                        if let dataVal = result["data"] as? JSONDictionary {
                            if let activeArray = dataVal["active"] as? NSArray{
                                for i in 0...activeArray.count-1{
                                    let name = (activeArray[i] as AnyObject).value(forKey: "name") as? String
                                    let id = (activeArray[i] as AnyObject).value(forKey: "id") as? Int

                                    if i == 0{
                                        self.tripName = name!
                                        self.trip_id = "\(id!)"
                                    }
                                    let dict = ["tripName":name!,
                                                "tripId":"\(id!)"]
                                    self.tripListDict.append(dict)
                                }
                                self.tripListTableView.reloadData()
                            }
                        }
                    }
                }
            }catch{}
        } , failureHandler : { (error ) in
            print(error)
        })
    }
    
    func createTripAPICall(tripName:String){
        let postData = NSMutableData()
        
        let parameters = [
            [
                "name": "name",
                "value": tripName
            ]
        ]
        let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
        
        var body = ""
        let error: NSError? = nil
        for param in parameters {
            let paramName = param["name"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if let filename = param["fileName"] {
                let contentType = param["content-type"]!
                let fileContent = try! String(contentsOfFile: filename, encoding: String.Encoding.utf8)
                if (error != nil) {
                    print(error as Any)
                }
                body += "; filename=\"\(filename)\"\r\n"
                body += "Content-Type: \(contentType)\r\n\r\n"
                body += fileContent
            } else if let paramValue = param["value"] {
                body += "\r\n\r\n\(paramValue)"
            }
        }
        
        postData.append(body.data(using: String.Encoding.utf8)!)
        
        let webservice = WebAPIService()
        webservice.executeAPI(apiServive: .createTrip(tripData: postData as Data), completionHandler: { (data) in
            do{
                let jsonResult:AnyObject?  = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                
                DispatchQueue.main.async {
                    if let result = jsonResult as? [String: AnyObject] {
                        if result["success"] as? Bool == true{
                            self.tripListApiCall()
                            AertripToastView.toast(in: self.view, withText: "Trip added Successfully")
                        }else{
                            AertripToastView.toast(in: self.view, withText: "Something went wrong")
                        }
                    }
                }
            }catch{}
        } , failureHandler : { (error ) in
            print(error)
        })
    }
    
    func saveTripAPICall(){
        let postData = NSMutableData()
        var parameters = [[:]]
        if isIntOrMulticityFlight {
            parameters = getParametersForIntMCAndReturnJourney()
        } else {
            parameters = getParametersForJourney()
        }
        
        if let name = (tripListDict[selectedTripIndex] as AnyObject).value(forKey: "tripName") as? String{
            parameters.append([
                "name": "name",
                "value": name
            ])
        }
        
       
        if let id = (tripListDict[selectedTripIndex] as AnyObject).value(forKey: "tripId") as? String{
            parameters.append([
                "name": "trip_id",
                "value": id
            ])
        }
        
//        print("param= ", parameters)
        let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
        
        var body = ""
        let error: NSError? = nil
        for param in parameters {
            let paramName = param["name"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if let filename = param["fileName"] {
                let contentType = param["Content-Type"]!
                let fileContent = try? String(contentsOfFile: filename as! String, encoding: String.Encoding.utf8)
                if (error != nil) {
                    print(error!)
                }
                body += "; filename=\"\(filename)\"\r\n"
                body += "Content-Type: \(contentType)\r\n\r\n"
                body += fileContent!
            } else if let paramValue = param["value"] {
                body += "\r\n\r\n\(paramValue)"
            }
        }
        
        postData.append(body.data(using: String.Encoding.utf8)!)
        
        let webservice = WebAPIService()
        webservice.executeAPI(apiServive: .addToTrip(postData: postData as Data), completionHandler: { (data) in
            do{
                let jsonResult:AnyObject?  = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                
                DispatchQueue.main.async {
                    if let result = jsonResult as? [String: AnyObject] {
                        if result["success"] as? Bool == true{
                            
                            if let view = self.presentingViewController?.view{
                                self.dismiss(animated: true, completion: {
                                    AertripToastView.toast(in: view, withText: "Trip Saved Successfully")
                                })
                            }
                        }else{
                            AertripToastView.toast(in: self.view, withText: "Something went wrong")
                        }
                    }
                }
            }catch{}
        } , failureHandler : { (error ) in
            print(error)
        })
    }
    
    func getParametersForJourney() -> [[AnyHashable:Any]] {
        var parameters = [[:]]
        for i in 0...journey.count-1{
            parameters = [
                [
                    "name": "eventDetails[\(i)][airline_code]",
                    "value": "\(journey[i].al[0])"
                ],
                [
                    "name": "eventDetails[\(i)][depart_airport]",
                    "value": "\((journey[i].leg.first?.flights.first?.fr)!)"
                ],
                [
                    "name": "eventDetails[\(i)][arrival_airport]",
                    "value": "\((journey[i].leg.first?.flights.first?.to)!)"
                ],
                [
                    "name": "eventDetails[\(i)][flight_number]",
                    "value": "\((journey[i].leg.first?.flights.first?.fn)!)"
                ],
                [
                    "name": "eventDetails[\(i)][depart_terminal]",
                    "value": "\((journey[i].leg.first?.flights.first?.dtm)!)"
                ],
                [
                    "name": "eventDetails[\(i)][arrival_terminal]",
                    "value": "\((journey[i].leg.first?.flights.first?.atm)!)"
                ],
                [
                    "name": "eventDetails[\(i)][cabin_class]",
                    "value": "\(journey[i].cc)"
                ],
                [
                    "name": "eventDetails[\(i)][depart_dt]",
                    "value": "\(journey[i].dd)"
                ],
                [
                    "name": "eventDetails[\(i)][depart_time]",
                    "value": "\(journey[i].dt)"
                ],
                [
                    "name": "eventDetails[\(i)][arrival_dt]",
                    "value": "\(journey[i].ad)"
                ],
                [
                    "name": "eventDetails[\(i)][arrival_time]",
                    "value": "\(journey[i].at)"
                ],
                [
                    "name": "eventDetails[\(i)][equipment]",
                    "value": "\((journey[i].leg.first?.flights.first?.eq)!)"
                ],
                [
                    "name": "eventDetails[\(i)][timezone]",
                    "value": "\(timezone)"
                ],
            ]
        }
        return parameters
    }
    
    func getParametersForIntMCAndReturnJourney() -> [[AnyHashable:Any]] {
        var parameters = [[:]]
        for i in 0...intMCAndReturnJourney.count-1{
            parameters = [
                [
                    "name": "eventDetails[\(i)][airline_code]",
                    "value": "\(intMCAndReturnJourney[i].al[0])"
                ],
                [
                    "name": "eventDetails[\(i)][depart_airport]",
                    "value": "\((intMCAndReturnJourney[i].legsWithDetail.first?.flightsWithDetails.first?.fr)!)"
                ],
                [
                    "name": "eventDetails[\(i)][arrival_airport]",
                    "value": "\((intMCAndReturnJourney[i].legsWithDetail.first?.flightsWithDetails.first?.to)!)"
                ],
                [
                    "name": "eventDetails[\(i)][flight_number]",
                    "value": "\((intMCAndReturnJourney[i].legsWithDetail.first?.flightsWithDetails.first?.fn)!)"
                ],
                [
                    "name": "eventDetails[\(i)][depart_terminal]",
                    "value": "\((intMCAndReturnJourney[i].legsWithDetail.first?.flightsWithDetails.first?.dtm)!)"
                ],
                [
                    "name": "eventDetails[\(i)][arrival_terminal]",
                    "value": "\((intMCAndReturnJourney[i].legsWithDetail.first?.flightsWithDetails.first?.atm)!)"
                ],
                [
                    "name": "eventDetails[\(i)][cabin_class]",
                    "value": "\(intMCAndReturnJourney[i].cc)"
                ],
                [
                    "name": "eventDetails[\(i)][depart_dt]",
                    "value": "\(intMCAndReturnJourney[i].dd)"
                ],
                [
                    "name": "eventDetails[\(i)][depart_time]",
                    "value": "\(intMCAndReturnJourney[i].dt)"
                ],
                [
                    "name": "eventDetails[\(i)][arrival_dt]",
                    "value": "\(intMCAndReturnJourney[i].ad)"
                ],
                [
                    "name": "eventDetails[\(i)][arrival_time]",
                    "value": "\(intMCAndReturnJourney[i].at)"
                ],
                [
                    "name": "eventDetails[\(i)][equipment]",
                    "value": "\((intMCAndReturnJourney[i].legsWithDetail.first?.flightsWithDetails.first?.eq)!)"
                ],
                [
                    "name": "eventDetails[\(i)][timezone]",
                    "value": "\(timezone)"
                ],
            ]
        }
        return parameters
    }
}
