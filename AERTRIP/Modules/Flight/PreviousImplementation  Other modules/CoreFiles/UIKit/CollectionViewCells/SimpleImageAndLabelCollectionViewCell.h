//
//  SimpleImageAndLabelCollectionViewCell.h
//  Mazkara
//
//  Created by Kakshil Shah on 16/05/16.
//  Copyright © 2016 BazingaLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleImageAndLabelCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coreImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *overlayView;

@end
