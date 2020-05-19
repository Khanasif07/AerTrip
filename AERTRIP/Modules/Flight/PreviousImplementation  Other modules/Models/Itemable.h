//
//  Itemable.h
//  Aertrip
//
//  Created by Kakshil Shah on 6/1/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Itemable : NSObject
@property (nonatomic,strong) NSString *itemHeader;
@property (nonatomic,strong) NSMutableArray *itemSectionArray;
@property (nonatomic,strong) NSMutableDictionary *itemSectionDictionary;

@end
