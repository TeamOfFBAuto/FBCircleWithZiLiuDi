//
//  FBCircleModel.m
//  FBCircle
//
//  Created by soulnear on 14-5-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBCircleModel.h"
#import "BlogFeed.h"
#import "PhotoFeed.h"
#import "Extension.h"
#import "FbNewsFeed.h"
#import "RTLabel.h"

@implementation FBCircleModel
@synthesize fb_content       = _fb_content;
@synthesize fb_deteline      = _fb_deteline;
@synthesize fb_forward_num   = _fb_forward_num;
@synthesize fb_image         = _fb_image;
@synthesize fb_imageid       = _fb_imageid;
@synthesize fb_ip            = _fb_ip;
@synthesize fb_lat           = _fb_lat;
@synthesize fb_lng           = _fb_lng;
@synthesize fb_area          = _fb_area;
@synthesize fb_reply_num     = _fb_reply_num;
@synthesize fb_replyid       = _fb_replyid;
@synthesize fb_rootid        = _fb_rootid;
@synthesize fb_status        = _fb_status;
@synthesize fb_tid           = _fb_tid;
@synthesize fb_topic_type    = _fb_topic_type;
@synthesize fb_uid           = _fb_uid;
@synthesize fb_username      = _fb_username;
@synthesize fb_zan_num       = _fb_zan_num;
@synthesize fb_face          = _fb_face;
@synthesize fb_sort          = _fb_sort;



//转发

@synthesize rfb_model         = _rfb_model;
@synthesize rfb_content       = _rfb_content;
@synthesize rfb_deteline      = _rfb_deteline;
@synthesize rfb_forward_num   = _rfb_forward_num;
@synthesize rfb_image         = _rfb_image;
@synthesize rfb_imageid       = _rfb_imageid;
@synthesize rfb_ip            = _rfb_ip;
@synthesize rfb_lat           = _rfb_lat;
@synthesize rfb_lng           = _rfb_lng;
@synthesize rfb_area          = _rfb_area;
@synthesize rfb_reply_num     = _rfb_reply_num;
@synthesize rfb_replyid       = _rfb_replyid;
@synthesize rfb_rootid        = _rfb_rootid;
@synthesize rfb_status        = _rfb_status;
@synthesize rfb_tid           = _rfb_tid;
@synthesize rfb_topic_type    = _rfb_topic_type;
@synthesize rfb_uid           = _rfb_uid;
@synthesize rfb_username      = _rfb_username;
@synthesize rfb_zan_num       = _rfb_zan_num;
@synthesize rfb_face          = _rfb_face;
@synthesize rfb_sort          = _rfb_sort;


@synthesize fb_authkey        = _fb_authkey;

@synthesize fb_comment_array = _fb_comment_array;
@synthesize fb_praise_array = _fb_praise_array;

@synthesize rfb_comment_array = _rfb_comment_array;
@synthesize rfb_praise_array = _rfb_praise_array;


@synthesize data_array = _data_array;
@synthesize isShowMenuView = _isShowMenuView;


//返回图片地址

+(NSMutableArray *)returnImageUrlWith:(NSString *)fb_images
{
    NSArray * image_array = [fb_images componentsSeparatedByString:@"||"];
    
    NSMutableArray * images = [NSMutableArray array];
    
    for (NSString * image_string in image_array)
    {
        NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
        
        if (image_string.length > 0)
        {
            [dictionary setObject:image_string forKey:@"link"];
            
            [images addObject:dictionary];
        }
        
        
    }
    
    return images;
}


-(FBCircleModel *)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.fb_tid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tid"]];
        self.fb_uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
        self.fb_username = [NSString stringWithFormat:@"%@",[dic objectForKey:@"username"]];
        self.fb_content = [ZSNApi cleanHTMLWithString:[ZSNApi ddecodeSpecialCharactersStringWith:[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]]]];
        
        self.fb_imageid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"imageid"]];
        if ([self.fb_imageid isEqualToString:@"<null>"] || [self.fb_imageid isEqual:[NSNull null]])
        {
            self.fb_imageid = @"";
        }
        
        if ([[dic objectForKey:FB_IMAGEID] isEqualToString:@"0"]) {
            self.fb_image = [NSMutableArray array];
        }else
        {
            NSString * image_string = [dic objectForKey:@"image_small_m"];
            self.fb_image = [NSMutableArray arrayWithArray:[image_string componentsSeparatedByString:@"|"]];
        }
        self.fb_lng = [NSString stringWithFormat:@"%@",[dic objectForKey:@"jing_lng"]];
        self.fb_lat = [NSString stringWithFormat:@"%@",[dic objectForKey:@"wei_lat"]];
        self.fb_deteline = [NSString stringWithFormat:@"%@",[dic objectForKey:@"dateline"]];
        self.fb_reply_num = [NSString stringWithFormat:@"%@",[dic objectForKey:@"replys"]];
        self.fb_area = [NSString stringWithFormat:@"%@",[dic objectForKey:@"locality"]];
        self.fb_face = [NSString stringWithFormat:@"%@",[dic objectForKey:@"face_small"]];
        self.fb_sort = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sort"]];
        
        
                
        self.fb_topic_type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"topic_type"]];
        self.fb_zan_num = [NSString stringWithFormat:@"%@",[dic objectForKey:@"zan_num"]];
        self.fb_forward_num = [NSString stringWithFormat:@"%@",[dic objectForKey:@"forward_num"]];
        self.fb_replyid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"replyid"]];
        self.fb_rootid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"rootid"]];
        self.fb_ip = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ip"]];
        self.fb_status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
        
        
        
        if ([self.fb_sort isEqualToString:@"1"])
        {
            self.fb_topic_type = @"1";
            
            FBCircleExtension * extension = [[FBCircleExtension alloc] initWithDictionary:[[dic objectForKey:@"extension"] objectFromJSONString]];
            self.rfb_username = extension.extentsion_title;
            self.rfb_content = [ZSNApi decodeSpecialCharactersString:extension.extentsion_content];
            self.rfb_face = extension.extentsion_image;
            self.rfb_zan_num  = extension.extentsion_link;
        }
        
       
        if ([self.fb_sort isEqualToString:@"0"])
        {
            self.fb_topic_type = @"0";
            if (![[dic objectForKey:@"roottid"] isEqualToString:@"0"]) {
                self.fb_topic_type = @"2";
            }
        }else
        {
            self.rfb_sort = self.fb_sort;
            
            if([self.fb_sort isEqualToString:@"3"]&&[[dic objectForKey:@"type"] isEqualToString:@"first"])
            {
                //解析图集
                NSDictionary *photojson= [[dic objectForKey:FB_CONTENT] objectFromJSONString];
                PhotoFeed * photo=[[PhotoFeed alloc]initWithJson:photojson];
                
                self.rfb_username = photo.title;
                self.rfb_content = [ZSNApi decodeSpecialCharactersString:photo.title];
                NSArray * image_array = [photo.image_string componentsSeparatedByString:@"|"];
                if (image_array.count > 0) {
                    self.rfb_face = [image_array objectAtIndex:0];
                }else
                {
                    self.rfb_face = @"";
                }
                
                self.rfb_zan_num  = [NSString stringWithFormat:@"http://special.fblife.com/showphoto/%@.html",photo.aid];
                
            }else if([self.fb_sort isEqualToString:@"2"]&&[[dic objectForKey:@"type"] isEqualToString:@"first"])
            {
                //解析文集
                NSDictionary *blogjson= [[dic objectForKey:FB_CONTENT] objectFromJSONString];
                
                BlogFeed * blog=[[BlogFeed alloc]initWithJson:blogjson];
                
                self.rfb_username = blog.title;
                self.rfb_content = blog.content;
                self.rfb_face = blog.photo;
                self.rfb_zan_num  = [NSString stringWithFormat:@"http://www.fb.cn/blog/view/%@",blog.blogid];
                
            }else if([self.fb_sort isEqualToString:@"4"]&&[[dic objectForKey:@"type"] isEqualToString:@"first"])
            {
                //论坛帖子转发为微博
                NSDictionary * newsForwoadjson= [[dic objectForKey:FB_CONTENT] objectFromJSONString];
                FbNewsFeed * fbnews= [[FbNewsFeed alloc] initWithJson:newsForwoadjson];
                
                self.fb_content = @"";
                self.rfb_username = fbnews.title;
                self.rfb_content = fbnews.content;
                self.rfb_face = fbnews.photo;
                self.rfb_zan_num  = [NSString stringWithFormat:@"http://bbs.fblife.com/thread_%@.html",fbnews.bbsid];
            }else if([self.fb_sort isEqualToString:@"5"]&&[[dic objectForKey:@"type"] isEqualToString:@"first"])
            {
                //论坛分享
                NSDictionary *newsSendjson= [[dic objectForKey:FB_EXTENSION] objectFromJSONString];
                
                Extension * ex=[[Extension alloc] initWithJson:newsSendjson];
                
                self.rfb_username = ex.title;
                self.rfb_content = ex.forum_content;
                self.rfb_face = ex.photo;
                self.rfb_zan_num  = [NSString stringWithFormat:@"http://bbs.fblife.com/thread_%@.html",ex.authorid];
                
                
            }else if (([self.fb_sort isEqualToString:@"8"] || [self.fb_sort isEqualToString:@"7"] || [self.fb_sort isEqualToString:@"6"])&&[[dic objectForKey:@"type"] isEqualToString:@"first"])
            {
                ///新闻
                NSDictionary *exjson= [[dic objectForKey:FB_EXTENSION] objectFromJSONString];
                Extension * ex=[[Extension alloc]initWithJson:exjson];
                
                self.rfb_username = ex.title;
                self.rfb_content = ex.forum_content;
                self.rfb_face = ex.photo;
                self.rfb_zan_num  = [NSString stringWithFormat:@"http://cmsweb.fblife.com/web.php?c=listnews&a=jump&id=%@",[dic objectForKey:@"sortid"]];
            }else if([self.fb_sort isEqualToString:@"10"]&&[[dic objectForKey:@"type"] isEqualToString:@"first"])
            {
                //资源分享
                NSDictionary *newsSendjson= [[dic objectForKey:FB_EXTENSION] objectFromJSONString];
                
                Extension * ex=[[Extension alloc] initWithJson:newsSendjson];
                
                self.rfb_username = ex.title;
                self.rfb_content = ex.forum_content;
                self.rfb_face = ex.photoFlg?[NSString stringWithFormat:@"http://fb.cn%@",ex.photo]:@"";
                self.rfb_zan_num  = [NSString stringWithFormat:@"http://bbs.fblife.com/thread_%@.html",ex.authorid];
                ///张少南，这里缺少资源分享的链接地址
                
            }else if (([self.fb_sort isEqualToString:@"9"]&&[[dic objectForKey:@"type"] isEqualToString:@"first"]))
            {
                //商城分享
                NSDictionary *newsSendjson= [[dic objectForKey:FB_EXTENSION] objectFromJSONString];
                
                Extension * ex=[[Extension alloc] initWithJson:newsSendjson];
                
                self.rfb_username = ex.title;
                self.rfb_content = ex.forum_content;
                self.rfb_face = ex.photoFlg?[NSString stringWithFormat:@"http://fb.cn%@",ex.photo]:@"";
                self.rfb_zan_num  = [NSString stringWithFormat:@"http://bbs.fblife.com/thread_%@.html",ex.authorid];
                //张少南，这里缺少商城的链接地址
            }else if ([self.fb_sort isEqualToString:@"15"]&&[[dic objectForKey:@"type"] isEqualToString:@"first"])
            {
                NSDictionary * atlas_dic = [[dic objectForKey:FB_EXTENSION] objectFromJSONString];
                
                NSString * title = [zsnApi exchangeStringForDeleteNULL:[atlas_dic objectForKey:@"title"]];
                NSString * photo = [zsnApi exchangeStringForDeleteNULL:[atlas_dic objectForKey:@"photo"]];
                NSString * intro = [zsnApi exchangeStringForDeleteNULL:[atlas_dic objectForKey:@"intro"]];
                
                
                self.rfb_username = title;
                self.rfb_content = intro;
                self.rfb_face = @"";
                self.rfb_zan_num  = [NSString stringWithFormat:@"http://special.fblife.com/showphoto/%@.html",[dic objectForKey:@"sortid"]];
                //张少南，这里缺少我也不知道是什么的链接地址，跳转方向不明确
                
                if (photo.length > 0)
                {
                    self.rfb_face = photo;
                }
            }
            
            self.fb_sort = @"1";
            self.fb_topic_type = @"1";
        }
        
        
        /*
        NSArray * comments = [dic objectForKey:@"comment"];
        
        self.fb_comment_array = [NSMutableArray array];
        
        if (comments.count > 0) {
            
            for (NSDictionary * theDic in comments) {
                FBCircleCommentModel * model = [[FBCircleCommentModel alloc] initWithDictionary:theDic];
                [self.fb_comment_array addObject:model];
            }
        }
        
        
        NSArray * praises = [dic objectForKey:@"praise"];
        
        self.fb_praise_array = [NSMutableArray array];
        
        if (praises.count > 0) {
            
            for (NSDictionary * theDic in praises) {
                FBCirclePraiseModel * model = [[FBCirclePraiseModel alloc] initWithDictionary:theDic];
                
                [self.fb_praise_array addObject:model];
            }
        }
        
        */
        if (![[dic objectForKey:@"roottid"] isEqualToString:@"0"])
        {
            NSDictionary * rDic = [dic objectForKey:@"followinfo"];
            
            self.rfb_tid = [NSString stringWithFormat:@"%@",[rDic objectForKey:@"tid"]];
            self.rfb_uid = [NSString stringWithFormat:@"%@",[rDic objectForKey:@"uid"]];
            self.rfb_username = [NSString stringWithFormat:@"%@",[rDic objectForKey:@"username"]];
            self.rfb_content = [ZSNApi decodeSpecialCharactersString:[NSString stringWithFormat:@"%@",[rDic objectForKey:@"content"]]];
            self.rfb_imageid = [NSString stringWithFormat:@"%@",[rDic objectForKey:@"imageid"]];
            if ([self.rfb_imageid isEqualToString:@"<null>"] || [self.rfb_imageid isEqual:[NSNull null]])
            {
                self.rfb_imageid = @"";
            }
            
            self.rfb_topic_type = [NSString stringWithFormat:@"%@",[rDic objectForKey:@"topic_type"]];
            self.rfb_zan_num = [NSString stringWithFormat:@"%@",[rDic objectForKey:@"zan_num"]];
            self.rfb_reply_num = [NSString stringWithFormat:@"%@",[rDic objectForKey:@"reply_num"]];
            self.rfb_forward_num = [NSString stringWithFormat:@"%@",[rDic objectForKey:@"forward_num"]];
            self.rfb_replyid = [NSString stringWithFormat:@"%@",[rDic objectForKey:@"replyid"]];
            self.rfb_rootid = [NSString stringWithFormat:@"%@",[rDic objectForKey:@"rootid"]];
            self.rfb_ip = [NSString stringWithFormat:@"%@",[rDic objectForKey:@"ip"]];
            self.rfb_lng = [NSString stringWithFormat:@"%@",[rDic objectForKey:@"lng"]];
            self.rfb_lat = [NSString stringWithFormat:@"%@",[rDic objectForKey:@"lat"]];
            self.rfb_area = [NSString stringWithFormat:@"%@",[rDic objectForKey:@"area"]];
            self.rfb_status = [NSString stringWithFormat:@"%@",[rDic objectForKey:@"status"]];
            self.rfb_deteline = [NSString stringWithFormat:@"%@",[rDic objectForKey:@"dateline"]];
            self.rfb_face = [NSString stringWithFormat:@"%@",[rDic objectForKey:@"face"]];
            self.rfb_sort = [NSString stringWithFormat:@"%@",[rDic objectForKey:@"sort"]];
            self.rfb_image = [NSMutableArray arrayWithArray:[rDic objectForKey:@"image"]];
            
            NSArray * comments = [rDic objectForKey:@"comment"];
            
            self.rfb_comment_array = [NSMutableArray array];
            
            if (comments.count > 0) {
                
                for (NSDictionary * theDic in comments) {
                    FBCircleCommentModel * model = [[FBCircleCommentModel alloc] initWithDictionary:theDic];
                    [self.rfb_comment_array addObject:model];
                }
            }
            
            
            NSArray * praises = [rDic objectForKey:@"praise"];
            
            self.rfb_praise_array = [NSMutableArray array];
            
            if (praises.count > 0) {
                
                for (NSDictionary * theDic in praises) {
                    FBCirclePraiseModel * model = [[FBCirclePraiseModel alloc] initWithDictionary:theDic];
                    [self.rfb_praise_array addObject:model];
                }
            }
            
            
            
            if([self.rfb_sort isEqualToString:@"3"]&&[[rDic objectForKey:@"type"] isEqualToString:@"first"])
            {
                //解析图集
                NSDictionary *photojson= [[rDic objectForKey:FB_CONTENT] objectFromJSONString];
                PhotoFeed * photo=[[PhotoFeed alloc]initWithJson:photojson];
                
                self.rfb_username = photo.title;
                self.rfb_content = [ZSNApi decodeSpecialCharactersString:photo.title];
                NSArray * image_array = [photo.image_string componentsSeparatedByString:@"|"];
                if (image_array.count > 0) {
                    self.rfb_face = [image_array objectAtIndex:0];
                }else
                {
                    self.rfb_face = @"";
                }
                
                self.rfb_zan_num  = [NSString stringWithFormat:@"http://special.fblife.com/showphoto/%@.html",photo.aid];
                
            }else if([self.rfb_sort isEqualToString:@"2"]&&[[rDic objectForKey:@"type"] isEqualToString:@"first"])
            {
                //解析文集
                NSDictionary *blogjson= [[rDic objectForKey:FB_CONTENT] objectFromJSONString];
                
                BlogFeed * blog=[[BlogFeed alloc]initWithJson:blogjson];
                
                self.rfb_username = blog.title;
                self.rfb_content = blog.content;
                self.rfb_face = blog.photo;
                self.rfb_zan_num  = [NSString stringWithFormat:@"http://www.fb.cn/blog/view/%@",blog.blogid];
                
            }else if([self.rfb_sort isEqualToString:@"4"]&&[[rDic objectForKey:@"type"] isEqualToString:@"first"])
            {
                //论坛帖子转发为微博
                NSDictionary * newsForwoadjson= [[dic objectForKey:FB_CONTENT] objectFromJSONString];
                FbNewsFeed * fbnews= [[FbNewsFeed alloc] initWithJson:newsForwoadjson];
                
                self.fb_content = @"";
                self.rfb_username = fbnews.title;
                self.rfb_content = fbnews.content;
                self.rfb_face = fbnews.photo;
                self.rfb_zan_num  = [NSString stringWithFormat:@"http://bbs.fblife.com/thread_%@.html",fbnews.bbsid];
            }else if([self.rfb_sort isEqualToString:@"5"]&&[[rDic objectForKey:@"type"] isEqualToString:@"first"])
            {
                //论坛分享
                NSDictionary *newsSendjson= [[rDic objectForKey:FB_EXTENSION] objectFromJSONString];
                
                Extension * ex=[[Extension alloc] initWithJson:newsSendjson];
                
                self.rfb_username = ex.title;
                self.rfb_content = ex.forum_content;
                self.rfb_face = ex.photo;
                self.rfb_zan_num  = [NSString stringWithFormat:@"http://bbs.fblife.com/thread_%@.html",ex.authorid];
                
                
            }else if (([self.rfb_sort isEqualToString:@"8"] || [self.rfb_sort isEqualToString:@"7"] || [self.rfb_sort isEqualToString:@"6"])&&[[rDic objectForKey:@"type"] isEqualToString:@"first"])
            {
                NSDictionary *exjson= [[rDic objectForKey:FB_EXTENSION] objectFromJSONString];
                Extension * ex=[[Extension alloc]initWithJson:exjson];
                
                self.rfb_username = ex.title;
                self.rfb_content = ex.forum_content;
                self.rfb_face = ex.photo;
                self.rfb_zan_num  = [NSString stringWithFormat:@"http://bbs.fblife.com/thread_%@.html",[dic objectForKey:@"sortid"]];
                //张少南，这里缺少新闻分享的，新闻地址
            }else if([self.rfb_sort isEqualToString:@"10"]&&[[rDic objectForKey:@"type"] isEqualToString:@"first"])
            {
                //资源分享
                NSDictionary *newsSendjson= [[rDic objectForKey:FB_EXTENSION] objectFromJSONString];
                
                Extension * ex=[[Extension alloc] initWithJson:newsSendjson];
                
                self.rfb_username = ex.title;
                self.rfb_content = ex.forum_content;
                self.rfb_face = ex.photoFlg?[NSString stringWithFormat:@"http://fb.cn%@",ex.photo]:@"";
                self.rfb_zan_num  = [NSString stringWithFormat:@"http://bbs.fblife.com/thread_%@.html",ex.authorid];
                ///张少南，这里缺少资源分享的链接地址
                
            }else if (([self.rfb_sort isEqualToString:@"9"]&&[[rDic objectForKey:@"type"] isEqualToString:@"first"]))
            {
                //商城分享
                NSDictionary *newsSendjson= [[rDic objectForKey:FB_EXTENSION] objectFromJSONString];
                
                Extension * ex=[[Extension alloc] initWithJson:newsSendjson];
                
                self.rfb_username = ex.title;
                self.rfb_content = ex.forum_content;
                self.rfb_face = ex.photoFlg?[NSString stringWithFormat:@"http://fb.cn%@",ex.photo]:@"";
                self.rfb_zan_num  = [NSString stringWithFormat:@"http://bbs.fblife.com/thread_%@.html",ex.authorid];
                //张少南，这里缺少商城的链接地址
            }else if ([self.rfb_sort isEqualToString:@"15"]&&[[rDic objectForKey:@"type"] isEqualToString:@"first"])
            {
                NSDictionary * atlas_dic = [[rDic objectForKey:FB_EXTENSION] objectFromJSONString];
                
                NSString * title = [zsnApi exchangeStringForDeleteNULL:[atlas_dic objectForKey:@"title"]];
                NSString * photo = [zsnApi exchangeStringForDeleteNULL:[atlas_dic objectForKey:@"photo"]];
                NSString * intro = [zsnApi exchangeStringForDeleteNULL:[atlas_dic objectForKey:@"intro"]];
                
                
                self.rfb_username = title;
                self.rfb_content = intro;
                self.rfb_face = @"";
                self.rfb_zan_num  = [NSString stringWithFormat:@"http://special.fblife.com/showphoto/%@.html",[rDic objectForKey:@"sortid"]];
                //张少南，这里缺少我也不知道是什么的链接地址，跳转方向不明确
                
                if (photo.length > 0)
                {
                    self.rfb_face = photo;
                }
            }
            
            self.fb_sort = @"1";
            self.fb_topic_type = @"1";
            
            
            
            
            
            if ([self.rfb_sort isEqualToString:@"1"])
            {
                self.rfb_topic_type = @"1";
                self.fb_topic_type = @"1";
                self.fb_sort = @"1";
                
                FBCircleExtension * extension = [[FBCircleExtension alloc] initWithDictionary:[[rDic objectForKey:@"extension"] objectFromJSONString]];
                self.rfb_username = extension.extentsion_title;
                self.rfb_content = [ZSNApi decodeSpecialCharactersString:extension.extentsion_content];
                self.rfb_face = extension.extentsion_image;
                self.rfb_zan_num  = extension.extentsion_link;
            }
            
        }
    }
    
    return self;
}


-(void)initHttpRequestWithUid:(NSString *)theUid Page:(int)thePage WithType:(int)theType WithCompletionBlock:(FBCircleCompletionBlock)theCompletionblock WithFailedBlock:(FBCircleFailedBlock)theFailedBlock;
{
    fbCircleCompletionBlock = theCompletionblock;
    
    fbCircleFailedBlock = theFailedBlock;
    
    
    if (!self.data_array)
    {
        self.data_array = [NSMutableArray array];
    }else
    {
//        if (thePage == 1)
//        {
            [self.data_array removeAllObjects];
//        }
    }
    
    __weak typeof(self)bself = self;
    
    if (thePage == 1 && theType == 1)
    {
        NSMutableArray * sqlite_array = [FBCircleModel findWaitingUploadBlogAll];
        
        for (int i = 0;i < sqlite_array.count;i++)
        {
            FBCircleModel * model = [sqlite_array objectAtIndex:i];
            
            if ([model.fb_imageid rangeOfString:@"assets"].length)
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
                        [bself.data_array addObject:model];
                    });
                });
            }else
            {
                [self.data_array addObject:model];
            }
        }
    }
    
    NSString * fullUrl = [NSString stringWithFormat:FBCIRCLE_URL,theUid,thePage,theType];
    
    NSLog(@"请求FB圈接口-----%@",fullUrl);
    
    NSURL * url = [NSURL URLWithString:fullUrl];
    
    NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        @try {
            
            if (data == nil || data.length == 0)
            {
                fbCircleFailedBlock(@"");
                return ;
            }
            
            
            NSDictionary * allDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            if ([[allDic objectForKey:@"errcode"] intValue]==0)
            {
                NSMutableArray * delete_array;
                
                if (thePage == 1 && theType == 1)
                {
                    [FBCircleModel deleteAllBlog];
                    
                    delete_array = [FBCircleModel findAllWaitingUploadDelete];
                }
                
                NSArray * array = [allDic objectForKey:@"datainfo"];                
              
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    for (NSDictionary * dic in array)
                    {
                        FBCircleModel * model = [[FBCircleModel alloc] initWithDictionary:dic];
                        
                        for (FBCirclePraiseModel * praise_model in delete_array)
                        {
                            if (![model.fb_tid isEqualToString:praise_model.praise_tid])
                            {
                                return ;
                            }
                        }
                        
                        
                        if (theType == 1)
                        {
                            [FBCircleModel addBlogWith:model];
                        }
                        
                        [self.data_array addObject:model];
                    }
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (fbCircleCompletionBlock) {
                            fbCircleCompletionBlock(self.data_array);
                        }
                    });
                    
                });
            }
         
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }];
}

#pragma mark-加载未发送的数据库数据

-(void)loadSqliteData
{
    
    
    
    //    [self.data_array addObjectsFromArray:sqlite_array];
}


#pragma mark-数据库方法

//查找需要上传的说说

+(NSMutableArray *)findWaitingUploadBlogAll
{
    sqlite3 * db = [DataBase openDB];
    
    sqlite3_stmt * stmt = nil;
    
    int result = sqlite3_prepare_v2(db, "select * from waitingUploadForBlog order by tid desc",-1,&stmt, nil);
    
    if (result == SQLITE_OK)
    {
        //        sqlite3_bind_int(stmt,1,theType);
        NSMutableArray * perArray = [[NSMutableArray alloc] init];
        while (SQLITE_ROW == sqlite3_step(stmt))
        {
            const unsigned char * uid = sqlite3_column_text(stmt,0);
            const unsigned char * username = sqlite3_column_text(stmt,1);
            const unsigned char * content = sqlite3_column_text(stmt,2);
            const unsigned char * dateline = sqlite3_column_text(stmt,3);
            const unsigned char * images = sqlite3_column_text(stmt,4);
            const unsigned char * tid = sqlite3_column_text(stmt,5);
            const unsigned char * area = sqlite3_column_text(stmt,6);
            const unsigned char * lng = sqlite3_column_text(stmt,7);
            const unsigned char * lat = sqlite3_column_text(stmt,8);
            const unsigned char * autherkey = sqlite3_column_text(stmt,9);
            
            
            FBCircleModel * per = [[FBCircleModel alloc] init];
            
            
            per.fb_tid = tid?[NSString stringWithUTF8String:(const char *)tid]:@"";
            per.fb_uid = uid?[NSString stringWithUTF8String:(const char *)uid]:@"";
            per.fb_username = username?[NSString stringWithUTF8String:(const char *)username]:@"";
            per.fb_content = content?[NSString stringWithUTF8String:(const char *)content]:@"";
            per.fb_deteline = dateline?[NSString stringWithUTF8String:(const char *)dateline]:@"";
            per.fb_imageid = images?[NSString stringWithUTF8String:(const char *)images]:@"";
            per.fb_area = area?[NSString stringWithUTF8String:(const char *)area]:@"";
            per.fb_lng = lng?[NSString stringWithUTF8String:(const char *)lng]:@"";
            per.fb_lat = lat?[NSString stringWithUTF8String:(const char *)lat]:@"";
            per.fb_authkey = autherkey?[NSString stringWithUTF8String:(const char *)autherkey]:@"";
            
            [perArray addObject:per];
        }
        return perArray;
        
    }else
    {
        NSLog(@"failed with result:%d",result);
        return [NSMutableArray array];
    }
    sqlite3_finalize(stmt);
}

//添加等待发送说说数据


+(int)addWeiBoContentWithInfo:(FBCircleModel *)info
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db,"insert into waitingUploadForBlog(uid,username,content,dateline,images,tid,area,lng,lat,autherkey) values(?,?,?,?,?,?,?,?,?,?)", -1,&stmt,nil);
    
    sqlite3_bind_text(stmt,1,[info.fb_uid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,2,[info.fb_username UTF8String],-1,nil);
    sqlite3_bind_text(stmt,3,[info.fb_content UTF8String],-1,nil);
    sqlite3_bind_text(stmt,4,[info.fb_deteline UTF8String],-1,nil);
    sqlite3_bind_text(stmt,5,[info.fb_imageid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,6,[info.fb_tid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,7,[info.fb_area UTF8String],-1,nil);
    sqlite3_bind_text(stmt,8,[info.fb_lng UTF8String],-1,nil);
    sqlite3_bind_text(stmt,9,[info.fb_lat UTF8String],-1,nil);
    sqlite3_bind_text(stmt,10,[info.fb_authkey UTF8String],-1,nil);
    
    
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    return  result;
}


//删除数据

+(int)deleteBlogByDateLine:(NSString *)theDate
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "delete from waitingUploadForBlog where dateline=?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [theDate UTF8String], -1, nil);
    //    sqlite3_bind_int(stmt,1,theType);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"delete error = %d",result);
    return result;
}

//删除未发送的所有的说说

+(int)deleteAllNOSendBlog
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "delete from waitingUploadForBlog", -1, &stmt, nil);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"no send blog delete error = %d",result);
    return result;
}




#pragma mark- 未发送的赞的内容
//添加
+(int)addNOSendPraiseWith:(FBCirclePraiseModel *)info
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db,"insert into waitingUploadForPraise(uid,username,dateline,tid) values(?,?,?,?)", -1,&stmt,nil);
    
    sqlite3_bind_text(stmt,1,[info.praise_uid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,2,[info.praise_username UTF8String],-1,nil);
    sqlite3_bind_text(stmt,3,[info.praise_dateline UTF8String],-1,nil);
    sqlite3_bind_text(stmt,4,[info.praise_tid UTF8String],-1,nil);
    
    int result = sqlite3_step(stmt);
    NSLog(@"数据库保存赞 ---   %d",result);
    sqlite3_finalize(stmt);
    return  result;
}


//查找需要上传的赞

+(NSMutableArray *)findAllWaitingUploadPraise
{
    sqlite3 * db = [DataBase openDB];
    
    sqlite3_stmt * stmt = nil;
    
    int result = sqlite3_prepare_v2(db, "select * from waitingUploadForPraise order by dateline desc",-1,&stmt, nil);
    
    if (result == SQLITE_OK)
    {
        //        sqlite3_bind_int(stmt,1,theType);
        NSMutableArray * perArray = [[NSMutableArray alloc] init];
        while (SQLITE_ROW == sqlite3_step(stmt))
        {
            const unsigned char * uid = sqlite3_column_text(stmt,0);
            const unsigned char * username = sqlite3_column_text(stmt,1);
            const unsigned char * dateline = sqlite3_column_text(stmt,2);
            const unsigned char * tid = sqlite3_column_text(stmt,3);
            
            
            FBCirclePraiseModel * per = [[FBCirclePraiseModel alloc] init];
            
            
            per.praise_uid = uid?[NSString stringWithUTF8String:(const char *)uid]:@"";
            per.praise_username = username?[NSString stringWithUTF8String:(const char *)username]:@"";
            per.praise_dateline = dateline?[NSString stringWithUTF8String:(const char *)dateline]:@"";
            per.praise_tid = tid?[NSString stringWithUTF8String:(const char *)tid]:@"";
            
            [perArray addObject:per];
        }
        return perArray;
        
    }else
    {
        NSLog(@"failed with result:%d",result);
        return [NSMutableArray array];
    }
    sqlite3_finalize(stmt);
}


//删除已发送成功的赞的数据

+(int)deletePraiseByDateLine:(NSString *)theDate
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "delete from waitingUploadForPraise where dateline=?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [theDate UTF8String], -1, nil);
    //    sqlite3_bind_int(stmt,1,theType);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"delete error = %d",result);
    return result;
}


+(int)deleteAllNOPraiseBlog
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "delete from waitingUploadForPraise", -1, &stmt, nil);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"delete error = %d",result);
    return result;
}





#pragma mark - 未发送删除相关

//添加未发送的删除（没有删除model，暂用praisemodel）
+(int)addNOSendDeleteWith:(FBCirclePraiseModel *)info
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db,"insert into waitingUploadForDelete(uid,username,dateline,tid) values(?,?,?,?)", -1,&stmt,nil);
    
    sqlite3_bind_text(stmt,1,[info.praise_uid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,2,[info.praise_username UTF8String],-1,nil);
    sqlite3_bind_text(stmt,3,[info.praise_dateline UTF8String],-1,nil);
    sqlite3_bind_text(stmt,4,[info.praise_tid UTF8String],-1,nil);
    
    int result = sqlite3_step(stmt);
    NSLog(@"数据库保存删除 ---   %d",result);
    sqlite3_finalize(stmt);
    return  result;
}

//查找所有的未发送的删除

+(NSMutableArray *)findAllWaitingUploadDelete
{
    sqlite3 * db = [DataBase openDB];
    
    sqlite3_stmt * stmt = nil;
    
    int result = sqlite3_prepare_v2(db, "select * from waitingUploadForDelete order by dateline desc",-1,&stmt, nil);
    
    if (result == SQLITE_OK)
    {
        //        sqlite3_bind_int(stmt,1,theType);
        NSMutableArray * perArray = [[NSMutableArray alloc] init];
        while (SQLITE_ROW == sqlite3_step(stmt))
        {
            const unsigned char * uid = sqlite3_column_text(stmt,0);
            const unsigned char * username = sqlite3_column_text(stmt,1);
            const unsigned char * dateline = sqlite3_column_text(stmt,2);
            const unsigned char * tid = sqlite3_column_text(stmt,3);
            
            
            FBCirclePraiseModel * per = [[FBCirclePraiseModel alloc] init];
            
            
            per.praise_uid = uid?[NSString stringWithUTF8String:(const char *)uid]:@"";
            per.praise_username = username?[NSString stringWithUTF8String:(const char *)username]:@"";
            per.praise_dateline = dateline?[NSString stringWithUTF8String:(const char *)dateline]:@"";
            per.praise_tid = tid?[NSString stringWithUTF8String:(const char *)tid]:@"";
            
            [perArray addObject:per];
        }
        return perArray;
        
    }else
    {
        NSLog(@"failed with result:%d",result);
        return [NSMutableArray array];
    }
    sqlite3_finalize(stmt);
}

//删除发送成功的删除

+(int)deleteDeleteByDateLine:(NSString *)theDate
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "delete from waitingUploadForDelete where dateline=?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [theDate UTF8String], -1, nil);
    //    sqlite3_bind_int(stmt,1,theType);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"delete error = %d",result);
    return result;
}


+(int)deleteAllNODeleteBlog
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "delete from waitingUploadForDelete", -1, &stmt, nil);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"delete error = %d",result);
    return result;
}



#pragma mark - 未发转发相关

//添加等待发送的转发内容(没有转发model暂用commentmodel代替)

+(int)addNOSendForwardWith:(FBCircleCommentModel *)info
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db,"insert into watingUploadForForward(uid,username,content,dateline,tid) values(?,?,?,?,?)", -1,&stmt,nil);
    
    sqlite3_bind_text(stmt,1,[info.comment_uid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,2,[info.comment_username UTF8String],-1,nil);
    sqlite3_bind_text(stmt,3,[info.comment_content UTF8String],-1,nil);
    sqlite3_bind_text(stmt,4,[info.comment_dateline UTF8String],-1,nil);
    sqlite3_bind_text(stmt,5,[info.comment_tid UTF8String],-1,nil);
    
    int result = sqlite3_step(stmt);
    NSLog(@"数据库保存转发结果 ---   %d",result);
    sqlite3_finalize(stmt);
    return  result;
    
}

//查找所有的未发送的转发

+(NSMutableArray *)findAllWaitingUploadForward
{
    sqlite3 * db = [DataBase openDB];
    
    sqlite3_stmt * stmt = nil;
    
    int result = sqlite3_prepare_v2(db, "select * from watingUploadForForward order by dateline desc",-1,&stmt, nil);
    
    if (result == SQLITE_OK)
    {
        //        sqlite3_bind_int(stmt,1,theType);
        NSMutableArray * perArray = [[NSMutableArray alloc] init];
        while (SQLITE_ROW == sqlite3_step(stmt))
        {
            const unsigned char * uid = sqlite3_column_text(stmt,0);
            const unsigned char * username = sqlite3_column_text(stmt,1);
            const unsigned char * content = sqlite3_column_text(stmt,2);
            const unsigned char * dateline = sqlite3_column_text(stmt,3);
            const unsigned char * tid = sqlite3_column_text(stmt,4);
            
            
            FBCircleCommentModel * per = [[FBCircleCommentModel alloc] init];
            
            
            per.comment_uid = uid?[NSString stringWithUTF8String:(const char *)uid]:@"";
            per.comment_username = username?[NSString stringWithUTF8String:(const char *)username]:@"";
            per.comment_content = content?[NSString stringWithUTF8String:(const char *)content]:@"";
            per.comment_dateline = dateline?[NSString stringWithUTF8String:(const char *)dateline]:@"";
            per.comment_tid = tid?[NSString stringWithUTF8String:(const char *)tid]:@"";
            
            [perArray addObject:per];
        }
        return perArray;
        
    }else
    {
        NSLog(@"failed with result:%d",result);
        return [NSMutableArray array];
    }
    sqlite3_finalize(stmt);
}

//删除发送成功的转发

+(int)deleteForwardByDateLine:(NSString *)theDate
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "delete from watingUploadForForward where dateline=?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [theDate UTF8String], -1, nil);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"delete error = %d",result);
    return result;
}




+(int)deleteAllNOForwardBlog
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "delete from watingUploadForForward", -1, &stmt, nil);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"delete error = %d",result);
    return result;
}





//添加等待发送的评论内容

+(int)addNOSendCommentWith:(FBCircleCommentModel *)info
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db,"insert into waitingUploadForComment(uid,username,content,dateline,tid) values(?,?,?,?,?)", -1,&stmt,nil);
    
    sqlite3_bind_text(stmt,1,[info.comment_uid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,2,[info.comment_username UTF8String],-1,nil);
    sqlite3_bind_text(stmt,3,[info.comment_content UTF8String],-1,nil);
    sqlite3_bind_text(stmt,4,[info.comment_dateline UTF8String],-1,nil);
    sqlite3_bind_text(stmt,5,[info.comment_tid UTF8String],-1,nil);
    
    int result = sqlite3_step(stmt);
    NSLog(@"数据库保存评论结果 ---   %d",result);
    sqlite3_finalize(stmt);
    return  result;
}

//查找所有的未发送的评论

+(NSMutableArray *)findAllWaitingUploadComments
{
    sqlite3 * db = [DataBase openDB];
    
    sqlite3_stmt * stmt = nil;
    
    int result = sqlite3_prepare_v2(db, "select * from waitingUploadForComment order by dateline desc",-1,&stmt, nil);
    
    if (result == SQLITE_OK)
    {
        //        sqlite3_bind_int(stmt,1,theType);
        NSMutableArray * perArray = [[NSMutableArray alloc] init];
        while (SQLITE_ROW == sqlite3_step(stmt))
        {
            const unsigned char * uid = sqlite3_column_text(stmt,0);
            const unsigned char * username = sqlite3_column_text(stmt,1);
            const unsigned char * content = sqlite3_column_text(stmt,2);
            const unsigned char * dateline = sqlite3_column_text(stmt,3);
            const unsigned char * tid = sqlite3_column_text(stmt,4);
            
            
            FBCircleCommentModel * per = [[FBCircleCommentModel alloc] init];
            
            
            per.comment_uid = uid?[NSString stringWithUTF8String:(const char *)uid]:@"";
            per.comment_username = username?[NSString stringWithUTF8String:(const char *)username]:@"";
            per.comment_content = content?[NSString stringWithUTF8String:(const char *)content]:@"";
            per.comment_dateline = dateline?[NSString stringWithUTF8String:(const char *)dateline]:@"";
            per.comment_tid = tid?[NSString stringWithUTF8String:(const char *)tid]:@"";
            
            [perArray addObject:per];
        }
        return perArray;
        
    }else
    {
        NSLog(@"failed with result:%d",result);
        return [NSMutableArray array];
    }
    sqlite3_finalize(stmt);
}

//删除发送成功的评论

+(int)deleteCommentsByDateLine:(NSString *)theDate
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "delete from waitingUploadForComment where dateline=?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [theDate UTF8String], -1, nil);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"delete error = %d",result);
    return result;
}



+(int)deleteAllNOComments
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "delete from waitingUploadForComment", -1, &stmt, nil);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"delete error = %d",result);
    return result;
}

#pragma mark-增加微博信息


+(int)addBlogWith:(FBCircleModel *)info
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db,"insert into FBCircleBlog(fb_tid,fb_uid,fb_username,fb_content,fb_sort,fb_imageid,fb_topic_type,fb_zan_num,fb_reply_num,fb_forward_num,fb_replyid,fb_rootid,fb_ip,fb_lng,fb_lat,fb_area,fb_status,fb_deteline,fb_face,rfb_tid,rfb_uid,rfb_username,rfb_content,rfb_sort,rfb_imageid,rfb_topic_type,rfb_zan_num,rfb_reply_num,rfb_forward_num,rfb_replyid,rfb_rootid,rfb_ip,rfb_lng,rfb_lat,rfb_area,rfb_status,rfb_deteline,rfb_face,fb_image,rfb_image,autherkey) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", -1,&stmt,nil);
    
    sqlite3_bind_text(stmt,1,[info.fb_tid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,2,[info.fb_uid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,3,[info.fb_username UTF8String],-1,nil);
    sqlite3_bind_text(stmt,4,[info.fb_content UTF8String],-1,nil);
    sqlite3_bind_text(stmt,5,[info.fb_sort UTF8String],-1,nil);
    sqlite3_bind_text(stmt,6,[info.fb_imageid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,7,[info.fb_topic_type UTF8String],-1,nil);
    sqlite3_bind_text(stmt,8,[info.fb_zan_num UTF8String],-1,nil);
    sqlite3_bind_text(stmt,9,[info.fb_reply_num UTF8String],-1,nil);
    sqlite3_bind_text(stmt,10,[info.fb_forward_num UTF8String],-1,nil);
    sqlite3_bind_text(stmt,11,[info.fb_replyid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,12,[info.fb_rootid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,13,[info.fb_ip UTF8String],-1,nil);
    sqlite3_bind_text(stmt,14,[info.fb_lng UTF8String],-1,nil);
    sqlite3_bind_text(stmt,15,[info.fb_lat UTF8String],-1,nil);
    sqlite3_bind_text(stmt,16,[info.fb_area UTF8String],-1,nil);
    sqlite3_bind_text(stmt,17,[info.fb_status UTF8String],-1,nil);
    sqlite3_bind_text(stmt,18,[info.fb_deteline UTF8String],-1,nil);
    sqlite3_bind_text(stmt,19,[info.fb_face UTF8String],-1,nil);
    
    
    sqlite3_bind_text(stmt,20,[info.rfb_tid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,21,[info.rfb_uid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,22,[info.rfb_username UTF8String],-1,nil);
    sqlite3_bind_text(stmt,23,[info.rfb_content UTF8String],-1,nil);
    sqlite3_bind_text(stmt,24,[info.rfb_sort UTF8String],-1,nil);
    sqlite3_bind_text(stmt,25,[info.rfb_imageid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,26,[info.rfb_topic_type UTF8String],-1,nil);
    sqlite3_bind_text(stmt,27,[info.rfb_zan_num UTF8String],-1,nil);
    sqlite3_bind_text(stmt,28,[info.rfb_reply_num UTF8String],-1,nil);
    sqlite3_bind_text(stmt,29,[info.rfb_forward_num UTF8String],-1,nil);
    sqlite3_bind_text(stmt,30,[info.rfb_replyid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,31,[info.rfb_rootid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,32,[info.rfb_ip UTF8String],-1,nil);
    sqlite3_bind_text(stmt,33,[info.rfb_lng UTF8String],-1,nil);
    sqlite3_bind_text(stmt,34,[info.rfb_lat UTF8String],-1,nil);
    sqlite3_bind_text(stmt,35,[info.rfb_area UTF8String],-1,nil);
    sqlite3_bind_text(stmt,36,[info.rfb_status UTF8String],-1,nil);
    sqlite3_bind_text(stmt,37,[info.rfb_deteline UTF8String],-1,nil);
    sqlite3_bind_text(stmt,38,[info.rfb_face UTF8String],-1,nil);
    
    
    NSString * string = @"";
    
    if (info.fb_imageid.length > 0)
    {
        for (int i=0; i<info.fb_image.count; i++)
        {
            NSDictionary *dicimgurl=[info.fb_image objectAtIndex:i];
            
            string = [NSString stringWithFormat:@"%@||%@",string,[dicimgurl objectForKey:@"link"]];
        }
    }
    
    
    
    NSString * rstring = @"";
    
    if (info.rfb_imageid.length > 0)
    {
        for (int i=0; i<info.rfb_image.count; i++)
        {
            NSDictionary *dicimgurl=[info.rfb_image objectAtIndex:i];
            
            rstring = [NSString stringWithFormat:@"%@||%@",rstring,[dicimgurl objectForKey:@"link"]];
        }
    }
    
    sqlite3_bind_text(stmt,39,[string UTF8String],-1,nil);
    sqlite3_bind_text(stmt,40,[rstring UTF8String],-1,nil);
    
    
    sqlite3_bind_text(stmt,41,[[SzkAPI getAuthkey] UTF8String],-1,nil);
    
    
    if (info.fb_comment_array.count > 0)
    {
        for (FBCircleCommentModel * comment_model in info.fb_comment_array)
        {
            [FBCircleModel addCommentWith:comment_model withtid:info.fb_tid];
        }
    }
    
    if (info.fb_praise_array.count > 0)
    {
        for (FBCirclePraiseModel * praise_model in info.fb_praise_array)
        {
            [FBCircleModel addPraiseWith:praise_model withtid:info.fb_tid];
        }
    }
    
    
    
    if (info.rfb_comment_array.count > 0)
    {
        for (FBCircleCommentModel * comment_model in info.rfb_comment_array)
        {
            [FBCircleModel addCommentWith:comment_model withtid:info.rfb_tid];
        }
    }
    
    if (info.rfb_praise_array.count > 0)
    {
        for (FBCirclePraiseModel * praise_model in info.rfb_praise_array)
        {
            [FBCircleModel addPraiseWith:praise_model withtid:info.rfb_tid];
        }
    }
    
    
    
    int result = sqlite3_step(stmt);
    
//    NSLog(@"添加微博数据 ---   %d",result);
    
    sqlite3_finalize(stmt);
    return  result;
    
}


//查找所有数据


+(NSMutableArray *)findAll
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    int result = sqlite3_prepare_v2(db,"select * from FBCircleBlog order by fb_deteline desc", -1,&stmt,nil);
    
    NSLog(@"result ------   %d",result);
    
    if (result == SQLITE_OK)
    {
        NSMutableArray * perArray = [[NSMutableArray alloc] init];
        
        while (SQLITE_ROW == sqlite3_step(stmt))
        {
            const unsigned char * tid = sqlite3_column_text(stmt,0);
            const unsigned char * uid = sqlite3_column_text(stmt,1);
            const unsigned char * username = sqlite3_column_text(stmt,2);
            const unsigned char * content = sqlite3_column_text(stmt,3);
            const unsigned char * sort = sqlite3_column_text(stmt,4);
            const unsigned char * imageid = sqlite3_column_text(stmt,5);
            const unsigned char * topic_type = sqlite3_column_text(stmt,6);
            const unsigned char * zan_num = sqlite3_column_text(stmt,7);
            const unsigned char * reply_num = sqlite3_column_text(stmt,8);
            const unsigned char * forward_num = sqlite3_column_text(stmt,9);
            const unsigned char * replyid = sqlite3_column_text(stmt,10);
            const unsigned char * rootid = sqlite3_column_text(stmt,11);
            const unsigned char * ip = sqlite3_column_text(stmt,12);
            const unsigned char * lng = sqlite3_column_text(stmt,13);
            const unsigned char * lat = sqlite3_column_text(stmt,14);
            const unsigned char * area = sqlite3_column_text(stmt,15);
            const unsigned char * status = sqlite3_column_text(stmt,16);
            const unsigned char * dateline = sqlite3_column_text(stmt,17);
            const unsigned char * face = sqlite3_column_text(stmt,18);
            
            
            
            const unsigned char * rtid = sqlite3_column_text(stmt,19);
            const unsigned char * ruid = sqlite3_column_text(stmt,20);
            const unsigned char * rusername = sqlite3_column_text(stmt,21);
            const unsigned char * rcontent = sqlite3_column_text(stmt,22);
            const unsigned char * rsort = sqlite3_column_text(stmt,23);
            const unsigned char * rimageid = sqlite3_column_text(stmt,24);
            const unsigned char * rtopic_type = sqlite3_column_text(stmt,25);
            const unsigned char * rzan_num = sqlite3_column_text(stmt,26);
            const unsigned char * rreply_num = sqlite3_column_text(stmt,27);
            const unsigned char * rforward_num = sqlite3_column_text(stmt,28);
            const unsigned char * rreplyid = sqlite3_column_text(stmt,29);
            const unsigned char * rrootid = sqlite3_column_text(stmt,30);
            const unsigned char * rip = sqlite3_column_text(stmt,31);
            const unsigned char * rlng = sqlite3_column_text(stmt,32);
            const unsigned char * rlat = sqlite3_column_text(stmt,33);
            const unsigned char * rarea = sqlite3_column_text(stmt,34);
            const unsigned char * rstatus = sqlite3_column_text(stmt,35);
            const unsigned char * rdateline = sqlite3_column_text(stmt,36);
            const unsigned char * rface = sqlite3_column_text(stmt,37);
            
            const unsigned char * image = sqlite3_column_text(stmt,38);
            const unsigned char * rimage = sqlite3_column_text(stmt,39);
            const unsigned char * autherkey = sqlite3_column_text(stmt,40);
            
            
            
            
            FBCircleModel * per = [[FBCircleModel alloc] init];
            
            NSString * fb_image = image?[NSString stringWithUTF8String:(const char *)image]:@"";
            
            per.fb_image = [FBCircleModel returnImageUrlWith:fb_image];
            
            NSString * rfb_image = rimage?[NSString stringWithUTF8String:(const char *)rimage]:@"";
            
            per.rfb_image = [FBCircleModel returnImageUrlWith:rfb_image];
            
//            NSLog(@"fb_image--------%@",per.fb_image);
            
            
            per.fb_tid = tid?[NSString stringWithUTF8String:(const char *)tid]:@"";
            per.fb_uid = uid?[NSString stringWithUTF8String:(const char *)uid]:@"";
            per.fb_username = username?[NSString stringWithUTF8String:(const char *)username]:@"";
            per.fb_content = content?[NSString stringWithUTF8String:(const char *)content]:@"";
            per.fb_sort = sort?[NSString stringWithUTF8String:(const char *)sort]:@"";
            per.fb_imageid = imageid?[NSString stringWithUTF8String:(const char *)imageid]:@"";
            per.fb_topic_type = topic_type?[NSString stringWithUTF8String:(const char *)topic_type]:@"";
            per.fb_zan_num = zan_num?[NSString stringWithUTF8String:(const char *)zan_num]:@"";
            per.fb_reply_num = reply_num?[NSString stringWithUTF8String:(const char *)reply_num]:@"";
            per.fb_forward_num = forward_num?[NSString stringWithUTF8String:(const char *)forward_num]:@"";
            per.fb_replyid = replyid?[NSString stringWithUTF8String:(const char *)replyid]:@"";
            per.fb_rootid = rootid?[NSString stringWithUTF8String:(const char *)rootid]:@"";
            per.fb_ip = ip?[NSString stringWithUTF8String:(const char *)ip]:@"";
            per.fb_lng = lng?[NSString stringWithUTF8String:(const char *)lng]:@"";
            per.fb_lat = lat?[NSString stringWithUTF8String:(const char *)lat]:@"";
            per.fb_area = area?[NSString stringWithUTF8String:(const char *)area]:@"";
            per.fb_status = status?[NSString stringWithUTF8String:(const char *)status]:@"";
            per.fb_deteline = dateline?[NSString stringWithUTF8String:(const char *)dateline]:@"";
            per.fb_face = face?[NSString stringWithUTF8String:(const char *)face]:@"";
            
            
            per.rfb_tid = rtid?[NSString stringWithUTF8String:(const char *)rtid]:@"";
            per.rfb_uid = ruid?[NSString stringWithUTF8String:(const char *)ruid]:@"";
            per.rfb_username = rusername?[NSString stringWithUTF8String:(const char *)rusername]:@"";
            per.rfb_content = rcontent?[NSString stringWithUTF8String:(const char *)rcontent]:@"";
            per.rfb_sort = rsort?[NSString stringWithUTF8String:(const char *)rsort]:@"";
            per.rfb_imageid = rimageid?[NSString stringWithUTF8String:(const char *)rimageid]:@"";
            per.rfb_topic_type = rtopic_type?[NSString stringWithUTF8String:(const char *)rtopic_type]:@"";
            per.rfb_zan_num = rzan_num?[NSString stringWithUTF8String:(const char *)rzan_num]:@"";
            per.rfb_reply_num = rreply_num?[NSString stringWithUTF8String:(const char *)rreply_num]:@"";
            per.rfb_forward_num = rforward_num?[NSString stringWithUTF8String:(const char *)rforward_num]:@"";
            per.rfb_replyid = rreplyid?[NSString stringWithUTF8String:(const char *)rreplyid]:@"";
            per.rfb_rootid = rrootid?[NSString stringWithUTF8String:(const char *)rrootid]:@"";
            per.rfb_ip = rip?[NSString stringWithUTF8String:(const char *)rip]:@"";
            per.rfb_lng = rlng?[NSString stringWithUTF8String:(const char *)rlng]:@"";
            per.rfb_lat = rlat?[NSString stringWithUTF8String:(const char *)rlat]:@"";
            per.rfb_area = rarea?[NSString stringWithUTF8String:(const char *)rarea]:@"";
            per.rfb_status = rstatus?[NSString stringWithUTF8String:(const char *)rstatus]:@"";
            per.rfb_deteline = rdateline?[NSString stringWithUTF8String:(const char *)rdateline]:@"";
            per.rfb_face = rface?[NSString stringWithUTF8String:(const char *)rface]:@"";
            per.fb_authkey = autherkey?[NSString stringWithUTF8String:(const char *)autherkey]:@"";
            
            
            NSMutableArray * comment_array = [FBCircleModel findAllCommentByTid:per.fb_tid];
            
            per.fb_comment_array = comment_array;
            
            
            NSMutableArray * praise_array = [FBCircleModel findAllPraiseByTid:per.fb_tid];
            
            per.fb_praise_array = praise_array;
            
            
            NSMutableArray * rcomment_array = [FBCircleModel findAllCommentByTid:per.rfb_tid];
            
            per.rfb_comment_array = rcomment_array;
            
            
            NSMutableArray * rpraise_array = [FBCircleModel findAllPraiseByTid:per.rfb_tid];
            
            per.rfb_praise_array = rpraise_array;
            
            
            
            [perArray addObject:per];
        }
        sqlite3_finalize(stmt);
        return perArray;
    }else
    {
        return [NSMutableArray array];
    }
}


//删除所有微博

+(int)deleteAllBlog
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "delete from FBCircleBlog", -1, &stmt, nil);
    
    [FBCircleModel deleteallComments];
    
    [FBCircleModel deleteallPraises];
    
    //    sqlite3_bind_text(stmt, 1, [theTid UTF8String], -1, nil);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"删除微博结果 = %d",result);
    return result;
    
}

+(int)deleteBlogWithTid:(NSString *)tid
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "delete * from FBCircleBlog where fb_tid=?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [tid UTF8String], -1, nil);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"delete error = %d",result);
    return result;
}

//删除原微博时修改数据库原微博rtid

+(int)updateRfbTidid:(NSString *)theNewTid WithTid:(NSString *)theTid
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "UPDATE FBCircleBlog SET rfb_tid=? WHERE rfb_tid=?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [theNewTid UTF8String], -1, nil);
    sqlite3_bind_text(stmt, 2, [theTid UTF8String], -1, nil);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"修改原微博内容tid result = %d",result);
    return result;
}




#pragma mark-评论相关接口


//添加评论

+(int)addCommentWith:(FBCircleCommentModel *)info withtid:(NSString *)tid
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db,"insert into FBCircleCommentModel(tid,username,content,dateline,face,uid) values(?,?,?,?,?,?)", -1,&stmt,nil);
    
    sqlite3_bind_text(stmt,1,[tid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,2,[info.comment_username UTF8String],-1,nil);
    sqlite3_bind_text(stmt,3,[info.comment_content UTF8String],-1,nil);
    sqlite3_bind_text(stmt,4,[info.comment_dateline UTF8String],-1,nil);
    sqlite3_bind_text(stmt,5,[info.comment_face UTF8String],-1,nil);
    sqlite3_bind_text(stmt,6,[info.comment_uid UTF8String],-1,nil);
    
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    return  result;
}



//删除评论数据

+(int)deleteCommentByTid:(NSString *)theTid
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "delete * from FBCircleCommentModel where tid=?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [theTid UTF8String], -1, nil);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"delete error = %d",result);
    return result;
}


//删除所有评论内容

+(int)deleteallComments
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "delete from FBCircleCommentModel", -1, &stmt, nil);
    //    sqlite3_bind_text(stmt, 1, [theTid UTF8String], -1, nil);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"删除所有评论数据 = %d",result);
    return result;
}



//通过tid查找评论

+(NSMutableArray *)findAllCommentByTid:(NSString *)theTid
{
    sqlite3 * db = [DataBase openDB];
    
    sqlite3_stmt * stmt = nil;
    
    int result = sqlite3_prepare_v2(db, "select * from FBCircleCommentModel where tid=? order by tid desc",-1,&stmt, nil);
    
    if (result == SQLITE_OK)
    {
        sqlite3_bind_text(stmt, 1,[theTid UTF8String], -1, nil);
        
        NSMutableArray * perArray = [[NSMutableArray alloc] init];
        
        while (SQLITE_ROW == sqlite3_step(stmt))
        {
            const unsigned char * tid = sqlite3_column_text(stmt,0);
            const unsigned char * username = sqlite3_column_text(stmt,1);
            const unsigned char * content = sqlite3_column_text(stmt,2);
            const unsigned char * dateline = sqlite3_column_text(stmt,3);
            const unsigned char * face = sqlite3_column_text(stmt,4);
            const unsigned char * uid = sqlite3_column_text(stmt,5);
            
            FBCircleCommentModel * per = [[FBCircleCommentModel alloc] init];
            
            per.comment_username = username?[NSString stringWithUTF8String:(const char *)username]:@"";
            per.comment_content = content?[NSString stringWithUTF8String:(const char *)content]:@"";
            per.comment_dateline = dateline?[NSString stringWithUTF8String:(const char *)dateline]:@"";
            per.comment_face = face?[NSString stringWithUTF8String:(const char *)face]:@"";
            per.comment_uid = uid?[NSString stringWithUTF8String:(const char *)uid]:@"";
            
            [perArray addObject:per];
        }
        return perArray;
        
    }else
    {
        NSLog(@"failed with result:%d",result);
        return [NSMutableArray array];
    }
    sqlite3_finalize(stmt);
}




#pragma mark-赞相关接口


//添加赞

+(int)addPraiseWith:(FBCirclePraiseModel *)info withtid:(NSString *)tid
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db,"insert into FBCirclePraiseModel(tid,uid,username,image_url) values(?,?,?,?)", -1,&stmt,nil);
    
    sqlite3_bind_text(stmt,1,[tid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,2,[info.praise_uid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,3,[info.praise_username UTF8String],-1,nil);
    sqlite3_bind_text(stmt,4,[info.praise_image_url UTF8String],-1,nil);
    
    int result = sqlite3_step(stmt);
    
//    NSLog(@"数据库添加赞 ---  %d",result);
    
    sqlite3_finalize(stmt);
    return  result;
}



//删除赞数据

+(int)deletePraiseByTid:(NSString *)theTid;
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "delete * from FBCirclePraiseModel where tid=?", -1, &stmt, nil);
    sqlite3_bind_text(stmt, 1, [theTid UTF8String], -1, nil);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"数据库通过tid删除赞 = %d",result);
    return result;
}


//删除所有赞内容

+(int)deleteallPraises
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "delete from FBCirclePraiseModel", -1, &stmt, nil);
    //    sqlite3_bind_text(stmt, 1, [theTid UTF8String], -1, nil);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"数据库删除所有评论数据 = %d",result);
    return result;
}



//通过tid查找转发

+(NSMutableArray *)findAllPraiseByTid:(NSString *)theTid
{
    sqlite3 * db = [DataBase openDB];
    
    sqlite3_stmt * stmt = nil;
    
    int result = sqlite3_prepare_v2(db, "select * from FBCirclePraiseModel where tid=? order by tid desc",-1,&stmt, nil);
    
    if (result == SQLITE_OK)
    {
        sqlite3_bind_text(stmt, 1,[theTid UTF8String], -1, nil);
        
        NSMutableArray * perArray = [[NSMutableArray alloc] init];
        
        while (SQLITE_ROW == sqlite3_step(stmt))
        {
            const unsigned char * tid = sqlite3_column_text(stmt,0);
            const unsigned char * uid = sqlite3_column_text(stmt,1);
            const unsigned char * username = sqlite3_column_text(stmt,2);
            const unsigned char * image_url = sqlite3_column_text(stmt,3);
            
            FBCirclePraiseModel * per = [[FBCirclePraiseModel alloc] init];
            
            per.praise_username = username?[NSString stringWithUTF8String:(const char *)username]:@"";
            per.praise_uid = uid?[NSString stringWithUTF8String:(const char *)uid]:@"";
            per.praise_image_url = image_url?[NSString stringWithUTF8String:(const char *)image_url]:@"";
            
            [perArray addObject:per];
        }
        return perArray;
        
    }else
    {
        NSLog(@"failed with result:%d",result);
        return [NSMutableArray array];
    }
    sqlite3_finalize(stmt);
}






#pragma mark-增加个人微博信息


+(int)addGzuji:(FBCircleModel *)info
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db,"insert into Gzuji(fb_tid,fb_uid,fb_username,fb_content,fb_sort,fb_imageid,fb_topic_type,fb_zan_num,fb_reply_num,fb_forward_num,fb_replyid,fb_rootid,fb_ip,fb_lng,fb_lat,fb_area,fb_status,fb_deteline,fb_face,rfb_tid,rfb_uid,rfb_username,rfb_content,rfb_sort,rfb_imageid,rfb_topic_type,rfb_zan_num,rfb_reply_num,rfb_forward_num,rfb_replyid,rfb_rootid,rfb_ip,rfb_lng,rfb_lat,rfb_area,rfb_status,rfb_deteline,rfb_face,fb_image,rfb_image) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", -1,&stmt,nil);
    
    sqlite3_bind_text(stmt,1,[info.fb_tid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,2,[info.fb_uid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,3,[info.fb_username UTF8String],-1,nil);
    sqlite3_bind_text(stmt,4,[info.fb_content UTF8String],-1,nil);
    sqlite3_bind_text(stmt,5,[info.fb_sort UTF8String],-1,nil);
    sqlite3_bind_text(stmt,6,[info.fb_imageid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,7,[info.fb_topic_type UTF8String],-1,nil);
    sqlite3_bind_text(stmt,8,[info.fb_zan_num UTF8String],-1,nil);
    sqlite3_bind_text(stmt,9,[info.fb_reply_num UTF8String],-1,nil);
    sqlite3_bind_text(stmt,10,[info.fb_forward_num UTF8String],-1,nil);
    sqlite3_bind_text(stmt,11,[info.fb_replyid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,12,[info.fb_rootid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,13,[info.fb_ip UTF8String],-1,nil);
    sqlite3_bind_text(stmt,14,[info.fb_lng UTF8String],-1,nil);
    sqlite3_bind_text(stmt,15,[info.fb_lat UTF8String],-1,nil);
    sqlite3_bind_text(stmt,16,[info.fb_area UTF8String],-1,nil);
    sqlite3_bind_text(stmt,17,[info.fb_status UTF8String],-1,nil);
    sqlite3_bind_text(stmt,18,[info.fb_deteline UTF8String],-1,nil);
    sqlite3_bind_text(stmt,19,[info.fb_face UTF8String],-1,nil);
    
    
    sqlite3_bind_text(stmt,20,[info.rfb_tid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,21,[info.rfb_uid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,22,[info.rfb_username UTF8String],-1,nil);
    sqlite3_bind_text(stmt,23,[info.rfb_content UTF8String],-1,nil);
    sqlite3_bind_text(stmt,24,[info.rfb_sort UTF8String],-1,nil);
    sqlite3_bind_text(stmt,25,[info.rfb_imageid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,26,[info.rfb_topic_type UTF8String],-1,nil);
    sqlite3_bind_text(stmt,27,[info.rfb_zan_num UTF8String],-1,nil);
    sqlite3_bind_text(stmt,28,[info.rfb_reply_num UTF8String],-1,nil);
    sqlite3_bind_text(stmt,29,[info.rfb_forward_num UTF8String],-1,nil);
    sqlite3_bind_text(stmt,30,[info.rfb_replyid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,31,[info.rfb_rootid UTF8String],-1,nil);
    sqlite3_bind_text(stmt,32,[info.rfb_ip UTF8String],-1,nil);
    sqlite3_bind_text(stmt,33,[info.rfb_lng UTF8String],-1,nil);
    sqlite3_bind_text(stmt,34,[info.rfb_lat UTF8String],-1,nil);
    sqlite3_bind_text(stmt,35,[info.rfb_area UTF8String],-1,nil);
    sqlite3_bind_text(stmt,36,[info.rfb_status UTF8String],-1,nil);
    sqlite3_bind_text(stmt,37,[info.rfb_deteline UTF8String],-1,nil);
    sqlite3_bind_text(stmt,38,[info.rfb_face UTF8String],-1,nil);
    
    
    NSString * string = @"";
    
    if (info.fb_imageid.length > 0)
    {
        for (int i=0; i<info.fb_image.count; i++)
        {
            NSDictionary *dicimgurl=[info.fb_image objectAtIndex:i];
            
            string = [NSString stringWithFormat:@"%@||%@",string,[dicimgurl objectForKey:@"link"]];
        }
    }
    
    
    
    NSString * rstring = @"";
    
    if (info.rfb_imageid.length > 0)
    {
        for (int i=0; i<info.rfb_image.count; i++)
        {
            NSDictionary *dicimgurl=[info.rfb_image objectAtIndex:i];
            
            rstring = [NSString stringWithFormat:@"%@||%@",rstring,[dicimgurl objectForKey:@"link"]];
        }
    }
    
    sqlite3_bind_text(stmt,39,[string UTF8String],-1,nil);
    sqlite3_bind_text(stmt,40,[rstring UTF8String],-1,nil);
    
    
    if (info.fb_comment_array.count > 0)
    {
        for (FBCircleCommentModel * comment_model in info.fb_comment_array)
        {
            [FBCircleModel addCommentWith:comment_model withtid:info.fb_tid];
        }
    }
    
    if (info.fb_praise_array.count > 0)
    {
        for (FBCirclePraiseModel * praise_model in info.fb_praise_array)
        {
            [FBCircleModel addPraiseWith:praise_model withtid:info.fb_tid];
        }
    }
    
    
    
    int result = sqlite3_step(stmt);
    
//    NSLog(@"添加微博数据 ---   %d",result);
    
    sqlite3_finalize(stmt);
    return  result;
}


//查找个人所有数据


+(NSMutableArray *)findGzuji
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    int result = sqlite3_prepare_v2(db,"select * from Gzuji order by fb_deteline desc", -1,&stmt,nil);
    
    NSLog(@"result ------   %d",result);
    
    if (result == SQLITE_OK)
    {
        NSMutableArray * perArray = [[NSMutableArray alloc] init];
        
        while (SQLITE_ROW == sqlite3_step(stmt))
        {
            const unsigned char * tid = sqlite3_column_text(stmt,0);
            const unsigned char * uid = sqlite3_column_text(stmt,1);
            const unsigned char * username = sqlite3_column_text(stmt,2);
            const unsigned char * content = sqlite3_column_text(stmt,3);
            const unsigned char * sort = sqlite3_column_text(stmt,4);
            const unsigned char * imageid = sqlite3_column_text(stmt,5);
            const unsigned char * topic_type = sqlite3_column_text(stmt,6);
            const unsigned char * zan_num = sqlite3_column_text(stmt,7);
            const unsigned char * reply_num = sqlite3_column_text(stmt,8);
            const unsigned char * forward_num = sqlite3_column_text(stmt,9);
            const unsigned char * replyid = sqlite3_column_text(stmt,10);
            const unsigned char * rootid = sqlite3_column_text(stmt,11);
            const unsigned char * ip = sqlite3_column_text(stmt,12);
            const unsigned char * lng = sqlite3_column_text(stmt,13);
            const unsigned char * lat = sqlite3_column_text(stmt,14);
            const unsigned char * area = sqlite3_column_text(stmt,15);
            const unsigned char * status = sqlite3_column_text(stmt,16);
            const unsigned char * dateline = sqlite3_column_text(stmt,17);
            const unsigned char * face = sqlite3_column_text(stmt,18);
            
            
            
            const unsigned char * rtid = sqlite3_column_text(stmt,19);
            const unsigned char * ruid = sqlite3_column_text(stmt,20);
            const unsigned char * rusername = sqlite3_column_text(stmt,21);
            const unsigned char * rcontent = sqlite3_column_text(stmt,22);
            const unsigned char * rsort = sqlite3_column_text(stmt,23);
            const unsigned char * rimageid = sqlite3_column_text(stmt,24);
            const unsigned char * rtopic_type = sqlite3_column_text(stmt,25);
            const unsigned char * rzan_num = sqlite3_column_text(stmt,26);
            const unsigned char * rreply_num = sqlite3_column_text(stmt,27);
            const unsigned char * rforward_num = sqlite3_column_text(stmt,28);
            const unsigned char * rreplyid = sqlite3_column_text(stmt,29);
            const unsigned char * rrootid = sqlite3_column_text(stmt,30);
            const unsigned char * rip = sqlite3_column_text(stmt,31);
            const unsigned char * rlng = sqlite3_column_text(stmt,32);
            const unsigned char * rlat = sqlite3_column_text(stmt,33);
            const unsigned char * rarea = sqlite3_column_text(stmt,34);
            const unsigned char * rstatus = sqlite3_column_text(stmt,35);
            const unsigned char * rdateline = sqlite3_column_text(stmt,36);
            const unsigned char * rface = sqlite3_column_text(stmt,37);
            
            const unsigned char * image = sqlite3_column_text(stmt,38);
            const unsigned char * rimage = sqlite3_column_text(stmt,39);
            
            
            
            
            FBCircleModel * per = [[FBCircleModel alloc] init];
            
            NSString * fb_image = image?[NSString stringWithUTF8String:(const char *)image]:@"";
            
            per.fb_image = [FBCircleModel returnImageUrlWith:fb_image];
            
            NSString * rfb_image = rimage?[NSString stringWithUTF8String:(const char *)rimage]:@"";
            
            per.rfb_image = [FBCircleModel returnImageUrlWith:rfb_image];
            
//            NSLog(@"fb_image--------%@",per.fb_image);
            
            
            per.fb_tid = tid?[NSString stringWithUTF8String:(const char *)tid]:@"";
            per.fb_uid = uid?[NSString stringWithUTF8String:(const char *)uid]:@"";
            per.fb_username = username?[NSString stringWithUTF8String:(const char *)username]:@"";
            per.fb_content = content?[NSString stringWithUTF8String:(const char *)content]:@"";
            per.fb_sort = sort?[NSString stringWithUTF8String:(const char *)sort]:@"";
            per.fb_imageid = imageid?[NSString stringWithUTF8String:(const char *)imageid]:@"";
            per.fb_topic_type = topic_type?[NSString stringWithUTF8String:(const char *)topic_type]:@"";
            per.fb_zan_num = zan_num?[NSString stringWithUTF8String:(const char *)zan_num]:@"";
            per.fb_reply_num = reply_num?[NSString stringWithUTF8String:(const char *)reply_num]:@"";
            per.fb_forward_num = forward_num?[NSString stringWithUTF8String:(const char *)forward_num]:@"";
            per.fb_replyid = replyid?[NSString stringWithUTF8String:(const char *)replyid]:@"";
            per.fb_rootid = rootid?[NSString stringWithUTF8String:(const char *)rootid]:@"";
            per.fb_ip = ip?[NSString stringWithUTF8String:(const char *)ip]:@"";
            per.fb_lng = lng?[NSString stringWithUTF8String:(const char *)lng]:@"";
            per.fb_lat = lat?[NSString stringWithUTF8String:(const char *)lat]:@"";
            per.fb_area = area?[NSString stringWithUTF8String:(const char *)area]:@"";
            per.fb_status = status?[NSString stringWithUTF8String:(const char *)status]:@"";
            per.fb_deteline = dateline?[NSString stringWithUTF8String:(const char *)dateline]:@"";
            per.fb_face = face?[NSString stringWithUTF8String:(const char *)face]:@"";
            
            
            per.rfb_tid = rtid?[NSString stringWithUTF8String:(const char *)rtid]:@"";
            per.rfb_uid = ruid?[NSString stringWithUTF8String:(const char *)ruid]:@"";
            per.rfb_username = rusername?[NSString stringWithUTF8String:(const char *)rusername]:@"";
            per.rfb_content = rcontent?[NSString stringWithUTF8String:(const char *)rcontent]:@"";
            per.rfb_sort = rsort?[NSString stringWithUTF8String:(const char *)rsort]:@"";
            per.rfb_imageid = rimageid?[NSString stringWithUTF8String:(const char *)rimageid]:@"";
            per.rfb_topic_type = rtopic_type?[NSString stringWithUTF8String:(const char *)rtopic_type]:@"";
            per.rfb_zan_num = rzan_num?[NSString stringWithUTF8String:(const char *)rzan_num]:@"";
            per.rfb_reply_num = rreply_num?[NSString stringWithUTF8String:(const char *)rreply_num]:@"";
            per.rfb_forward_num = rforward_num?[NSString stringWithUTF8String:(const char *)rforward_num]:@"";
            per.rfb_replyid = rreplyid?[NSString stringWithUTF8String:(const char *)rreplyid]:@"";
            per.rfb_rootid = rrootid?[NSString stringWithUTF8String:(const char *)rrootid]:@"";
            per.rfb_ip = rip?[NSString stringWithUTF8String:(const char *)rip]:@"";
            per.rfb_lng = rlng?[NSString stringWithUTF8String:(const char *)rlng]:@"";
            per.rfb_lat = rlat?[NSString stringWithUTF8String:(const char *)rlat]:@"";
            per.rfb_area = rarea?[NSString stringWithUTF8String:(const char *)rarea]:@"";
            per.rfb_status = rstatus?[NSString stringWithUTF8String:(const char *)rstatus]:@"";
            per.rfb_deteline = rdateline?[NSString stringWithUTF8String:(const char *)rdateline]:@"";
            per.rfb_face = rface?[NSString stringWithUTF8String:(const char *)rface]:@"";
            
            
            NSMutableArray * comment_array = [FBCircleModel findAllCommentByTid:per.fb_tid];
            
            per.fb_comment_array = comment_array;
            
            
            NSMutableArray * praise_array = [FBCircleModel findAllPraiseByTid:per.fb_tid];
            
            per.fb_praise_array = praise_array;
            
            
            [perArray addObject:per];
        }
        sqlite3_finalize(stmt);
        return perArray;
    }else
    {
        return [NSMutableArray array];
    }
}


//删除所有缓存个人微博数据

+(int)deleteAllGzuji
{
    sqlite3 * db = [DataBase openDB];
    sqlite3_stmt * stmt = nil;
    sqlite3_prepare_v2(db, "delete from Gzuji", -1, &stmt, nil);
    
    [FBCircleModel deleteallComments];
    
    [FBCircleModel deleteallPraises];
    
    //    sqlite3_bind_text(stmt, 1, [theTid UTF8String], -1, nil);
    int result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    NSLog(@"删除微博结果 = %d",result);
    return result;
    
}










@end



















