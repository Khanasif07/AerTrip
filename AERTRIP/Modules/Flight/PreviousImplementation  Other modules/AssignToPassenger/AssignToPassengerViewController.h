//
//  AssignToPassengerViewController.h
//  Aertrip
//
//  Created by Kakshil Shah on 9/10/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol AssignPassengerHandler
@optional
- (void)assignAction;


@end
@interface AssignToPassengerViewController : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *passengerCollectionView;
@property (weak, nonatomic) IBOutlet UIView *assignView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *dimmerLayer;
@property (weak, nonatomic) IBOutlet UIImageView *backingImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;


@property (strong, nonatomic) UIImage *backingImage;
@property (nonatomic,strong) NSMutableArray *passengerArray;

@end
