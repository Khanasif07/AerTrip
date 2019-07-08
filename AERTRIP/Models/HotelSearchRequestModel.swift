//
//  HotelSearchRequestModel.swift
//  AERTRIP
//
//  Created by apple on 20/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct HotelSearchRequestModel {
    var sid :String
    var international:Bool
    var vcodes : [String]
    var requestParameters:RequestParameters
    
    init() {
        let json = JSON()
        self.init(json:json)
    }
    
    init(json:JSON) {
        self.sid = json[APIKeys.sid.rawValue].stringValue
        self.international = json[APIKeys.international.rawValue].boolValue
        self.vcodes = json[APIKeys.vcodes.rawValue].arrayObject as? [String] ?? []
        self.requestParameters = RequestParameters(json:json[APIKeys.requestParmaters.rawValue])
        
    }
    
    
    
}



struct RequestParameters {
    var isPageRefreshed : String
    var numOfRooms: String
    var checkIn: String
    var checkOut:String
    var country : String
    var longitude : String
    var destType: String
    var city : String
    var destName : String
    var radius : [Radius]
    var latitude : String
    var underScore : String
    var cityId : String
    var destinationId:String
    
    init() {
        let json = JSON()
        self.init(json:json)
    }
    
    
    init(json: JSON) {
        self.isPageRefreshed = json[APIKeys.isPageRefereshed.rawValue].stringValue
        self.numOfRooms = json[APIKeys.num_rooms.rawValue].stringValue
        self.checkIn = json[APIKeys.check_in.rawValue].stringValue
        self.checkOut = json[APIKeys.check_out.rawValue].stringValue
        self.country = json[APIKeys.country.rawValue].stringValue
        self.longitude = json[APIKeys.longitude.rawValue].stringValue
        self.destType = json[APIKeys.dest_type.rawValue].stringValue
        self.city = json[APIKeys.city.rawValue].stringValue
        self.destName = json[APIKeys.dest_name.rawValue].stringValue
        self.radius = Radius.retunRadiusArray(jsonArr: json[APIKeys.radius.rawValue].arrayValue)
        self.latitude = json[APIKeys.latitude.rawValue].stringValue
        self.underScore = json[APIKeys.underScore.rawValue].stringValue
        self.cityId = json[APIKeys.city_id.rawValue].stringValue
        self.destinationId = json[APIKeys.dest_id.rawValue].stringValue
        
    }
    
 
}

struct Radius {
    var a : String
    
    init () {
        let json = JSON()
        self.init(json:json)
    }
    
    init(json: JSON) {
        self.a = json[APIKeys.a.rawValue].stringValue
    }
    
    static func retunRadiusArray(jsonArr:[JSON]) -> [Radius] {
        var radii = [Radius]()
        for element in jsonArr {
            radii.append(Radius(json: element))
        }
        return radii
    }
    
}
