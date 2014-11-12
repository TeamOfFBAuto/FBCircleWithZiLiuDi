//
//  FBCircleCommentView.m
//  FBCircle
//
//  Created by soulnear on 14-5-21.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBCircleCommentView.h"
#define IMAGE_WIDHT 15
#define IMAGE_HEIGHT 15

@implementation FBCircleCommentView
@synthesize delegate = _delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBCOLOR(247,247,247);
    }
    return self;
}



-(float)setAllViewsWith:(NSMutableArray *)dataArray
{
    float height = 0;
    
    for (int i = 0;i < dataArray.count;i++)
    {        
        FBCircleCommentModel * model = [dataArray objectAtIndex:i];
        
//        NSString * commentString = [NSString stringWithFormat:@"<a href=\"fb://atSomeone@/%@\">%@</a> : %@",model.comment_uid,model.comment_username,model.comment_content];
//        
//        commentString = [ZSNApi FBImageChange:[ZSNApi decodeSpecialCharactersString:commentString]];
        
        CGRect labelFrame = CGRectMake(0,height,self.frame.size.width,0);

        /*
        RTLabel * label = [[RTLabel alloc] initWithFrame:CGRectMake(0,height,self.frame.size.width,0)];
        label.text = [commentString stringByReplacingEmojiCheatCodesWithUnicode];
        label.delegate = self;
        label.lineSpacing = 3;
        label.rt_color = @"#576a9a";
        label.textColor = RGBCOLOR(3,3,3);
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12];
        [self addSubview:label];
        
        CGSize optimuSize = [label optimumSize];
        labelFrame.size.height = optimuSize.height+4;
        label.frame = labelFrame;
        height += optimuSize.height + 7;
        label = nil;
         
         */
        
        
        NSString * content = [model.comment_content stringByReplacingEmojiCheatCodesWithUnicode];
        
        content = [NSString stringWithFormat:@"%@:%@",model.comment_username,content];
        
        OHAttributedLabel * label = [[OHAttributedLabel alloc] initWithFrame:labelFrame];
        label.textColor = RGBCOLOR(3,3,3);
        label.font = [UIFont systemFontOfSize:12];
        [self addSubview:label];
        [OHLableHelper creatAttributedText:content Label:label OHDelegate:self WithWidht:IMAGE_WIDHT WithHeight:IMAGE_HEIGHT WithLineBreak:NO];
        NSRange range = [content rangeOfString:model.comment_username];
        label.underlineLinks = NO;
        [label addCustomLink:[NSURL URLWithString:model.comment_uid] inRange:range];
        [label setLinkColor:RGBCOLOR(87,106,154)];
//        label.backgroundColor = [UIColor clearColor];
        height += label.frame.size.height+3;
        
    }

    return height;
}


#pragma mark - OHAttributedLabelDelegate

-(BOOL)attributedLabel:(OHAttributedLabel*)attributedLabel shouldFollowLink:(NSTextCheckingResult*)linkInfo
{
    NSString * uid = [linkInfo.URL absoluteString];
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickUserNameWithUid:)])
    {
        [_delegate clickUserNameWithUid:uid];
    }
    
    return YES;
}
//-(UIColor*)colorForLink:(NSTextCheckingResult*)linkInfo underlineStyle:(int32_t*)underlineStyle
//{
//    return RGBCOLOR(87,106,154);
//}



-(void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"点击链接-----%@",[url absoluteString]);
    
    NSString * theUrl = [url absoluteString];
    
    NSString * uid = [theUrl stringByReplacingOccurrencesOfString:@"fb://atSomeone@/" withString:@""];
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickUserNameWithUid:)]) {
        [_delegate clickUserNameWithUid:uid];
    }
    
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
