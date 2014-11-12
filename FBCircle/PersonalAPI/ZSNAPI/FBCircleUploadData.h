//
//  FBCircleUploadData.h
//  FBCircle
//
//  Created by soulnear on 14-6-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//
/*
 **后台上传类
 */

#import <Foundation/Foundation.h>
#import "FBCircleModel.h"
#import "ASIFormDataRequest.h"
#import <AssetsLibrary/AssetsLibrary.h>



@interface FBCircleUploadData : NSObject
{
    NSOperationQueue *queue;
}


@property(nonatomic,strong)FBCircleModel * myModel;


-(void)upload;




//发表单条说说

-(void)uploadBlogWith:(FBCircleModel *)model;


//上传banner跟face
-(void)uploadBannerAndFace;

#pragma mark - 取消所有请求

-(void)cancelAllRequest;


@end
