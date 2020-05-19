//
//  PassengerCollectionViewCell.h
//  Aertrip
//
//  Created by Kakshil Shah on 9/10/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassengerCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coreImageView;
@property (weak, nonatomic) IBOutlet UILabel *shortNameLabel;
@property (weak, nonatomic) IBOutlet UIView *selectionView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
