//
//  CCache.m
//  Mazkara
//
//  Created by Kakshil Shah on 16/02/17.
//  Copyright © 2017 BazingaLabs. All rights reserved.
//

#import "CCache.h"

@implementation CCache
+(BOOL) activelyExistsInCacheKey:(NSString *) cacheKey{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *cacheList = [defaults objectForKey:CACHE_LIST_KEY];
    
    for (NSDictionary *cacheObjectInList in cacheList) {
        if ([cacheObjectInList[@"cacheKey"] isEqualToString:cacheKey]) {
            return true;
        }
    }
    
    return false;
}
+(NSString *) getKeyForParameters:(NSDictionary *) parameters andAPI:(NSString *)apiName{
    NSString *parametersString = [parameters description];
    return [NSString stringWithFormat:@"%@%@%@",CACHE_KEY,parametersString,apiName];
}

+(NSDictionary *) dictionaryForKey:(NSString *) cacheKey{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:cacheKey]) {
        return (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:cacheKey]];
    }
    return nil;
}

+(void) saveDictionary:(NSDictionary *) dictionary forKey:(NSString *) cacheKey{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *dataDictionary = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    [defaults setObject:dataDictionary forKey:cacheKey];
    [defaults synchronize];
}

+(void) saveDictionary:(NSDictionary *) dictionary forKey:(NSString *) cacheKey expires:(BOOL) expires{
    NSDate *expiryDate = [NSDate distantFuture];
    if (expires) {
        expiryDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 30];
    }
    [CCache saveExpiryInDefaults:expiryDate withKey:cacheKey];
    [CCache saveDictionary:dictionary forKey:cacheKey];
}


+(void) saveExpiryInDefaults:(NSDate *)expiryDate withKey:(NSString *) cacheKey{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:CACHE_LIST_KEY]){
        [CCache updateOrCreateExpiry:expiryDate forKey:cacheKey];
    }
    else{
        NSMutableArray *cacheList = [[NSMutableArray alloc] init];
        [cacheList addObject:[CCache cacheKeyDictionaryFromKey:cacheKey andExpiry:expiryDate]];
        [defaults setObject:cacheList forKey:CACHE_LIST_KEY];
        [defaults synchronize];
    }
}


+(void) updateOrCreateExpiry:(NSDate *) expiryDate forKey:(NSString *)cacheKey{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *cacheList = [[defaults objectForKey:CACHE_LIST_KEY] mutableCopy];
    NSDictionary *cacheObject = [CCache cacheKeyDictionaryFromKey:cacheKey andExpiry:expiryDate];
    NSDictionary *removableObject;
    for (NSDictionary *cacheObjectInList in cacheList) {
        if ([cacheObjectInList[@"cacheKey"] isEqualToString:cacheKey]) {
            removableObject = cacheObjectInList;
            break;
        }
    }
    if (removableObject) {
        [cacheList removeObject:removableObject];
    }
    
    [cacheList addObject:cacheObject];
    [defaults setObject:cacheList forKey:CACHE_LIST_KEY];
    [defaults synchronize];
}

+(NSDictionary *) cacheKeyDictionaryFromKey:(NSString *) cacheKey andExpiry:(NSDate *) expiry{
    return @{@"cacheKey":cacheKey,@"expiry":expiry};
}

+(void) collectGarbage {
    @try {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *cacheList = [defaults objectForKey:CACHE_LIST_KEY];
        if (cacheList) {
            NSMutableArray *objectsToDelete = [[NSMutableArray alloc] init];
            for (NSDictionary *cacheObjectInList in cacheList) {
                NSDate *expiryDate = cacheObjectInList[@"expiry"];
                if( [expiryDate timeIntervalSinceDate:[NSDate date]] <= 0 ) {
                    [objectsToDelete addObject:cacheObjectInList];
                }
                //ToDo here BUG KAK
            }
            
            for (NSDictionary *deletableObject in objectsToDelete) {
                NSString *key = deletableObject[@"cacheKey"];
                if ([defaults objectForKey:key]) {
                    [defaults removeObjectForKey:key];
                }
                [cacheList removeObject:deletableObject];
            }
            
            [defaults setObject:cacheList forKey:CACHE_LIST_KEY];
            [defaults synchronize];
        }
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
@end
