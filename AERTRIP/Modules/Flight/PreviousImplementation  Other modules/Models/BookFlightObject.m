//
//  BookFlightObject.m
//  Aertrip
//
//  Created by Kakshil Shah on 8/11/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "BookFlightObject.h"
#import "AERTRIP-Swift.h"

@implementation BookFlightObject

- (NSAttributedString *)getTitleString{
    
    UIFont * sourceSansPRO18 = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18];
    NSDictionary * attributesForAirportCode =  @{NSFontAttributeName:sourceSansPRO18};
    
    NSAttributedString * title = [[NSAttributedString alloc] init];

    if ([self flightSearchType] == RETURN_JOURNEY) {
        
        NSMutableAttributedString * originAttributedString = [[NSMutableAttributedString alloc] initWithString:[self origin] attributes:attributesForAirportCode];
        
        NSMutableAttributedString * destinatinAttributedString = [[NSMutableAttributedString alloc] initWithString: [self destination] attributes:attributesForAirportCode];
        
        NSAttributedString * join ;
        
        
        NSTextAttachment * textAttachment = [[NSTextAttachment alloc]init];
        UIImage *iconImage = AppImages.returnIcon;
        
        [textAttachment setBounds:CGRectMake(0, roundf(sourceSansPRO18.capHeight - iconImage.size.height)/2.f, iconImage.size.width, iconImage.size.height)];
        [textAttachment setImage:iconImage];
        join = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
        
        
        NSMutableAttributedString * outputAttributedString = [[NSMutableAttributedString alloc]initWithAttributedString:originAttributedString];
        [outputAttributedString appendAttributedString:join];
        [outputAttributedString appendAttributedString:destinatinAttributedString];
        
        title =  outputAttributedString;
    }
    if ( self.flightSearchType == SINGLE_JOURNEY) {
        
        NSMutableAttributedString * originAttributedString = [[NSMutableAttributedString alloc] initWithString:[self origin] attributes:attributesForAirportCode];
        
        NSMutableAttributedString * destinatinAttributedString = [[NSMutableAttributedString alloc] initWithString:[self destination] attributes:attributesForAirportCode];
        
        NSAttributedString * join ;
        
        
        NSTextAttachment * textAttachment = [[NSTextAttachment alloc]init];
        UIImage *iconImage = AppImages.onewayIcon;
        
        [textAttachment setBounds:CGRectMake(0, roundf(sourceSansPRO18.capHeight - iconImage.size.height)/2.f, iconImage.size.width, iconImage.size.height)];
        [textAttachment setImage:iconImage];
        join = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
        
        NSMutableAttributedString * outputAttributedString = [[NSMutableAttributedString alloc]initWithAttributedString:originAttributedString];
        [outputAttributedString appendAttributedString:join];
        [outputAttributedString appendAttributedString:destinatinAttributedString];
        
        
        title =  outputAttributedString;
        
    }
    
    if  ( self.flightSearchType == MULTI_CITY) {
    
        
        NSString * previousIndexOrigin = @"";
        NSString * previousIndexDestination = @"";
        
        NSMutableAttributedString * outputAttributedString  = [[NSMutableAttributedString alloc] init];
        UIFont * sourceSansPRO18 = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18];
        
        
        NSTextAttachment * textAttachment = [[NSTextAttachment alloc]init];
        UIImage *iconImage = AppImages.onewayIcon;
        
        [textAttachment setBounds:CGRectMake(0, roundf(sourceSansPRO18.capHeight - iconImage.size.height)/2.f, iconImage.size.width, iconImage.size.height)];
        [textAttachment setImage:iconImage];
        
        NSAttributedString* join = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
        
        for (int i = 0;  i < [self.originArray count]; i++) {
            
            NSString * currentOrigin = [self.originArray objectAtIndex: i];
            if ([self.destinationArray count] < i){
                return title;
            }
            NSString * currentDestination = [self.destinationArray objectAtIndex: i];

            NSDictionary * attributesForAirportCode =  @{NSFontAttributeName:sourceSansPRO18};
            
            NSAttributedString * originAttributedString = [[NSAttributedString alloc] initWithString:currentOrigin attributes:attributesForAirportCode];
            NSAttributedString * destinatinAttributedString = [[NSAttributedString alloc] initWithString:currentDestination attributes:attributesForAirportCode];
            
            if ( [previousIndexDestination caseInsensitiveCompare:currentOrigin] == NSOrderedSame ){//( [previousIndexDestination isEqualToString:currentOrigin] )
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

        title =  outputAttributedString;
    }
    
    return title;
}

@end
