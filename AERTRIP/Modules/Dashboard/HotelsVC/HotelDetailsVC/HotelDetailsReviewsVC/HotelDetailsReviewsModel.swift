//
//  HotelDetailsReviewsModel.swift
//  AERTRIP
//
//  Created by Admin on 08/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct  HotelDetailsReviewsModel {
    
    var webUrl: String = ""                                // web_url
    var rating: String = ""                                //rating
    var ratingImgUrl: String = ""                          //rating_img_url
    var numReviews: String = ""                            //num_reviews
    var writeReview: String = ""                           //writeReview
    var photoCount: String = ""                            //photo_count
    var awardsImage: String = ""                           //awards_image
    var seeAllPhotos: String = ""                           //see_all_photos
    var rankingData: RankingData?                           //ranking_data
    var reviewRatingCount: [String : Any] = [:]            //review_rating_count
    var ratingSummary : [RatingSummary]?                   //subratings
    var tripTypes: [TripTypes]?                              //trip_types
    
    
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.facilities.rawValue: self.webUrl,
                APIKeys.city_code.rawValue: self.rating,
                APIKeys.address.rawValue: self.ratingImgUrl,
                APIKeys.acc_type.rawValue: self.numReviews,
                APIKeys.temp_price.rawValue: self.writeReview,
                APIKeys.price.rawValue: self.photoCount,
                APIKeys.at_hotel_fares.rawValue: self.awardsImage,
                APIKeys.no_of_nights.rawValue: self.seeAllPhotos,
                APIKeys.num_rooms.rawValue: self.rankingData as Any,
                APIKeys.list_price.rawValue: self.reviewRatingCount,
                APIKeys.tax.rawValue: self.ratingSummary as Any,
                APIKeys.discount.rawValue: self.tripTypes as Any
        ]
    }
    
    
    init(json: JSONDictionary) {
        
        if let obj = json[APIKeys.webUrl.rawValue] {
            self.webUrl = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.rating.rawValue] {
            self.rating = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.ratingImgUrl.rawValue] {
            self.ratingImgUrl = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.numReviews.rawValue] {
            self.numReviews = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.writeReview.rawValue] {
            self.writeReview = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.photoCount.rawValue] {
            self.photoCount = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.awardsImage.rawValue] {
            self.awardsImage = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.seeAllPhotos.rawValue] {
            self.seeAllPhotos = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.rankingData.rawValue] as? JSONDictionary {
            self.rankingData = RankingData.rankingData(response: obj)
        }
        if let obj = json[APIKeys.reviewRatingCount.rawValue] as? JSONDictionary {
            self.reviewRatingCount = obj
        }
        if let obj = json[APIKeys.subratings.rawValue] as? [JSONDictionary] {
            self.ratingSummary = RatingSummary.ratingSummary(response: obj)
        }
        if let obj = json[APIKeys.tripTypes.rawValue] as? [JSONDictionary] {
            self.tripTypes = TripTypes.tripTypes(response: obj)
        }
    }
    
    //Mark:- Functions
    //================
    ///Static Function
    static func hotelDetailsReviews(response: JSONDictionary) -> HotelDetailsReviewsModel {
        let hotelDetailsReviews = HotelDetailsReviewsModel(json: response)
        return hotelDetailsReviews
    }
    
}

struct RankingData {
    var rankingString: String = ""              // ranking_string
    var rankingOutOf: String = ""               //ranking_out_of
    var geoLocationId: String = ""              //geo_location_id
    var ranking: String = ""                    //ranking
    var geoLocationName : String = ""           //geo_location_name
    var rankingStringDetail: String = ""      //ranking_string_detail
    
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.rankingString.rawValue: self.rankingString,
                APIKeys.rankingOutOf.rawValue: self.rankingOutOf,
                APIKeys.geoLocationId.rawValue: self.geoLocationId,
                APIKeys.ranking.rawValue: self.ranking,
                APIKeys.geoLocationName.rawValue: self.geoLocationName,
                APIKeys.rankingStringDetail.rawValue: self.rankingStringDetail
        ]}
    
    init(json: JSONDictionary) {
        
        if let obj = json[APIKeys.rankingString.rawValue] {
            self.rankingString = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.rankingOutOf.rawValue] {
            self.rankingOutOf = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.geoLocationId.rawValue] {
            self.geoLocationId = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.ranking.rawValue] {
            self.ranking = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.geoLocationName.rawValue] {
            self.geoLocationName = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.rankingStringDetail.rawValue] {
            self.rankingStringDetail = "\(obj)".removeNull
        }
    }
    
    //Mark:- Functions
    //================
    ///Static Function
    static func rankingData(response: JSONDictionary) -> RankingData {
        let data = RankingData(json: response)
        return data
    }
}

struct RatingSummary {
    var ratingImageUrl: String = "" //rating_image_url
    var name: String = ""           //name
    var value: String = ""          //value
    var localizedName: String = ""  //localized_name
    
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.ratingImageUrl.rawValue: self.ratingImageUrl,
                APIKeys.name.rawValue: self.name,
                APIKeys.value.rawValue: self.value,
                APIKeys.localizedName.rawValue: self.localizedName
        ]}
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.ratingImageUrl.rawValue] {
            self.ratingImageUrl = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.name.rawValue] {
            self.name = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.value.rawValue] {
            self.value = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.localizedName.rawValue] {
            self.localizedName = "\(obj)".removeNull
        }
    }
    
    //Mark:- Functions
    //================
    ///Static Function
    static func ratingSummary(response: [JSONDictionary]) -> [RatingSummary] {
        var ratingSummaryData = [RatingSummary]()
        for json in response {
            ratingSummaryData.append(RatingSummary(json: json))
        }
        return ratingSummaryData
    }
    
}

struct TripTypes {
    var name: String = ""               //name
    var value: String = ""              //value
    var localizedName: String = ""      //localized_name
    
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.name.rawValue: self.name,
                APIKeys.value.rawValue: self.value,
                APIKeys.localizedName.rawValue: self.localizedName
        ]}
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.name.rawValue] {
            self.name = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.value.rawValue] {
            self.value = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.localizedName.rawValue] {
            self.localizedName = "\(obj)".removeNull
        }
    }
    
    //Mark:- Functions
    //================
    ///Static Function
    static func tripTypes(response: [JSONDictionary]) -> [TripTypes] {
        var tripTypesData = [TripTypes]()
        for json in response {
            tripTypesData.append(TripTypes(json: json))
        }
        return tripTypesData
    }
}

