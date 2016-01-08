# IOSIMFaceView
IOSIMFaceView 是IM对话中有表情输入和对话框表情显示。

## Preview

![image](https://raw.githubusercontent.com/DavidWangTM/IOSIMFaceView/master/nice.gif)
## instructions

Face文件在expression中
```Objective-C
	//转移字符开头符号，可以是/s或者/.等。。
    #define FACE_NAME_HEAD  @"["
	// 表情转义字符的长度（ /s占2个长度，xxx占3个长度，共5个长度 ）
	#define FACE_NAME_LEN   5
  
```

文本插入表情主要代码：
```Objective-C
	EmojiTextAttachment *attachment = [[EmojiTextAttachment alloc]init];
    attachment.emojiSize = 20;
    UIImage *image = [UIImage imageNamed:[emojiTagname objectAtIndex:i]];
    attachment.image = image;
    NSAttributedString *text = [NSAttributedString attributedStringWithAttachment:attachment];
    [str replaceCharactersInRange:range withAttributedString:text];
  
```

输入框插入表情主要代码：
```Objective-C
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
```    
