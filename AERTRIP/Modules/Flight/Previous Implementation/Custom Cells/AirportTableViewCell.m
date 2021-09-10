//
//  AirportTableViewCell.m
//  Aertrip
//
//  Created by Kakshil Shah on 7/14/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import "AirportTableViewCell.h"

@implementation AirportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)addButtonAction:(id)sender {
  
    
    [self.delegate addAction:self.indexPath];
}

- (IBAction)removeButtonAction:(id)sender {
    [self.delegate removeAction:self.indexPath];
    
}



@end
