//
//  TimeTool.m
//  MatureHelp
//
//  Created by DavidWang on 15/4/7.
//  Copyright (c) 2015年 nef. All rights reserved.
//

#import "TimeTool.h"

@implementation TimeTool

+(NSString *)GetTime:(NSDate*) showdata{
    NSDate* today = [NSDate date];
    NSTimeInterval tt = [today timeIntervalSince1970];
    NSTimeInterval dt = [showdata timeIntervalSince1970];
    double cha = tt - dt;
    NSString* timetext;
    if (cha<60) {
        timetext = @"刚刚";
    }else if (cha<60*60) {
        int a = cha/60;
        timetext = [NSString stringWithFormat:@"%d分前",a];
    } else if (cha<60*60*24) {
        int a = cha/60/60;
        int b = cha - a*60*60;
        b=b/60;
        timetext = [NSString stringWithFormat:@"%d小时前",a];
    } else if (cha<60*60*24*30) {
        int a = cha/60/60/24;
        int b = cha - a*60*60*24;
        b=b/60/60;
                timetext = [NSString stringWithFormat:@"%d天前",a];
    }
    else if (cha<60*60*24*30*12) {
        int a = cha/60/60/24/30;
        int b = cha - a*60*60*24*30;
        b=b/60/60/24;
                timetext = [NSString stringWithFormat:@"%d个月前",a];
    }
    else {
        timetext = @"很久以前";
    }
    return timetext;
}

+(NSString*)getFullTimeStr:(NSDate *) mdata{
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:mdata];
//    NSInteger weekday= [component weekday];
    
//    NSString * daystr=nil;
//    switch (weekday) {
//        case 1:
//            daystr=@"日";
//            break;
//        case 2:
//            daystr=@"一";
//            break;
//        case 3:
//            daystr=@"二";
//            break;
//        case 4:
//            daystr=@"三";
//            break;
//        case 5:
//            daystr=@"四";
//            break;
//        case 6:
//            daystr=@"五";
//            break;
//        case 7:
//            daystr=@"六";
//            break;
//        default:
//            break;
//    }
    
        NSString * string=[NSString stringWithFormat:@"%02ld/%02ld  %04ld",[component month],[component day],[component year]];
    
//    NSString * string=[NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld",(long)[component year],(long)[component month],(long)[component day],(long)[component hour],(long)[component minute]];
    
    return string;
}

+(NSString *)getDialTimeStr:(long) nsTimeInterval{
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:nsTimeInterval];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    
    NSInteger year=[component year];
    NSInteger month=[component month];
    NSInteger day=[component day];
    NSInteger hour=[component hour];
    NSInteger minute=[component minute];
    NSInteger week=[component week];
    NSInteger weekday=[component weekday];
    
    NSDate * today=[NSDate date];
    component=[calendar components:unitFlags fromDate:today];
    
    NSInteger t_year=[component year];
    NSInteger t_month=[component month];
    NSInteger t_day=[component day];
    NSInteger t_week=[component week];
    
    NSString*string=nil;
    if(year==t_year&&month==t_month&&day==t_day)
    {
        if(hour<6&&hour>=0)
            string=[NSString stringWithFormat:@"凌晨 %02ld:%02ld",hour,minute];
        else if(hour>=6&&hour<12)
            string=[NSString stringWithFormat:@"上午 %02ld:%02ld",hour,minute];
        else if(hour>=12&&hour<18){
            NSInteger h = hour - 12;
            if (h == 0) {
                h += 12;
            }
            string=[NSString stringWithFormat:@"下午 %02ld:%02ld",h,minute];
        }else
            string=[NSString stringWithFormat:@"晚上 %02ld:%02ld",hour,minute];
    }
    else if(year==t_year&&week==t_week)
    {
        NSString * daystr=nil;
        switch (weekday) {
            case 1:
                daystr=@"日";
                break;
            case 2:
                daystr=@"一";
                break;
            case 3:
                daystr=@"二";
                break;
            case 4:
                daystr=@"三";
                break;
            case 5:
                daystr=@"四";
                break;
            case 6:
                daystr=@"五";
                break;
            case 7:
                daystr=@"六";
                break;
            default:
                break;
        }
        string=[NSString stringWithFormat:@"周%@ %02ld:%02ld",daystr,hour,minute];
    }
    else if(year==t_year)
        string=[NSString stringWithFormat:@"%02ld月%02ld日 %02ld:%02ld",month,day,hour,minute];
    else
        string=[NSString stringWithFormat:@"%ld年%02ld月%02ld日",year,month,day];
    
    return string;
}

+(NSString *)getNowTimeStr{
    NSDate* today = [NSDate date];
    NSTimeInterval tt = [today timeIntervalSince1970];
    return [NSString stringWithFormat:@"%f",tt];
}

+(NSString *)getTimeLong:(long) time{
    int seconds = time % 60;
    int minutes = (time / 60) % 60;
    int hours = time / 3600;
    return [NSString stringWithFormat:@"%02ld:%02ld",minutes,seconds];
}


@end
