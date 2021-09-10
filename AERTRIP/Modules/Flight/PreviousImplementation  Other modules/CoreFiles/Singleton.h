//
//  Singleton.h
//  Mazkara
//
//  Created by Kakshil Shah on 09/06/16.
//  Copyright © 2016 BazingaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parser.h"
@interface Singleton : NSObject
@property (nonatomic,strong) NSMutableArray  *zoneArray;
+ (id)singleton;
@end
