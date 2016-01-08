//
//  SessionModel.h
//  wanshitong
//
//  Created by DavidWang on 15/12/1.
//  Copyright © 2015年 DavidWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionModel : NSObject

@property (strong ,nonatomic) NSString *userimg;
@property (strong ,nonatomic) NSMutableAttributedString *content;
@property (strong ,nonatomic) NSString *time;
@property NSInteger sendType;


@end
