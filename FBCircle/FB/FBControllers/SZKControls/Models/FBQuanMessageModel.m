//
//  MessageModel.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-23.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBQuanMessageModel.h"

@implementation FBQuanMessageModel
/**
 *  id: "4",
 fromuid: "362516",
 fromuname: "myown",
 fromtid: "12",
 touid: "355696",
 totid: "1",
 optype: "1",
 status: "0",
 dateline: "1400818386",
 fromuface: "http://bbs.fblife.com/ucenter/avatar.php?uid=362516&type=virtual&size=small",
 recontent: "sdfsfsfsfsfss",
 maincontent: "sdfsfsfdfs"
 },
 */

-(void)setDic:(NSDictionary *)dicinfo{
    
    _detailid=[NSString stringWithFormat:@"%@",[dicinfo objectForKey:@"id"]];
    
    _fromuid=[NSString stringWithFormat:@"%@",[dicinfo objectForKey:@"fromuid"]];
    
    _fromuname=[NSString stringWithFormat:@"%@",[dicinfo objectForKey:@"fromuname"]];
    
    _fromtid=[NSString stringWithFormat:@"%@",[dicinfo objectForKey:@"fromtid"]];
    
    _touid=[NSString stringWithFormat:@"%@",[dicinfo objectForKey:@"touid"]];
    
    _optype=[NSString stringWithFormat:@"%@",[dicinfo objectForKey:@"optype"]];
    
    _status=[NSString stringWithFormat:@"%@",[dicinfo objectForKey:@"status"]];
    
    _dateline=[NSString stringWithFormat:@"%@",[dicinfo objectForKey:@"dateline"]];
    
    _fromuface=[NSString stringWithFormat:@"%@",[dicinfo objectForKey:@"fromuface"]];
    
    _recontent=[NSString stringWithFormat:@"%@",[dicinfo objectForKey:@"recontent"]];
    
    _maincontent=[NSString stringWithFormat:@"%@",[dicinfo objectForKey:@"maincontent"]];
    
    _totid = [NSString stringWithFormat:@"%@",[dicinfo objectForKey:@"totid"]];
    
    _frontimg = [NSString stringWithFormat:@"%@",[dicinfo objectForKey:@"frontimg"]];
    
    
}


@end
