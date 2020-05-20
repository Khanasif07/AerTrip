//
//  TravellerListImportViewController.h
//  Aertrip
//
//  Created by Kakshil Shah on 5/31/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "HMSegmentedControl.h"
#import "ShadowButton.h"
@protocol TravellerListImportHandler

@optional
- (void)addGuests:(NSArray *)array;

@end

@interface TravellerListImportViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UIImageView *emptyImageView;
@property (weak, nonatomic) IBOutlet UILabel *emptyTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *emptyButtonIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *emptyButtonLabel;
//@property (weak, nonatomic) IBOutlet ShadowButton *emptyViewButton;
// Rishabh - class not found
@property (weak, nonatomic) IBOutlet UIButton *emptyViewButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emptyButtonImageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emptyButtonImageViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emptyButtonImageViewWidth;




@property (weak, nonatomic) IBOutlet UITableView *importTableView;
@property (weak, nonatomic) IBOutlet UIButton *importButton;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *topSegmentControl;
@property (weak, nonatomic) IBOutlet UISearchBar *travellerSearchBar;

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;



@property (assign, nonatomic) BOOL isImport;
@property (weak, nonatomic) id<TravellerListImportHandler> delegate;





@end
