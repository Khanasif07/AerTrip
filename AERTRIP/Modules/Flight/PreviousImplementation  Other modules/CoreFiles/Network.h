//
//  Network.h
//  EatRepeat
//
//  Created by Kakshil Shah on 24/10/16.
//  Copyright © 2016 Mazkara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@class Appkeys;

@interface Network : NSObject
+ (id)sharedNetwork;
//- (void) callApi3:(NSString *) apiName
//      parameters:(NSDictionary *)parameters
//         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
//         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


- (void) callApi:(NSString *) apiName
      parameters:(NSDictionary *)parameters
   loadFromCache:(BOOL) loadFromCache
         expires: (BOOL) expires
         success:(void (^)(NSDictionary* dataDictionary))success
         failure:(void (^)(NSString *error, BOOL popup))failure;

// Only for Local Testing

//- (void) callLocalApi:(NSString *) apiName
//           parameters:(NSDictionary *)parameters
//              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
//              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


//Get API
- (void) callGETApi:(NSString *) apiName
         parameters:(NSDictionary *)parameters
      loadFromCache:(BOOL) loadFromCache
            expires: (BOOL) expires
            success:(void (^)(NSDictionary* dataDictionary))success
            failure:(void (^)(NSString *error,BOOL popup))failure;


//image upload api
//- (void) callApi2:(NSString *) apiName
//      parameters:(NSDictionary *)parameters
// imageAttachment:(UIImage *)image
//   imageFileName:(NSString *)imageFilename
//         success:(void (^)(NSDictionary* dataDictionary))success
//         failure:(void (^)(NSString *error,BOOL popup))failure ;

@end
