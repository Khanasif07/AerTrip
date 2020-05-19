//
//  Fare.h
//  Aertrip
//
//  Created by Kakshil Shah on 08/08/18.
//  Copyright © 2018 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fare : NSObject
@property (nonatomic,strong) NSString *baseFare; //BF -> value
@property (nonatomic,strong) NSString *grandTotal; //grand_total -> value
@property (nonatomic,strong) NSString *taxes; //taxes -> value
@property (nonatomic,strong) NSString *totalPayable; //total_payable_now -> value
@end
