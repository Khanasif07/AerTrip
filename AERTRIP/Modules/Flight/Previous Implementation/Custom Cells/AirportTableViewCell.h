//
//  AirportTableViewCell.h
//  Aertrip
//
//  Created by Kakshil Shah on 7/14/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AirportCellHandler
@optional
- (void)addAction:(NSIndexPath *)indexPath;
- (void)removeAction:(NSIndexPath *)indexPath;

@end

@interface AirportTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *flightShortNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIView *vierticalLineView;
@property (weak, nonatomic) IBOutlet UIView *horizontalLineView;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

//
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (weak, nonatomic) id<AirportCellHandler> delegate;

@end
