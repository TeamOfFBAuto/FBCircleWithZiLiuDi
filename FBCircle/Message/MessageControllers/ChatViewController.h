//
//  ChatViewController.h
//  FBCircle
//
//  Created by soulnear on 14-5-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"
#import "MessageModel.h"
#include "CustomChatViewCell.h"
#import "ChatInputView.h"



@interface ChatViewController : MyViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,ChatInputViewDelegate>
{
    UITextView * temp_textView;
    
    int temp_count;
    
    int historyPage;
    
    NSTimer * theTimer;
    
}

@property(nonatomic,strong)UITableView * mytableView;

@property(nonatomic,strong)ChatModel * theModel;

@property(nonatomic,assign)int allCount;

@property(nonatomic,assign)int currentPage;

@property(nonatomic,assign)BOOL isLoading;//显示是否正在加载数据

@property(nonatomic,strong)MessageModel * messageInfo;

@property(nonatomic,strong)NSMutableArray * data_array;

@property(nonatomic,strong)ChatInputView * inputToolBarView;

@property(nonatomic,strong)UIView * theTouchView;

@property(assign,nonatomic)CGFloat previousTextViewContentHeight;

@property(nonatomic,strong)NSString * otherHeaderImage;



@end
