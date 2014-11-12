//
//  GupData.h
//  FBCircle
//
//  Created by gaomeng on 14-6-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"

#import "ASIFormDataRequest.h"

@interface GupData : NSObject

{
    ASIFormDataRequest *_userFacerequest;//上传头像
    ASIFormDataRequest *_userBannerrequest;//上传banner
}

@property(nonatomic,strong)UIImage *userUpFaceImage;//头像
@property(nonatomic,strong)UIImage *userUpBanner;//banner





-(void)upUserFace;//上传用户头像

-(void)upUserBanner;//上传banner






@end
