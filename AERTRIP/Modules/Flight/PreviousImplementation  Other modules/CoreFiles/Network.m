
//
//  Network.m
//  EatRepeat
//
//  Created by Kakshil Shah on 24/10/16.
//  Copyright © 2016 Mazkara. All rights reserved.
//

#import "Network.h"
#import "CCache.h"
#import "TextLogObjC.h"



@implementation Network



+ (id)sharedNetwork {
        static Network *network = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            network = [[self alloc] init];
        });
        return network;
}

- (void) callApi:(NSString *) apiName
          parameters:(NSDictionary *)parameters
          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSLog(@"Parameter: %@ API: %@", parameters, apiName);
    
    if ([BaseViewController isReachable]) {
        
        //NSString *apiURL = [self getValueForKey:ApiURL_KEY];
//        NSString *url = [NSString stringWithFormat:@"%@%@",ApiURL,apiName]; // Commented when chenged to beta-rz url(Golu)
        NSString *baseUrl = AppKeys.baseUrlWithVersion;
        NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,apiName];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager POST:url parameters:parameters headers:nil progress:nil success:success failure:failure];
        //[manager POST:url parameters:parameters progress:nil success:success failure:failure];
        
    }
    else {
        [BaseViewController notifyNoInternetIssue];
    }
}


- (void) callApi:(NSString *) apiName
      parameters:(NSDictionary *)parameters
   loadFromCache:(BOOL) loadFromCache
         expires: (BOOL) expires
         success:(void (^)(NSDictionary* dataDictionary))success
         failure:(void (^)(NSString *error,BOOL popup))failure {
   
    NSLog(@"Parameter: %@ API: %@", parameters, apiName);
//    NSString *url = [NSString stringWithFormat:@"%@%@",ApiURL,apiName]; // Commented when chenged to beta-rz url(Golu)
    NSString *baseUrl = AppKeys.baseUrlWithVersion;
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,apiName];

    TextLogObjC *textLog = [[TextLogObjC alloc] init];
    
    NSString *requestDate = textLog.getCurrentDateTime;

    if ([BaseViewController isReachable]) {
        
        NSString *cacheKey = [CCache getKeyForParameters:parameters andAPI:apiName];
        if (loadFromCache && [CCache activelyExistsInCacheKey:cacheKey]) {
            NSDictionary *responseObject = [CCache dictionaryForKey:cacheKey];
            [self callApiInBG:apiName parameters:parameters expires:expires];
            success(responseObject);
        }
        else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
       // manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            
//            [manager.requestSerializer setValue:API_KEY forHTTPHeaderField:@"api-key"];
            [manager.requestSerializer setValue: AppKeys.apiKey forHTTPHeaderField:@"api-key"];
            
            
            
        [manager POST:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *responseDictionary = (NSDictionary *)responseObject;
            NSLog(@"%@",responseDictionary);
            if ([Parser checkForSuccess:responseDictionary]) {
                NSDictionary *dataDictionary = [Parser getData:responseDictionary];
                if (loadFromCache) {
                    [CCache saveDictionary:dataDictionary forKey:cacheKey expires:expires];
                }
                success(dataDictionary);
                
                // Logger request
                NSString *apiUrl=[NSString stringWithFormat:@"##########################################################################################\nAPI URL :::\n%@",url];
                [textLog logTextToFile:apiUrl];


                NSString *param=[NSString stringWithFormat:@"parameters ::::::::    %@   ::::::::\n%@",requestDate,parameters.description];
                [textLog logTextToFile:param];
                
                NSString *headers=[NSString stringWithFormat:@"REQUEST HEADER :::::::: %@   ::::::::\n%@",requestDate, manager.requestSerializer.HTTPRequestHeaders.description];
                [textLog logTextToFile:headers];
                
                // Logger response
                NSString *response=[NSString stringWithFormat:@"RESPONSE DATA ::::::::    %@ ::::::::=\n%@\n##########################################################################################",textLog.getCurrentDateTime,dataDictionary.description];
                [textLog logTextToFile:response];

            }
            else{
                NSString *failureText = [Parser getErrorFromDictionary:responseDictionary];
                failure(failureText,YES);
                
                
                // Logger request
                NSString *apiUrl=[NSString stringWithFormat:@"##########################################################################################\nAPI URL :::\n%@",url];
                [textLog logTextToFile:apiUrl];


                NSString *param=[NSString stringWithFormat:@"parameters ::::::::    %@   ::::::::\n%@",requestDate,parameters.description];
                [textLog logTextToFile:param];
                
                NSString *headers=[NSString stringWithFormat:@"REQUEST HEADER :::::::: %@   ::::::::\n%@",requestDate, manager.requestSerializer.HTTPRequestHeaders.description];
                [textLog logTextToFile:headers];
                
                // Logger response
                NSString *fail=[NSString stringWithFormat:@"Failure=\n%@\n##########################################################################################",failureText];
                [textLog logTextToFile:fail];

            }
            [manager invalidateSessionCancelingTasks:YES resetSession:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
            NSLog(@"Error : %@", ErrorResponse);
            failure(OOPS_ERROR_MESSAGE,NO);
            
            
            // Logger request
            NSString *apiUrl=[NSString stringWithFormat:@"##########################################################################################\nAPI URL :::\n%@",url];
            [textLog logTextToFile:apiUrl];


            NSString *param=[NSString stringWithFormat:@"parameters ::::::::    %@   ::::::::\n%@",requestDate,parameters.description];
            [textLog logTextToFile:param];
            
            NSString *headers=[NSString stringWithFormat:@"REQUEST HEADER :::::::: %@   ::::::::\n%@",requestDate, manager.requestSerializer.HTTPRequestHeaders.description];
            [textLog logTextToFile:headers];
            
            // Logger response
            NSString *fail=[NSString stringWithFormat:@"Failure=\n%@\n##########################################################################################",ErrorResponse];
            [textLog logTextToFile:fail];
            [manager invalidateSessionCancelingTasks:YES resetSession:YES];
        }];
        }
    }
    else {
        [BaseViewController notifyNoInternetIssue];
    }
}




- (void) callGETApi:(NSString *) apiName
      parameters:(NSDictionary *)parameters
   loadFromCache:(BOOL) loadFromCache
         expires: (BOOL) expires
         success:(void (^)(NSDictionary* dataDictionary))success
         failure:(void (^)(NSString *error,BOOL popup))failure {
    
//    NSString *url = [NSString stringWithFormat:@"%@%@",ApiURL,apiName]; // Commented when chenged to beta-rz url(Golu)
    NSString *baseUrl = AppKeys.baseUrlWithVersion;
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,apiName];

    TextLogObjC *textLog = [[TextLogObjC alloc] init];
    
    NSString* requestDate = textLog.getCurrentDateTime;
    
    if ([BaseViewController isReachable]) {
        
        NSString *cacheKey = [CCache getKeyForParameters:parameters andAPI:apiName];
//        NSLog(@"loadFromCache Get Parameter: %@ API: %@%@", parameters, ApiURL,apiName);

        if (loadFromCache && [CCache activelyExistsInCacheKey:cacheKey]) {
            NSDictionary *responseObject = [CCache dictionaryForKey:cacheKey];
            [self callGETApiInBG:apiName parameters:parameters expires:expires];
            success(responseObject);
        }
        else{
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
          //  manager.requestSerializer = [AFJSONRequestSerializer serializer];

//            [manager.requestSerializer setValue:API_KEY forHTTPHeaderField:@"api-key"];
            [manager.requestSerializer setValue:AppKeys.apiKey forHTTPHeaderField:@"api-key"];

            [manager GET:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                if ([Parser checkForSuccess:responseDictionary]) {
                    NSDictionary *dataDictionary = [Parser getData:responseDictionary];
                    if (loadFromCache) {
                        [CCache saveDictionary:dataDictionary forKey:cacheKey expires:expires];
                    }
//                    NSLog(@"Response:%@",dataDictionary);
                    
                    NSString *apiUrl=[NSString stringWithFormat:@"##########################################################################################\nAPI URL :::\n%@",url];
                    [textLog logTextToFile:apiUrl];

                    NSString *param=[NSString stringWithFormat:@"parameters ::::::::    %@   ::::::::\n%@",requestDate,parameters.description];
                    [textLog logTextToFile:param];
                    
                    NSString *headers=[NSString stringWithFormat:@"REQUEST HEADER :::::::: %@   ::::::::\n%@",requestDate, manager.requestSerializer.HTTPRequestHeaders.description];
                    [textLog logTextToFile:headers];
                    
                    NSString *response=[NSString stringWithFormat:@"RESPONSE DATA ::::::::    %@ ::::::::=\n%@\n##########################################################################################",textLog.getCurrentDateTime,dataDictionary.description];
                    [textLog logTextToFile:response];

                    success(dataDictionary);
                }
                else{
                    NSString *failureText = [Parser getErrorFromDictionary:responseDictionary];
                    failure(failureText,YES);
                    
                    NSString *apiUrl=[NSString stringWithFormat:@"##########################################################################################\nAPI URL :::\n%@",url];
                    [textLog logTextToFile:apiUrl];

                    NSString *param=[NSString stringWithFormat:@"parameters ::::::::    %@   ::::::::\n%@",requestDate,parameters.description];
                    [textLog logTextToFile:param];
                    
                    NSString *headers=[NSString stringWithFormat:@"REQUEST HEADER :::::::: %@   ::::::::\n%@",requestDate, manager.requestSerializer.HTTPRequestHeaders.description];
                    [textLog logTextToFile:headers];

                    NSString *response=[NSString stringWithFormat:@"RESPONSE DATA ::::::::    %@ ::::::::=\n%@\n##########################################################################################",textLog.getCurrentDateTime,failureText];
                    [textLog logTextToFile:response];



                }
                [manager invalidateSessionCancelingTasks:YES resetSession:YES];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                NSLog(@"Error : %@", ErrorResponse);
                failure(OOPS_ERROR_MESSAGE,NO);
                
                NSString *apiUrl=[NSString stringWithFormat:@"##########################################################################################\nAPI URL :::\n%@",url];
                [textLog logTextToFile:apiUrl];

                NSString *param=[NSString stringWithFormat:@"parameters ::::::::    %@   ::::::::\n%@",requestDate,parameters.description];
                [textLog logTextToFile:param];
                
                NSString *headers=[NSString stringWithFormat:@"REQUEST HEADER :::::::: %@   ::::::::\n%@",requestDate, manager.requestSerializer.HTTPRequestHeaders.description];
                [textLog logTextToFile:headers];
                
                NSString *response=[NSString stringWithFormat:@"RESPONSE DATA ::::::::    %@ ::::::::=\n%@\n##########################################################################################",textLog.getCurrentDateTime,ErrorResponse];
                [textLog logTextToFile:response];
                [manager invalidateSessionCancelingTasks:YES resetSession:YES];
            }];
        }
    }
    else {
        [BaseViewController notifyNoInternetIssue];
    }
}

- (void) callGETApiInBG:(NSString *) apiName
             parameters:(NSDictionary *)parameters
                expires:(BOOL)expires{
    NSString *cacheKey = [CCache getKeyForParameters:parameters andAPI:apiName];
//    NSString *url = [NSString stringWithFormat:@"%@%@",ApiURL,apiName];// Commented when chenged to beta-rz url(Golu)
    NSString *baseUrl = AppKeys.baseUrlWithVersion;
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,apiName];

    TextLogObjC *textLog = [[TextLogObjC alloc] init];
    
    NSString* requestDate = textLog.getCurrentDateTime;

//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
//    [manager.requestSerializer setValue:API_KEY forHTTPHeaderField:@"api-key"];
    [manager.requestSerializer setValue:AppKeys.apiKey forHTTPHeaderField:@"api-key"];
    
    [manager GET:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        if ([Parser checkForSuccess:responseDictionary]) {
            NSDictionary *dataDictionary = [Parser getData:responseDictionary];
            [CCache saveDictionary:dataDictionary forKey:cacheKey expires:expires];
            
            NSString *apiUrl=[NSString stringWithFormat:@"##########################################################################################\nAPI URL :::%@",url];
            [textLog logTextToFile:apiUrl];

            NSString *param=[NSString stringWithFormat:@"parameters ::::::::    %@   ::::::::\n%@",requestDate,parameters.description];
            [textLog logTextToFile:param];
            
            NSString *headers=[NSString stringWithFormat:@"REQUEST HEADER :::::::: %@   ::::::::\n%@",requestDate, manager.requestSerializer.HTTPRequestHeaders.description];
            [textLog logTextToFile:headers];
            
            NSString *response=[NSString stringWithFormat:@"RESPONSE DATA ::::::::    %@ ::::::::=\n%@\n##########################################################################################",textLog.getCurrentDateTime,dataDictionary.description];
            [textLog logTextToFile:response];

        }
        NSLog(@"Response:%@",responseDictionary);
        [manager invalidateSessionCancelingTasks:YES resetSession:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"failure!");
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"Error : %@", ErrorResponse);
        
        NSString *apiUrl=[NSString stringWithFormat:@"##########################################################################################\nAPI URL :::%@",url];
        [textLog logTextToFile:apiUrl];

        NSString *param=[NSString stringWithFormat:@"parameters ::::::::    %@   ::::::::\n%@",requestDate,parameters.description];
        [textLog logTextToFile:param];
        
        NSString *headers=[NSString stringWithFormat:@"REQUEST HEADER :::::::: %@   ::::::::\n%@",requestDate, manager.requestSerializer.HTTPRequestHeaders.description];
        [textLog logTextToFile:headers];
        
        NSString *response=[NSString stringWithFormat:@"RESPONSE DATA ::::::::    %@ ::::::::=\n%@\n##########################################################################################",textLog.getCurrentDateTime,ErrorResponse];
        [textLog logTextToFile:response];
        [manager invalidateSessionCancelingTasks:YES resetSession:YES];
        
    }];
}


- (void) callApiInBG:(NSString *) apiName
          parameters:(NSDictionary *)parameters
             expires:(BOOL)expires{
    NSString *cacheKey = [CCache getKeyForParameters:parameters andAPI:apiName];
//    NSString *url = [NSString stringWithFormat:@"%@%@",ApiURL,apiName]; // Commented when chenged to beta-rz url(Golu)
    NSString *baseUrl = AppKeys.baseUrlWithVersion;
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,apiName];
    
    TextLogObjC *textLog = [[TextLogObjC alloc] init];
    
    NSString* requestDate = textLog.getCurrentDateTime;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager.requestSerializer setValue:API_KEY forHTTPHeaderField:@"api-key"];
    [manager.requestSerializer setValue:AppKeys.apiKey forHTTPHeaderField:@"api-key"];

    [manager POST:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        if ([Parser checkForSuccess:responseDictionary]) {
            NSDictionary *dataDictionary = [Parser getData:responseDictionary];
            [CCache saveDictionary:dataDictionary forKey:cacheKey expires:expires];
            
            NSString *apiUrl=[NSString stringWithFormat:@"##########################################################################################\nAPI URL :::\n%@",url];
            [textLog logTextToFile:apiUrl];

            NSString *param=[NSString stringWithFormat:@"parameters ::::::::    %@   ::::::::\n%@",requestDate,parameters.description];
            [textLog logTextToFile:param];
            
            NSString *headers=[NSString stringWithFormat:@"REQUEST HEADER :::::::: %@   ::::::::\n%@",requestDate, manager.requestSerializer.HTTPRequestHeaders.description];
            [textLog logTextToFile:headers];
            
            NSString *response=[NSString stringWithFormat:@"RESPONSE DATA ::::::::    %@ ::::::::=\n%@\n##########################################################################################",textLog.getCurrentDateTime,dataDictionary.description];
            [textLog logTextToFile:response];
            
        }
        [manager invalidateSessionCancelingTasks:YES resetSession:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"failure!");
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"Error : %@", ErrorResponse);
        
        NSString *apiUrl=[NSString stringWithFormat:@"##########################################################################################\nAPI URL :::\n%@",url];
        [textLog logTextToFile:apiUrl];

        NSString *param=[NSString stringWithFormat:@"parameters ::::::::    %@   ::::::::\n%@",requestDate,parameters.description];
        [textLog logTextToFile:param];
        
        NSString *headers=[NSString stringWithFormat:@"REQUEST HEADER :::::::: %@   ::::::::\n%@",requestDate, manager.requestSerializer.HTTPRequestHeaders.description];
        [textLog logTextToFile:headers];
        
        NSString *response=[NSString stringWithFormat:@"RESPONSE DATA ::::::::    %@ ::::::::=\n%@\n##########################################################################################",textLog.getCurrentDateTime,ErrorResponse];
        [textLog logTextToFile:response];

        [manager invalidateSessionCancelingTasks:YES resetSession:YES];
    }];
}



- (void) callApi:(NSString *) apiName
      parameters:(NSDictionary *)parameters
 imageAttachment:(UIImage *)image
   imageFileName:(NSString *)imageFilename
         success:(void (^)(NSDictionary* dataDictionary))success
         failure:(void (^)(NSString *error,BOOL popup))failure {
    
    
    NSLog(@"Parameter: %@ API: %@", parameters, apiName);
    
    if ([BaseViewController isReachable]) {
        
//        NSString *url = [NSString stringWithFormat:@"%@%@",ApiURL,apiName]; // Commented when chenged to beta-rz url(Golu)
        NSString *baseUrl = AppKeys.baseUrlWithVersion;
        NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,apiName];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//        [manager.requestSerializer setValue:API_KEY forHTTPHeaderField:@"api-key"];
        
        [manager.requestSerializer setValue:AppKeys.apiKey forHTTPHeaderField:@"api-key"];
        [manager POST:url parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            float actualImageSize = UIImageJPEGRepresentation(image,1.0f).length;
            float destinationFileSize = 2000000.0;
            float percentage = destinationFileSize / actualImageSize;
            
            NSData *imageData = UIImageJPEGRepresentation(image,percentage);
            NSLog(@"File Size in byte: %lu", (unsigned long)imageData.length);
            
            [formData appendPartWithFileData:imageData
                                        name:imageFilename
                                    fileName:@"image.jpg"
                                    mimeType:@"image/jpeg"];
        } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSDictionary *responseDictionary = (NSDictionary *)responseObject;
            NSLog(@"Response %@",responseDictionary);
            
            if ([Parser checkForSuccess:responseDictionary]) {
                
                NSDictionary *dataDictionary = [Parser getData:responseDictionary];
                success(dataDictionary);
                
            }
            else {
                
                NSString *failureText = [Parser getErrorFromDictionary:responseDictionary];
                failure(failureText,YES);
            }
            [manager invalidateSessionCancelingTasks:YES resetSession:YES];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
            NSLog(@"Error : %@", ErrorResponse);
            failure(OOPS_ERROR_MESSAGE,NO);
            [manager invalidateSessionCancelingTasks:YES resetSession:YES];
        }];
        
    }
    else {
        
        [BaseViewController notifyNoInternetIssue];
        
    }
}




- (void) callLocalApi:(NSString *) apiName
      parameters:(NSDictionary *)parameters
         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {

    if ([BaseViewController isReachable]) {
        NSString *localAPI = @"http://192.168.0.132:8000/api/";
        NSString *url = [NSString stringWithFormat:@"%@%@",localAPI,apiName];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager POST:url parameters:parameters headers:nil progress:nil success:success failure:failure];
    }
    else {
        [BaseViewController notifyNoInternetIssue];
    }
}




-(NSString *) getValueForKey:(NSString *)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    
    if ([key isEqualToString:LAT_KEY] || [key isEqualToString:LONG_KEY]) {
        if ([self getBooleanForKey:MANUAL_ZONE_SELECTED]) {
            if ([key isEqualToString:LAT_KEY]) {
                return [defaults valueForKey:CUSTOM_LAT_KEY];
            }
            if ([key isEqualToString:LONG_KEY]) {
                return [defaults valueForKey:CUSTOM_LONG_KEY];
            }
        }
    }
    
    
    return [defaults valueForKey:key];
}
-(BOOL) getBooleanForKey:(NSString *)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}
-(id )loadObjectFromPreferences:(NSString*)key
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [prefs objectForKey:key ];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    return obj;
}
- (BOOL)exists:(NSString *)value
{
    if (value) {
        if(![value isEqualToString:@""])
        {
            return true;
        }
    }
    return false;
}





@end
