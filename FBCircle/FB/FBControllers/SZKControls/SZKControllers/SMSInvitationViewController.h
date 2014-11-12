//
//  SMSInvitationViewController.h
//  FBCircle
//
//  Created by 史忠坤 on 14-5-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//短信邀请界面

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>


@interface SMSInvitationViewController : MyViewController<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate>{
    NSMutableArray *arrayOfCharacters;//'A'~'Z'
    
    NSArray *arrayinfoaddress;//把电话本里面的放到这个数组里面
    
    NSMutableArray *   arrayname;//每个人一个字典，封装成model
    
    

}
    
@property(nonatomic,strong)UITableView *mainTabV;



@property(nonatomic,strong)UIButton  *bigNextButton;

@property(nonatomic,strong)NSMutableArray *arraySelect;

@property(nonatomic,strong)NSMutableArray *selectindexes;


@end
