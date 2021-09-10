//
//  Singleton.m
//  Mazkara
//
//  Created by Kakshil Shah on 09/06/16.
//  Copyright © 2016 BazingaLabs. All rights reserved.
//

#import "Singleton.h"
@implementation Singleton

+ (id)singleton {
    static Singleton *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

@end
