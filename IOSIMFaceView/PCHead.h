//
//  PCHead.h
//  MantleDemo
//
//  Created by DavidWang on 15/7/22.
//  Copyright (c) 2015年 DavidWang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CompressionNum 0.5

#define Isend 0
#define sendMe 1
#define sendMeNo 2

#define IRead 0

//0为正常状态,1为键盘上,2为表情上
#define defaultstatus 0
#define keyboardup 1
#define faceup 2

//头像大小
#define HEAD_SIZE 40.0f
#define TEXT_MAX_HEIGHT 500.0f
//间距
#define INSETS 10.0f

//导航栏6.7的高度
#define STATUS_HEIGHT ([[UIDevice currentDevice].systemVersion doubleValue] < 7.0 ? 44.0 : 64.0)

#define ISIOS7LATER [[[UIDevice currentDevice] systemVersion] floatValue]>=7
#define ISIOS8LATER [[[UIDevice currentDevice] systemVersion] floatValue]>=8
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define SCREENWITH   [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define PHONEBOUND [[UIScreen mainScreen] bounds]
#define BOUNDS [[UIScreen mainScreen] bounds].size
#define IS_PHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_PHONE4   (([[UIScreen mainScreen] bounds].size.height-480)?NO:YES)
#define IS_PHONE6   (([[UIScreen mainScreen] bounds].size.height-667)?NO:YES)
#define IS_PHONE6PIS (([[UIScreen mainScreen] bounds].size.height-736)?NO:YES)


