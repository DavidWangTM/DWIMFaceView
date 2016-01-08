//
//  EmojiTextAttachment.h
//  InputEmojiExample
//
//  Created by DavidWang on 15/4/7.
//  Copyright (c) 2015年 nef. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmojiTextAttachment : NSTextAttachment
@property(strong, nonatomic) NSString *emojiTag;
@property(assign, nonatomic) CGFloat emojiSize;  //For emoji image size
@end
