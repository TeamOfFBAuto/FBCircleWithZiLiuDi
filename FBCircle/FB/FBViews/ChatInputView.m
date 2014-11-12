//
//  ChatInputView.m
//  FBCircle
//
//  Created by soulnear on 14-5-20.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "ChatInputView.h"

@implementation ChatInputView
@synthesize myTextView = _myTextView;
@synthesize sendButton = _sendButton;
@synthesize delegate = _delegate;
@synthesize face_back_view = _face_back_view;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        
        isFace = NO;
        
        self.backgroundColor = RGBCOLOR(241,241,241);
        self.layer.masksToBounds = YES;
        self.layer.borderColor = RGBCOLOR(225,225,225).CGColor;
        self.layer.borderWidth = 0.5;
        
        
        _myTextView = [[UITextView alloc] initWithFrame:CGRectMake(17,6,248,32)];
        _myTextView.backgroundColor = [UIColor whiteColor];
        _myTextView.delegate = self;
        _myTextView.contentMode = UIViewContentModeCenter;
        _myTextView.returnKeyType = UIReturnKeySend;
        _myTextView.font = [UIFont systemFontOfSize:15];
        _myTextView.layer.borderColor = RGBCOLOR(216,216,216).CGColor;
        _myTextView.textColor = RGBCOLOR(153,153,153);
        _myTextView.layer.borderWidth = 0.5;
        _myTextView.layer.cornerRadius = 5;
        [self addSubview:_myTextView];
        
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(270,2,40,40);
        [_sendButton setImage:[UIImage imageNamed:!isFace?@"biaoqing-icon-56_56.png":@"jianpan-icon-56_56.png"] forState:UIControlStateNormal];
        [_sendButton setTitleColor:RGBCOLOR(91,138,59) forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendMessageTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendButton];
        
        
        line_view = [[UIView alloc] initWithFrame:CGRectMake(0,43.5,320,0.5)];
        
        line_view.backgroundColor = RGBCOLOR(202,202,202);
        
        [self addSubview:line_view];
        
        
        _face_back_view = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,215)];
        
        
        faceScrollView = [[WeiBoFaceScrollView alloc] initWithFrame:CGRectMake(0,0,320,215) target:self];
        faceScrollView.delegate = self;
        faceScrollView.bounces = NO;
        faceScrollView.contentSize = CGSizeMake(320*1,0);//设置有多少页表情
        [_face_back_view addSubview:faceScrollView];
        
        
        pageControl = [[GrayPageControl alloc] initWithFrame:CGRectMake(0,0,320,9)];
        pageControl.center = CGPointMake(160,215-20);
        pageControl.numberOfPages = 3;
        pageControl.currentPage = 0;
     //   [_face_back_view addSubview:pageControl];
    }
    return self;
}


-(void)sendMessageTap:(UIButton *)sender
{
    [_sendButton setImage:[UIImage imageNamed:!isFace?@"biaoqing-icon-56_56.png":@"jianpan-icon-56_56.png"] forState:UIControlStateNormal];
    
    isFace = !isFace;
    
    [_sendButton setImage:[UIImage imageNamed:!isFace?@"biaoqing-icon-56_56.png":@"jianpan-icon-56_56.png"] forState:UIControlStateNormal];
    
    [_myTextView resignFirstResponder];
    
    if (!isFace)
    {
        _myTextView.inputView = nil;
    }else
    {
        _myTextView.inputView = _face_back_view;
    }
    
    [_myTextView becomeFirstResponder];
}



#pragma mark - Message input view
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight WihtHeight:(float)theHeight
{
    CGRect prevFrame = self.myTextView.frame;
    
    int numLines = changeInHeight;
    
    if (numLines > 6)
    {
        //        CGPoint bottomOffset = CGPointMake(0.0f,self.textView.contentSize.height - self.textView.bounds.size.height);
        //        [self.textView setContentOffset:bottomOffset animated:YES];
    }else
    {
        self.myTextView.frame = CGRectMake(prevFrame.origin.x,
                                         prevFrame.origin.y,
                                         prevFrame.size.width,
                                         prevFrame.size.height + theHeight);
        self.myTextView.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 4.0f : 0.0f),0.0f,(numLines >= 6 ? 4.0f : 0.0f),0.0f);
                
        self.myTextView.scrollEnabled = (numLines>2);
    }
    
    line_view.frame = CGRectMake(line_view.frame.origin.x,self.frame.size.height-0.5,line_view.frame.size.width,line_view.frame.size.height);
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    pageControl.center = CGPointMake(160+scrollView.contentOffset.x,215-30);
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //获取当前页码
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    
    //设置当前页码
    pageControl.currentPage = index;
}


-(void)expressionClickWith:(NewFaceView *)faceView faceName:(NSString *)name
{
    _myTextView.text = [_myTextView.text stringByAppendingString:name];
    [_myTextView.delegate textViewDidChange:_myTextView];
}


- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound )
    {
        return YES;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendMessageToSomeBodyWith:)]) {
        [self.delegate sendMessageToSomeBodyWith:_myTextView.text];
    }
    
    [txtView resignFirstResponder];
    
    return NO;
}


#pragma mark - 恢复到初始状态
-(void)resetInputView
{
    [_myTextView resignFirstResponder];
    _myTextView.text = @"";
    _myTextView.inputView = nil;
    _myTextView.frame = CGRectMake(17,6,248,32);
    line_view.frame = CGRectMake(0,43.5,320,0.5);
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
