//
//  GMAPI.m
//  FBCircle
//
//  Created by gaomeng on 14-8-25.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GMAPI.h"

#import "RTLabel.h"

@implementation GMAPI
+(NSString *)exchangeStringForDeleteNULL:(id)sender
{
    NSString * temp = [NSString stringWithFormat:@"%@",sender];
    
    if (temp.length == 0 || [temp isEqualToString:@"<null>"] || [temp isEqualToString:@"null"] || [temp isEqualToString:@"(null)"])
    {
        temp = @"暂无";
    }
    
    return temp;
}



+(NSString *)exchangeStringForDeleteNULLWithWeiTianXie:(id)sender{
    NSString * temp = [NSString stringWithFormat:@"%@",sender];
    
    if (temp.length == 0 || [temp isEqualToString:@"<null>"] || [temp isEqualToString:@"null"] || [temp isEqualToString:@"(null)"])
    {
        temp = @"未填写";
    }
    
    return temp;
}


+(NSString *)exchangeStringForYuanwenDelete:(RTLabel*)sender contentText:(NSString *)neirong
{
    NSString * temp = [NSString stringWithFormat:@"%@",neirong];
    
    if (temp.length == 0 || [temp isEqualToString:@"<null>"] || [temp isEqualToString:@"null"] || [temp isEqualToString:@"(null)"])
    {
        temp = @"原文已删除";
        sender.textColor = [UIColor grayColor];
    }
    
    return temp;
}


@end
