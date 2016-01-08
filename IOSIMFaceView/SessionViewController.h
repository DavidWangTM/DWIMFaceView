//
//  SessionViewController.h
//  wanshitong
//
//  Created by DavidWang on 15/11/20.
//  Copyright © 2015年 DavidWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCHead.h"

@interface SessionViewController : UIViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) IBOutlet UIView *containerView;

- (IBAction)sendOnclick:(id)sender;
- (IBAction)expressionOnclick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *contentText;

@property (weak, nonatomic) IBOutlet UIView *emojiView;

@property (weak, nonatomic) IBOutlet UIScrollView *emojiscrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@end
