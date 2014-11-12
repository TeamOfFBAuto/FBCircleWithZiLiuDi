//
//  GMAPI.h
//  FBCircle
//
//  Created by gaomeng on 14-8-25.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RTLabel;

@interface GMAPI : NSObject

+(NSString *)exchangeStringForDeleteNULL:(id)sender;//暂无

+(NSString *)exchangeStringForDeleteNULLWithWeiTianXie:(id)sender;//未填写

+(NSString *)exchangeStringForYuanwenDelete:(RTLabel*)sender contentText:(NSString *)neirong;//原文已删除

@end
