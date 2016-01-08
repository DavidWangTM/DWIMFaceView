//
//  LeftCell.h
//  wanshitong
//
//  Created by DavidWang on 15/11/20.
//  Copyright © 2015年 DavidWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCHead.h"

@interface LeftCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UIView *content_view_b;
@property (weak, nonatomic) IBOutlet UIView *content_view;
@property (weak, nonatomic) IBOutlet UIImageView *contentBg;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (weak, nonatomic) NSMutableAttributedString *str;

@end
