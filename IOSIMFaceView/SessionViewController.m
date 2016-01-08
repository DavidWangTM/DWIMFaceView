//
//  SessionViewController.m
//  wanshitong
//
//  Created by DavidWang on 15/11/20.
//  Copyright © 2015年 DavidWang. All rights reserved.
//

#import "SessionViewController.h"
#import "LeftCell.h"
#import "RightCell.h"
#import "ExpressionCell.h"
#import "ExpressionAddView.h"
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"
#import "myTextAttachment.h"
#import "SessionModel.h"
#import "TimeTool.h"



#define LINENUMBER 10

#define FACE_NAME_HEAD  @"["
// 表情转义字符的长度（ [占1个长度，xxx占3个长度，共5个长度 ）
#define FACE_NAME_LEN   5

#define FACE_COUNT_ALL  85


@interface SessionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSMutableArray *data;
    NSMutableArray *emojiTags;
    NSMutableArray *emojiTagname;
    NSMutableArray *emojiImages;
    //0为正常状态,1为键盘上,2为表情上
    NSInteger typestatus;
    NSInteger pageNum;
    NSInteger topstatus;
    BOOL is_add;
    NSString *endtime;
    NSString *upcontent;
    NSString *sendcontent;
    BOOL is_one;
    BOOL is_end;
}

@end

@implementation SessionViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pageNum = 0;
    typestatus = defaultstatus;
    data = [NSMutableArray new];
    topstatus = 0;
    is_one = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    [self AddExpression];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [data count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SessionModel *info = [data objectAtIndex:indexPath.row];
    NSMutableAttributedString *str = info.content;
    CGRect rect = [str boundingRectWithSize:CGSizeMake((SCREENWITH-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGSize textSize = rect.size;
        
    return 45+textSize.height+40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    SessionModel *info = [data objectAtIndex:row];
    if (info.sendType == Isend) {
        static NSString *identifier = @"RightCell";
        RightCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.str = info.content;
        cell.timeLab.text = info.time;
        [cell.timeLab sizeToFit];
        cell.timeView.frame = CGRectMake(cell.frame.size.width/2 - (cell.timeLab.frame.size.width + 35)/2, cell.timeView.frame.origin.y, cell.timeLab.frame.size.width + 30, cell.timeView.frame.size.height);
        cell.timeLab.center = CGPointMake(cell.timeView.frame.size.width/2, cell.timeView.frame.size.height/2);
        
        return cell;
    }else{
        static NSString *identifier = @"LeftCell";
        LeftCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.str = info.content;
        cell.timeLab.text = info.time;
        [cell.timeLab sizeToFit];
        cell.timeView.frame = CGRectMake(cell.frame.size.width/2 - (cell.timeLab.frame.size.width + 35)/2, cell.timeView.frame.origin.y, cell.timeLab.frame.size.width + 30, cell.timeView.frame.size.height);
        cell.timeLab.center = CGPointMake(cell.timeView.frame.size.width/2, cell.timeView.frame.size.height/2);
        return cell;
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (typestatus == keyboardup) {
        [self.view endEditing:YES];
    }else if (typestatus == faceup) {
        [UIView animateWithDuration:0.3 animations:^{
            _emojiView.frame = CGRectMake(_emojiView.frame.origin.x, SCREENHEIGHT, _emojiView.frame.size.width, _emojiView.frame.size.height);
            _containerView.frame = CGRectMake(_containerView.frame.origin.x, _containerView.frame.origin.y, _containerView.frame.size.width, SCREENHEIGHT);
        } completion:^(BOOL finished) {
            _emojiView.hidden = YES;
        }];
        typestatus = defaultstatus;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendOnclick:(id)sender {
    NSString *content = [_contentText.textStorage getPlainString];
    if (content.length > 0) {
        [self sendContent:content];
    }
}



-(void)sendContent:(NSString *) content{
    NSMutableArray *emarr = [NSMutableArray new];
    [self getMessageRange:content :emarr];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:content attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    for(int j = 0;j < emarr.count ;j++){
        for (int i = 0; i < emojiTags.count; i++) {
            NSString *img = [emojiTags objectAtIndex:i];
            NSRange range = [[str string]rangeOfString:img];
            if (range.length != 0) {
                EmojiTextAttachment *attachment = [[EmojiTextAttachment alloc]init];
                attachment.emojiSize = 20;
                UIImage *image = [UIImage imageNamed:[emojiTagname objectAtIndex:i]];
                attachment.image = image;
                NSAttributedString *text = [NSAttributedString attributedStringWithAttachment:attachment];
                [str replaceCharactersInRange:range withAttributedString:text];
            }
        }
    }
    _contentText.text = @"";
    [self textViewDidChange:_contentText];
    SessionModel *info = [SessionModel new];
    info.content = str;
    int i = random() % 2;
    info.sendType = i;
    info.time = [TimeTool getDialTimeStr:[[TimeTool getNowTimeStr] longLongValue]];
    [data addObject:info];
    [_tableView reloadData];
    if (data.count != 0) {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:(data.count -1)  inSection:0];
        [_tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}



//以下是键盘和表情

- (IBAction)expressionOnclick:(id)sender {
    [self showExpression];
}

-(void)showExpression{
    if (typestatus == defaultstatus) {
        _emojiView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _emojiView.frame = CGRectMake(_emojiView.frame.origin.x, SCREENHEIGHT - _emojiView.frame.size.height, _emojiView.frame.size.width, _emojiView.frame.size.height);
            _containerView.frame = CGRectMake(_containerView.frame.origin.x, _containerView.frame.origin.y, _containerView.frame.size.width, SCREENHEIGHT - _emojiView.frame.size.height);
        }];
        typestatus = faceup;
        if (data.count != 0) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:(data.count -1)  inSection:0];
            [_tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }else if (typestatus == keyboardup){
        [self.view endEditing:YES];
        _emojiView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _emojiView.frame = CGRectMake(_emojiView.frame.origin.x, SCREENHEIGHT - _emojiView.frame.size.height, _emojiView.frame.size.width, _emojiView.frame.size.height);
            _containerView.frame = CGRectMake(_containerView.frame.origin.x, _containerView.frame.origin.y, _containerView.frame.size.width, SCREENHEIGHT - _emojiView.frame.size.height);
        }];
        typestatus = faceup;
        if (data.count != 0) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:(data.count -1)  inSection:0];
            [_tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }else if(typestatus == keyboardup){
        [UIView animateWithDuration:0.3 animations:^{
            _emojiView.frame = CGRectMake(_emojiView.frame.origin.x, SCREENHEIGHT, _emojiView.frame.size.width, _emojiView.frame.size.height);
            _containerView.frame = CGRectMake(_containerView.frame.origin.x, _containerView.frame.origin.y, _containerView.frame.size.width, SCREENHEIGHT);
        } completion:^(BOOL finished) {
            _emojiView.hidden = YES;
        }];
        typestatus = defaultstatus;
    }
}



//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    if (typestatus == faceup) {
        [UIView animateWithDuration:0.3 animations:^{
            _emojiView.frame = CGRectMake(_emojiView.frame.origin.x, SCREENHEIGHT, _emojiView.frame.size.width, _emojiView.frame.size.height);
            _containerView.frame = CGRectMake(_containerView.frame.origin.x, _containerView.frame.origin.y, _containerView.frame.size.width, SCREENHEIGHT);
        } completion:^(BOOL finished) {
            _emojiView.hidden = YES;
        }];
    }
    
    
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    //[UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.containerView.frame = containerFrame;
    [self.tableView setContentInset:UIEdgeInsetsMake(keyboardBounds.size.height + 64, 0, 0, 0)];
    // commit animations
    [UIView commitAnimations];
    typestatus = keyboardup;
    
    
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
   // [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.containerView.frame = containerFrame;
    [self.tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    
    // commit animations
    [UIView commitAnimations];
    
    if (typestatus == keyboardup) {
        typestatus = defaultstatus;
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView  == _tableView) {
        if (typestatus == keyboardup) {
            [self.view endEditing:YES];
        }else if (typestatus == faceup) {
            [UIView animateWithDuration:0.3 animations:^{
                _emojiView.frame = CGRectMake(_emojiView.frame.origin.x, SCREENHEIGHT, _emojiView.frame.size.width, _emojiView.frame.size.height);
                _containerView.frame = CGRectMake(_containerView.frame.origin.x, _containerView.frame.origin.y, _containerView.frame.size.width, SCREENHEIGHT);
            } completion:^(BOOL finished) {
                _emojiView.hidden = YES;
            }];
            typestatus = defaultstatus;
        }
    }
}


- (void)textViewDidChange:(UITextView *)_textView {
    [_contentText setFont:[UIFont systemFontOfSize:16]];
    CGSize size = _contentText.contentSize;
    size.height -= 2;
    if ( size.height >= 68 ) {
        
        size.height = 68;
    }
    else if ( size.height <= 32 ) {
        
        size.height = 32;
    }
    
    if ( size.height != _contentText.frame.size.height ) {
        
        CGFloat span = size.height - _contentText.frame.size.height;
        
        CGRect frame = _bottomView.frame;
        frame.origin.y -= span;
        frame.size.height += span;
        _bottomView.frame = frame;
    }
}

-(void)AddExpression{
    emojiTags = [NSMutableArray new];
    emojiTagname = [NSMutableArray new];
    
    for (int i = 1; i < FACE_COUNT_ALL + 1; i++) {
        NSString *index = [NSString stringWithFormat:@"%03d", i];
        NSString *tags = [NSString stringWithFormat:@"%@%@]",FACE_NAME_HEAD,index];
        [emojiTags addObject:tags];
        [emojiTagname addObject:index];
    }
    
    for (int i = 0; i < 4; i++) {
        ExpressionAddView *ev = [[[NSBundle mainBundle] loadNibNamed:@"ExpressionAddView" owner:self options:nil] firstObject];
        ev.frame = CGRectMake(SCREENWITH * i, 0, SCREENWITH, ev.frame.size.height);
        ev.collectionView.delegate = self;
        ev.collectionView.dataSource = self;
        ev.collectionView.tag = i+100;
        UINib *cellNib = [UINib nibWithNibName:@"ExpressionCell" bundle:nil];
        [ev.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ExpressionCell"];
        [_emojiscrollView addSubview:ev];
    }
    _emojiscrollView.delegate = self;
    [_emojiscrollView setContentSize:CGSizeMake(4 * SCREENWITH, _emojiscrollView.frame.size.height)];
}

#pragma mark - UICollectionViewDataSource Delegate
#pragma mark cell的数量
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 27;
}

#pragma mark cell的视图
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"ExpressionCell";
    ExpressionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSInteger tag = collectionView.tag - 100;
    NSInteger row = indexPath.row;
    NSInteger index = row + 27 *tag;
    if (tag != 0) {
        index -= 1;
    }
    NSString *index1 = [NSString stringWithFormat:@"%03ld", index + 1];
    
    if (row == 26) {
        cell.showImg.image = [UIImage imageNamed:@"del_emoji_normal"];
    }else{
        cell.showImg.image = [UIImage imageNamed:index1];
    }
    
    
    return cell;
}

//pragma mark cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (SCREENWITH - 15*2 - (8 * 10))/9;
    return CGSizeMake( width , width);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tag = collectionView.tag - 100;
    NSInteger row = indexPath.row;
    NSInteger index = row + 27 *tag;
    if (tag != 0) {
        index -= 1;
    }
    
    if (row == 26) {
        [_contentText deleteBackward];
    }else{
        [self insertEmoji:index];
    }
}

/*
 *  scrollView代理方法区
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _emojiscrollView) {
        NSUInteger page = [self pageCalWithScrollView:scrollView];
        [_pageControl setCurrentPage:page];
    }
}

-(NSUInteger)pageCalWithScrollView:(UIScrollView *)scrollView{
    
    NSUInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width + .5f;
    
    return page;
}

#pragma mark - Action

- (void)insertEmoji:(NSInteger) tag{
    //Create emoji attachment
    EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
    
    //Set tag and image
    emojiTextAttachment.emojiTag = emojiTags[tag];
    emojiTextAttachment.image = [UIImage imageNamed:emojiTagname[tag]];
    
    //Set emoji size
    emojiTextAttachment.emojiSize = 20;
    
    //Insert emoji image
    [_contentText.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment]
                                          atIndex:_contentText.selectedRange.location];
    
    //Move selection location
    _contentText.selectedRange = NSMakeRange(_contentText.selectedRange.location + 1, _contentText.selectedRange.length);
    
    [self textViewDidChange:_contentText];
}


/**
 * 解析输入的文本
 *
 * 根据文本信息分析出哪些是表情，哪些是文字
 */
- (void)getMessageRange:(NSString*)message :(NSMutableArray*)array {
    
    NSRange range = [message rangeOfString:FACE_NAME_HEAD];
    
    //判断当前字符串是否存在表情的转义字符串
    if ( range.length > 0 ) {
        
        if ( range.location > 0 ) {
            
            [array addObject:[message substringToIndex:range.location]];
            
            message = [message substringFromIndex:range.location];
            
            if ( message.length > FACE_NAME_LEN ) {
                
                [array addObject:[message substringToIndex:FACE_NAME_LEN]];
                
                message = [message substringFromIndex:FACE_NAME_LEN];
                [self getMessageRange:message :array];
            }
            else
                // 排除空字符串
                if ( message.length > 0 ) {
                    
                    [array addObject:message];
                }
        }
        else {
            
            if ( message.length > FACE_NAME_LEN ) {
                
                [array addObject:[message substringToIndex:FACE_NAME_LEN]];
                
                message = [message substringFromIndex:FACE_NAME_LEN];
                [self getMessageRange:message :array];
            }
            else
                // 排除空字符串
                if ( message.length > 0 ) {
                    
                    [array addObject:message];
                }
        }
    }
    else {
        
        [array addObject:message];
    }
    
}



@end
