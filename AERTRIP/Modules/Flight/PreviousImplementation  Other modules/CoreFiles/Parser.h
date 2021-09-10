//
//  Parser.h
//  Mazkara
//
//  Created by Kakshil Shah on 20/04/16.
//  Copyright © 2016 BazingaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface Parser : NSObject
+(BOOL) checkForSuccess:(NSDictionary *) responseDictionary;


//Individual
+(User *) parseUser:(NSDictionary *) userDictionary;
+(Address *) parseAddress:(NSDictionary *) addressDictionary;
+(GeneralUserPreferences *) parseUserPreferences:(NSDictionary *) preferencesDictionary;
+(UserDetails *) parseUserDetails:(NSDictionary *) userDetailsDictionary;
+(ContactMethod *) parseContactMethod:(NSDictionary *) contactMethodDictionary;
+(Traveller *) parseTraveller:(NSDictionary *) travellerDictionary withAddressArray:(NSArray *)addressArray;
+ (DropDownData *)parseDropDownDataDictionary:(NSDictionary *)dictionary;
+ (FlightPreferencesDropDown *)parseFlightPreferencesDropDownDataDictionary:(NSDictionary *)dictionary;
+ (NSArray *)parseFrequentFlyerArray:(NSArray *)array;
+ (NSArray *)parseAirportSearchArray:(NSArray *)array;
+ (AirportSearch *)parseAirportSearchDictionary:(NSDictionary *)dictionary;
+ (NSArray *)parseFlightSearchResultDictionary:(NSDictionary *)dictionary;
+ (FlightResultsDict *)parseFlightResultsDictDictionary:(NSDictionary *)dictionary;
+ (BookFlightObject *)parseBookFlightObjectForSIDDictionary:(NSDictionary *)dictionary;
//Utility
+(NSString *) generateCSVFromArray:(NSArray *)array;
+(NSString *) convertToFrontEnd:(NSString *) inputString;
+(NSString *) convertToBackend:(NSString *) inputString;
+(NSString *) getValueForKey:(NSString *)key inDictionary:(NSDictionary *)dictionary;
+(NSString *) getValueForKey:(NSString *)key inDictionary:(NSDictionary *)dictionary withDefault:(NSString *)defaultValue;
+(NSDictionary *)getData:(NSDictionary *)dictionary;
+(NSString *)getErrorFromDictionary:(NSDictionary *)dictionary;
+(NSString *) handleAmount:(NSString *)amount;

@end
