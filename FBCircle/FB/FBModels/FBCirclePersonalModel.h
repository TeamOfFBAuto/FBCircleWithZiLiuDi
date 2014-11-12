//
//  FBCirclePersonalModel.h
//  FBCircle
//
//  Created by soulnear on 14-5-24.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//用户信息Model 具有网络请求功能

#import <Foundation/Foundation.h>

@class FBCirclePersonalModel;

typedef void(^FBCirclePersonalModelCompletionBlock)(FBCirclePersonalModel * model);

typedef void(^FBCirclePersonalModelFailedBlock)(NSString * string);


@interface FBCirclePersonalModel : NSObject
{
    FBCirclePersonalModelCompletionBlock personalModelCompletionBlock;
    
    FBCirclePersonalModelFailedBlock personalModelFailedBlock;
}


@property(nonatomic,strong)NSString * person_uid;
@property(nonatomic,strong)NSString * person_username;
@property(nonatomic,strong)NSString * person_password;
@property(nonatomic,strong)NSString * person_phone;
@property(nonatomic,strong)NSString * person_email;
@property(nonatomic,strong)NSString * person_province;
@property(nonatomic,strong)NSString * person_city;
@property(nonatomic,strong)NSString * person_face;
@property(nonatomic,strong)NSString * person_words;
@property(nonatomic,strong)NSString * person_buddynum;
@property(nonatomic,strong)NSString * person_topicnum;
@property(nonatomic,strong)NSString * person_imagenum;
@property(nonatomic,strong)NSString * person_frontpic;
@property(nonatomic,strong)NSString * person_token;
@property(nonatomic,strong)NSString * person_status;
@property(nonatomic,strong)NSString * person_uptime;
@property(nonatomic,strong)NSString * person_dateline;
@property(nonatomic,strong)NSString * person_gender;


-(FBCirclePersonalModel *)initWithDictionary:(NSDictionary *)dic;



-(void)loadPersonWithUid:(NSString *)theUid WithBlock:(FBCirclePersonalModelCompletionBlock)theBlock WithFailedBlcok:(FBCirclePersonalModelFailedBlock)FailedBlock;




@end









