//
//  IntMCAndReturnDetailsVM.swift
//  Aertrip
//
//  Created by Apple  on 17.04.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation
///typealias reference used for IntMultiCityAndReturnWSResponse.Results.J
typealias IntJourney = IntMultiCityAndReturnWSResponse.Results.J
///typealias reference used for [IntMultiCityAndReturnWSResponse.Results.J]
typealias IntResultArray = [IntJourney]
///typealias reference used for IntMultiCityAndReturnWSResponse.Results.J.Fare
typealias IntTaxes = IntMultiCityAndReturnWSResponse.Results.J.Fare
///typealias reference used for IntMultiCityAndReturnWSResponse.Results.Apdet
typealias IntAirportDetailsWS = IntMultiCityAndReturnWSResponse.Results.Apdet
///typealias reference used for IntMultiCityAndReturnWSResponse.Results.ALMaster
typealias IntAirlineMasterWS = IntMultiCityAndReturnWSResponse.Results.ALMaster
///typealias reference used for IntMultiCityAndReturnWSResponse.Results.Fdet
typealias IntFlightDetail = IntMultiCityAndReturnWSResponse.Results.Fdet

let msgForLessThen2Hr = "Selected flights have less than 2 hrs of gap."
let msgForOverlapTime = "Flight timings are not compatible. Select a different flight."


protocol ShowMessageDelegate:NSObjectProtocol{
    func showTost(msg: String)
    func updateSeleted()
}



class IntMCAndReturnDetailsVM{
    var numberOfLegs = 0 //Number origin or destination.
    var headerArray =  [MultiLegHeader]()//Header collection title array.
    var journeyHeaderViewArray = [IntJourneyHeaderView]()//Header object for different tableview.
    var taxesResult = [String:String]()
    var largeTitle:String = "105 options at same price"
    var selectedJourney = IntResultArray()
    var showJourneyId = "0"
    var results = [IntResultArray]()//Main array which contain results.
    var internationalDataArray: IntResultArray?{
        didSet{
            setUpdataDataForTable()
        }
    }
    var selectedCompleteJourney = IntJourney(JSON())
    var delegate:ShowMessageDelegate?
    var isFareSetBefore = false
    var airportDetailsResult = [String : IntAirportDetailsWS]()
    var airlineDetailsResult = [String : IntAirlineMasterWS]()
    var bookFlightObject = BookFlightObject()
    var sid = ""
    
    func setUpdataDataForTable(){
        guard let data = self.internationalDataArray else { return }
        let dataRemovinglessLegs = data.filter({$0.legsWithDetail.count == numberOfLegs})
        for i in 0..<self.numberOfLegs{
            let newData = dataRemovinglessLegs
            //For create to data for table view according to numberOfLegs
            let dataAtIndex = newData.map({(journey) -> IntJourney in
                var newJourney = journey
                newJourney.legsWithDetail = [journey.legsWithDetail[i]]
                return newJourney
            })
            //removing the journey with same legWithDetails.
            var dataRemovingDuplicate = IntResultArray()
            var updateJData = IntJourney(JSON())
            dataAtIndex.forEach { jData in
                if !dataRemovingDuplicate.contains(where: { (newJData) -> Bool in
                    updateJData = jData
                    return newJData.leg[i] == jData.leg[i]
                }){
                    dataRemovingDuplicate.append(jData)
                    if jData.id == self.showJourneyId{
                        self.selectedJourney.insert(jData, at: i)
                    }
                }else{
                    //Keeping track of removed journey
                    if let index = dataRemovingDuplicate.firstIndex(where: {$0.leg[i] == updateJData.leg[i]}){
                        if updateJData.id == self.showJourneyId{
                            self.selectedJourney.insert(dataRemovingDuplicate[index], at: i)
                            updateJData.combineJourney = dataRemovingDuplicate[index].combineJourney.union(updateJData.combineJourney)
                            updateJData.combineFk = updateJData.combineFk.union(dataRemovingDuplicate[index].combineFk)
                            dataRemovingDuplicate[index] = updateJData
                        }else{
                            dataRemovingDuplicate[index].combineJourney = dataRemovingDuplicate[index].combineJourney.union(updateJData.combineJourney)
                            
                            dataRemovingDuplicate[index].combineFk = dataRemovingDuplicate[index].combineFk.union(updateJData.combineFk)
                            
                        }
                    }
                }
            }
//            self.delegate?.updateSeleted()
            dataRemovingDuplicate = dataRemovingDuplicate.sorted{($0.legsWithDetail.first?.dt ?? "") < ($1.legsWithDetail.first?.dt ?? "")}
            self.results.insert(dataRemovingDuplicate, at: i)
        }
    }
    
    func updateCellOnSelection(index:Int, journey: IntJourney){
   
        if index < (numberOfLegs - 1){
            let upIndex = (index + 1)
            self.results[upIndex] = self.results[upIndex].map({ jData -> IntJourney in
                var newJdata = jData
                if var legs = newJdata.legsWithDetail.first{
                    legs.isDisabled = !(newJdata.combineJourney.contains(journey.leg[index]))
                    newJdata.legsWithDetail = [legs]
                }
                return  newJdata
            })
        }
        updatedTalbesOnSecection(index:index, journey: journey)
    }
    
    
    func updateSelectionForMuticity(index:Int, journey: IntJourney){
         if index < (numberOfLegs - 1){
             let upIndex = (index + 1)
                self.results[upIndex] = self.results[upIndex].map({ jData -> IntJourney in
                    var newJdata = jData
                    if var legs = newJdata.legsWithDetail.first{
                        var interSectArray = journey.combineFk.intersection(jData.combineFk)
                        for i in 0..<upIndex{
                            interSectArray = interSectArray.intersection(self.selectedJourney[i].combineFk)
                        }
                        legs.isDisabled = interSectArray.isEmpty
                        newJdata.legsWithDetail = [legs]
                        return newJdata
                    }
                    return  newJdata
                })
                self.updatedTalbesOnSecection(index: index)
         }
     }
    

    func updatedTalbesOnSecection(index:Int, journey: IntJourney = IntJourney(JSON())){
        
        if index < (numberOfLegs - 1){
            let journey = (journey.fk == "") ? self.selectedJourney[index] : journey
            let upIndex = (index + 1)
            guard journey.legsWithDetail.first?.ad == self.results[upIndex].first?.legsWithDetail.first?.dd,
                let selectedArivalDate = convertIntoDate(date: journey.legsWithDetail.first?.ad, time: journey.legsWithDetail.first?.at) else {return}
            self.results[upIndex] = self.results[upIndex].map{newJourney -> IntJourney in
                var jour = newJourney
                if let dprtDate = self.convertIntoDate(date: jour.legsWithDetail.first?.dd, time: jour.legsWithDetail.first?.dt), (dprtDate > selectedArivalDate), !(jour.legsWithDetail.first?.isDisabled ?? false){
                    if var legs = jour.legsWithDetail.first{
                        legs.isDisabled = false
                        jour.legsWithDetail = [legs]
                    }
                }else{
                    if var legs = jour.legsWithDetail.first{
                        legs.isDisabled = true
                        jour.legsWithDetail = [legs]
                    }
                }
                return jour
            }
        }
        
    }
    
    func checkForMessageWith(_ journey:IntJourney, at index: Int){
        guard self.selectedJourney[index].leg[index] == journey.leg[index] else {return}
        let timeDiffrence = getTimeDifferenceBetween(self.selectedJourney[index - 1], and: journey)
        if timeDiffrence <= 0{
            self.delegate?.showTost(msg: msgForOverlapTime)
        }else if timeDiffrence < 120{
            self.delegate?.showTost(msg: msgForLessThen2Hr)
        }
    }
    
    
    private func getTimeDifferenceBetween(_ firstJrny: IntJourney, and secondJrny: IntJourney)-> Int{
        
        let arvTime = self.convertIntoDate(date: firstJrny.legsWithDetail.first?.ad, time: firstJrny.legsWithDetail.first?.at) ?? Date()
        let dprtTime = self.convertIntoDate(date: secondJrny.legsWithDetail.first?.dd, time: secondJrny.dt) ?? Date()
        let dateComponents =  Calendar.current.dateComponents([.minute], from: arvTime, to: dprtTime)
        return dateComponents.minute ?? 0
    }
    
    private func convertIntoDate(date: String?, time: String?)->Date?{
        guard let date = date, let time = time else {return nil}
        let dateStr = "\(date) \(time)"//"2020-07-15 20:59"
        let dateFormetter = DateFormatter()
        dateFormetter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormetter.date(from: dateStr)
    }
    

}
