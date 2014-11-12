//
//  FoundViewController.h
//  FBCircle
//
//  Created by soulnear on 14-8-4.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundViewController : MyViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;//主tableview
    
}

-(void)pushWebViewWithStr:(NSString *)stringValue;

-(void)pushMyerweimaVc;

-(void)pushToPersonInfoVcWithStr:(NSString *)stringValue;

-(void)pushToGrxx4;

@end
