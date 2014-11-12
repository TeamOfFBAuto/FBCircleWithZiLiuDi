//
//  FBCirclePraiseModel.m
//  FBCircle
//
//  Created by soulnear on 14-5-21.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBCirclePraiseModel.h"

@implementation FBCirclePraiseModel
@synthesize praise_uid = _praise_uid;
@synthesize praise_username = _praise_username;
@synthesize praise_image_url = _praise_image_url;
@synthesize praise_dateline = _praise_dateline;
@synthesize praise_tid = _praise_tid;



-(FBCirclePraiseModel *)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    
    if (self) {
        
        self.praise_uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
        
        self.praise_username = [NSString stringWithFormat:@"%@",[dic objectForKey:@"username"]];
        //张少南  图片字段是什么
        self.praise_image_url = [NSString stringWithFormat:@"%@",[dic objectForKey:@"face"]];
    }
    
    return self;
}


@end
