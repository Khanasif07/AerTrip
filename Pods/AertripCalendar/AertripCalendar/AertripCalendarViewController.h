//
//  AertripCalendarViewController.h
//  Aertrip
//
//  Created by Kakshil Shah on 6/29/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AertripCalendarDataModel/CalendarDataModel.h>



@interface AertripCalendarViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *startDateView;
@property (weak, nonatomic) IBOutlet UIView *endDateView;

@property (weak, nonatomic) IBOutlet UILabel *startDateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateSubLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *endDateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateSubLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *nightCountLabel;
@property (weak, nonatomic) IBOutlet UIView *nightView;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIView *doneOutterView;
@property (weak, nonatomic) IBOutlet UIView *dimmerLayer;

@property (weak, nonatomic) IBOutlet UIImageView *backingImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintMainView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIView *TopView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroudViewLeadingConstraint;

@property (weak, nonatomic) IBOutlet UIStackView *TapStackView;

@property (strong, nonatomic,nullable) CalendarVM * viewModel;
@property (strong ,nullable)  MulticityCalendarVM * multicityViewModel;

@property (weak, nonatomic) IBOutlet UIView * _Nullable multiCitySelectionTap;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *multicitySelectionTabWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *multicitySelectionLeading;

@end
