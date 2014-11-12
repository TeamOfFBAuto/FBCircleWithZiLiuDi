//
//  FBCirclePraiseModel.h
//  FBCircle
//
//  Created by soulnear on 14-5-21.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBCirclePraiseModel : NSObject
{
    
}

@property(nonatomic,strong)NSString * praise_uid;
@property(nonatomic,strong)NSString * praise_username;
@property(nonatomic,strong)NSString * praise_image_url;
@property(nonatomic,strong)NSString * praise_dateline;
@property(nonatomic,strong)NSString * praise_tid;


-(FBCirclePraiseModel *)initWithDictionary:(NSDictionary *)dic;



@end
