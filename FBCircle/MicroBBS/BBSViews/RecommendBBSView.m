//
//  RecommendBBSView.m
//  FBCircle
//
//  Created by lichaowei on 14/10/30.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "RecommendBBSView.h"
#import "JoinBBSCell.h"
#import "LSecionView.h"

@implementation RecommendBBSView

-(instancetype)initWithFrame:(CGRect)frame
                       title:(NSString *)title
                     dataArr:(NSArray *)dataArr
{
    self = [super initWithFrame:frame];
    if (self) {
        
        dataArray = dataArr;
        
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        [self addSubview:table];
        
        LSecionView *section2 = [[LSecionView alloc]initWithFrame:CGRectMake(0, 0, 304, 40) title:title target:self action:nil];
        section2.rightBtn.hidden = YES;
        table.tableHeaderView = section2;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier= @"JoinBBSCell";
    
    JoinBBSCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JoinBBSCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak typeof(self)weakSelf = self;
    __weak typeof(JoinBBSCell *)weakCell = cell;
    BBSInfoModel *aModel = [dataArray objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:aModel cellBlock:^(NSString *topicId) {
        NSLog(@"join topic id %@",topicId);
        [weakSelf JoinBBSId:topicId cell:weakCell];
    }];
    
    return cell;
    
}


/**
 *  加入论坛
 *
 *  @param bbsId 论坛id
 */
- (void)JoinBBSId:(NSString *)bbsId cell:(JoinBBSCell *)sender
{
    __weak typeof(self)weakSelf = self;
    //    __weak typeof(UIButton *)weakBtn = sender;
    NSString *url = [NSString stringWithFormat:FBCIRCLE_BBS_MEMBER_JOIN,[SzkAPI getAuthkey],bbsId];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            int erroCode = [[result objectForKey:@"errcode"]integerValue];
            if (erroCode == 0) {
                //加入论坛通知
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UPDATE_BBS_JOINSTATE object:nil userInfo:nil];
                //                weakBtn.selected = YES;
                sender.joinButton.selected = YES;
                sender.memeberLabel.text = [NSString stringWithFormat:@"%d",[sender.memeberLabel.text integerValue] + 1];
            }
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:self];
    }];
    
}


@end
