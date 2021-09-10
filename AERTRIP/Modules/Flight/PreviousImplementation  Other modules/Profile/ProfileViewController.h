//
//  ProfileViewController.h
//  Aertrip
//
//  Created by Kakshil Shah on 24/04/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "BaseViewController.h"

@interface ProfileViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phonenumberHeight;
@property (weak, nonatomic) IBOutlet UILabel *shortNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (weak, nonatomic) IBOutlet UILabel *largeShortNameLabel;

@end
