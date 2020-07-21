//
//  RecentModel.m
//  Aertrip
//
//  Created by Hrishikesh Devhare on 14/01/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

#import "RecentSearchDisplayModel.h"
#import <UIKit/UIKit.h>

@interface RecentSearchDisplayModel ()
@end



@implementation RecentSearchDisplayModel


- (void)setupPaxCount {
    NSUInteger adult = [[self.quary objectForKey:@"adult"] integerValue];
    NSUInteger children = [[self.quary objectForKey:@"child"] integerValue];
    NSUInteger infants = [[self.quary objectForKey:@"infant"] integerValue];
    
    NSMutableString * paxCount = [NSMutableString string];
    
    if ( adult == 1) {
        [paxCount appendString:@"1 Adult"];
    }
    else {
        [paxCount appendFormat:@"%lu Adults",(unsigned long)adult];
    }
    
    if ( children == 1) {
        [paxCount appendString:@", 1 Child"];
    }
    if ( children > 1 ) {
        [paxCount appendFormat:@", %lu Children",(unsigned long)children];
    }
    
    if ( infants == 1) {
        [paxCount appendString:@", 1 Infant"];
    }
    if ( infants > 1 ) {
        [paxCount appendFormat:@", %lu Infants",(unsigned long)infants];
    }
    
    self.paxCount = paxCount;
}


-(void)setupTravelType{
    
    NSString * travelType = [self.quary objectForKey:@"trip_type"];

    if ( [travelType isEqualToString:@"return"] ) {
        self.travelType = @"Return";
        return;
    }
    if ([travelType isEqualToString:@"single"] ) {
        self.travelType = @"Oneway";
        return;
    }
    
    if ([travelType isEqualToString:@"multi"] ){
        self.travelType = @"Multicity";
        return;
    }
}


-(NSString*)formatDateString:(NSString*)inputDate{
    
    NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate * departDate = [DateFormatter dateFromString:inputDate];
    [DateFormatter setDateFormat:@"d MMM"];
    NSString * outputDateString = [DateFormatter stringFromDate:departDate];
    return outputDateString;
}

-(void)setDateForMulticityJourney{
    
    NSArray * datesArray = [self.quary mutableArrayValueForKey:@"depart"];
    NSString * dateInStringFormat = [self formatDateString:[datesArray objectAtIndex:0]];
    NSMutableString * outputString = [NSMutableString stringWithString:dateInStringFormat];

    for ( int i = 1 ; i < datesArray.count ; i++) {
        NSString * dateInStringFormat = [datesArray objectAtIndex:i];
        [outputString appendString:@" - "];
        [outputString appendString:[self formatDateString:dateInStringFormat]];
    }
    
    self.travelDate = outputString;
}

-(void)setupDateForSingleLegJourney{
    
    NSString *departDateString = [self.quary objectForKey:@"depart"];
    NSMutableString * outputString = [NSMutableString stringWithString:[self formatDateString:departDateString]];
    
    NSString * returnDateString = [self.quary objectForKey:@"return"];
    
    if ( returnDateString != nil) {
        NSString * returnOutputString = [self formatDateString:returnDateString];
        [outputString appendFormat:@" - %@",returnOutputString];
    }
    
    self.travelDate = outputString;
}

-(void)setupDate{
    
    NSString * travelType = [self.quary objectForKey:@"trip_type"];
    
    if([travelType isEqualToString:@"multi"]) {
        [self setDateForMulticityJourney];
    }
    else {
        [self setupDateForSingleLegJourney] ;
    }
    
}
-(void)setupTravelClass{
           self.flightClass = [self.quary objectForKey:@"cabinclass"];
}


-(void) setTravelPlanForMulticityJourney{
    
    NSString * previousIndexOrigin = @"";
    NSString * previousIndexDestination = @"";
    
    NSMutableAttributedString * outputAttributedString  = [[NSMutableAttributedString alloc] init];
    UIFont * sourceSansPRO18 = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18];

    
    NSTextAttachment * textAttachment = [[NSTextAttachment alloc]init];
    UIImage *iconImage = [UIImage imageNamed:@"oneway"];
    
    [textAttachment setBounds:CGRectMake(0, roundf(sourceSansPRO18.capHeight - iconImage.size.height)/2.f, iconImage.size.width, iconImage.size.height)];
    [textAttachment setImage:iconImage];
    
    NSAttributedString* join = [NSAttributedString attributedStringWithAttachment:textAttachment];

    NSArray *originArray = [self.quary mutableArrayValueForKey:@"origin"];
    NSArray * destinationArray = [self.quary mutableArrayValueForKey:@"destination"];

    
    for (int i = 0;  i < originArray.count; i++) {
        
        NSString * currentOrigin = [originArray objectAtIndex:i];
        NSString * currentDestination = [destinationArray objectAtIndex:i];
        
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
    
    self.TravelPlan = outputAttributedString;
}

- (void)setupTravelPlanForSingleLegJourney {
    NSString * origin = [self.quary objectForKey:@"origin"];
    NSString * destination  = [self.quary objectForKey:@"destination"];
    
    
    UIFont * sourceSansPRO18 = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18];
    NSDictionary * attributesForAirportCode =  @{NSFontAttributeName:sourceSansPRO18};
    
    
    NSMutableAttributedString * originAttributedString = [[NSMutableAttributedString alloc] initWithString:origin attributes:attributesForAirportCode];
    
    NSMutableAttributedString * destinatinAttributedString = [[NSMutableAttributedString alloc] initWithString:destination attributes:attributesForAirportCode];
    
    NSAttributedString * join ;
    if ( [self.travelType isEqualToString:@"Return"]) {
        
        NSTextAttachment * textAttachment = [[NSTextAttachment alloc]init];
        UIImage *iconImage = [UIImage imageNamed:@"return"];
        
        [textAttachment setBounds:CGRectMake(0, roundf(sourceSansPRO18.capHeight - iconImage.size.height)/2.f, iconImage.size.width, iconImage.size.height)];
        [textAttachment setImage:iconImage];
        join = [NSAttributedString attributedStringWithAttachment:textAttachment];
    }
    else {

        NSTextAttachment * textAttachment = [[NSTextAttachment alloc]init];
        UIImage *iconImage = [UIImage imageNamed:@"oneway"];

        [textAttachment setBounds:CGRectMake(0, roundf(sourceSansPRO18.capHeight - iconImage.size.height)/2.f, iconImage.size.width, iconImage.size.height)];
        [textAttachment setImage:iconImage];
        join = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
    }
    
    NSMutableAttributedString * outputAttributedString = [[NSMutableAttributedString alloc]initWithAttributedString:originAttributedString];
    [outputAttributedString appendAttributedString:join];
    [outputAttributedString appendAttributedString:destinatinAttributedString];
    
    self.TravelPlan = outputAttributedString;
}

-(void)setupTravelPlan {
    
    NSString * travelType = [self.quary objectForKey:@"trip_type"];
    
    if([travelType isEqualToString:@"multi"]) {
        [self setTravelPlanForMulticityJourney];
    }
    else {
        [self setupTravelPlanForSingleLegJourney] ;
    }
}
- (void)setupSearchTime:(NSDictionary*)dictionary {
    
     self.searchTime = [dictionary objectForKey:@"time_ago"];
}

-(instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    if (self = [self init]) {
        
        self.quary = [dictionary objectForKey:@"query"];

        [self setupSearchTime:dictionary];
        [self setupTravelType];
        [self setupTravelPlan];
        [self setupTravelClass];
        [self setupDate];
        [self setupPaxCount];
    }
    return  self;
}


@end
