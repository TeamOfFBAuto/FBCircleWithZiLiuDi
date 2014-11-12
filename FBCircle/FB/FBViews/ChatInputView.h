//
//  ChatInputView.h
//  FBCircle
//
//  Created by soulnear on 14-5-20.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+MyChatViewCell.h"
#import "WeiBoFaceScrollView.h"
#import "NewFaceView.h"
#import "GrayPageControl.h"

@protocol ChatInputViewDelegate <NSObject>

-(void)sendMessageToSomeBodyWith:(NSString *)content;

@end


@interface ChatInputView : UIImageView<UIScrollViewDelegate,expressionDelegate,UITextViewDelegate>
{
    UIView * line_view;
    
    WeiBoFaceScrollView * faceScrollView;
    
    GrayPageControl * pageControl;
    
    BOOL isFace;
}


@property(nonatomic,strong)UITextView * myTextView;

@property(nonatomic,strong)UIButton * sendButton;

@property(nonatomic,strong)UIView * face_back_view;


@property(nonatomic,assign)id<ChatInputViewDelegate>delegate;

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight WihtHeight:(float)theHeight;
///恢复输入框状态
-(void)resetInputView;
@end
