//
//  HomeFlightViewModel.h
//  Aertrip
//
//  Created by Hrishikesh Devhare on 14/12/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Aertrip-Swift.h"
#import "MultiCityFlightTableViewCell.h"
#import "flightSearchType.h"
#import "CalendarVM.h"
#import "MulticityCalendarVM.h"

NS_ASSUME_NONNULL_BEGIN

@class FlightClass; 
@class BookFlightObject;
@class FlightWhatNextData;

@protocol FlightViewModelDelegate
-(void)showErrorMessage:(NSString*)errorMessage;
-(void)showLoaderIndicatorForFilghtSearch;
-(void)hideLoaderIndicatorForFilghtSearch;
-(void)showFlightSearchResult:(BookFlightObject*)bookflightObject flightSearchParameters:(NSDictionary*)flightSearchParameters;
-(void)setupFromAndToView;
-(void)datesSelectedIsReturn:(BOOL)isReturn;
-(void)setupDatesInOnwardsReturnView;
-(void)updateRecentSearch;
-(void)reloadMultiCityTableView;
-(void)reloadMultiCityTableViewAtIndex:(NSIndexPath*)indexPath;
-(void)shakeAnimation:(PlaceholderLabels)label atIndex:(NSIndexPath*)indexPath;
-(void)shakeAnimation:(PlaceholderLabels)label;
-(void)disableRemoveMulticityButton:(BOOL)disable;
-(void)disableAddMulticityButton:(BOOL)disable;
-(void)setupPassengerCountView;
-(void)setupFlightClassType;
-(void)setupFlightViews;
-(void)didFetchCountryCodes:(NSMutableArray*)countryCodes;
@end



@interface FlightFormDataModel : NSObject < UICollectionViewDataSource , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSMutableArray *fromFlightArray;
@property (strong, nonatomic) NSMutableArray *toFlightArray;
@property (strong, nonatomic) NSMutableArray *recentSearchArray;
@property (strong, nonatomic, nullable) NSDate *onwardsDate;
@property (strong, nonatomic, nullable) NSDate *returnDate;
@property (assign) FlightSearchType flightSearchType;
@property (strong, nonatomic) TravellerCount *travellerCount;
@property (strong, nonatomic) FlightClass *flightClass;
@property (strong, nonatomic) NSMutableArray *segmentTitleSectionArray;
@property (strong, nonatomic) NSMutableArray *flightSearchArray;
@property (strong, nonatomic) NSMutableArray *multiCityArray;
@property (strong, nonatomic) NSIndexPath *selectedMultiCityArrayIndex;
@property (weak, nonatomic) id <FlightViewModelDelegate > delegate ;
//Change for flight form not fill for some case.
@property(nonatomic) BOOL isSettingForMulticity;

-(void)setInitialValues;
-(void)selectedDatesFromCalendar:(NSDate *)startDate endDate:(NSDate *)endDate isReturn:(BOOL)isReturn;
-(NSMutableDictionary *)buildDictionaryForFlightSearch;
-(NSString*)flightFromText;
-(NSString*)flightToText;
-(NSString *)dateFormatedFromDate:(NSDate *)date;
-(NSString *)dayOfDate:(NSDate *)date;
-(long)adultCount;
-(long)childrenCount;
-(long)infantCount;
-(UIImage*)flightClassImage;
-(NSString*)flightClassName;
-(BOOL)isValidFlightSearch;
-(void)performFlightSearch;
-(void)performFlightSearchWith:(NSMutableDictionary*)dict;
-(AirportSelectionVM*)prepareForAirportSelection:(BOOL)isFrom  airportSelectionMode:(AirportSelectionMode)airportSelectionVM;
-(AirportSelectionVM*)prepareForMultiCityAirportSelection:(BOOL)isFrom indexPath:(NSIndexPath*)indexPath;
-(CalendarVM*)VMForDateSelectionIsOnwardsSelection:(BOOL)isOnwards forReturnMode:(BOOL)forReturn;
-(void)setMulticityAirports:(NSMutableArray * _Nullable)fromArray toArray:(NSMutableArray * _Nullable)toArray atIndexPath:(NSIndexPath*)indexPath;
-(void)setupMultiCityView;
-(void)removeLastLegFromJourney;
-(void)addFlightLegForMulticityJourney;
-(MulticityCalendarVM*)prepareVMForMulticityCalendar:(NSUInteger)currentIndex;


@property (strong , nonatomic) NSString * airlineCode;

@end

NS_ASSUME_NONNULL_END
