//
//  LeftCell.m
//  wanshitong
//
//  Created by DavidWang on 15/11/20.
//  Copyright © 2015年 DavidWang. All rights reserved.
//

#import "LeftCell.h"

@implementation LeftCell

- (void)awakeFromNib {
    // Initialization code
    _timeView.layer.cornerRadius = 5.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    CGRect rect = [_str boundingRectWithSize:CGSizeMake((SCREENWITH-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGSize textSize = rect.size;
    _contentLab.attributedText = _str;
    [_contentLab setFrame:CGRectMake(10, 20, textSize.width + 5, textSize.height)];
    [_contentLab sizeToFit];
    
    [_contentBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
    _contentBg.frame = CGRectMake(_contentLab.frame.origin.x-18, 10, textSize.width+30, textSize.height+30);
}


@end
