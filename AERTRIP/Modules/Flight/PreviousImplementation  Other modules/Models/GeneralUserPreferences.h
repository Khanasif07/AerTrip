//
//  GeneralUserPreferences.h
//  Aertrip
//
//  Created by Kakshil Shah on 04/05/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralUserPreferences : NSObject
@property (nonatomic,strong) NSString *displayOrder;
@property (nonatomic,strong) NSString *sortOrder;
@property (nonatomic,strong) NSMutableArray *labelsArray;
@end
