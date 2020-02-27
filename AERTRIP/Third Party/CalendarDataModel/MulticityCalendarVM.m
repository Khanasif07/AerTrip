//
//  CustomCalerdarVMForMulticity.m
//  Aertrip
//
//  Created by Hrishikesh Devhare on 19/01/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

#import "MulticityCalendarVM.h"

@implementation MulticityCalendarVM
-(void)onDoneButtonTapped {
    
    [self.delegate MulticityDateSelectionWithDictionary:self.travelDatesDictionary reloadUI:YES];
}

-(NSInteger)cityCount{
    
    return [[self.travelDatesDictionary allKeys] count];
}
@end
