//
//  Parser.m
//  Mazkara
//
//  Created by Kakshil Shah on 20/04/16.
//  Copyright © 2016 BazingaLabs. All rights reserved.
//

#import "Parser.h"
#import "BaseViewController.h"
@implementation Parser




+(NSString *) handleAmount:(NSString *)amount{
    if (amount.length > 2) {
        NSString *lastValues = [amount substringFromIndex:amount.length - 2];
        if ([lastValues isEqualToString:@".0"]) {
            amount = [amount substringToIndex:amount.length - 2];
        }
    }
    return amount;
}

+ (NSString *)extractYoutubeIdFromLink:(NSString *)link {
    
    NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    
    NSArray *array = [regExp matchesInString:link options:0 range:NSMakeRange(0,link.length)];
    if (array.count > 0) {
        NSTextCheckingResult *result = array.firstObject;
        return [link substringWithRange:result.range];
    }
    return @"Error";
}


//MARK:- Helper Code
+(NSString *) getValueForKey:(NSString *)key inDictionary:(NSDictionary *)dictionary{
    if ([dictionary valueForKey:key]) {
        NSString *returnValue =  [NSString stringWithFormat:@"%@",[dictionary valueForKey:key]];
        if ([returnValue isEqualToString:@"None"]) {
            return EMPTY_STRING;
        }
        if ([returnValue isEqualToString:@"<null>"]) {
            return EMPTY_STRING;
        }
        return returnValue;
    }
    return EMPTY_STRING;
}

//+(NSString *) getURLForKey:(NSString *)key inDictionary:(NSDictionary *)dictionary{
//    if ([dictionary valueForKey:key]) {
//        return [[Parser getValueForKey:key inDictionary:dictionary] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    }
//    return EMPTY_STRING;
//}

+(NSString *) getValueForKey:(NSString *)key inDictionary:(NSDictionary *)dictionary withDefault:(NSString *)defaultValue{
    if ([dictionary valueForKey:key]) {
        return [dictionary valueForKey:key];
    }
    return defaultValue;
}

+(id) genericValueForKey:(NSString *)key inDictionary:(NSDictionary *)dictionary {
    if ([dictionary isKindOfClass:[NSString class]]) {
        return @"";

    }else {
        if ([dictionary valueForKey:key]) {
            id object = [dictionary valueForKey:key];
            if(object != nil && ![object isKindOfClass:[NSNull class]]){
                return [dictionary valueForKey:key];
            }else{
                return @"";
            }
        }
    }
    return @"";
}

+(User *) parseUser:(NSDictionary *) userDictionary{
    User *user = [User new];
    user.userID = [Parser getValueForKey:@"pax_id" inDictionary:userDictionary];
    user.mobile = [Parser getValueForKey:@"mobile" inDictionary:userDictionary];
    user.location = [Parser getValueForKey:@"location" inDictionary:userDictionary];
    user.membershipNumber = [Parser getValueForKey:@"membership_num" inDictionary:userDictionary];
    user.panNumber = [Parser getValueForKey:@"pan_number" inDictionary:userDictionary];
    user.aadharNumber = [Parser getValueForKey:@"aadhar_number" inDictionary:userDictionary];
    user.salutation = [Parser getValueForKey:@"salutation" inDictionary:userDictionary];

    
//    user.profileImage = [Parser getURLForKey:@"profile_img" inDictionary:userDictionary];
//    if (![self exists:user.profileImage]) {
//        user.profileImage = [Parser getURLForKey:@"img" inDictionary:userDictionary];
//    }
    
    user.name = [Parser getValueForKey:@"billing_name" inDictionary:userDictionary];    
    user.email= [Parser getValueForKey:@"email" inDictionary:userDictionary];
//    if([userDictionary objectForKey:@"hotels"]) {
//        
//        NSDictionary *hotelsDictionary = [userDictionary objectForKey:@"hotels"];
//        user.hotelsMaxStarRating = [Parser getValueForKey:@"hotel_max_star" inDictionary:hotelsDictionary];
//        user.hotelsMinStarRating = [Parser getValueForKey:@"hotel_min_star" inDictionary:hotelsDictionary];
//    }
    user.hotelsMaxStarRating = [Parser getValueForKey:@"hotel_max_star" inDictionary:userDictionary];
    user.hotelsMinStarRating = [Parser getValueForKey:@"hotel_min_star" inDictionary:userDictionary];
    
    
    
return user;
}

+(Address *) parseAddress:(NSDictionary *) addressDictionary{
    Address *address = [Address new];
    address.line1 = [Parser getValueForKey:@"address_line1" inDictionary:addressDictionary];
    address.line2 = [Parser getValueForKey:@"address_line2" inDictionary:addressDictionary];
    address.line3 = [Parser getValueForKey:@"address_line3" inDictionary:addressDictionary];
    address.type = [Parser getValueForKey:@"address_type" inDictionary:addressDictionary];
    address.city = [Parser getValueForKey:@"city" inDictionary:addressDictionary];
    address.countryCode = [Parser getValueForKey:@"country" inDictionary:addressDictionary];
    address.countryName = [Parser getValueForKey:@"country_name" inDictionary:addressDictionary];
    address.addressID = [Parser getValueForKey:@"id" inDictionary:addressDictionary];
    address.userID = [Parser getValueForKey:@"passenger_id" inDictionary:addressDictionary];
    address.postalCode = [Parser getValueForKey:@"postal_code" inDictionary:addressDictionary];
    address.state = [Parser getValueForKey:@"state" inDictionary:addressDictionary];
    return address;
}

+(GeneralUserPreferences *) parseUserPreferences:(NSDictionary *) preferencesDictionary{
    GeneralUserPreferences *preferences = [GeneralUserPreferences new];
    preferences.displayOrder = [Parser getValueForKey:@"display_order" inDictionary:preferencesDictionary];
    preferences.sortOrder = [Parser getValueForKey:@"sort_order" inDictionary:preferencesDictionary];
    preferences.labelsArray = (NSMutableArray *)[[Parser genericValueForKey:@"labels" inDictionary:preferencesDictionary] mutableCopy];
    if (![preferences.labelsArray containsObject:@"Others"]) {
        [preferences.labelsArray addObject:@"Others"];
    }
    return preferences;
}

+(UserDetails *) parseUserDetails:(NSDictionary *) userDetailsDictionary{
    UserDetails *details = [UserDetails new];
    NSMutableArray *addressArray = [[NSMutableArray alloc] init];
    NSDictionary *allAddressDictionary = [Parser genericValueForKey:@"addresses" inDictionary:userDetailsDictionary];
    if (![allAddressDictionary isKindOfClass:[NSString class]]) {
        for (NSString *key in [allAddressDictionary allKeys]) {
            NSDictionary *addressDictionary = [allAddressDictionary valueForKey:key];
            Address *address = [Parser parseAddress:addressDictionary];
            [addressArray addObject:address];
        }
    }
    
    details.addressArray = addressArray;
    details.billingAddress = [Parser parseAddress:[userDetailsDictionary valueForKey:@"billing_address"]];
    details.user = [Parser parseUser:userDetailsDictionary];
    details.preferences = [Parser parseUserPreferences:[userDetailsDictionary valueForKey:@"general_preferences"]];
    NSDictionary *linkedAccounts =  [Parser genericValueForKey:@"linked_accounts" inDictionary:userDetailsDictionary];
    if ([linkedAccounts isKindOfClass:[NSDictionary class]]) {
        details.linkedAccountsNames = [linkedAccounts allKeys];
    }
    
    
    NSMutableArray *travellerArray = [[NSMutableArray alloc] init];
    NSDictionary *allTravellersDictionary = [Parser genericValueForKey:@"travellers" inDictionary:userDetailsDictionary];
    
    if (![allTravellersDictionary isKindOfClass:[NSString class]]) {

        for (NSString *key in [allTravellersDictionary allKeys]) {
            NSDictionary *travellerDictionary = [allTravellersDictionary valueForKey:key];
            Traveller *traveller = [Parser parseTraveller:travellerDictionary withAddressArray:addressArray];
            [travellerArray addObject:traveller];
            if (traveller.travellerID == details.user.userID) {
                details.selfTraveller = traveller;
            }
        }
    }
    details.travellersArray = travellerArray;
    for (Traveller *traveller in travellerArray) {
        if ([traveller.travellerID isEqualToString:details.user.userID]) {
            details.hotelPreferencesArray = traveller.hotelPreferencesArray;
        }
    }
    return details;
}


+(ContactMethod *) parseContactMethod:(NSDictionary *) contactMethodDictionary{
    ContactMethod *contact = [ContactMethod new];
    contact.sortOrder = [Parser getValueForKey:@"sort_order" inDictionary:contactMethodDictionary];
    contact.label = [Parser getValueForKey:@"contact_label" inDictionary:contactMethodDictionary];
    contact.type = [Parser getValueForKey:@"contact_type" inDictionary:contactMethodDictionary];
    contact.value = [Parser getValueForKey:@"contact_value" inDictionary:contactMethodDictionary];
    contact.contactID = [Parser getValueForKey:@"id" inDictionary:contactMethodDictionary];
    contact.ISD = [Parser getValueForKey:@"isd" inDictionary:contactMethodDictionary];
    contact.mobileFormatted = [Parser getValueForKey:@"mobile_formatted" inDictionary:contactMethodDictionary];
    return contact;
}

+(TravellerPreference *) parseTravellerPreference:(NSDictionary *) dictionary {
    TravellerPreference *travellerPreference = [TravellerPreference new];
   
    travellerPreference.displayName = [Parser getValueForKey:@"display_name" inDictionary:dictionary];
    travellerPreference.preferenceID = [Parser getValueForKey:@"id" inDictionary:dictionary];
    travellerPreference.type = [Parser getValueForKey:@"preference_type" inDictionary:dictionary];
    travellerPreference.value = [Parser getValueForKey:@"preference_value" inDictionary:dictionary];

   
    return travellerPreference;
}

+(FrequentFlier *) parseFrequentFlier:(NSDictionary *) dictionary {
    FrequentFlier *frequentFlier = [FrequentFlier new];
    
    frequentFlier.airlineCode = [Parser getValueForKey:@"airline_code" inDictionary:dictionary];
    frequentFlier.airlineName = [Parser getValueForKey:@"airline_name" inDictionary:dictionary];
    frequentFlier.ffNumber = [Parser getValueForKey:@"ff_number" inDictionary:dictionary];
    frequentFlier.ffID = [Parser getValueForKey:@"id" inDictionary:dictionary];
    frequentFlier.logoURL = [Parser getValueForKey:@"logo_url" inDictionary:dictionary];

    
    return frequentFlier;
}


+(Traveller *) parseTraveller:(NSDictionary *) travellerDictionary withAddressArray:(NSArray *)allAddressArray{
    Traveller *traveller = [Traveller new];
    
    
    //Address
    NSMutableArray *addressArray = [[NSMutableArray alloc] init];
    NSArray *addressIDArray = [Parser genericValueForKey:@"address_id" inDictionary:travellerDictionary];
    if (![addressIDArray isKindOfClass:[NSString class]]) {
        for (NSString *addressID in addressIDArray) {
            for (Address *address in allAddressArray) {
                if ([address.addressID isEqualToString:addressID]) {
                    if (![addressArray containsObject:address]) {
                        [addressArray addObject:address];
                    }
                }
            }
        }
    }
    traveller.addressArray = addressArray;
    
    //Contact
    NSMutableArray *socialContactArray = [[NSMutableArray alloc] init];
    NSMutableArray *emailContactArray = [[NSMutableArray alloc] init];
    NSMutableArray *mobileContactArray = [[NSMutableArray alloc] init];

    
    NSDictionary *contactDictionary = [Parser genericValueForKey:@"contact" inDictionary:travellerDictionary];
    
    
    
    NSArray *socialContactUnParsedArray = [Parser genericValueForKey:@"social" inDictionary:contactDictionary];
    NSArray *emailContactUnParsedArray = [Parser genericValueForKey:@"email" inDictionary:contactDictionary];
    NSArray *mobileContactUnParsedArray = [Parser genericValueForKey:@"mobile" inDictionary:contactDictionary];

    
    if (socialContactUnParsedArray!=NULL && ![socialContactUnParsedArray isKindOfClass:[NSString class]]) {
        for (NSDictionary *contactMethodDictionary in socialContactUnParsedArray) {
            [socialContactArray addObject:[Parser parseContactMethod:contactMethodDictionary]];
        }
    }
    traveller.contactMethodArraySocial = socialContactArray;
    
    
    if (emailContactUnParsedArray!=NULL && ![emailContactUnParsedArray isKindOfClass:[NSString class]]) {
        for (NSDictionary *contactMethodDictionary in emailContactUnParsedArray) {
            [emailContactArray addObject:[Parser parseContactMethod:contactMethodDictionary]];
        }
    }
    traveller.contactMethodArrayEmail = emailContactArray;
    
    
    if (mobileContactUnParsedArray!=NULL && ![mobileContactUnParsedArray isKindOfClass:[NSString class]]) {
        for (NSDictionary *contactMethodDictionary in mobileContactUnParsedArray) {
            [mobileContactArray addObject:[Parser parseContactMethod:contactMethodDictionary]];
        }
    }
    traveller.contactMethodArrayMobile = mobileContactArray;
    
    
    //preferences
    NSMutableArray *preferenceParsedArray = [[NSMutableArray alloc] init];
    NSArray *preferenceArray = [Parser genericValueForKey:@"preferences" inDictionary:travellerDictionary];
    if ([preferenceArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dictionary in preferenceArray) {
            [preferenceParsedArray addObject:[Parser parseTravellerPreference:dictionary]];
        }
    }
    traveller.preferenceArray = preferenceParsedArray;

    
    
    //ff
    NSMutableArray *frequentFlierParsedArray = [[NSMutableArray alloc] init];
    NSArray *ffArray = [Parser genericValueForKey:@"ff" inDictionary:travellerDictionary];
    if ([ffArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dictionary in ffArray) {
            [frequentFlierParsedArray addObject:[Parser parseFrequentFlier:dictionary]];
        }
    }
    traveller.frequentFlyerArray = frequentFlierParsedArray;
    
    //Everything else
    traveller.company = [Parser getValueForKey:@"company" inDictionary:travellerDictionary];
    traveller.countryID = [Parser getValueForKey:@"country_id" inDictionary:travellerDictionary];
    traveller.department = [Parser getValueForKey:@"department" inDictionary:travellerDictionary];
    traveller.doa = [Parser getValueForKey:@"doa" inDictionary:travellerDictionary];
    traveller.dob = [Parser getValueForKey:@"dob" inDictionary:travellerDictionary];
    traveller.employeeID = [Parser getValueForKey:@"employee_id" inDictionary:travellerDictionary];
    traveller.firstName = [Parser getValueForKey:@"first_name" inDictionary:travellerDictionary];
    traveller.gender = [Parser getValueForKey:@"gender" inDictionary:travellerDictionary];
    traveller.googleID = [Parser getValueForKey:@"google_id" inDictionary:travellerDictionary];
    traveller.homeCity = [Parser getValueForKey:@"home_city" inDictionary:travellerDictionary];
    
    traveller.travellerID = [Parser getValueForKey:@"id" inDictionary:travellerDictionary];
    traveller.jobTitle = [Parser getValueForKey:@"job_title" inDictionary:travellerDictionary];
    traveller.label = [Parser getValueForKey:@"label" inDictionary:travellerDictionary];
    if(![self exists:traveller.label]){
        traveller.label = @"Others";
    }
    traveller.lastName = [Parser getValueForKey:@"last_name" inDictionary:travellerDictionary];
    traveller.middleName = [Parser getValueForKey:@"middle_name" inDictionary:travellerDictionary];
    traveller.notes = [Parser getValueForKey:@"notes" inDictionary:travellerDictionary];
//    traveller.profileImageURL = [Parser getURLForKey:@"profile_image" inDictionary:travellerDictionary];
    traveller.passportCountry = [Parser getValueForKey:@"passport_country" inDictionary:travellerDictionary];
    traveller.passportCountryName = [Parser getValueForKey:@"passport_country_name" inDictionary:travellerDictionary];
    traveller.passportExpiryDate = [Parser getValueForKey:@"passport_expiry_date" inDictionary:travellerDictionary];
//    traveller.passportImage = [Parser getURLForKey:@"passport_image" inDictionary:travellerDictionary];
    traveller.passportIssueDate = [Parser getValueForKey:@"passport_issue_date" inDictionary:travellerDictionary];
    traveller.passportNumber = [Parser getValueForKey:@"passport_number" inDictionary:travellerDictionary];
    traveller.salutation = [Parser getValueForKey:@"salutation" inDictionary:travellerDictionary];

    
    
    
    return traveller;
}



+ (DropDownData *)parseDropDownDataDictionary:(NSDictionary *)dictionary {
    DropDownData *dropDownData = [DropDownData new];
    if ([dictionary objectForKey:@"email"]) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSString *key in [[dictionary objectForKey:@"email"] allKeys]) {
            [array addObject:[[dictionary objectForKey:@"email"] objectForKey:key]];
        }
        dropDownData.emailTypeArray = array ;
    }
    if ([dictionary objectForKey:@"mobile"]) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSString *key in [[dictionary objectForKey:@"mobile"] allKeys]) {
            [array addObject:[[dictionary objectForKey:@"mobile"] objectForKey:key]];
        }
        dropDownData.mobileTypeArray = array;
    }
    if ([dictionary objectForKey:@"social"]) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSString *key in [[dictionary objectForKey:@"social"] allKeys]) {
            [array addObject:[[dictionary objectForKey:@"social"] objectForKey:key]];
        }
        dropDownData.socialTypeArray = array;
    }
    if ([dictionary objectForKey:@"address"]) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSString *key in [[dictionary objectForKey:@"address"] allKeys]) {
            [array addObject:[[dictionary objectForKey:@"address"] objectForKey:key]];
        }
        dropDownData.addressTypeArray = array;
    }
    if ([dictionary objectForKey:@"salutation"]) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSString *key in [[dictionary objectForKey:@"salutation"] allKeys]) {
            [array addObject:[[dictionary objectForKey:@"salutation"] objectForKey:key]];
        }
        dropDownData.salutationTypeArray = array;
    }
    return dropDownData;
}


+ (FlightPreferencesDropDown *)parseFlightPreferencesDropDownDataDictionary:(NSDictionary *)dictionary {
    FlightPreferencesDropDown *flightPreferencesDropDown = [FlightPreferencesDropDown new];
    if ([dictionary objectForKey:@"preferences"]) {
        if ([[dictionary objectForKey:@"preferences"] objectForKey:@"meal"]) {
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSDictionary *allDictionary = [Parser genericValueForKey:@"meal" inDictionary:[dictionary objectForKey:@"preferences"]];
            for (NSString *key in [allDictionary allKeys]) {
                KeyValueData *keyValue = [KeyValueData new];
                keyValue.value = [allDictionary valueForKey:key];
                keyValue.key = key;
                [array addObject:keyValue];
            }
                
            flightPreferencesDropDown.mealTypeArray = array;

            
        }
        if ([[dictionary objectForKey:@"preferences"] objectForKey:@"seat"]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSDictionary *allDictionary = [Parser genericValueForKey:@"seat" inDictionary:[dictionary objectForKey:@"preferences"]];
            
            for (NSString *key in [allDictionary allKeys]) {
                KeyValueData *keyValue = [KeyValueData new];
                keyValue.value = [allDictionary valueForKey:key];
                keyValue.key = key;
                [array addObject:keyValue];

            }
            flightPreferencesDropDown.seatTypeArray = array;
        }
    }
    
    return flightPreferencesDropDown;
}

+ (NSArray *)parseFrequentFlyerArray:(NSArray *)array {
    NSMutableArray *parsedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in array) {
        FrequentFlightPreferences *frequentFlightPreferences = [Parser parseFrequentFlyerDictionary:dictionary];
        [parsedArray addObject:frequentFlightPreferences];
    }
    return parsedArray;
}

+ (FrequentFlightPreferences *)parseFrequentFlyerDictionary:(NSDictionary *)dictionary {
    FrequentFlightPreferences *frequentFlightPreferences = [FrequentFlightPreferences new];
    frequentFlightPreferences.flyerShortName = [Parser getValueForKey:@"iata" inDictionary:dictionary];
    frequentFlightPreferences.flyerName = [Parser getValueForKey:@"label" inDictionary:dictionary];
//    frequentFlightPreferences.flyerFlag = [Parser getURLForKey:@"logo_url" inDictionary:dictionary];
//    frequentFlightPreferences.flyerValue = [Parser getURLForKey:@"value" inDictionary:dictionary];

    return frequentFlightPreferences;
    
}







+ (Amenities *)parseAmenitiesDictionary:(NSDictionary *)dictionary {
    Amenities *amenities = [Amenities new];
    
    NSArray *parsedArray = [Parser genericValueForKey:@"basic" inDictionary:dictionary];
    if ([parsedArray isKindOfClass:[NSArray class]]) {
        amenities.basicArray = parsedArray;
    }
    amenities.mainArray = [Parser parseAmenitiesMainTypeArray:[dictionary objectForKey:@"main"]];
    return amenities;
}

+ (NSArray *)parseAmenitiesMainTypeArray:(NSArray *)array {
    NSMutableArray *parsedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in array) {
        AmenitiesMainType *amenitiesMainType = [Parser parseAmenitiesMainTypeDictionary:dictionary];
        [parsedArray addObject:amenitiesMainType];
    }
    return parsedArray;
}

+ (AmenitiesMainType *)parseAmenitiesMainTypeDictionary:(NSDictionary *)dictionary {
    AmenitiesMainType *amenitiesMainType = [AmenitiesMainType new];
    amenitiesMainType.name = [Parser getValueForKey:@"name" inDictionary:dictionary];
    amenitiesMainType.className = [Parser getValueForKey:@"class" inDictionary:dictionary];
    amenitiesMainType.available = [Parser getValueForKey:@"available" inDictionary:dictionary];

    return amenitiesMainType;
    
}


//MARK:- FLIGHTS APIS
+ (NSArray *)parseAirlineSearchArray:(NSArray *)array {
    
    NSMutableArray *parsedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in array) {
        AirportSearch *airportSearch = [Parser parseAirportSearchDictionary:dictionary];
        [parsedArray addObject:airportSearch];
    }
    return parsedArray;
    
}


+ (NSArray *)parseAirportSearchArray:(NSArray *)array {
    
    NSMutableArray *parsedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in array) {
        AirportSearch *airportSearch = [Parser parseAirportSearchDictionary:dictionary];
        [parsedArray addObject:airportSearch];
    }
    return parsedArray;
    
}


+ (AirportSearch *)parseAirportSearchDictionary:(NSDictionary *)dictionary {
    
    AirportSearch *airportSearch = [AirportSearch new];
    airportSearch.category = [Parser getValueForKey:@"category" inDictionary:dictionary];
    airportSearch.iata = [Parser getValueForKey:@"iata" inDictionary:dictionary];
    airportSearch.airport = [Parser getValueForKey:@"airport" inDictionary:dictionary];
    airportSearch.city = [Parser getValueForKey:@"city" inDictionary:dictionary];
    airportSearch.country = [Parser getValueForKey:@"country" inDictionary:dictionary];
    airportSearch.countryCode = [Parser getValueForKey:@"country_code" inDictionary:dictionary];
    airportSearch.latitude = [Parser getValueForKey:@"latitude" inDictionary:dictionary];
    airportSearch.longitude = [Parser getValueForKey:@"longitude" inDictionary:dictionary];
    airportSearch.rank = [Parser getValueForKey:@"rank" inDictionary:dictionary];
    airportSearch.timezone = [Parser getValueForKey:@"timezone" inDictionary:dictionary];
    airportSearch.timezoneShortName = [Parser getValueForKey:@"timezone_short_name" inDictionary:dictionary];
    airportSearch.timezoneOffset = [Parser getValueForKey:@"timezone_offset" inDictionary:dictionary];
    airportSearch.timezoneDisplay = [Parser getValueForKey:@"timezone_display" inDictionary:dictionary];
    airportSearch.label = [Parser getValueForKey:@"label" inDictionary:dictionary];
    airportSearch.value = [Parser getValueForKey:@"value" inDictionary:dictionary];
    
    NSString * distanceString = [Parser getValueForKey:@"distance" inDictionary:dictionary];
    airportSearch.distanceLabel = distanceString;
    if (distanceString != nil){
        NSArray * distanceComponents = [distanceString componentsSeparatedByString:@" km"];
        if(distanceComponents.count == 2)
        airportSearch.distance = [[distanceComponents objectAtIndex:0] integerValue];
    }
    return airportSearch;
    
}



+ (BookFlightObject *)parseBookFlightObjectForSIDDictionary:(NSDictionary *)dictionary {
    BookFlightObject *bookFlightObject = [BookFlightObject new];
    bookFlightObject.sid = [Parser getValueForKey:@"sid" inDictionary:dictionary];
    if ([dictionary objectForKey:@"display_groups"]) {
        NSDictionary *dictionaryGeneric = [Parser genericValueForKey:@"display_groups" inDictionary:dictionary];
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            bookFlightObject.displayGroups = dictionaryGeneric;
        }
    }
    if ([dictionary objectForKey:@"vcodes"]) {
        NSArray *array = [Parser genericValueForKey:@"vcodes" inDictionary:dictionary];
        if ([array isKindOfClass:[NSArray class]]) {
            bookFlightObject.vcodes = array;
        }
    }
    return bookFlightObject;
}


+ (NSArray *)parseFlightSearchResultDictionary:(NSDictionary *)dictionary {
    NSMutableArray *outputFlightArray = [[NSMutableArray alloc] init];
    for (NSDictionary *flightGroupDictionary in [dictionary objectForKey:@"flights"]) {
        NSDictionary *results = [flightGroupDictionary objectForKey:@"results"];
        
        //Storing all of them into defaults
        NSDictionary *allAirlines = [results objectForKey:@"aldet"];
        for (NSString *key in allAirlines) {
            NSString *value = [allAirlines objectForKey:key];
            NSString *specialKey = [NSString stringWithFormat:@"%@%@",key,SPECIAL_KEY_AIRLINE];
            [Parser saveValue:value forKey:specialKey];
        }
        
        
        //Storing all of them into defaults
        NSDictionary *allCities = [results objectForKey:@"cityap"];
        for (NSString *key in allCities) {
            NSString *value = [allCities objectForKey:key];
            NSString *specialKey = [NSString stringWithFormat:@"%@%@",key,SPECIAL_KEY_CITY];
            [Parser saveValue:value forKey:specialKey];
        }
        
        
        //Storing all of them into defaults
        NSMutableArray *outputAirportsArray = [[NSMutableArray alloc] init];
        NSDictionary *allAirports = [results objectForKey:@"apdet"];
        for (NSString *key in allAirports) {
            NSDictionary *airportDictionary = [allAirports objectForKey:key];
            Airport *airport = [Parser parseAirport:airportDictionary withKey:key];
            [outputAirportsArray addObject:airport];
        }
        
        NSArray *flightsArray = [results objectForKey:@"j"];
        for (NSDictionary *flightDictionary in flightsArray) {
            FlightJourney *flightJourney = [Parser parseFlightJourney:flightDictionary];
            flightJourney.airportsArray = outputAirportsArray;
            [outputFlightArray addObject:flightJourney];
        }
    }
    return outputFlightArray;
}

+ (Airport *)parseAirport:(NSDictionary *)dictionary withKey:(NSString *) key {
    Airport *airport = [Airport new];
    airport.city = [Parser getValueForKey:@"c" inDictionary:dictionary];
    airport.country = [Parser getValueForKey:@"cname" inDictionary:dictionary];
    airport.name = [Parser getValueForKey:@"n" inDictionary:dictionary];
    airport.key = key;
    return airport;
}
+(void) saveValue:(NSString *)value forKey:(NSString *)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:key];
    [defaults synchronize];
}


+ (FlightJourney *)parseFlightJourney:(NSDictionary *)dictionary {
    FlightJourney *flightJourney = [FlightJourney new];
    flightJourney.totalFare = [Parser getValueForKey:@"farepr" inDictionary:dictionary];
    flightJourney.FareTypeName = [Parser getValueForKey:@"FareTypeName" inDictionary:dictionary];
    flightJourney.arrivalDate = [Parser getValueForKey:@"ad" inDictionary:dictionary];
    flightJourney.arrivalTime = [Parser getValueForKey:@"at" inDictionary:dictionary];
    flightJourney.cabinClass = [Parser getValueForKey:@"cabin_class" inDictionary:dictionary];
    flightJourney.changeOfPlaneTitle = [Parser getValueForKey:@"copt" inDictionary:dictionary];
    flightJourney.departureDate = [Parser getValueForKey:@"dd" inDictionary:dictionary];
    flightJourney.departureTime = [Parser getValueForKey:@"dt" inDictionary:dictionary];
    flightJourney.primaryKey = [Parser getValueForKey:@"fk" inDictionary:dictionary];
    flightJourney.fewSeatsRemaining = [Parser getValueForKey:@"fsr" inDictionary:dictionary];
    flightJourney.longLayover = [Parser getValueForKey:@"llow" inDictionary:dictionary];
    flightJourney.overnightFlight = [Parser getValueForKey:@"ovgtf" inDictionary:dictionary];
    flightJourney.redEye = [Parser getValueForKey:@"red" inDictionary:dictionary];
    flightJourney.refundable = [Parser getValueForKey:@"rfd" inDictionary:dictionary];
    flightJourney.reschedulable = [Parser getValueForKey:@"rsc" inDictionary:dictionary];
    flightJourney.totalTime = [dictionary valueForKey:@"tt"];
    flightJourney.airlineCodesArray = [dictionary valueForKey:@"al"];
    flightJourney.allAirportsCodes = [dictionary valueForKey:@"ap"];
    flightJourney.airlineFare = [Parser parseFare:[dictionary valueForKey:@"fare"]];
    
    
    
    NSMutableArray *parsedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *legDictionary in [dictionary valueForKey:@"leg"]) {
        Leg *leg = [Parser parseLeg:legDictionary];
        [parsedArray addObject:leg];
    }
    flightJourney.allLegs = parsedArray;
    
    
    return flightJourney;
}

+ (Leg *)parseLeg:(NSDictionary *)dictionary {
    Leg *leg = [Leg new];
    leg.arrivalDate = [Parser getValueForKey:@"ad" inDictionary:dictionary];
    leg.arrivalTime = [Parser getValueForKey:@"at" inDictionary:dictionary];
    leg.departureDate = [Parser getValueForKey:@"dd" inDictionary:dictionary];
    leg.departureTime = [Parser getValueForKey:@"dt" inDictionary:dictionary];
    leg.totalTime = [Parser getValueForKey:@"tt" inDictionary:dictionary];
    
    leg.airlineCodesArray = [dictionary valueForKey:@"al"];
    leg.allAirportsCodes = [dictionary valueForKey:@"ap"];
    
    NSMutableArray *parsedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *flightDictionary in [dictionary valueForKey:@"flights"]) {
        Flight *flight = [Parser parseFlight:flightDictionary];
        [parsedArray addObject:flight];
    }
    leg.allFlights = parsedArray;
    
    return leg;
}


+ (Flight *)parseFlight:(NSDictionary *)dictionary {
    Flight *flight = [Flight new];
    flight.arrivalDate = [Parser getValueForKey:@"ad" inDictionary:dictionary];
    flight.arrivalTime = [Parser getValueForKey:@"at" inDictionary:dictionary];
    flight.arrivalTerminus = [Parser getValueForKey:@"atm" inDictionary:dictionary];
    flight.airlineCode = [Parser getValueForKey:@"atm" inDictionary:dictionary];
    flight.departureDate = [Parser getValueForKey:@"dd" inDictionary:dictionary];
    flight.departureTime = [Parser getValueForKey:@"dt" inDictionary:dictionary];
    flight.cabinClass = [Parser getValueForKey:@"cc" inDictionary:dictionary];
    flight.departureTerminus = [Parser getValueForKey:@"dtm" inDictionary:dictionary];
    flight.equipment = [Parser getValueForKey:@"eq" inDictionary:dictionary];
    flight.flightNumber = [Parser getValueForKey:@"fn" inDictionary:dictionary];
    flight.fromAirport = [Parser getValueForKey:@"fr" inDictionary:dictionary];
    flight.toAirport = [Parser getValueForKey:@"to" inDictionary:dictionary];
    flight.changeOfPlaneTitle = [Parser getValueForKey:@"copt" inDictionary:dictionary];
    flight.primaryKey = [Parser getValueForKey:@"fk" inDictionary:dictionary];
    flight.fewSeatsRemaining = [Parser getValueForKey:@"fsr" inDictionary:dictionary];
    flight.longLayover = [Parser getValueForKey:@"llow" inDictionary:dictionary];
    flight.overnightFlight = [Parser getValueForKey:@"ovgtf" inDictionary:dictionary];
    flight.redEye = [Parser getValueForKey:@"red" inDictionary:dictionary];
    flight.refundable = [Parser getValueForKey:@"rfd" inDictionary:dictionary];
    flight.reschedulable = [Parser getValueForKey:@"rsc" inDictionary:dictionary];
    flight.totalFare = [Parser getValueForKey:@"farepr" inDictionary:dictionary];
    flight.FareTypeName = [Parser getValueForKey:@"FareTypeName" inDictionary:dictionary];
    flight.allAirportsCodes = [dictionary valueForKey:@"ap"];
    flight.time = [dictionary valueForKey:@"ft"];
    return flight;
}

+ (Fare *)parseFare:(NSDictionary *)dictionary {
    Fare *fare = [Fare new];
    fare.baseFare = [NSString stringWithFormat:@"%@",[[dictionary valueForKey:@"BF"] valueForKey:@"value"]];
    
    
    
    fare.grandTotal = [NSString stringWithFormat:@"%@",[[dictionary valueForKey:@"grand_total"] valueForKey:@"value"]];
    
    
    
    fare.taxes = [NSString stringWithFormat:@"%@",[[dictionary valueForKey:@"taxes"] valueForKey:@"value"]];
    
    
    
    fare.totalPayable = [NSString stringWithFormat:@"%@",[[dictionary valueForKey:@"total_payable_now"] valueForKey:@"value"]];
    return fare;
}






+ (FlightResultsDict *)parseFlightResultsDictDictionary:(NSDictionary *)dictionary {
    
    FlightResultsDict *flightResultsDict = [FlightResultsDict new];
    flightResultsDict.cityap = [Parser getValueForKey:@"cityap" inDictionary:dictionary];
    flightResultsDict.rsid = [Parser getValueForKey:@"rsid" inDictionary:dictionary];
    flightResultsDict.jCount = [Parser getValueForKey:@"j_count" inDictionary:dictionary];
    
    if ([dictionary objectForKey:@"taxes"]) {
        NSDictionary *dict = [dictionary objectForKey:@"taxes"];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            NSArray *allKeys = [dict allKeys];
            NSMutableArray *parsedArray = [[NSMutableArray alloc] init];
            for (NSString *key in allKeys) {
                KeyValueData *keyValueData = [KeyValueData new];
                keyValueData.key = key;
                keyValueData.value = [dict objectForKey:key];
                [parsedArray addObject:keyValueData];
            }
            flightResultsDict.taxesKeyValueArray = parsedArray;
        }
    }
   

    if ([dictionary objectForKey:@"aldet"]) {
        NSDictionary *dict = [dictionary objectForKey:@"aldet"];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            NSArray *allKeys = [dict allKeys];
            NSMutableArray *parsedArray = [[NSMutableArray alloc] init];
            for (NSString *key in allKeys) {
                KeyValueData *keyValueData = [KeyValueData new];
                keyValueData.key = key;
                keyValueData.value = [dict objectForKey:key];
                [parsedArray addObject:keyValueData];
            }
            flightResultsDict.aldetKeyValueArray = parsedArray;
        }
    }
    
    if ([dictionary objectForKey:@"alMaster"]) {
        NSDictionary *dict = [dictionary objectForKey:@"alMaster"];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            
            NSArray *allKeys = [dict allKeys];
            NSMutableArray *parsedArray = [[NSMutableArray alloc] init];
            
            for (NSString *key in allKeys) {
                
                NSDictionary *dictInner = [dict objectForKey:key];
                FlightResultAlMaster *flightResultAlMaster = [Parser parseFlightResultAlMaster:dictInner];
                flightResultAlMaster.code = key;
                [parsedArray addObject:flightResultAlMaster];
            }
            flightResultsDict.flightResultAlMasterArray = parsedArray;
        }
    }
    
    flightResultsDict.jArray = [Parser parseFlightResultJDictArray:[dictionary objectForKey:@"j"]];
    
    if ([dictionary objectForKey:@"f"]) {
        NSArray *arrayGeneric = [Parser genericValueForKey:@"f" inDictionary:dictionary];
        if ([arrayGeneric isKindOfClass:[NSArray class]]) {
            flightResultsDict.fArray = arrayGeneric;
        }
    }
    
    if ([dictionary objectForKey:@"apdet"]) {
        NSDictionary *dictionaryGeneric = [Parser genericValueForKey:@"apdet" inDictionary:dictionary];
        if ([dictionaryGeneric isKindOfClass:[NSDictionary class]]) {
            flightResultsDict.apdetDict = dictionaryGeneric;
        }
    }
    
    return flightResultsDict;
}

+ (FlightResultAlMaster *)parseFlightResultAlMaster:(NSDictionary *)dictionary {
    
    FlightResultAlMaster *flightResultAlMaster = [FlightResultAlMaster new];
    flightResultAlMaster.name = [Parser getValueForKey:@"name" inDictionary:dictionary];
    flightResultAlMaster.bgColor = [Parser getValueForKey:@"bgcolor" inDictionary:dictionary];
    flightResultAlMaster.humaneScrore = [Parser getValueForKey:@"humane_score" inDictionary:dictionary];
    
    return  flightResultAlMaster;

    
}


+ (NSArray *)parseFlightResultJDictArray:(NSArray *)array {
    
    NSMutableArray *parsedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in array) {
        FlightResultJDict *flightResultJDict = [Parser parseFlightResultJDict:dictionary];
        [parsedArray addObject:flightResultJDict];
    }
    return parsedArray;
    
    
    
    
}

+ (FlightResultJDict *)parseFlightResultJDict:(NSDictionary *)dictionary {
    FlightResultJDict *flightResultJDict = [FlightResultJDict new];
    
    flightResultJDict.red = [Parser getValueForKey:@"red" inDictionary:dictionary];
    flightResultJDict.otherFares = [Parser getValueForKey:@"otherfares" inDictionary:dictionary];
    flightResultJDict.ID = [Parser getValueForKey:@"id" inDictionary:dictionary];
    flightResultJDict.isIcc = [Parser getValueForKey:@"icc" inDictionary:dictionary];
    flightResultJDict.isIic = [Parser getValueForKey:@"iic" inDictionary:dictionary];
    flightResultJDict.dTime = [Parser getValueForKey:@"dt" inDictionary:dictionary];
    flightResultJDict.aDate = [Parser getValueForKey:@"ad" inDictionary:dictionary];
    flightResultJDict.isOverNight = [Parser getValueForKey:@"ovngt" inDictionary:dictionary];
    flightResultJDict.pricingSolutionKey = [Parser getValueForKey:@"pricingsolution_key" inDictionary:dictionary];
    flightResultJDict.redT = [Parser getValueForKey:@"redt" inDictionary:dictionary];
    flightResultJDict.aDate = [Parser getValueForKey:@"ad" inDictionary:dictionary];
    
    if ([dictionary objectForKey:@"humane_price"]) {
        NSDictionary *dictionaryGeneric = [Parser genericValueForKey:@"humane_price" inDictionary:dictionary];
        if ([dictionaryGeneric isKindOfClass:[NSDictionary class]]) {
            flightResultJDict.humanePrice = dictionaryGeneric;
        }
    }
    flightResultJDict.sict = [Parser getValueForKey:@"sict" inDictionary:dictionary];
    flightResultJDict.isRefundable = [Parser getValueForKey:@"rfd" inDictionary:dictionary];
    flightResultJDict.qid = [Parser getValueForKey:@"qid" inDictionary:dictionary];
    flightResultJDict.ovgtf = [Parser getValueForKey:@"ovgtf" inDictionary:dictionary];
    flightResultJDict.cc = [Parser getValueForKey:@"cc" inDictionary:dictionary];
    flightResultJDict.fsr = [Parser getValueForKey:@"fsr" inDictionary:dictionary];
    flightResultJDict.coa = [Parser getValueForKey:@"coa" inDictionary:dictionary];
    flightResultJDict.humaneScore = [Parser getValueForKey:@"humane_score" inDictionary:dictionary];
    if ([dictionary objectForKey:@"leg"]) {
        NSArray *arrayGeneric = [Parser genericValueForKey:@"leg" inDictionary:dictionary];
        if ([arrayGeneric isKindOfClass:[NSArray class]]) {
            flightResultJDict.legArray = arrayGeneric;
        }
    }
    flightResultJDict.eqt = [Parser getValueForKey:@"eqt" inDictionary:dictionary];
    flightResultJDict.farePr = [Parser getValueForKey:@"farepr" inDictionary:dictionary];
    flightResultJDict.cop = [Parser getValueForKey:@"cop" inDictionary:dictionary];
    
    if ([dictionary objectForKey:@"al"]) {
        NSArray *arrayGeneric = [Parser genericValueForKey:@"al" inDictionary:dictionary];
        if ([arrayGeneric isKindOfClass:[NSArray class]]) {
            flightResultJDict.alArray = arrayGeneric;
        }
    }
    
    flightResultJDict.apc = [Parser getValueForKey:@"apc" inDictionary:dictionary];
    flightResultJDict.cott = [Parser getValueForKey:@"cott" inDictionary:dictionary];
    flightResultJDict.overNightText = [Parser getValueForKey:@"ovngtt" inDictionary:dictionary];
    flightResultJDict.dDate = [Parser getValueForKey:@"dd" inDictionary:dictionary];
    flightResultJDict.dspNoShow = [Parser getValueForKey:@"dsp_noshow" inDictionary:dictionary];

    if ([dictionary objectForKey:@"hmne_prms"]) {
        NSArray *arrayGeneric = [Parser genericValueForKey:@"hmne_prms" inDictionary:dictionary];
        if ([arrayGeneric isKindOfClass:[NSArray class]]) {
            flightResultJDict.humaneParamsArray = arrayGeneric;
        }
    }
    flightResultJDict.seats = [Parser getValueForKey:@"seats" inDictionary:dictionary];
    flightResultJDict.lg = [Parser getValueForKey:@"lg" inDictionary:dictionary];
    
    if ([dictionary objectForKey:@"humane_arr"]) {
        NSDictionary *dictionaryGeneric = [Parser genericValueForKey:@"humane_arr" inDictionary:dictionary];
        if ([dictionaryGeneric isKindOfClass:[NSDictionary class]]) {
            flightResultJDict.humaneArrDict = dictionaryGeneric;
        }
    }
    
    if ([dictionary objectForKey:@"ap"]) {
        NSArray *arrayGeneric = [Parser genericValueForKey:@"ap" inDictionary:dictionary];
        if ([arrayGeneric isKindOfClass:[NSArray class]]) {
            flightResultJDict.apArray = arrayGeneric;
        }
    }
    
    
    if ([dictionary objectForKey:@"fare"]) {
        NSDictionary *dictionaryGeneric = [Parser genericValueForKey:@"fare" inDictionary:dictionary];
        if ([dictionaryGeneric isKindOfClass:[NSDictionary class]]) {
            flightResultJDict.fareDict = dictionaryGeneric;
        }
    }
    
    flightResultJDict.llow = [Parser getValueForKey:@"llow" inDictionary:dictionary];
    flightResultJDict.slot = [Parser getValueForKey:@"slot" inDictionary:dictionary];
    flightResultJDict.fareTypeName = [Parser getValueForKey:@"FareTypeName" inDictionary:dictionary];
    flightResultJDict.stop = [Parser getValueForKey:@"stp" inDictionary:dictionary];
    flightResultJDict.cot = [Parser getValueForKey:@"cot" inDictionary:dictionary];
    flightResultJDict.fareBasis = [Parser getValueForKey:@"farebasis" inDictionary:dictionary];
    flightResultJDict.aTime = [Parser getValueForKey:@"at" inDictionary:dictionary];
    flightResultJDict.vendor = [Parser getValueForKey:@"vendor" inDictionary:dictionary];
    flightResultJDict.llowT = [Parser getValueForKey:@"llowt" inDictionary:dictionary];
    flightResultJDict.ovgtlo = [Parser getValueForKey:@"ovgtlo" inDictionary:dictionary];
    flightResultJDict.isIcc = [Parser getValueForKey:@"is_icc" inDictionary:dictionary];
    flightResultJDict.ofk = [Parser getValueForKey:@"ofk" inDictionary:dictionary];
    flightResultJDict.coat = [Parser getValueForKey:@"coat" inDictionary:dictionary];
    flightResultJDict.changeOfPlaneText = [Parser getValueForKey:@"copt" inDictionary:dictionary];
    flightResultJDict.rsc = [Parser getValueForKey:@"rsc" inDictionary:dictionary];
    flightResultJDict.slo = [Parser getValueForKey:@"slo" inDictionary:dictionary];
    flightResultJDict.fk = [Parser getValueForKey:@"fk" inDictionary:dictionary];
    if ([dictionary objectForKey:@"tt"]) {
        NSArray *arrayGeneric = [Parser genericValueForKey:@"tt" inDictionary:dictionary];
        if ([arrayGeneric isKindOfClass:[NSArray class]]) {
            flightResultJDict.tt = arrayGeneric;
        }
    }
    if ([dictionary objectForKey:@"lott"]) {
        NSArray *arrayGeneric = [Parser genericValueForKey:@"lott" inDictionary:dictionary];
        if ([arrayGeneric isKindOfClass:[NSArray class]]) {
            flightResultJDict.lott = arrayGeneric;
        }
    }


    
    
    
    return flightResultJDict;
    
}


//MARK:- Utility
+ (NSDictionary *)getData:(NSDictionary *)dictionary
{
    if([dictionary objectForKey:@"data"]){
        return [dictionary objectForKey:@"data"];
    }
    return nil;
}

+ (NSString *)getErrorFromDictionary:(NSDictionary *)dictionary
{
    NSString *error = OOPS_ERROR_MESSAGE;
    @try {
        NSArray *errorArray = [dictionary valueForKey:@"errors"];
        for (id possibleError in errorArray) {
            NSString *possibleErrorString = [NSString stringWithFormat:@"%@",possibleError];
            if ([possibleErrorString isKindOfClass:[NSString class]]) {
                if ([ERROR_CODES objectForKey:possibleErrorString])
                    error = [ERROR_CODES objectForKey:possibleErrorString];
                }
            }
        }
    @catch (NSException *exception) {
        NSLog(@"Error Exception");
    } @finally {
        //Nothing here
    }
    return error;
}






//MARK:- ConversionCode
+ (NSString *) convertToFrontEnd:(NSString *) inputString
{
    if(inputString) {
        const char *jsonString = [inputString UTF8String];
        NSData *jsonData = [NSData dataWithBytes:jsonString length:strlen(jsonString)];
        return [[NSString alloc] initWithData:jsonData encoding:NSNonLossyASCIIStringEncoding];
    }
    return EMPTY_STRING;
}

+ (NSString *)generateCSVFromArray:(NSArray *)array
{
    if (!array || array.count == 0) {
        return EMPTY_STRING;
    }
    NSString *outputString = EMPTY_STRING;
    for (int i = 0; i<array.count; i++) {
        outputString = [outputString stringByAppendingString:array[i]];
        if (i != array.count - 1) {
            outputString = [outputString stringByAppendingString:@","];
        }
    }
    
    return outputString;
}

+ (NSString *) convertToBackend:(NSString *) inputString
{
    if(inputString) {
        
        NSString *uniText = [NSString stringWithUTF8String:[inputString UTF8String]];
        NSData *msgData = [uniText dataUsingEncoding:NSNonLossyASCIIStringEncoding];
        return [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding] ;
    }
    return EMPTY_STRING
}


+ (BOOL)exists:(NSString *)value
{
    if (value) {
        if(![value isEqualToString:@""])
        {
            return true;
        }
    }
    return false;
}




//MARK:- new API
+ (BOOL)checkForSuccess:(NSDictionary *)responseDictionary
{
    NSString *success = [NSString stringWithFormat:@"%@",[responseDictionary objectForKey:SUCCESS_KEY]];
    if ([success isEqualToString:@"0"]) {
        return FALSE;
    }
    return TRUE;
}




@end
