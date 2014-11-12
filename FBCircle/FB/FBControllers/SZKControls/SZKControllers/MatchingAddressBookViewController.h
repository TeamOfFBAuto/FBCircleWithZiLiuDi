//
//  MatchingAddressBookViewController.h
//  FBCircle
//
//  Created by 史忠坤 on 14-5-26.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//
//  FBCircle
//
//  Created by 史忠坤 on 14-5-21.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "SuggestFriendCell.h"

#import "FriendAttribute.h"

#import <MessageUI/MFMessageComposeViewController.h>

#import "ASIFormDataRequest.h"

@interface MatchingAddressBookViewController :MyViewController<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate>{
    
    
    ASIFormDataRequest *request;
    
    
    
}


@property(nonatomic,strong)UITableView *mainTabV;


@property(nonatomic,strong)NSMutableArray *arrayInfo;

@property(nonatomic,strong)NSString *str_title;

@property(nonatomic,strong)FBQuanAlertView *theFbquanalertV;//黑色背景的提醒

@end
