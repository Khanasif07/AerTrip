//
//  FrequentFlyerViewController.h
//  Aertrip
//
//  Created by Kakshil Shah on 5/17/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol FrequentFlyerSearchHandler
@optional
- (void)frequentFlyerSelected:(NSIndexPath *)indexPath value:(FrequentFlier *)frequentFlier;

@end



@interface FrequentFlyerViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *frequentFlyerTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *frequentFlyerSearchBar;
@property (weak, nonatomic) IBOutlet UIView *topView;



@property (nonatomic,strong) NSIndexPath *indexPath;
@property (strong, nonatomic) FrequentFlier *frequentFlier;



@end
