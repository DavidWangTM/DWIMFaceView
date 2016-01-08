//
//  TimeTool.h
//  MatureHelp
//
//  Created by DavidWang on 15/4/7.
//  Copyright (c) 2015年 nef. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTool : NSObject

+(NSString *)GetTime:(NSDate*) showdata;
+(NSString *)getFullTimeStr:(NSDate *) mdata;
+(NSString *)getDialTimeStr:(long) nsTimeInterval;
+(NSString *)getNowTimeStr;
+(NSString *)getTimeLong:(long) time;
@end
