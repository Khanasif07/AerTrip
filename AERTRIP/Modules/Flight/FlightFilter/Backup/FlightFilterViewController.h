//
//  FlightFilterViewController.h
//  Aertrip
//
//  Created by Kakshil Shah on 8/27/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MARKRangeSlider.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
@protocol FlightFilterHandler
- (void)applyFilter:(BOOL)isClearAll;

@end

@interface FlightFilterViewController : BaseViewController<handleActions,UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleStringLabel;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *topSegmentControl;
@property (weak, nonatomic) IBOutlet UITableView *filterTableView;
@property (weak, nonatomic) IBOutlet UIView *smartSortView;
@property (weak, nonatomic) IBOutlet UILabel *smartSortDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIView *timesView;
@property (weak, nonatomic) IBOutlet UILabel *departureTimeValueLabel;
@property (weak, nonatomic) IBOutlet UIView *departureImagesView;
@property (weak, nonatomic) IBOutlet MARKRangeSlider *departureRangeSlider;
@property (weak, nonatomic) IBOutlet UILabel *arrivalFromTimeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalToTimeValueLabel;
@property (weak, nonatomic) IBOutlet MARKRangeSlider *arrivalRangeSlider;


@property (weak, nonatomic) IBOutlet UIView *durationView;
@property (weak, nonatomic) IBOutlet UILabel *tripDurationFromValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripDurationToValueLabel;
@property (weak, nonatomic) IBOutlet MARKRangeSlider *tripDurationRangeSlider;
@property (weak, nonatomic) IBOutlet UILabel *layoverDurationFromValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *layoverDurationToValueLabel;
@property (weak, nonatomic) IBOutlet MARKRangeSlider *layoverDurationRangeSlider;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *departureBlurViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *departureBlurViewTralingConstraint;


@property (weak, nonatomic) IBOutlet UIView *airportView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *departureViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *departureTableHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *departureTableView;
@property (weak, nonatomic) IBOutlet UIButton *airportDepartureButton;
@property (weak, nonatomic) IBOutlet UIImageView *airportDepartureSelectionOptionImageView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrivalViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrivalTableHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *arrivalTableView;
@property (weak, nonatomic) IBOutlet UIButton *airportArrivalButton;
@property (weak, nonatomic) IBOutlet UIImageView *airportArrivalSelectionOptionImageView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoverViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoverTableHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *layoverTableView;
@property (weak, nonatomic) IBOutlet UIButton *airportLayoverButton;
@property (weak, nonatomic) IBOutlet UIImageView *airportLayoverSelectionOptionImageView;



@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UILabel *priceFromValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceToValueLabel;
@property (weak, nonatomic) IBOutlet MARKRangeSlider *priceRangeSlider;
@property (weak, nonatomic) IBOutlet UIButton *refundableSelectedButton;

@property (weak, nonatomic) IBOutlet UIView *multiCitySegmentWrapper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *multiCitySegmentWrapperHeightConstraint;
@property (weak, nonatomic) IBOutlet UISegmentedControl *multiCitySegmentControl;


@property (assign, nonatomic) BOOL isMultiCity;
@property (strong, nonatomic) FlightFilter *flightFilter;
@property (nonatomic,weak) id<FlightFilterHandler> delegateFlight;

@end
