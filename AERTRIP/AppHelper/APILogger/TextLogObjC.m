//
//  TextLogObjC.m
//  Aertrip
//
//  Created by Monika Sonawane on 20/08/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextLogObjC.h"

//@implementation TextLogObjC
//
//- (void)logText:(NSString *)text{
//
//    NSString *stringURL = @"http://www.somewhere.com/thefile.png";
//    NSURL  *url = [NSURL URLWithString:stringURL];
//    NSData *urlData = [NSData dataWithContentsOfURL:url];
//    if ( urlData )
//    {
//      NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//      NSString  *documentsDirectory = [paths objectAtIndex:0];
//
//      NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"filename.png"];
//      [urlData writeToFile:filePath atomically:YES];
//    }
//
//}
//@end




@implementation TextLogObjC
- (void)logTextToFile:(NSString *)data
{
    if(data){
//        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
//        NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
        
//        NSString *dataToAppend;
//        NSString *currDateTime = [dateFormatter stringFromDate:[NSDate date]];
//        currDateTime = [currDateTime stringByAppendingString:@"\n\n"];
//        dataToAppend = [currDateTime stringByAppendingString:data];

        
        NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"log.txt"];
        NSString *contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];

        if(contents == nil){
            contents = data;
        }else{
            contents = [contents stringByAppendingString:data];
        }
        
        contents = [contents stringByAppendingString:@"\n\n"];

        [contents writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}


- (NSString *)getCurrentDateTime{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);

    return [dateFormatter stringFromDate:[NSDate date]];
}
@end
