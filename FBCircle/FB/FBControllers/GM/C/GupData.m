//
//  GupData.m
//  FBCircle
//
//  Created by gaomeng on 14-6-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GupData.h"

@implementation GupData


-(void)upUserFace{
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"gIsUpFace"];
    
    if ([str isEqualToString:@"yes"]) {
        
        [self test];
        
    }
    
    
}

-(void)upUserBanner{
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"gIsUpBanner"];
    
    if ([str isEqualToString:@"yes"]) {
        
        [self testbanner];
        
    }
    
}

//- (void)dealloc
//{
//    _userBannerrequest.delegate = nil;
//    _userFacerequest.delegate = nil;
//}





#pragma mark - 上传头像(图片)

#define TT_CACHE_EXPIRATION_AGE_NEVER     (1.0 / 0.0)
-(void)test{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        @try {
            NSString* fullURL = [NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=updatehead&authkey=%@",[SzkAPI getAuthkey]];
            NSString *str = @"yes";
            [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpFace"];
            NSLog(@"%s",__FUNCTION__);
            NSLog(@"上传头像请求的地址===%@",fullURL);
            
            _userFacerequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:fullURL]];
            AppDelegate *_appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
            
            
            _userFacerequest.delegate = _appDelegate;
            _userFacerequest.tag = 100;
            
            //得到图片的data
            NSData* data;
            //获取图片质量
            NSMutableData *myRequestData=[NSMutableData data];
            [_userFacerequest setPostFormat:ASIMultipartFormDataPostFormat];
            
            UIImage *userUpFace = [GlocalUserImage getUserFaceImage];
            
            data = UIImageJPEGRepresentation(userUpFace,0.5);
            NSLog(@"在此上传头像或banner%s",__FUNCTION__);
            [_userFacerequest addRequestHeader:@"uphead" value:[NSString stringWithFormat:@"%d", [myRequestData length]]];
            //设置http body
            [_userFacerequest addData:data withFileName:[NSString stringWithFormat:@"boris.png"] andContentType:@"image/PNG" forKey:[NSString stringWithFormat:@"uphead"]];
            
            [_userFacerequest setRequestMethod:@"POST"];
            _userFacerequest.cachePolicy = TT_CACHE_EXPIRATION_AGE_NEVER;
            _userFacerequest.cacheStoragePolicy = ASICacheForSessionDurationCacheStoragePolicy;
            [_userFacerequest startAsynchronous];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    });
    
    
}


//-(void)requestFinished:(ASIHTTPRequest *)request
//{
//    NSLog(@"上传完成");
//    
//    @try {
//        if (request.tag == 100)//上传头像
//        {
//            NSLog(@"走了555");
//            NSDictionary * dic = [[NSDictionary alloc] initWithDictionary:[request.responseData objectFromJSONData]];
//            
//            NSLog(@"tupiandic==%@",dic);
//            
//            if ([[dic objectForKey:@"errcode"] isEqualToString:@"0"]) {
//                
//                NSString *str = @"no";
//                [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpFace"];
//                
//            }else{
//                NSString *str = @"yes";
//                [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpFace"];
//            }
//            
//            
//        }else if(request.tag == 101){//上传banner
//            NSLog(@"走了555");
//            NSDictionary * dic = [[NSDictionary alloc] initWithDictionary:[request.responseData objectFromJSONData]];
//            
//            NSLog(@"tupiandic==%@",dic);
//            
//            if ([[dic objectForKey:@"errcode"] isEqualToString:@"0"]) {
//                NSLog(@"上传成功");
//                NSString *str = @"no";
//                [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"gIsUpBanner"];
//            }else{
//                NSString *str = @"yes";
//                [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpFace"];
//                
//            }
//        }
//    }
//    @catch (NSException *exception) {
//        
//    }
//    @finally {
//        
//    }
//    
//    
//}




//上传bannr

#define TT_CACHE_EXPIRATION_AGE_NEVER     (1.0 / 0.0)
-(void)testbanner{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        @try {
            
            NSString* fullURL = [NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=updateuserinfo&optype=front&authkey=%@",[SzkAPI getAuthkey]];
            
            NSString *str = @"yes";
            [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpBanner"];
            
            NSLog(@"%s",__FUNCTION__);
            NSLog(@"上传banner请求的地址===%@",fullURL);
            
            _userBannerrequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:fullURL]];
            
            AppDelegate *_appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
            
            
            _userBannerrequest.delegate = _appDelegate;
            _userBannerrequest.tag = 101;
            
            UIImage *userUpimage = [GlocalUserImage getUserBannerImage];
            
            NSData *data = UIImageJPEGRepresentation(userUpimage,0.5);
            
            [_userBannerrequest addRequestHeader:@"frontpic" value:[NSString stringWithFormat:@"%d", [data length]]];
            
            
            //设置http body
            [_userBannerrequest addData:data withFileName:[NSString stringWithFormat:@"boris.png"] andContentType:@"image/PNG" forKey:[NSString stringWithFormat:@"frontpic"]];
            
            [_userBannerrequest setRequestMethod:@"POST"];
            _userBannerrequest.cachePolicy = TT_CACHE_EXPIRATION_AGE_NEVER;
            _userBannerrequest.cacheStoragePolicy = ASICacheForSessionDurationCacheStoragePolicy;
            [_userBannerrequest startAsynchronous];
            
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    });
    
    
}











@end
