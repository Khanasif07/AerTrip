//
//  AertripCalendarViewController.h
//  Aertrip
//
//  Created by Kakshil Shah on 6/29/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarVM.h"
#import "MulticityCalendarVM.h"



@interface AertripCalendarViewController : UIViewController

@property (weak, nonatomic , nullable) IBOutlet UIView *startDateView;
@property (weak, nonatomic , nullable) IBOutlet UIView *endDateView;

@property (weak, nonatomic , nullable) IBOutlet UILabel *startDateValueLabel;
@property (weak, nonatomic , nullable) IBOutlet UILabel *startDateSubLabel;
@property (weak, nonatomic , nullable) IBOutlet UILabel *startDateLabel;

@property (weak, nonatomic , nullable) IBOutlet UILabel *endDateValueLabel;
@property (weak, nonatomic , nullable) IBOutlet UILabel *endDateSubLabel;
@property (weak, nonatomic , nullable) IBOutlet UILabel *endDateLabel;

@property (weak, nonatomic , nullable) IBOutlet UILabel *nightCountLabel;
@property (weak, nonatomic , nullable) IBOutlet UIView *nightView;

@property (weak, nonatomic , nullable) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic , nullable) IBOutlet UIView *doneOutterView;
@property (weak, nonatomic , nullable) IBOutlet UIView *dimmerLayer;

@property (weak, nonatomic , nullable) IBOutlet UIImageView *backingImageView;

@property (weak, nonatomic , nullable) IBOutlet NSLayoutConstraint *topConstraintMainView;
@property (weak, nonatomic , nullable) IBOutlet UIView *bottomView;
@property (weak, nonatomic , nullable) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (weak, nonatomic , nullable) IBOutlet NSLayoutConstraint *TopSpaceConstraint;
@property (weak, nonatomic , nullable) IBOutlet UIView *TopView;

@property (weak, nonatomic , nullable) IBOutlet NSLayoutConstraint *backgroudViewLeadingConstraint;

@property (weak, nonatomic , nullable) IBOutlet UIStackView *TapStackView;

@property (strong, nonatomic,nullable) CalendarVM * viewModel;
@property (strong ,nullable)  MulticityCalendarVM * multicityViewModel;
@property (weak, nonatomic,nullable) IBOutlet UIStackView *weekdaysStackView;

@property (weak, nonatomic) IBOutlet UIView * _Nullable multiCitySelectionTap;

@property (weak, nonatomic, nullable) IBOutlet NSLayoutConstraint *multicitySelectionTabWidth;
@property (weak, nonatomic, nullable) IBOutlet NSLayoutConstraint *multicitySelectionLeading;

@end
