//
//  FBCircleCommentModel.h
//  FBCircle
//
//  Created by soulnear on 14-5-21.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

typedef void(^FBCircleCommentModelCompletionBlock)(NSMutableArray * array);

typedef void(^FBCircleCommentModelFailedBlock)(AFHTTPRequestOperation * opration);

@interface FBCircleCommentModel : NSObject
{
    FBCircleCommentModelCompletionBlock fbCircleCommentModelCompletionBlock;
    
    FBCircleCommentModelFailedBlock fbCircleCommentModelFailedBlock;
    
}

@property(nonatomic,strong)NSString * comment_uid;
@property(nonatomic,strong)NSString * comment_username;
@property(nonatomic,strong)NSString * comment_content;
@property(nonatomic,strong)NSString * comment_dateline;
@property(nonatomic,strong)NSString * comment_face;
@property(nonatomic,strong)NSString * comment_tid;


@property(nonatomic,strong)NSMutableArray * data_array;

@property(nonatomic,strong)AFHTTPRequestOperation * requestOperation;


-(FBCircleCommentModel *)initWithDictionary:(NSDictionary *)dic;


-(void)loadCommentsWithTid:(NSString *)theTid Page:(int)page WithCommentBlock:(FBCircleCommentModelCompletionBlock)completionBlock WithFailedBlock:(FBCircleCommentModelFailedBlock)failedBlock;



@end












