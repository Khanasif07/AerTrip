//
//  CCache.h
//  Mazkara
//
//  Created by Kakshil Shah on 16/02/17.
//  Copyright © 2017 BazingaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "Parser.h"
@interface CCache : NSObject

+(BOOL) activelyExistsInCacheKey:(NSString *) cacheKey;
+(NSString *) getKeyForParameters:(NSDictionary *) parameters andAPI:(NSString *)apiName;
+(NSDictionary *) dictionaryForKey:(NSString *) cacheKey;
+(void) saveDictionary:(NSDictionary *) dictionary forKey:(NSString *) cacheKey expires:(BOOL) expires;
+(void) collectGarbage;
@end
