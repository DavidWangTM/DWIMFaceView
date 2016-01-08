//
//  myTextAttachment.m
//  11
//
//  Created by 郝高明 on 15/6/8.
//  Copyright (c) 2015年 郝高明. All rights reserved.
//

#import "myTextAttachment.h"

@implementation myTextAttachment

-(CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{
    return CGRectMake( 0 , 0 , lineFrag.size.height , lineFrag.size.height);
}
@end
