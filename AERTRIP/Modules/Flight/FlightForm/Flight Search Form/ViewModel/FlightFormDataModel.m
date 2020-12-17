//
//  HomeFlightViewModel.m
//  Aertrip
//
//  Created by Hrishikesh Devhare on 14/12/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "FlightFormDataModel.h"
#import "Constants.h"
#import "AirportSearch.h"
#import "Parser.h"
#import "Network.h"
#import "AirportSelctionHandler.h"
#import "RecentSearchDisplayModel.h"
#import "MulticityFlightLeg.h"
#import "AirlineSearchModel.h"
#import <CoreLocation/CoreLocation.h>

@class BookFlightObject;
@class FlightWhatNextData;

@interface FlightFormDataModel () <AirportSelctionHandler, CalendarDataHandler   ,CLLocationManagerDelegate>

@property (strong , nonatomic) CLLocationManager * locationManager;
@end

@implementation FlightFormDataModel

-(instancetype)init {
    
    self = [super init];
    
    self.fromFlightArray = [[NSMutableArray alloc] init];
    self.toFlightArray = [[NSMutableArray alloc] init];
    self.recentSearchArray = [[NSMutableArray alloc]init];

    self.multiCityArray = [[NSMutableArray alloc] init];
    
    self.segmentTitleSectionArray = [@[@"Oneway", @"Return", @"Multi-City"] mutableCopy];
    
    self.travellerCount = [[TravellerCount alloc]init];
    self.travellerCount.flightAdultCount = 1;
    self.travellerCount.flightChildrenCount = 0;
    self.travellerCount.flightInfantCount = 0;
    
    
    FlightClass *flightClassOne = [FlightClass new];
    flightClassOne.imageName = @"";
    flightClassOne.name = @"Economy";
    flightClassOne.type = ECONOMY_FLIGHT_TYPE;
    
    self.flightClass = flightClassOne;
    self.flightSearchType = SINGLE_JOURNEY;
    
    self.onwardsDate = [NSDate date];
    [self setupLocationService];
    [self getRecentSearches];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterForground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    return self;
}

-(void)setInitialValues{
    
    self.fromFlightArray = [[NSMutableArray alloc] init];
    self.toFlightArray = [[NSMutableArray alloc] init];
    self.recentSearchArray = [[NSMutableArray alloc]init];
    
    self.segmentTitleSectionArray = [@[@"Onway", @"Return", @"Multi-City"] mutableCopy];

    self.travellerCount = [[TravellerCount alloc]init];
    self.travellerCount.flightAdultCount = 1;
    self.travellerCount.flightChildrenCount = 0;
    self.travellerCount.flightInfantCount = 0;
    
    
    FlightClass *flightClassOne = [FlightClass new];
    flightClassOne.imageName = @"";
    flightClassOne.name = @"Economy";
    flightClassOne.type = ECONOMY_FLIGHT_TYPE;
    
    self.flightClass = flightClassOne;
    self.flightSearchType = SINGLE_JOURNEY;
}


-(void)appDidEnterForground:(NSNotification *)notification  {
    
    if ([self.onwardsDate compare:[NSDate date]] == NSOrderedAscending ) {
        self.onwardsDate = [NSDate date];
    }
    
    if ([self.returnDate compare:[NSDate date]] == NSOrderedAscending ) {
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDate *tomorrow = [cal dateByAddingUnit:NSCalendarUnitDay
                                           value:1
                                          toDate:[NSDate date]
                                         options:0];
        self.returnDate = tomorrow;
    }

    [self.delegate setupDatesInOnwardsReturnView];
    
}


- (void)selectedDatesFromCalendar:(NSDate *)startDate endDate:(NSDate *)endDate isReturn:(BOOL)isReturn
{
    self.onwardsDate = startDate;
    self.returnDate = endDate;
    if (isReturn) {
        self.flightSearchType = RETURN_JOURNEY;
    }
    else {
        self.flightSearchType = SINGLE_JOURNEY;
    }
    [self.delegate datesSelectedIsReturn:isReturn];
}


-(NSString *) generateCVSStringFromArray:(NSArray *)array forDisplay:(BOOL)forDisplay
{
    if (!array) {
        return @"";
    }
    if (array.count == 0) {
        return @"";
    }
    
    if (array.count == 1 ) {
        return [array firstObject];
    }
    
    NSString *outputString = @"";
    for (int i = 0; i<array.count; i++) {
        outputString = [outputString stringByAppendingString:array[i]];
        if (i != array.count - 1) {
            outputString = [outputString stringByAppendingString:@", "];
        }
        if (i == array.count - 2 && forDisplay) {
            outputString = [outputString stringByAppendingString:@"\n"];
        }
    }
    
    return outputString;
}


- (NSString *)generateCSVFromSelectionArray:(NSArray *)array forDisplay:(BOOL)forDisplay
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (AirportSearch *airportSearch in array) {
        [resultArray addObject:airportSearch.iata];
    }
    return [self generateCVSStringFromArray:resultArray forDisplay:forDisplay];
}


- (NSString *)parseString:(NSString *)value
{
    if (value) {
        if(![value isEqualToString:@""])
        {
            NSString *trimmedString = [value stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            return trimmedString;
        }
    }
    return @"";
}


- (NSString *)dateFormattedForAPIRequest:(NSDate*)date {
    NSString *depart = @"";
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:@"dd-MM-yyyy"];
    depart = [inputDateFormatter stringFromDate:self.onwardsDate];
    return depart;
}

- (NSMutableDictionary *)buildDictionaryForFlightSearch
{
    
    NSMutableDictionary *parametersDynamic = [[NSMutableDictionary alloc] init];
    
    [parametersDynamic setObject:[self parseString:[NSString stringWithFormat:@"%ld",(long)self.travellerCount.flightAdultCount]] forKey:@"adult"];
    [parametersDynamic setObject:[self parseString:[NSString stringWithFormat:@"%ld",(long)self.travellerCount.flightChildrenCount]] forKey:@"child"];
    [parametersDynamic setObject:[self parseString:[NSString stringWithFormat:@"%ld",(long)self.travellerCount.flightInfantCount]] forKey:@"infant"];
 

    [parametersDynamic setObject:[self.flightClass.name capitalizedString] forKey:@"cabinclass"];
    
    
        if (self.flightSearchType == MULTI_CITY) {

            [parametersDynamic setObject:@"multi" forKey:@"trip_type"];

            
            for (int i = 0 ; i  < self.multiCityArray.count ; i++ ){
                
                MulticityFlightLeg * flightLeg = [self.multiCityArray objectAtIndex:i];
                
                NSString * origin = flightLeg.origin.iata;
                
                if ( origin == nil) {
                    break;
                }
                NSString * destination = flightLeg.destination.iata;

                if ( destination == nil) {
                    break;
                }
                NSDate * date = flightLeg.travelDate;

                if ( date == nil) {
                    break;
                }
                
                 NSString *nameOriginKey = [NSString stringWithFormat:@"origin[%i]",i];
                [parametersDynamic setObject:origin forKey:nameOriginKey];
                

                NSString *nameDestinationKey = [NSString stringWithFormat:@"destination[%i]",i];
                [parametersDynamic setObject:destination forKey:nameDestinationKey];

                
                NSString * dateInString = [self formateDateForMultiCityAPIRequest:date];
                
                NSString *nameDepartKey = [NSString stringWithFormat:@"depart[%i]",i];
                [parametersDynamic setObject:dateInString forKey:nameDepartKey];

            }
        }
        else {
            if (self.onwardsDate != nil) {
                NSString * depart = [self dateFormattedForAPIRequest:self.onwardsDate];
                [parametersDynamic setObject:depart forKey:@"depart"];
            }
            
            [parametersDynamic setObject:[self generateCSVFromSelectionArray:self.fromFlightArray forDisplay:NO] forKey:@"origin"];
            [parametersDynamic setObject:[self generateCSVFromSelectionArray:self.toFlightArray forDisplay:NO]  forKey:@"destination"];
            
            
            
               NSString *tripType = @"single";
            
            if (self.flightSearchType == RETURN_JOURNEY) {
                tripType = @"return";
                NSString *returnString = @"";
                if (self.returnDate != nil) {
                    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
                    [inputDateFormatter setDateFormat:@"dd-MM-yyyy"];
                    returnString = [inputDateFormatter stringFromDate:self.returnDate];
                }
                [parametersDynamic setObject:returnString forKey:@"return"];
            }else {
                [parametersDynamic setObject:@"1" forKey:@"totalLegs"];

            }
            
            [parametersDynamic setObject:tripType forKey:@"trip_type"];

        }
    
   
        return parametersDynamic;
}



- (NSString *)dateFormatedFromDate:(NSDate *)date
{
    if (date != nil) {
        NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
        [inputDateFormatter setDateFormat:@"d MMM"];
        NSString *dateString = [inputDateFormatter stringFromDate:date];
        return dateString;
    }else {
        return @"";
    }
    
    
}

- (NSString *)dayOfDate:(NSDate *)date {
    if (date != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
        
        NSInteger weekday = [components weekday];
        NSString *weekdayName = [dateFormatter weekdaySymbols][weekday - 1];
        return weekdayName;
    }
    return @"";
}


-(NSString*)flightFromText{
   return [self generateCSVFromSelectionArray:self.fromFlightArray forDisplay:YES];
}

-(NSString*)flightToText {
    return [self generateCSVFromSelectionArray:self.toFlightArray forDisplay:YES];
}


-(NSString*)returnValueText {
    return  [self dateFormatedFromDate:self.returnDate];
}


- (long)adultCount{
    return self.travellerCount.flightAdultCount;
}
-(long)childrenCount
{
    return  self.travellerCount.flightChildrenCount;
}
- (long)infantCount {
    return self.travellerCount.flightInfantCount;
}

- (NSString *)getImageNameForFlightClass:(FlightClass *)flightClass {
    
    if ([flightClass.type isEqualToString:ECONOMY_FLIGHT_TYPE]) {
        return @"EconomyClassBlack";
    }else if ([flightClass.type isEqualToString:BUSINESS_FLIGHT_TYPE]) {
        return @"BusinessClassBlack";
        
    }else if ([flightClass.type isEqualToString:PREMIUM_FLIGHT_TYPE]) {
        return @"PreEconomyClassBlack";
        
    }else if ([flightClass.type isEqualToString:FIRST_FLIGHT_TYPE]) {
        return @"FirstClassBlack";
        
    }
    return @"";
}


-(UIImage*)flightClassImage {
    return [UIImage imageNamed:[self getImageNameForFlightClass:self.flightClass]];

}

-(NSString*) flightClassName{
    
    if ([self.flightClass.type isEqualToString:PREMIUM_FLIGHT_TYPE] ) {
        return @"Premium";
    }
    return  self.flightClass.name;
}


-(void)performFlightSearch{
    
    if([self isValidFlightSearch]) {
        [self performFlightSearchWebServiceCall:[self buildDictionaryForFlightSearch]];
    }
}

-(void)performFlightSearchWith:(NSMutableDictionary*)dict {
    [self performFlightSearchWebServiceCall:dict];
}

- (BOOL)validateSingleLegJourney {
    if (self.fromFlightArray.count == 0) {
        [self.delegate  showErrorMessage:@"Please select an origin airport"];
        [self.delegate shakeAnimation:FromLabel];
        return NO;
    }
    
    if (self.toFlightArray.count == 0) {
        [self.delegate  showErrorMessage:@"Please select a destination airport"];
        [self.delegate shakeAnimation:ToLabel];
        return NO;
    }
    NSString *from = [self generateCSVFromSelectionArray:self.fromFlightArray forDisplay:NO];
    NSString *to = [self generateCSVFromSelectionArray:self.toFlightArray forDisplay:NO];
    if ([from isEqualToString:to]) {
        [self.delegate  showErrorMessage:@"Origin and destination cannot be same"];
        [self.delegate shakeAnimation:ToLabel];
        return NO;
        
    }
    
    if (!self.onwardsDate) {
        [self.delegate  showErrorMessage:@"Please select a departure date"];
        [self.delegate shakeAnimation:DepartureDateLabel];
        return NO;
    }
    if (self.flightSearchType == RETURN_JOURNEY) {
        NSMutableArray *countryCodeArr = [[NSMutableArray alloc] init];
        
        AirportSearch *fromCountry = self.fromFlightArray.firstObject;
        AirportSearch *toCountry = self.toFlightArray.firstObject;
                
        if (fromCountry != nil && toCountry != nil) {
            if(![fromCountry.countryCode  isEqual: @""]){
                [countryCodeArr addObject: [fromCountry countryCode]];
            }
            
            if(![toCountry.countryCode  isEqual: @""]){
                [countryCodeArr addObject: [toCountry countryCode]];
            }
        }
        
        [self.delegate didFetchCountryCodes: countryCodeArr];

        
        if (!self.returnDate) {
            [self.delegate  showErrorMessage:@"Please select a return date"];
            [self.delegate shakeAnimation:ArrivalDateLabel];
            return NO;
        }
    }
    
    if ( (self.flightClass.name == nil) || [self.flightClass.name isEqual: @""]){
        [self.delegate  showErrorMessage:@"Please select a cabin class."];
        [self.delegate shakeAnimation: CabinClass];
        return  NO;
    }
    
     return YES;
}

-(BOOL)validateMultiCityJourney {
    
    NSMutableArray *countryCodeArr = [[NSMutableArray alloc] init];

    for (int i = 0 ; i  < self.multiCityArray.count ; i++ ){
        
        MulticityFlightLeg * flightLeg = [self.multiCityArray objectAtIndex:i];
        if (flightLeg.origin.countryCode != nil){
            [countryCodeArr addObject: [flightLeg.origin countryCode]];
        }
        if ((flightLeg.destination.countryCode) != nil){
            [countryCodeArr addObject: [flightLeg.destination countryCode]];
        }
//        [countryCodeArr addObject: [flightLeg.destination countryCode]];
        
        if (i == self.multiCityArray.count - 1) {
            [self.delegate didFetchCountryCodes: countryCodeArr];
        }

        NSString * origin = flightLeg.origin.iata;
        
        if ( origin == nil) {
             [self.delegate  showErrorMessage:@"Please select an origin airport"];
            NSIndexPath * index = [NSIndexPath indexPathForRow:i inSection:0];
            [self.delegate shakeAnimation:MulticityFromLabel atIndex:index];
             return NO;
        }
        NSString * destination = flightLeg.destination.iata;
        
        if ( destination == nil) {
            [self.delegate  showErrorMessage:@"Please select a destination airport"];
            NSIndexPath * index = [NSIndexPath indexPathForRow:i inSection:0];
            [self.delegate shakeAnimation:MulticityToLabel atIndex:index];

             return  NO;
        }
        NSDate * date = flightLeg.travelDate;
        
        if ( date == nil) {
            [self.delegate  showErrorMessage:@"Please select a valid date"];
            NSIndexPath * index = [NSIndexPath indexPathForRow:i inSection:0];
            [self.delegate shakeAnimation:MulticityDateLabel atIndex:index];
             return NO;
        }
        
        if(origin == destination){
            [self.delegate  showErrorMessage:@"Origin and destination cannot be same"];
            return NO;

        }
    }
    if ( (self.flightClass.name == nil) || [self.flightClass.name isEqual: @""]){
        [self.delegate  showErrorMessage:@"Please select a cabin class."];
        [self.delegate shakeAnimation: CabinClass];
        return  NO;
    }
    return YES;
}

-(BOOL)isValidFlightSearch
{
    BOOL isValidSearch = NO;
    
    if (self.flightSearchType != MULTI_CITY) {
        isValidSearch =  [self validateSingleLegJourney];
    }
    else {
        isValidSearch = [self validateMultiCityJourney];
    }
    
    return isValidSearch;
}


- (void) performFlightSearchWebServiceCall:(NSDictionary*)flightSearchParameters
{
    [self.delegate showLoaderIndicatorForFilghtSearch];
    __weak typeof(self) weakSelf = self;

    [[Network sharedNetwork]
     callGETApi:FLIGHT_SEARCH_API
     parameters:flightSearchParameters
     loadFromCache:NO
     expires:YES
     success:^(NSDictionary *dataDictionary) {
        if (!weakSelf) { return; }
        [weakSelf addToRecentSearch:flightSearchParameters];
         BookFlightObject * bookingObject = [self handleResponseForFlightSearch:dataDictionary flightSearchParameters:flightSearchParameters];
         
         dispatch_async(dispatch_get_main_queue(), ^{
                      [weakSelf.delegate showFlightSearchResult:bookingObject flightSearchParameters:flightSearchParameters];
         });
         


    } failure:^(NSString *error, BOOL popup) {
        if (!weakSelf) { return; }
        [weakSelf.delegate showErrorMessage:error];
        [weakSelf.delegate hideLoaderIndicatorForFilghtSearch];
    }];
}



- (BookFlightObject*)handleResponseForFlightSearch:(NSDictionary *)dictionary flightSearchParameters:(NSDictionary*)flightSearchParameters{
    
    BookFlightObject *bookFlightObject= [Parser parseBookFlightObjectForSIDDictionary:dictionary];
    NSInteger adultCount = [[flightSearchParameters valueForKey:@"adult"] intValue];
    NSInteger infantCount = [[flightSearchParameters valueForKey:@"infant"] intValue];
    NSInteger childCount = [[flightSearchParameters valueForKey:@"child"] intValue];
    
    bookFlightObject.travellerCount.flightAdultCount = adultCount;
    bookFlightObject.travellerCount.flightChildrenCount = childCount;
    bookFlightObject.travellerCount.flightInfantCount = infantCount;
    
    bookFlightObject.flightAdultCount = adultCount;
    bookFlightObject.flightChildrenCount = childCount;
    bookFlightObject.flightInfantCount = infantCount;
    NSInteger count =  adultCount + infantCount + childCount;
    
  
    NSString * date;
    NSString * tripType = [flightSearchParameters valueForKey:@"trip_type"];

        if ( [tripType isEqualToString:@"return"]) {
            
            NSString * departDateString = [flightSearchParameters valueForKey:@"depart"];
              NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//              [dateFormatter setDateFormat:@"dd-MM-yyyy"];
            NSDate * departDate = [self dateFromString:departDateString];//[dateFormatter dateFromString:departDateString];
            bookFlightObject.onwardDate = departDate;
              [dateFormatter setDateFormat:@"d MMM"];
            
            date = [dateFormatter stringFromDate:departDate];
            NSString * returnDateString = [flightSearchParameters valueForKey:@"return"];
            
//            [dateFormatter setDateFormat:@"dd-MM-yyyy"];
            NSDate * returnDate = [self dateFromString:returnDateString];//[dateFormatter dateFromString:returnDateString];
            [dateFormatter setDateFormat:@"d MMM"];
            
            NSString * returnString = [dateFormatter stringFromDate:returnDate];
            
            date = [date stringByAppendingFormat:@" - %@",returnString];
            bookFlightObject.returnDate = returnDate;
        }
        if ([tripType isEqualToString:@"single"]) {
                
            NSString * departDateString = [flightSearchParameters valueForKey:@"depart"];
              NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
              [dateFormatter setDateFormat:@"dd-MM-yyyy"];
              NSDate * departDate = [self dateFromString:departDateString];//[dateFormatter dateFromString:departDateString];
              [dateFormatter setDateFormat:@"d MMM"];

            date = [dateFormatter stringFromDate:departDate];
            bookFlightObject.onwardDate = departDate;
        }
    if ( [tripType isEqualToString:@"multi"]) {
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"d MMM"];

        NSString * firstDateString = [flightSearchParameters valueForKey:@"depart[0]"];
        NSString * lastDateKey = [NSString stringWithFormat:@"%@%lu%@",@"depart[",(bookFlightObject.displayGroups.allKeys.count - 1),@"]" ];
        NSString * lastDateString = [flightSearchParameters valueForKey:lastDateKey];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSDate * firstDate = [self dateFromString:firstDateString];//[dateFormatter dateFromString:firstDateString];
        NSDate * lastDate = [self dateFromString:lastDateString];//[dateFormatter dateFromString:lastDateString];
        [dateFormatter setDateFormat:@"d MMM"];

        NSString * formattedFirstDate = [dateFormatter stringFromDate:firstDate];
        NSString * formattedLastDate = [dateFormatter stringFromDate:lastDate];
        
        NSMutableArray *storedDates = [[NSMutableArray alloc] init];
        for (int i=0; i<_multiCityArray.count; i++) {
            
            NSString * lastDateKey = [NSString stringWithFormat:@"%@%d%@",@"depart[",(i),@"]" ];
            NSString * lastDateString = [flightSearchParameters valueForKey:lastDateKey];

            if(lastDateString != nil){
                if(![storedDates containsObject:lastDateString]){
                    [storedDates addObject:lastDateString];
                }
            }
        }
        
        if(storedDates.count > 2){
            date = [NSString stringWithFormat:@"%@ ... %@",formattedFirstDate,formattedLastDate];
        }else{
            date = [NSString stringWithFormat:@"%@ - %@",formattedFirstDate,formattedLastDate];
        }
    }
        
    if ([[dictionary valueForKey:@"is_domestic"] boolValue]) {
        bookFlightObject.isDomestic = YES;
    } else {
        bookFlightObject.isDomestic = NO;
    }
        
    
    if((childCount > 0 && infantCount > 0) || (childCount > 0) || (infantCount > 0)) {
        bookFlightObject.subTitleString = [NSString stringWithFormat:@"%@  •  %ld Pax  •  %@", date,  (long)count, [flightSearchParameters valueForKey:@"cabinclass"]];
    }else{
        bookFlightObject.subTitleString = [NSString stringWithFormat:@"%@  •  %ld Adt  •  %@", date,  (long)count, [flightSearchParameters valueForKey:@"cabinclass"]];
    }
    
   if ( [tripType isEqualToString:@"return"]) {
       bookFlightObject.flightSearchType = RETURN_JOURNEY;
   }
    if ( [tripType isEqualToString:@"single"]) {
        bookFlightObject.flightSearchType = SINGLE_JOURNEY;
    }
    if ( [tripType isEqualToString:@"multi"]) {
        bookFlightObject.flightSearchType = MULTI_CITY;
    }
    
    
    UIFont * sourceSansPRO18 = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18];
    NSDictionary * attributesForAirportCode =  @{NSFontAttributeName:sourceSansPRO18};
    
    

    if ( [tripType isEqualToString:@"return"]) {
        
        NSMutableAttributedString * originAttributedString = [[NSMutableAttributedString alloc] initWithString:[flightSearchParameters valueForKey:@"origin"] attributes:attributesForAirportCode];
        
        NSMutableAttributedString * destinatinAttributedString = [[NSMutableAttributedString alloc] initWithString:[flightSearchParameters valueForKey:@"destination"] attributes:attributesForAirportCode];
        
        NSAttributedString * join ;
        
        
        NSTextAttachment * textAttachment = [[NSTextAttachment alloc]init];
        UIImage *iconImage = [UIImage imageNamed:@"return"];
        
        [textAttachment setBounds:CGRectMake(0, roundf(sourceSansPRO18.capHeight - iconImage.size.height)/2.f, iconImage.size.width, iconImage.size.height)];
        [textAttachment setImage:iconImage];
        join = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
        
        
        NSMutableAttributedString * outputAttributedString = [[NSMutableAttributedString alloc]initWithAttributedString:originAttributedString];
        [outputAttributedString appendAttributedString:join];
        [outputAttributedString appendAttributedString:destinatinAttributedString];
        
        bookFlightObject.titleString =  outputAttributedString;
    }
    if ( [tripType isEqualToString:@"single"]) {
        
        NSMutableAttributedString * originAttributedString = [[NSMutableAttributedString alloc] initWithString:[flightSearchParameters valueForKey:@"origin"] attributes:attributesForAirportCode];
        
        NSMutableAttributedString * destinatinAttributedString = [[NSMutableAttributedString alloc] initWithString:[flightSearchParameters valueForKey:@"destination"] attributes:attributesForAirportCode];
        
        NSAttributedString * join ;
        
        
        NSTextAttachment * textAttachment = [[NSTextAttachment alloc]init];
        UIImage *iconImage = [UIImage imageNamed:@"oneway"];
        
        [textAttachment setBounds:CGRectMake(0, roundf(sourceSansPRO18.capHeight - iconImage.size.height)/2.f, iconImage.size.width, iconImage.size.height)];
        [textAttachment setImage:iconImage];
        join = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
        
        NSMutableAttributedString * outputAttributedString = [[NSMutableAttributedString alloc]initWithAttributedString:originAttributedString];
        [outputAttributedString appendAttributedString:join];
        [outputAttributedString appendAttributedString:destinatinAttributedString];
        
        bookFlightObject.titleString =  outputAttributedString;
        
    }
    
    if  ( [tripType isEqualToString:@"multi"]) {
    
        
        NSString * previousIndexOrigin = @"";
        NSString * previousIndexDestination = @"";
        
        NSMutableAttributedString * outputAttributedString  = [[NSMutableAttributedString alloc] init];
        UIFont * sourceSansPRO18 = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18];
        
        
        NSTextAttachment * textAttachment = [[NSTextAttachment alloc]init];
        UIImage *iconImage = [UIImage imageNamed:@"oneway"];
        
        [textAttachment setBounds:CGRectMake(0, roundf(sourceSansPRO18.capHeight - iconImage.size.height)/2.f, iconImage.size.width, iconImage.size.height)];
        [textAttachment setImage:iconImage];
        
        NSAttributedString* join = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
        
        for (int i = 0;  i < 5; i++) {
            
            NSString * originKey = [NSString stringWithFormat:@"origin[%d]",i];
            NSString * destinationKey = [NSString stringWithFormat:@"destination[%d]",i];
            NSString * currentOrigin = [flightSearchParameters objectForKey:originKey];
            NSString * currentDestination = [flightSearchParameters objectForKey:destinationKey];
            
            if ( currentOrigin == nil) {
                break;
            }
            
            
            NSDictionary * attributesForAirportCode =  @{NSFontAttributeName:sourceSansPRO18};
            
            NSAttributedString * originAttributedString = [[NSAttributedString alloc] initWithString:currentOrigin attributes:attributesForAirportCode];
            NSAttributedString * destinatinAttributedString = [[NSAttributedString alloc] initWithString:currentDestination attributes:attributesForAirportCode];
            
            if ( [previousIndexDestination isEqualToString:currentOrigin] ){
                [outputAttributedString appendAttributedString:join];
                [outputAttributedString appendAttributedString:destinatinAttributedString];
            }else {
                
                if ( i != 0 ) {
                    NSAttributedString * comma = [[NSAttributedString alloc]initWithString:@"," attributes:attributesForAirportCode];
                    UIFont * sourceSansPRO12 = [UIFont fontWithName:@"SourceSansPro-Semibold" size:12];
                    NSDictionary * attributesForSpace =  @{NSFontAttributeName:sourceSansPRO12};
                    
                    NSAttributedString * space = [[NSAttributedString alloc]initWithString:@" " attributes:attributesForSpace];
                    
                    [outputAttributedString appendAttributedString:comma];
                    [outputAttributedString appendAttributedString:space];
                    
                }
                [outputAttributedString appendAttributedString:originAttributedString];
                [outputAttributedString appendAttributedString:join];
                [outputAttributedString appendAttributedString:destinatinAttributedString];
            }
            
            previousIndexOrigin = currentOrigin;
            previousIndexDestination = currentDestination;
        }
        
        bookFlightObject.titleString =  outputAttributedString;
    }
    return bookFlightObject;

}


//MARK:- Airport Selection Preparation and Delegate Methods

-(AirportSelectionVM*)prepareForAirportSelection:(BOOL)isFrom  airportSelectionMode:(AirportSelectionMode)airportSelectionMode
{
    
    AirportSelectionVM * fromToSelectionVM = [[AirportSelectionVM alloc]
                                              initWithIsFrom:isFrom
                                              delegateHandler:self
                                              fromArray:self.fromFlightArray
                                              toArray:self.toFlightArray
                                              airportSelectionMode:airportSelectionMode
                                              ];
    
    return fromToSelectionVM;
}


-(AirportSelectionVM*)prepareForMultiCityAirportSelection:(BOOL)isFrom indexPath:(NSIndexPath*)indexPath
{
    self.selectedMultiCityArrayIndex = indexPath;
    MulticityFlightLeg * currentLeg = [self.multiCityArray objectAtIndex:indexPath.row];

    NSMutableArray *fromFlightArray = [NSMutableArray array];
    if ( currentLeg.origin){
        [fromFlightArray addObject:currentLeg.origin];
    }
    
    NSMutableArray* toFlightArray =  [NSMutableArray array];
    if ( currentLeg.destination){
        [toFlightArray addObject:currentLeg.destination];
    }

    AirportSelectionVM * fromToSelectionVM = [[AirportSelectionVM alloc]
                                              initWithIsFrom:isFrom
                                              delegateHandler:self
                                              fromArray:fromFlightArray
                                              toArray:toFlightArray
                                              airportSelectionMode:AirportSelectionModeMultiCityJourney
                                              ];
    
    return fromToSelectionVM;
}

- (void)setMulticityAirports:(NSMutableArray * _Nullable)fromArray toArray:(NSMutableArray * _Nullable)toArray atIndexPath:(NSIndexPath*)indexPath{
  
    self.selectedMultiCityArrayIndex = indexPath;
    MulticityFlightLeg * currentSelected = [self.multiCityArray objectAtIndex:indexPath.row];
    currentSelected.origin = [fromArray firstObject];
    currentSelected.destination = [toArray firstObject];
    
    [self.multiCityArray replaceObjectAtIndex:indexPath.row withObject:currentSelected];
    
    [self.delegate reloadMultiCityTableViewAtIndex:indexPath];

    NSUInteger nextIndex = self.selectedMultiCityArrayIndex.row + 1;
    if(nextIndex < self.multiCityArray.count) {
        
        MulticityFlightLeg * nextRow = [self.multiCityArray objectAtIndex:nextIndex];
        if ( nextRow.origin == nil) {
            nextRow.origin = [toArray firstObject];

            NSIndexPath * nextIndexPath = [NSIndexPath indexPathForRow:nextIndex inSection:indexPath.section];

            [self.multiCityArray replaceObjectAtIndex:nextIndexPath.row  withObject:nextRow];
            [self.delegate reloadMultiCityTableViewAtIndex:nextIndexPath];
            
        }
    }
    
    NSUInteger previousIndex = self.selectedMultiCityArrayIndex.row - 1 ;
    
    if(previousIndex != -1){
        
        MulticityFlightLeg * previousRow = [self.multiCityArray objectAtIndex:previousIndex];
        if ( previousRow.destination == nil){
            if(previousRow.origin.iata != currentSelected.origin.iata){
                previousRow.destination = [fromArray firstObject];
                NSIndexPath * previousIndexPath = [NSIndexPath indexPathForRow:previousIndex inSection:indexPath.section];

                [self.multiCityArray replaceObjectAtIndex:previousIndexPath.row  withObject:previousRow];
                [self.delegate reloadMultiCityTableViewAtIndex:previousIndexPath];
            }
            
        }
    }
}

- (void)flightFromSource:(NSMutableArray *)fromArray toDestination:(NSMutableArray *)toArray airlineNum:(NSString *)airlineNum
{
    self.airlineCode = airlineNum;

        if (self.flightSearchType == MULTI_CITY) {
            
            [self setMulticityAirports:fromArray toArray:toArray atIndexPath:self.selectedMultiCityArrayIndex];
    }else {
        self.fromFlightArray = fromArray;
        self.toFlightArray = toArray;
        [self.delegate setupFromAndToView];
    }
}


//MARK:- Date Selection Preparation and Delegate Methods

-(CalendarVM*)VMForDateSelectionIsOnwardsSelection:(BOOL)isOnwards forReturnMode:(BOOL)forReturn
{
    
    CalendarVM * calendarVM = [[CalendarVM alloc] init];
    calendarVM.isStartDateSelection = isOnwards;
    calendarVM.isHotelCalendar = NO;
    calendarVM.date1 = self.onwardsDate;
    if ( self.flightSearchType == RETURN_JOURNEY) {
        calendarVM.date2 = self.returnDate;
    }
     calendarVM.isReturn = forReturn;
    calendarVM.delegate = self;
    return calendarVM;
}



// MARK:- Location Based Network API
-(void)setupLocationService
{
    //     Requesting Permission to Use Location Services.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dictionary = self.recentSearchArray[indexPath.row];
    NSMutableDictionary * queryDictionay = [NSMutableDictionary dictionaryWithDictionary:[dictionary objectForKey:@"query"]];
    
    NSString * tripType = [queryDictionay objectForKey:@"trip_type"];
    
    if ([tripType isEqualToString:@"multi"] ) {
        NSArray * departArray = [queryDictionay objectForKey:@"depart"];
        NSMutableArray * newDepartArray = [NSMutableArray array];
        for (int i = 0;  i < departArray.count; i++) {
            NSString * departDateStr = [departArray objectAtIndex:i];
            NSDate * departDate = [self dateFromString:departDateStr];
            NSString * newDepartDateStr = [self stringFromDate:departDate];
            [newDepartArray addObject:newDepartDateStr];
        }
        [queryDictionay setObject:newDepartArray forKey:@"depart"];
        
    } else {
        NSString * departDateStr = [queryDictionay objectForKey:@"depart"];
        NSDate * departDate = [self dateFromString:departDateStr];
        NSString * newDepartDateStr = [self stringFromDate:departDate];
        [queryDictionay setValue:newDepartDateStr forKey:@"depart"];

        if ([tripType isEqualToString:@"return"] ) {
            NSString * returnDateStr = [queryDictionay objectForKey:@"return"];
            NSDate *returnDate = [self dateFromString:returnDateStr];
            NSString * newReturnDateStr = [self stringFromDate:returnDate];
            [queryDictionay setValue:newReturnDateStr forKey:@"return"];
        }
    }
    
    if ([tripType isEqualToString:@"multi"] ) {
    
        NSArray * originArray = [queryDictionay objectForKey:@"origin"];
        NSArray * destinationArray = [queryDictionay objectForKey:@"destination"];
        NSArray * departArray = [queryDictionay objectForKey:@"depart"];

        for (int i = 0;  i < originArray.count; i++) {

            NSString *nameOriginKey = [NSString stringWithFormat:@"origin[%i]",i];
            NSString *nameDestinationKey = [NSString stringWithFormat:@"destination[%i]",i];
            NSString *nameDepartKey = [NSString stringWithFormat:@"depart[%i]",i];
            NSString * currentOrigin = [originArray objectAtIndex:i];
            [queryDictionay setValue:currentOrigin forKey:nameOriginKey];
            NSString * currentDestination = [destinationArray objectAtIndex:i];
            [queryDictionay setValue:currentDestination forKey:nameDestinationKey];
            NSString * date = [departArray objectAtIndex:i];
            [queryDictionay setValue:date forKey:nameDepartKey];
        }
        [queryDictionay removeObjectsForKeys:[NSArray arrayWithObjects:@"depart", @"destination", @"origin", nil]];
    }
    [self performFlightSearchWebServiceCall:queryDictionay];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    [self defaultCityForForm];
    NSLog(@"Error: %@",error.description);
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    [self.locationManager stopUpdatingLocation];
    [self performNearbyAirportsByLocation:currentLocation];
}


-(void)performNearbyAirportsByLocation:(CLLocation*)location
{
    ///Chnage for what next functionality by @Golu
    if ([FlightWhatNextData.shared isSettingForWhatNext]){
        return;
    }
    ///end
    [self.locationManager stopUpdatingLocation];
    
    NSString* latitudeLongituteString = [NSString stringWithFormat:@"?latitude=%.8f&longitude=%.8f",location.coordinate.latitude,location.coordinate.longitude];
    
    NSString * url = [NEARBY_AIRPORT_SEARCH_API stringByAppendingString:latitudeLongituteString];
    
    __weak typeof(self) weakSelf = self;
    
    [[Network sharedNetwork] callGETApi:url parameters:nil loadFromCache:NO expires:YES success:^(NSDictionary *dataDictionary) {
        if (!weakSelf) { return; }
        [weakSelf handleNearbyAirportByLocationResult:dataDictionary];
    } failure:^(NSString *error, BOOL popup) {
        if (!weakSelf) { return; }
        [weakSelf.delegate showErrorMessage:error.description];
    }];
    
}

-(void)handleNearbyAirportByLocationResult:(NSDictionary*)responseDictionary
{
    NSArray * airports = [responseDictionary allValues];
    NSArray * Airports = [Parser parseAirportSearchArray:airports];
    
    NSArray * nearbyAirports = [Airports sortedArrayUsingComparator:^NSComparisonResult(AirportSearch *airportOne, AirportSearch *airportTwo){
        
        if (airportOne.distance < airportTwo.distance) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if (airportOne.distance > airportTwo.distance) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        return NSOrderedSame;
    }];
    
    if(self.fromFlightArray.count == 0){
        AirportSearch * nearestAirport = [nearbyAirports firstObject];
        
        [self.fromFlightArray removeAllObjects];
        [self.fromFlightArray addObject:nearestAirport];
        [self.delegate setupFromAndToView];
    }
    
}


-(void)defaultCityForForm
{
    ///Chnage for what next functionality by @Golu
    if ([FlightWhatNextData.shared isSettingForWhatNext]){
        return;
    }
    ///end
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"popularAirports" ofType:@"json"];
    
    NSError *error= NULL;
    NSData* data = [NSData dataWithContentsOfFile:filepath];
    NSArray * arrayFromFile = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    if (error == NULL)
    {
        NSArray * array = [Parser parseAirportSearchArray:arrayFromFile];
        AirportSearch * nearestAirport = [array firstObject];
        [self.fromFlightArray removeAllObjects];
        [self.fromFlightArray addObject:nearestAirport];
        [self.delegate setupFromAndToView];
    }
}

- (void)setupNewMulticitySearch {
    
        // Add two Arrays
        [self addFlightLegForMulticityJourney];
        [self addFlightLegForMulticityJourney];
        [self.delegate disableRemoveMulticityButton:YES];
        [self.delegate reloadMultiCityTableView];
}

//MARK:- MULTICITY Implemenatation

- (void)setupMultiCityView {
    
    
    if(self.multiCityArray.count == 0) {
    
        [self setupNewMulticitySearch];
        return;
    }
    

    AirportSearch * firstOriginAirport = [self.fromFlightArray firstObject];
    AirportSearch * firstDestinationAirport = [self.toFlightArray firstObject];
    
    MulticityFlightLeg *firstLeg = [self.multiCityArray firstObject];
    
    BOOL airportSearchUpdated = NO;
    
    
    if([firstOriginAirport.iata compare:firstLeg.origin.iata] != NSOrderedSame) {
        airportSearchUpdated = YES;
    }
    if([firstDestinationAirport.iata compare:firstLeg.destination.iata] != NSOrderedSame) {
        airportSearchUpdated = YES;
    }
    
    //Change for flight form not fill for some case.
    if ((airportSearchUpdated) && (!self.isSettingForMulticity)){
        [self.multiCityArray removeAllObjects];
        [self setupNewMulticitySearch];
    }
}


-(void)removeLastLegFromJourney{
    
    [self.multiCityArray removeLastObject];
    
    
    NSInteger count = self.multiCityArray.count ;
    if( count > 2 ) {
        [self.delegate disableRemoveMulticityButton:NO];
    }
    else {
        [self.delegate disableRemoveMulticityButton:YES];
    }
    if ( count < 5){
        [self.delegate disableAddMulticityButton:NO];
    }
}

-(void)addFlightLegForMulticityJourney{
    
    
    MulticityFlightLeg* nextRowInMulticity = [self getNextRowForMulticity];
    [self.multiCityArray addObject:nextRowInMulticity];
    
    
    if(self.multiCityArray.count > 2){
        [self.delegate disableRemoveMulticityButton:NO];
    }else {
        [self.delegate disableRemoveMulticityButton:YES];
    }
    
    if( self.multiCityArray.count == 5 ) {
        [self.delegate disableAddMulticityButton:YES];

    }
}


- (MulticityFlightLeg *)getNextRowForMulticity
{
    
    MulticityFlightLeg * newRow = [[MulticityFlightLeg alloc]init];
    
    NSUInteger count = self.multiCityArray.count;
    
    if (count == 0 && self.fromFlightArray.count > 0){
        
        AirportSearch * firstObject = [self.fromFlightArray firstObject];
        newRow.origin = firstObject;
    }
    else {
        
        MulticityFlightLeg * lastObject = [self.multiCityArray lastObject];
        newRow.origin = lastObject.destination;
    }
    
    if(count == 0 ) {
        AirportSearch * destination = [self.toFlightArray firstObject];
        newRow.destination = destination;
    }
    
    if( count == 0 ){
        newRow.travelDate = self.onwardsDate;
    }
    
    return newRow;

}


-(MulticityCalendarVM*)prepareVMForMulticityCalendar:(NSUInteger)currentIndex
{
    MulticityCalendarVM * newMulticityCalendarVM = [[MulticityCalendarVM alloc]init];
    newMulticityCalendarVM.currentIndex = currentIndex;
    newMulticityCalendarVM.delegate = self;
    
    NSMutableDictionary * travelDatesDictionary = [[NSMutableDictionary alloc]init];

    for (int i = 0 ; i < self.multiCityArray.count ; i++) {
        
        MulticityFlightLeg * currentFligtLeg = [self.multiCityArray objectAtIndex:i];
        NSString * key = [NSString stringWithFormat:@"%d",i];
        NSString * date = [self formateDateForAPI:currentFligtLeg.travelDate];
        
        [travelDatesDictionary setObject:date forKey:key];
    }
    newMulticityCalendarVM.travelDatesDictionary = travelDatesDictionary;
    
    return newMulticityCalendarVM;
    
}

-(void)MulticityDateSelectionWithDictionary:(NSDictionary*)dictionary reloadUI:(BOOL)reloadUI{
    
    
    for ( NSString * key in [dictionary allKeys] ) {
        
        NSString *dateString = [dictionary objectForKey:key];
        NSUInteger index = [key integerValue];
        
        MulticityFlightLeg * flightLeg = [self.multiCityArray objectAtIndex:index];
        
        NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
        [inputDateFormatter setDateFormat:@"yyyy-MM-dd"];

        NSDate * updatedDate = [inputDateFormatter dateFromString:dateString];
        flightLeg.travelDate = updatedDate;
        
        [self.multiCityArray replaceObjectAtIndex:index withObject:flightLeg];
    }
    
    if (reloadUI) {
        [self.delegate reloadMultiCityTableView];
    }
}

//MARK:- Recent Searches

-(void)addToRecentSearch:(NSDictionary*)flightSearchParameters
{
    
    NSMutableDictionary * flightParameters = [NSMutableDictionary dictionaryWithDictionary:flightSearchParameters];
    
    NSError *error;
    NSData *jsonData ;
    
    NSString * tripType = [flightSearchParameters valueForKey:@"trip_type"];
    
    if ([tripType isEqualToString:@"multi"] ) {
        NSArray * departArray = [flightParameters objectForKey:@"depart"];
        NSMutableArray * newDepartArray = [NSMutableArray array];
        for (int i = 0;  i < departArray.count; i++) {
            NSString * departDateStr = [departArray objectAtIndex:i];
            NSDate * departDate = [self dateFromString:departDateStr];
            NSString * newDepartDateStr = [self stringFromDate:departDate];
            [newDepartArray addObject:newDepartDateStr];
        }
        [flightParameters setObject:newDepartArray forKey:@"depart"];
        
    } else {
        NSString * departDateStr = [flightParameters objectForKey:@"depart"];
        NSDate * departDate = [self dateFromString:departDateStr];
        NSString * newDepartDateStr = [self stringFromDate:departDate];
        [flightParameters setValue:newDepartDateStr forKey:@"depart"];

        if ([tripType isEqualToString:@"return"] ) {
            NSString * returnDateStr = [flightParameters objectForKey:@"return"];
            NSDate *returnDate = [self dateFromString:returnDateStr];
            NSString * newReturnDateStr = [self stringFromDate:returnDate];
            [flightParameters setValue:newReturnDateStr forKey:@"return"];
        }
    }
    
    if ([tripType compare:@"multi"]  == NSOrderedSame) {

        NSMutableArray * originAirports = [NSMutableArray arrayWithCapacity:5];
        NSMutableArray * destinationAirports = [NSMutableArray arrayWithCapacity:5];
        NSMutableArray * datesAirports = [NSMutableArray arrayWithCapacity:5];

        for (int i = 0;  i < 5; i++) {

            NSString * originKey = [NSString stringWithFormat:@"origin[%d]",i];
            NSString * destinationKey = [NSString stringWithFormat:@"destination[%d]",i];
            NSString * currentOrigin = [flightParameters objectForKey:originKey];
            NSString * currentDestination = [flightParameters objectForKey:destinationKey];
            NSString * dateKey = [NSString stringWithFormat:@"depart[%d]",i];
            NSString * dateInStringFormat = [flightParameters objectForKey:dateKey];

            if ( currentOrigin == nil) {
                break;
            }
            [originAirports addObject:currentOrigin];
            [destinationAirports addObject:currentDestination];
            [datesAirports addObject:dateInStringFormat];

            [flightParameters removeObjectsForKeys:[NSArray arrayWithObjects:originKey,destinationKey,dateKey, nil]];
        }

        [flightParameters setValue:originAirports forKey:@"origin"];
        [flightParameters setValue:destinationAirports forKey:@"destination"];
        [flightParameters setValue:datesAirports forKey:@"depart"];
    }
       
    jsonData = [NSJSONSerialization dataWithJSONObject:flightParameters // Here you can pass array or dictionary
        options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
          error:&error];
    
    
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //This is your JSON String
        //NSUTF8StringEncoding encodes special characters using an escaping scheme
    } else {
        NSLog(@"Got an error: %@", error);
        jsonString = @"";
    }
    
    NSMutableDictionary *parametersDynamic = [[NSMutableDictionary alloc] init];
    [parametersDynamic setObject:@"flight" forKey:@"product"];
    [parametersDynamic setObject:[self dateFormattedForAPIRequest:self.onwardsDate] forKey:@"data[start_date]"];
    [parametersDynamic setObject:jsonString forKey:@"data[query]"];
    
    __weak typeof(self) weakSelf = self;

    [[Network sharedNetwork] callApi:RECENT_SEARCH_SET_API parameters:parametersDynamic loadFromCache:NO expires:YES success:^(NSDictionary *dataDictionary) {
        if (!weakSelf) { return; }
        [weakSelf getRecentSearches];
    } failure:^(NSString *error, BOOL popup) {
        NSLog(@"%@", error.debugDescription);
    }];
}


-(void)getRecentSearches{
    ///Chnage for what next functionality by @Golu
    if([FlightWhatNextData.shared isSettingForWhatNext]){
          [self handleWhatNext];
      }
    ///end
        NSMutableDictionary *parametersDynamic = [[NSMutableDictionary alloc] init];
    [parametersDynamic setObject:@"flight" forKey:@"product"];
    
    __weak typeof(self) weakSelf = self;

    [[Network sharedNetwork] callGETApi:RECENT_SEARCH_GET_API parameters:parametersDynamic loadFromCache:NO expires:YES success:^(NSDictionary *dataDictionary) {
        if (!weakSelf) { return; }
        [weakSelf handleRecentSearchWSResponse:dataDictionary];
    } failure:^(NSString *error, BOOL popup) {
        ///Chnage for what next functionality by @Golu
        [FlightWhatNextData.shared clearData];
        ///end
    }];

}


-(FlightClass *)flightClassForString:(NSString*)flightClassName{
    
    
    FlightClass *flightclass = [FlightClass new];
    flightclass.imageName = @"";

    
    if ([flightClassName caseInsensitiveCompare:@"Economy"] == NSOrderedSame) {
    
        flightclass.name = @"Economy";
        flightclass.type = ECONOMY_FLIGHT_TYPE;
    }
    
    if ([flightClassName caseInsensitiveCompare:@"Premium Economy"] == NSOrderedSame) {
    
        flightclass.name = @"Premium Economy";
        flightclass.type = PREMIUM_FLIGHT_TYPE;
    }
    
     if ([flightClassName caseInsensitiveCompare:@"Business"] == NSOrderedSame) {
       
        flightclass.name = @"Business";
        flightclass.type = BUSINESS_FLIGHT_TYPE;

    }

     if ([flightClassName caseInsensitiveCompare:@"First"] == NSOrderedSame) {
       
        flightclass.name = @"First";
        flightclass.type = FIRST_FLIGHT_TYPE;
    }
    
    return flightclass ;
}


- (void)setFlightFormUIFrom:(NSDictionary *)airportsDictionary destination:(NSString *)destination origin:(NSString *)origin {
    NSArray * originsArray = [origin componentsSeparatedByString:@", "];
    NSMutableArray * airportsArray = [NSMutableArray array];
    for ( NSString * airportCode in originsArray) {
        
        NSDictionary * sourceAirportDictionary = [airportsDictionary valueForKey:airportCode];
        AirportSearch *SourceAirport = [Parser parseAirportSearchDictionary:sourceAirportDictionary];
        [airportsArray addObject:SourceAirport];
    }
    self.fromFlightArray = [NSMutableArray arrayWithArray:airportsArray];
    
    // Fetch destination airport
    airportsArray = [NSMutableArray array];
    NSArray * destinationAirports = [destination componentsSeparatedByString:@", "];
    
    for ( NSString * airportCode in destinationAirports) {
        NSDictionary * destinationAirportDictionary = [airportsDictionary valueForKey:airportCode];
        AirportSearch *ToAirport = [Parser parseAirportSearchDictionary:destinationAirportDictionary];
        [airportsArray addObject:ToAirport];
    }
    self.toFlightArray = [NSMutableArray arrayWithArray:airportsArray];
    
    [self.delegate setupFromAndToView];
}

- (void)setFlightFormUIForOnwardDate:(NSString *)departDateString returnDateString:(NSString *)returnDateString tripType:(NSString *)tripType {
    NSDate * departDate = [self dateFromString:departDateString];
    NSDate * returnDate = [self dateFromString:returnDateString];
    
    BOOL isReturn = NO;
    if ( [tripType isEqualToString:@"return"]){
        isReturn = YES;
    }
    [self selectedDatesFromCalendar:departDate endDate:returnDate isReturn:isReturn];
}

-(NSDate*)dateFromString:(NSString*) dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate * date = [ dateFormatter dateFromString:dateString];
    if (date == nil) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        date = [dateFormatter dateFromString:dateString];
    }
    return date;
}

-(NSString*)stringFromDate:(NSDate*) date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

-(void)handleRecentSearchWSResponse:(NSDictionary*)recentSearchWSResponse
{
    
    NSArray * recentSearchArray = [recentSearchWSResponse valueForKey:@"search"];
    NSDictionary * extraData = [recentSearchWSResponse valueForKey:@"extra_data"];
    NSDictionary * airportsDictionary = [extraData valueForKey:@"airports"];
    [self.recentSearchArray removeAllObjects];
    [self.recentSearchArray addObjectsFromArray:recentSearchArray];
    ///Chnage for what next functionality by @Golu
    if([FlightWhatNextData.shared isSettingForWhatNext]){
        [FlightWhatNextData.shared clearData];
        [self.delegate setupFlightViews];
        [self.delegate updateRecentSearch];
        return;
    }
    ///end
    if ( self.recentSearchArray.count > 0 ) {

        //  Fetch origin and destination airport and update UI
        NSDictionary * firstAirport = self.recentSearchArray[0];
        NSDictionary * query = [firstAirport valueForKey:@"query"];
        NSString * origin = [query valueForKey:@"origin"];
        NSString * departDateString =[query valueForKey:@"depart"];
        NSString * returnDateString =[query valueForKey:@"return"];

        NSString * destination = [query valueForKey:@"destination"];
        NSString * tripType = [query valueForKey:@"trip_type"];
        
        
        // Setting up Traveller details
        self.travellerCount.flightAdultCount = [[query valueForKey:@"adult"] intValue];
        self.travellerCount.flightChildrenCount = [[query valueForKey:@"child"] intValue];
        self.travellerCount.flightInfantCount = [[query valueForKey:@"infant"] intValue];
        
        [self.delegate setupPassengerCountView];
        
        // Setting up travel class
        
        self.flightClass = [self flightClassForString:[query valueForKey:@"cabinclass"]];
        [self.delegate setupFlightClassType];
        
        if ( [tripType isEqualToString:@"single"] || [tripType isEqualToString:@"return"] ) {
        
        // Fetch origin airport
        [self setFlightFormUIFrom:airportsDictionary destination:destination origin:origin];
       
            // setting dates on Flight form UI
        [self setFlightFormUIForOnwardDate:departDateString returnDateString:returnDateString tripType:tripType];
        }
        else {
            //Change for flight form not fill for some case.
            self.isSettingForMulticity = true;
            [self.multiCityArray removeAllObjects];
            self.flightSearchType = MULTI_CITY;
            
            NSArray *originArray = [query mutableArrayValueForKey:@"origin"];
            NSArray * destinationArray = [query mutableArrayValueForKey:@"destination"];
            NSArray * datesArray = [query mutableArrayValueForKey:@"depart"];
            
            for (int i = 0;  i < originArray.count; i++) {
                                
                NSString * currentOrigin = [originArray objectAtIndex:i];
                NSString * currentDestination = [destinationArray objectAtIndex:i];
                NSString * date = [datesArray objectAtIndex:i];
                
                NSDictionary * sourceAirportDictionary = [airportsDictionary valueForKey:currentOrigin];
                AirportSearch *SourceAirport = [Parser parseAirportSearchDictionary:sourceAirportDictionary];

                NSDictionary * destinationAirportDictionary = [airportsDictionary valueForKey:currentDestination];
                AirportSearch *ToAirport = [Parser parseAirportSearchDictionary:destinationAirportDictionary];

                NSDate * travelDate = [self dateFromString:date];
                MulticityFlightLeg * newMultiLegJourney = [[MulticityFlightLeg alloc]init];
                newMultiLegJourney.origin = SourceAirport;
                newMultiLegJourney.destination = ToAirport;
                newMultiLegJourney.travelDate = travelDate;
                [self.multiCityArray addObject:newMultiLegJourney];
            }
            //[self.delegate setupFlightViews];
        }
        [self.delegate setupFlightViews];
        [self.delegate updateRecentSearch];
        //Change for flight form not fill for some case.
        self.isSettingForMulticity = false;
    }

}



- (void) performSearchOnServerWithText:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;

    [[Network sharedNetwork] callGETApi:AIRPORT_SEARCH_API parameters:[self buildSearchParametersWithText:searchText] loadFromCache:NO expires:YES success:^(NSDictionary *dataDictionary) {
        if (!weakSelf) { return; }
        [weakSelf handleSearchResultDictionary:dataDictionary];
    } failure:^(NSString *error, BOOL popup) {

    }];
}

- (void)handleSearchResultDictionary:(NSDictionary *)dataDictionary {

    
    if ([[Parser getValueForKey:@"type" inDictionary:dataDictionary] isEqualToString:@"airlines"]) {

        
        [self createAirlineArrayFromSearchResult:[dataDictionary objectForKey:@"results"]];

        return;
    }
    
}


-(void)createAirlineArrayFromSearchResult:(NSArray*)resultArray{
    
//    if (resultArray.count > 0){
//
//        for (NSDictionary * dictionary in resultArray) {
//
//            AirlineSearchModel * airlineSearch = [[AirlineSearchModel alloc] initWithDictionary:dictionary];
//
//
//        }
//        self.airportDisplayArray = [[NSMutableArray alloc] init];
//        [self.airportDisplayArray addObject:@"SELECT YOUR FLIGHT"];
//        self.airlinesArray  = array;
//    }
}

- (NSDictionary *)buildSearchParametersWithText:(NSString *) searchText {
    
    NSArray *keys = [NSArray arrayWithObjects:@"q", nil];
    NSArray *objects = [NSArray arrayWithObjects: searchText, nil];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjects:objects
                                                           forKeys:keys];
    return parameters;
}


//MARK:- Search Network Call
- (NSDictionary *)dictionaryForAirportSearch:(NSString *) searchText {
    
    NSArray *keys = [NSArray arrayWithObjects:@"q", nil];
    NSArray *objects = [NSArray arrayWithObjects: searchText, nil];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjects:objects
                                                           forKeys:keys];
    return parameters;
}


- (void) performAirportSearchFromIATACode:(NSString *)searchText forOrigin:(BOOL)forOrigin
{
    __weak typeof(self) weakSelf = self;

    [[Network sharedNetwork] callGETApi:AIRPORT_SEARCH_API parameters:[self dictionaryForAirportSearch:searchText] loadFromCache:NO expires:YES success:^(NSDictionary *dataDictionary) {
        if (!weakSelf) { return; }
        [weakSelf HandleAirportSearchResult:dataDictionary forOrigin:forOrigin];
    } failure:^(NSString *error, BOOL popup) {
    }];
}

- (void)HandleAirportSearchResult:(NSDictionary*)dictionary forOrigin:(BOOL)forOrigin
{
    NSArray * airports =  [Parser parseAirportSearchArray:[dictionary objectForKey:@"results"]];
    
    if (forOrigin) {
        self.fromFlightArray = [NSMutableArray arrayWithObject:airports[0]];
    }
    else {
        self.toFlightArray = [NSMutableArray arrayWithObject:airports[0]];
    }
}

//MARK:- Recent Searches CollectionView Methods
- (NSString *)formateDateForAPI:(NSDate *) date {
    if (date == nil) {
        return @"";
    }
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [inputDateFormatter stringFromDate:date];
    return dateString;
}

- (NSString *)formateDateForMultiCityAPIRequest:(NSDate *) date {
    if (date == nil) {
        return @"";
    }
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    [inputDateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString = [inputDateFormatter stringFromDate:date];
    return dateString;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0 ){
        if(self.recentSearchArray.count > 5){
            return 5;
        }else{
            return self.recentSearchArray.count;
        }
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecentSearchCellCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecentSearchCell" forIndexPath:indexPath];
    
    NSDictionary * dictionary = self.recentSearchArray[indexPath.row];
    RecentSearchDisplayModel * recentModel = [[RecentSearchDisplayModel alloc] initWithDictionary:dictionary];
    [cell setPropertiesWithRecentSearch:recentModel];
    
    return cell;
}


-(CGSize)collectionView:(UICollectionView* )collectionView layout:(UICollectionViewLayout* )collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dictionary = self.recentSearchArray[indexPath.row];

    RecentSearchDisplayModel * recentModel = [[RecentSearchDisplayModel alloc] initWithDictionary:dictionary];
    
    UIFont *font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:18];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    
    
    CGFloat width = [[[NSAttributedString alloc] initWithString:recentModel.TravelPlan.string attributes:attributes] size].width;
    
    CGFloat dateWidth = [self getStringSizeWithText:recentModel.travelDate font:[UIFont fontWithName:@"SourceSansPro-Regular" size:14]].width;

    NSDictionary *qr = recentModel.quary;
    if(qr != nil){
        if ( ![[qr objectForKey:@"trip_type"] isEqualToString:@"multi"])
        {
            width = width + 105;
        }else{
            if((recentModel.TravelPlan.string.length==28) || (recentModel.TravelPlan.string.length==29)){
                width = width + 42;
            }else if((recentModel.TravelPlan.string.length==33) || (recentModel.TravelPlan.string.length==34)){
                width = width + 45;
            }else if ((recentModel.TravelPlan.string.length==24) || (recentModel.TravelPlan.string.length==25)){
                width = width + 80;
            }else if (recentModel.TravelPlan.string.length==20){
                width = width + 107;
            }else if(recentModel.TravelPlan.string.length==15){
                width = width + 140;
            }else if(recentModel.TravelPlan.string.length==16){
                width = width + 118;
            }else if (recentModel.TravelPlan.string.length==11){
                width = width + 120;
            }
            
        }
    }
    
    CGFloat dateWidthExtraConstant = 87;
    if (dateWidth + dateWidthExtraConstant > width) {
        width = dateWidth + dateWidthExtraConstant;
    }
    
    if(width > 275){
        width = 275;
    }

    return CGSizeMake(width, 75.0);
}


//MARK: What Next data set functions @Golu.
-(void)handleWhatNext{
    
    NSDictionary * query = [FlightWhatNextData.shared getSeatchDictionary];
    NSString * origin = [query valueForKey:@"origin"];
    NSString * departDateString =[query valueForKey:@"depart"];
    NSString * returnDateString =[query valueForKey:@"return"];
    
    NSString * destination = [query valueForKey:@"destination"];
    NSString * tripType = [query valueForKey:@"trip_type"];
    
    
    // Setting up Traveller details
    self.travellerCount.flightAdultCount = [[query valueForKey:@"adult"] intValue];
    self.travellerCount.flightChildrenCount = [[query valueForKey:@"child"] intValue];
    self.travellerCount.flightInfantCount = [[query valueForKey:@"infant"] intValue];
    
    [self.delegate setupPassengerCountView];
    
    // Setting up travel class
    
    self.flightClass = [self flightClassForString:[query valueForKey:@"cabinclass"]];
    [self.delegate setupFlightClassType];
    
    
    
    if ( [tripType isEqualToString:@"single"] || [tripType isEqualToString:@"return"] ) {
           
             // Fetch origin airport
             [self setFlightFormUIFromWhatNext:destination origin:origin];
             
             // setting dates on Flight form UI
             [self setFlightFormUIForOnwardDate:departDateString returnDateString:returnDateString tripType:tripType];
             
           }
    else {
        
        [self.multiCityArray removeAllObjects];
        self.flightSearchType = MULTI_CITY;
        
        NSArray *originArray = [query mutableArrayValueForKey:@"originArr"];
        NSArray * destinationArray = [query mutableArrayValueForKey:@"destinationArr"];
        NSArray * datesArray = [query mutableArrayValueForKey:@"departArr"];
        NSArray * departCityArr = [query mutableArrayValueForKey:@"departCityArr"];
        NSArray * arrivalCityArr = [query mutableArrayValueForKey:@"arrivalCityArr"];
        
        NSArray * departCountrys = [query mutableArrayValueForKey:@"departCountryArr"];
        NSArray * departsAirporsts = [query mutableArrayValueForKey:@"departAirpotrsArr"];
        NSArray * arrivalCountrys = [query mutableArrayValueForKey:@"arrivalCountryArr"];
        NSArray * arrivalAirporsts = [query mutableArrayValueForKey:@"arrivalAirportsArr"];
        
        for (int i = 0;  i < originArray.count; i++) {
            
            NSString * currentOrigin = [originArray objectAtIndex:i];
            NSString * currentDestination = [destinationArray objectAtIndex:i];
            NSString * date = [datesArray objectAtIndex:i];
            NSString * departCity = [departCityArr objectAtIndex:i];
            NSString * arrivalCity = [arrivalCityArr objectAtIndex:i];
            
            NSString * arrivalCountry = [arrivalCountrys objectAtIndex:i];
            NSString * arrivalAirports = [arrivalAirporsts objectAtIndex:i];
            NSString * departCountry = [departCountrys objectAtIndex:i];
            NSString * departAirport = [arrivalAirporsts objectAtIndex:i];
            
            AirportSearch * SourceAirport = [AirportSearch new];
            SourceAirport.iata = currentOrigin;
            SourceAirport.city = departCity;
            SourceAirport.countryCode = departCountry;
            SourceAirport.airport = departAirport;
            
            AirportSearch * ToAirport = [AirportSearch new];
            ToAirport.iata = currentDestination;
            ToAirport.city = arrivalCity;
            ToAirport.countryCode = arrivalCountry;
            ToAirport.airport = arrivalAirports;
            
            NSDate * travelDate = [self dateFromString:date];
            MulticityFlightLeg * newMultiLegJourney = [[MulticityFlightLeg alloc]init];
            newMultiLegJourney.origin = SourceAirport;
            newMultiLegJourney.destination = ToAirport;
            newMultiLegJourney.travelDate = travelDate;
            [self.multiCityArray addObject:newMultiLegJourney];
        }
        //[self.delegate setupFlightViews];
    }
    
  
    [self.delegate setupFlightViews];
    [self.delegate updateRecentSearch];
    
}


- (void)setFlightFormUIFromWhatNext: (NSString *)destination origin:(NSString *)origin {
    NSMutableArray * airportsArray = [NSMutableArray array];
    NSDictionary * flightNextParam = [FlightWhatNextData.shared getSeatchDictionary];
    
    AirportSearch *airportSearch = [AirportSearch new];
    airportSearch.iata = [flightNextParam valueForKey:@"origin"];
    airportSearch.city = [flightNextParam valueForKey: @"departCity"];
    airportSearch.countryCode = [flightNextParam valueForKey: @"departCountryCode"];
    airportSearch.airport = [flightNextParam valueForKey: @"departAirport"];
    [airportsArray addObject: airportSearch];
    self.fromFlightArray = [NSMutableArray arrayWithArray:airportsArray];

    // Fetch destination airport
    airportsArray = [NSMutableArray array];
    AirportSearch *airportSearchReturn = [AirportSearch new];
    airportSearchReturn.iata = [flightNextParam valueForKey:@"destination"];
    airportSearchReturn.city = [flightNextParam valueForKey: @"arrivalCity"];
    airportSearchReturn.countryCode = [flightNextParam valueForKey: @"arrivalCountryCode"];
    airportSearchReturn.airport = [flightNextParam valueForKey: @"arrivalAirpots"];
    [airportsArray addObject: airportSearchReturn];
    self.toFlightArray = [NSMutableArray arrayWithArray:airportsArray];
    [self.delegate setupFromAndToView];
}

- (CGSize)getStringSizeWithText:(NSString *)string font:(UIFont *)font{

    UILabel *label = [[UILabel alloc] init];
    label.text = string;
    label.font = font;

    return label.attributedText.size;
}

@end
