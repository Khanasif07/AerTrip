//
//  MultiCityFlightTableViewCell.h
//  Aertrip
//
//  Created by Kakshil Shah on 8/24/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MulticityFlightLeg.h"


typedef enum : NSUInteger {
    MulticityFromLabel,
    MulticityToLabel,
    MulticityDateLabel,
    FromLabel,
    ToLabel,
    DepartureDateLabel,
    ArrivalDateLabel,
    CabinClass
} PlaceholderLabels;

@protocol MultiCityFlightCellHandler
- (void)openAirportSelectionControllerFor:(BOOL)isFrom indexPath:(NSIndexPath *)indexPath;
- (void)openCalenderDateForMulticity:(NSIndexPath *)indexPath;
- (void)swapMultiCityAirportsFor:(NSIndexPath *)indexPath;

@optional




@end
@interface MultiCityFlightTableViewCell : UITableViewCell

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (strong, nonatomic) MulticityFlightLeg * flightLegRow;
@property (weak, nonatomic) id<MultiCityFlightCellHandler> delegate;


- (void)setupFromAndToView;
- (void)setupDateView;
- (void)shakeAnimation:(PlaceholderLabels)label;
- (void)setColorForFromView;

@end
