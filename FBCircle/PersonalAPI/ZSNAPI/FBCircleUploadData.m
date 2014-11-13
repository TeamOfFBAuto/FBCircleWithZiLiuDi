//
//  FBCircleUploadData.m
//  FBCircle
//
//  Created by soulnear on 14-6-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBCircleUploadData.h"

@implementation FBCircleUploadData


//本地相册图片地址转换为图片


-(NSMutableArray *)exchangeLocationImageWith:(NSString *)imageUrl
{
    NSMutableArray * allImageArray = [NSMutableArray array];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    NSArray * image_array = [imageUrl componentsSeparatedByString:@"||"];
    
    for (int i = 0;i < image_array.count;i++)
    {
        NSString *imgurl=[NSString stringWithFormat:@"%@",[image_array objectAtIndex:i]];
        
        NSURL *referenceURL = [NSURL URLWithString:imgurl];
        
        __block UIImage *returnValue = nil;
        [library assetForURL:referenceURL resultBlock:^(ALAsset *asset)
         {
             
             //returnValue = [UIImage imageWithCGImage:[asset thumbnail]]; //Retain Added
             ALAssetRepresentation *assetRep = [asset defaultRepresentation];
             
             CGImageRef imgRef = [assetRep fullScreenImage];
             
             returnValue=[UIImage imageWithCGImage:imgRef
                                             scale:assetRep.scale
                                       orientation:(UIImageOrientation)assetRep.orientation];
             [allImageArray addObject:returnValue];
             
             if (i == image_array.count -1) {
                 
             }
             
         } failureBlock:^(NSError *error)
         {
             // error handling
         }];
    }
    
    return allImageArray;
}


-(void)upload
{
    queue = [NSOperationQueue new];
    
    queue.maxConcurrentOperationCount = 1;
    
    //查找未发送微博
    NSMutableArray * blog_array = [FBCircleModel findWaitingUploadBlogAll];
    
    if (blog_array.count == 0)
    {
        NSString * path = [ZSNApi docImagePath];
        
        NSLog(@"path ----   %@",path);
        
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
    //将未发送微博添加到队列
    for (int i = 0;i < blog_array.count;i++)
    {
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                            initWithTarget:self
                                            selector:@selector(doWork:)
                                            object:[blog_array objectAtIndex:i]];
        [queue addOperation:operation];
    }
    
    
    
    //查找未发送赞并添加到队列
    NSMutableArray * praise_array = [FBCircleModel findAllWaitingUploadPraise];
    
    
    for (int i = 0;i < praise_array.count;i++)
    {
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                            initWithTarget:self
                                            selector:@selector(uploadPraise:)
                                            object:[praise_array objectAtIndex:i]];
        [queue addOperation:operation];
    }
    
    //查找未发送评论并添加到队列
    NSMutableArray * comments_array = [FBCircleModel findAllWaitingUploadComments];
    
    for (int i = 0;i < comments_array.count;i++)
    {
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                            initWithTarget:self
                                            selector:@selector(uploadComments:)
                                            object:[comments_array objectAtIndex:i]];
        [queue addOperation:operation];
    }
    
    //查找未发送转发并添加到队列
    NSMutableArray * forwards_array = [FBCircleModel findAllWaitingUploadForward];
    
    for (int i = 0;i < forwards_array.count;i++)
    {
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                            initWithTarget:self
                                            selector:@selector(uploadForwards:)
                                            object:[forwards_array objectAtIndex:i]];
        [queue addOperation:operation];
    }
    
    
    //查找未发送删除并添加到队列
    NSMutableArray * delete_array = [FBCircleModel findAllWaitingUploadDelete];
    
    for (int i = 0;i < delete_array.count;i++)
    {
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                            initWithTarget:self
                                            selector:@selector(uploadDelete:)
                                            object:[delete_array objectAtIndex:i]];
        [queue addOperation:operation];
    }
    
}


-(void)uploadDelete:(id)data
{
    FBCirclePraiseModel * model = (FBCirclePraiseModel *)data;
    
    NSString * fullUrl = [NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=topicdel&authkey=%@&tid=%@&fbtype=json",[SzkAPI getAuthkey],model.praise_tid];
    
    NSLog(@"删除微博url-----  %@",fullUrl);
    
    NSURLRequest * urlRequest = [[NSURLRequest alloc]  initWithURL:[NSURL URLWithString:fullUrl]];
    
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    
    
    __block AFHTTPRequestOperation * request = operation;
    
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         @try {
             NSDictionary * allDic = [operation.responseString objectFromJSONString];
             
             if ([[allDic objectForKey:@"errcode"] intValue] == 0)
             {
                 NSLog(@"删除微博成功");
                 
                 [FBCircleModel deleteDeleteByDateLine:model.praise_dateline];
                 
                 [FBCircleModel updateRfbTidid:model.praise_tid WithTid:@""];
                 
             }else
             {
                 NSLog(@"删除微博失败-----%@",[allDic objectForKey:@"errinfo"]);
             }
         }
         @catch (NSException *exception) {
             
         }
         @finally {
             
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];
    
    
    [operation start];
}


-(void)uploadForwards:(id)data
{
    FBCircleCommentModel * model = (FBCircleCommentModel *)data;
    
    
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_FORWARD]];
    [request setPostValue:[model.comment_content stringByReplacingEmojiUnicodeWithCheatCodes] forKey:@"content"];
    [request setPostValue:[SzkAPI getAuthkey] forKey:@"authkey"];
    [request setPostValue:model.comment_tid forKey:@"tid"];
    [request setPostValue:model.comment_uid forKey:@"touid"];
    
    __weak typeof(request)arequest = request;
    [request setCompletionBlock:^{
        NSDictionary * allDic = [arequest.responseString objectFromJSONString];
        if ([[allDic objectForKey:@"errcode"] intValue] == 0) {
            
            NSLog(@"转发成功");
            [FBCircleModel deleteForwardByDateLine:model.comment_dateline];
        }else
        {
            NSLog(@"转发失败 ---  %@",[allDic objectForKey:@"errinfo"]);
            
            [FBCircleModel deleteForwardByDateLine:model.comment_dateline];
        }

    }];
    
    [request setFailedBlock:^{
        
    }];
    
    [request startAsynchronous];
    
    
    
    /*
    
    NSString * fullUrl = [NSString stringWithFormat:FBCIRCLE_FORWARD_URL,[SzkAPI getAuthkey],model.comment_tid,model.comment_uid,[[model.comment_content stringByReplacingEmojiUnicodeWithCheatCodes] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"转发文章-------%@",fullUrl);
    
    NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:fullUrl]];
    
    AFHTTPRequestOperation * requestOpration = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    
    __block AFHTTPRequestOperation * request = requestOpration;
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * allDic = [operation.responseString objectFromJSONString];
         
         if ([[allDic objectForKey:@"errcode"] intValue] == 0) {
             
             NSLog(@"转发成功");
             
             [FBCircleModel deleteForwardByDateLine:model.comment_dateline];
             
         }else
         {
             NSLog(@"转发失败 ---  %@",[allDic objectForKey:@"errinfo"]);
             
             [FBCircleModel deleteForwardByDateLine:model.comment_dateline];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"转发失败");
     }];
    
    [requestOpration start];
     
     */
    
}



-(void)uploadComments:(id)data
{
    FBCircleCommentModel * model = (FBCircleCommentModel *)data;
    
    
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_REPLY]];
    [request setPostValue:[model.comment_content stringByReplacingEmojiUnicodeWithCheatCodes] forKey:@"content"];
    [request setPostValue:[SzkAPI getAuthkey] forKey:@"authkey"];
    [request setPostValue:model.comment_tid forKey:@"forwardtid"];
    
    __weak typeof(request)arequest = request;
    [request setCompletionBlock:^{
        NSDictionary * allDic = [arequest.responseString objectFromJSONString];
        
        if ([[allDic objectForKey:@"errcode"] intValue] == 0)
        {
            NSLog(@"发表评论成功");
            
            [FBCircleModel deleteCommentsByDateLine:model.comment_dateline];
            
        }else
        {
            
            NSLog(@"发表评论失败 ----  %@",[allDic objectForKey:@"errinfo"]);
        }
        
    }];
    
    [request setFailedBlock:^{
        NSLog(@"发表评论失败");
    }];
    
    [request startAsynchronous];
    
    
    /*
    NSString * fullUrl = [NSString stringWithFormat:FBCIRCLE_COMMENT_URL,[SzkAPI getAuthkey],model.comment_tid,model.comment_uid,[[model.comment_content stringByReplacingEmojiUnicodeWithCheatCodes] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"发表评论接口 ----   %@",fullUrl);
    
    NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:fullUrl]];
    
    AFHTTPRequestOperation * requestOpration = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    
    __block AFHTTPRequestOperation * request = requestOpration;
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * allDic = [operation.responseString objectFromJSONString];
         
         if ([[allDic objectForKey:@"errcode"] intValue] == 0)
         {
             NSLog(@"发表评论成功");
             
             [FBCircleModel deleteCommentsByDateLine:model.comment_dateline];
             
         }else
         {
             
             NSLog(@"发表评论失败 ----  %@",[allDic objectForKey:@"errinfo"]);
             
             //             [model.fb_comment_array removeObject:commentModel];
             //
             //             [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:history_selected_menu_page inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"发表评论失败");
         
     }];
    
    [requestOpration start];
    
    */
    
}




-(void)uploadPraise:(id)data
{
    FBCirclePraiseModel * model = (FBCirclePraiseModel *)data;
    
    NSString * fullUrl = [NSString stringWithFormat:FBCIRCLE_PRAISE_URL,[SzkAPI getAuthkey],model.praise_tid];
    
    NSURLRequest * UrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]];
    
    NSLog(@"赞接口----%@",fullUrl);
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:UrlRequest];
    
    __block AFHTTPRequestOperation * request = operation;
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * allDic = [operation.responseString objectFromJSONString];
         
         if ([[allDic objectForKey:@"errcode"] intValue] == 0)
         {
             NSLog(@"发送赞成功");
             
             [FBCircleModel deletePraiseByDateLine:model.praise_dateline];
         }else
         {
             NSLog(@"发送失败----%@",[allDic objectForKey:@"errinfo"]);
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];
    
    [operation start];
}



-(void)doWork:(id)data
{
    
    FBCircleModel * model = (FBCircleModel *)data;
    
    if (model.fb_imageid.length > 0)
    {
        NSMutableArray * allImageArray = [NSMutableArray array];
        
        NSArray * image_array = [model.fb_imageid componentsSeparatedByString:@"||"];
        
        NSString * path = [ZSNApi docImagePath];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            for (int i = 0;i<image_array.count;i++)
            {
                NSString *imgurl=[NSString stringWithFormat:@"%@",[image_array objectAtIndex:i]];
                
                NSString *filePath2 = [path stringByAppendingPathComponent:imgurl];
                
                UIImage *image = [UIImage imageWithContentsOfFile:filePath2];
                if (image)
                {
                    [allImageArray addObject:image];
                }                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                model.fb_image = allImageArray;
                
                [self uploadBlogWith:model];
            });
        });
        
    }else
    {
        [self uploadBlogWith:model];
    }
}


-(void)uploadBlogWith:(FBCircleModel *)model
{
    _myModel = model;
    
    if (model.fb_image.count) {
        [self zkingupdataImagesWith:model.fb_image WithModel:model];
    }else
    {
        NSString * fullUrl = @"";
        
        if (model.fb_area.length > 0)
        {
            fullUrl = [NSString stringWithFormat:PUBLISH_TEXT_LOCATION,model.fb_authkey,[[model.fb_content stringByReplacingEmojiUnicodeWithCheatCodes] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[model.fb_lng floatValue],[model.fb_lat floatValue],[model.fb_area stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }else
        {
            fullUrl = [NSString stringWithFormat:PUBLISH_TEXT,model.fb_authkey,[[model.fb_content stringByReplacingEmojiUnicodeWithCheatCodes] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [self sendBlogWithUrl:fullUrl With:model WithImages:@"" WithLng:model.fb_lng WithLat:model.fb_lat WithArea:model.fb_area];
    }
}


#pragma mark--请求图片
//上传图片
#define TT_CACHE_EXPIRATION_AGE_NEVER     (1.0 / 0.0)   // inf
- (void)zkingupdataImagesWith:(NSMutableArray *)_allImageArray WithModel:(FBCircleModel *)model
{
    
    NSString* fullURL = [NSString stringWithFormat:URLIMAGE,model.fb_authkey];
    
    NSLog(@"上传图片的url  ——--  %@",fullURL);
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:fullURL]];
    //    request.delegate = self;
    request.tag = 1;
    
    [request setRequestMethod:@"POST"];
    request.timeOutSeconds = 30;
    request.cachePolicy = TT_CACHE_EXPIRATION_AGE_NEVER;
    request.cacheStoragePolicy = ASICacheForSessionDurationCacheStoragePolicy;
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    NSLog(@"imagearray -----  %@",_allImageArray);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        //得到图片的data
        NSData* data;
        //获取图片质量
        //  NSString *tupianzhiliang=[[NSUserDefaults standardUserDefaults] objectForKey:TUPIANZHILIANG];
        
        NSMutableData *myRequestData=[NSMutableData data];
        
        for (int i = 0;i < _allImageArray.count; i++)
        {
            UIImage *image=[_allImageArray objectAtIndex:i];
            data = UIImageJPEGRepresentation(image,0.5);
            [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [myRequestData length]]];
            //设置http body
            [request addData:data withFileName:[NSString stringWithFormat:@"boris[%d].png",i] andContentType:@"image/PNG" forKey:@"topic[]"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            
            [request startAsynchronous];
        });
    });
    
    
    
    __block ASIHTTPRequest * finishedRequest = request;
    
    [finishedRequest setCompletionBlock:^{
        
        @try {
            __weak typeof(self) bself=self;
            
            NSDictionary * allDic = [request.responseString objectFromJSONString];
            
            NSLog(@"allDic ----   %@",[allDic objectForKey:@"data"]);
            
            if ([[allDic objectForKey:@"errcode"] intValue] == 0) {
                
                NSDictionary * dictionary = [allDic objectForKey:DATA];
                NSArray * array2 = [dictionary allKeys];
                NSArray *array = [array2 sortedArrayUsingSelector:@selector(compare:)];
                [bself sendBlogWithArray:array WithModel:model];
                
            }else
            {
                [bself sendErrorWith:[allDic objectForKey:@"data"]];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }];
    
    [finishedRequest setFailedBlock:^{
        int result = [FBCircleModel addWeiBoContentWithInfo:_myModel];
        
        NSLog(@"添加到数据库--%d",result);
    }];
}


-(void)sendBlogWithUrl:(NSString *)urlString With:(FBCircleModel *)model WithImages:(NSString *)authod WithLng:(NSString *)lng WithLat:(NSString *)lat WithArea:(NSString *)area
{
    NSLog(@"发送微博url ----  %@",urlString);
//    http://fb.fblife.com/openapi/index.php?mod=doweibo&code=add&content=%@&imgid=%@&fromtype=b5eeec0b&authkey=%@&jing_lng=%f&wei_lat=%f&locality=%@&map=google&fbtype=json
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:SEND_BLOG_URL]];
    [request setPostValue:[model.fb_content stringByReplacingEmojiUnicodeWithCheatCodes] forKey:@"content"];
    [request setPostValue:[SzkAPI getAuthkey] forKey:@"authkey"];
    [request setPostValue:authod forKey:@"imgid"];
    [request setPostValue:lng forKey:@"jing_lng"];
    [request setPostValue:lat forKey:@"wei_lat"];
    [request setPostValue:area forKey:@"locality"];
    
    __weak typeof(request)arequest = request;
    [request setCompletionBlock:^{
        NSLog(@"request -----  %@",[arequest.responseString objectFromJSONString]);
        
        model.fb_tid = @"111";
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:model,@"fbcirclemodel",nil];
        int delete_result = [FBCircleModel deleteBlogByDateLine:model.fb_deteline];
        NSLog(@"删除数据结果----%d",delete_result);
        [[NSNotificationCenter defaultCenter]postNotificationName:SUCCESSUPDATA object:model userInfo:dic];
        NSLog(@"发送成功");
    }];
    
    [request setFailedBlock:^{
        int result = [FBCircleModel addWeiBoContentWithInfo:model];
        NSLog(@"添加到数据库--%d==code====",result);
    }];
    
    [request startAsynchronous];
   

    /*
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
    __block AFHTTPRequestOperation * request = operation;
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * allDic = [operation.responseString objectFromJSONString];
         
         if ([[allDic objectForKey:@"errcode"] intValue] == 0)
         {
             model.fb_tid = @"111";
             
             NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:model,@"fbcirclemodel",nil];
             
             int delete_result = [FBCircleModel deleteBlogByDateLine:model.fb_deteline];
             
             NSLog(@"删除数据结果----%d",delete_result);
             
             [[NSNotificationCenter defaultCenter]postNotificationName:SUCCESSUPDATA object:model userInfo:dic];
             
             NSLog(@"发送成功");
             
         }else
         {
             NSLog(@"发送失败 ---  %@",[allDic objectForKey:@"errinfo"]);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         int result = [FBCircleModel addWeiBoContentWithInfo:model];
         
         NSLog(@"添加到数据库--%d==code====",result);
     }];
    
    [operation start];
     */
   
}



-(void)sendBlogWithArray:(NSArray *)array WithModel:(FBCircleModel *)model
{
    
    NSString* authod = @"";
    
    for (int i = 0;i < array.count;i++)
    {
        if (i == 0)
        {
            authod = [array objectAtIndex:i];
        }else
        {
            authod = [NSString stringWithFormat:@"%@|%@",authod,[array objectAtIndex:i]];
        }
    }
    
//    NSString * fullUrl = @"";
//    if (model.fb_area.length > 0)
//    {
//        fullUrl = [NSString stringWithFormat:PUBLISH_IMAGE_TEXT_LOCATION,model.fb_authkey,[[model.fb_content stringByReplacingEmojiUnicodeWithCheatCodes] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
//                   ,authod,[model.fb_lng floatValue],[model.fb_lat floatValue],[model.fb_area stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    }else
//    {
//        fullUrl = [NSString stringWithFormat:PUBLISH_IMAGE_TEXT,model.fb_authkey,[[model.fb_content stringByReplacingEmojiUnicodeWithCheatCodes] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[NSString stringWithFormat:@"%@",authod] stringByAddingPercentEscapesUsingEncoding:  NSUTF8StringEncoding]];
//        
//    }
    
//    NSLog(@"发表缓存微博接口 ----   %@",fullUrl);
    
    
    [self sendBlogWithUrl:@"" With:model WithImages:authod WithLng:model.fb_lng WithLat:model.fb_lat WithArea:model.fb_area];
}

//发送失败的提示框
-(void)sendErrorWith:(NSString *)error
{
    int result = [FBCircleModel addWeiBoContentWithInfo:_myModel];
    
    NSLog(@"添加到数据库----%d -- error ---  %@",result,error);
}


#pragma mark - 联网时上传未上传成功的banner face

-(void)uploadBannerAndFace
{
    //上传banner
    NSString *banner = [[NSUserDefaults standardUserDefaults]objectForKey:@"gIsUpBanner"];
    
    NSLog(@"%@",banner);
    
    if ([banner isEqualToString:@"yes"] && [GlocalUserImage getUserBannerImage]) {
        
        GupData *up =[[GupData alloc]init];
        
        [up upUserBanner];
        
    }
    
    
    //上传face
    NSString *touxiang = [[NSUserDefaults standardUserDefaults]objectForKey:@"gIsUpFace"];
    
    NSLog(@"%@",touxiang);
    
    if ([touxiang isEqualToString:@"yes"] && [GlocalUserImage getUserFaceImage]) {
        
        GupData *up =[[GupData alloc]init];
        
        [up upUserFace];
        
    }
}





#pragma mark-取消所有请求

-(void)cancelAllRequest
{
    [queue cancelAllOperations];
}



@end












