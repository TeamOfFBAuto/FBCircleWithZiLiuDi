//
//  FBCircleModel.h
//  FBCircle
//
//  Created by soulnear on 14-5-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//文章Model 具有网络请求功能

#import <Foundation/Foundation.h>
#import "FBCircleCommentModel.h"
#import "FBCirclePraiseModel.h"
#import "DataBase.h"
#import "FBCircleExtension.h"


typedef void(^FBCircleModelBlock)(NSMutableArray * array);

typedef void(^FBCircleCompletionBlock)(NSMutableArray * array);

typedef void(^FBCircleFailedBlock)(NSString * operation);



@interface FBCircleModel : NSObject
{
    FBCircleModelBlock fbcircleModelBlock;
    
    FBCircleCompletionBlock fbCircleCompletionBlock;
    
    FBCircleFailedBlock fbCircleFailedBlock;
    
    AFHTTPRequestOperation * fbCircleRequest;
    
    
    
    
}

@property(nonatomic,assign)BOOL time;//按时间分类标识
@property(nonatomic,strong)NSString *timeStr;//标准时间 2014-05-25

@property(nonatomic,strong)NSString * fb_tid;
@property(nonatomic,strong)NSString * fb_uid;
@property(nonatomic,strong)NSString * fb_username;
@property(nonatomic,strong)NSString * fb_content;
@property(nonatomic,strong)NSString * fb_imageid;
@property(nonatomic,strong)NSString * fb_topic_type;
@property(nonatomic,strong)NSString * fb_zan_num;
@property(nonatomic,strong)NSString * fb_reply_num;
@property(nonatomic,strong)NSString * fb_forward_num;
@property(nonatomic,strong)NSString * fb_replyid;
@property(nonatomic,strong)NSString * fb_rootid;
@property(nonatomic,strong)NSString * fb_ip;
@property(nonatomic,strong)NSString * fb_lng;
@property(nonatomic,strong)NSString * fb_lat;
@property(nonatomic,strong)NSString * fb_area;
@property(nonatomic,strong)NSString * fb_status;
@property(nonatomic,strong)NSString * fb_deteline;
@property(nonatomic,strong)NSMutableArray * fb_image;
@property(nonatomic,strong)NSString * fb_face;
//文章类型  0为普通微博  1 分享微博
@property(nonatomic,strong)NSString * fb_sort;


//转发

@property(nonatomic,strong)FBCircleModel * rfb_model;


@property(nonatomic,strong)NSString * rfb_tid;
@property(nonatomic,strong)NSString * rfb_uid;
@property(nonatomic,strong)NSString * rfb_username;//sort为0 存储用户名  为1 存储标题
@property(nonatomic,strong)NSString * rfb_content;
@property(nonatomic,strong)NSString * rfb_imageid;
@property(nonatomic,strong)NSString * rfb_topic_type;
@property(nonatomic,strong)NSString * rfb_zan_num; //sort为0 存储赞数量 为1时 存储链接地址
@property(nonatomic,strong)NSString * rfb_reply_num;
@property(nonatomic,strong)NSString * rfb_forward_num;
@property(nonatomic,strong)NSString * rfb_replyid;
@property(nonatomic,strong)NSString * rfb_rootid;
@property(nonatomic,strong)NSString * rfb_ip;
@property(nonatomic,strong)NSString * rfb_lng;
@property(nonatomic,strong)NSString * rfb_lat;
@property(nonatomic,strong)NSString * rfb_area;
@property(nonatomic,strong)NSString * rfb_status;
@property(nonatomic,strong)NSString * rfb_deteline;
@property(nonatomic,strong)NSMutableArray * rfb_image;
@property(nonatomic,strong)NSString * rfb_face; //sort为0 存储头像链接 为1时存储 图片地址
@property(nonatomic,strong)NSString * rfb_sort;


@property(nonatomic,strong)NSString * fb_authkey;

@property(nonatomic,strong)NSMutableArray * fb_comment_array;
@property(nonatomic,strong)NSMutableArray * fb_praise_array;

@property(nonatomic,strong)NSMutableArray * rfb_comment_array;
@property(nonatomic,strong)NSMutableArray * rfb_praise_array;

@property(nonatomic,strong)NSMutableArray * data_array;

@property(nonatomic,assign)BOOL isShowMenuView;


//


-(FBCircleModel *)initWithDictionary:(NSDictionary *)dic;

-(void)initHttpRequestWithUid:(NSString *)theUid Page:(int)thePage WithType:(int)theType WithCompletionBlock:(FBCircleCompletionBlock)theCompletionblock WithFailedBlock:(FBCircleFailedBlock)theFailedBlock;


//zking添加
@property(nonatomic,strong)NSArray *fbImageArray;





//查找所有未发送的说说

+(NSMutableArray *)findWaitingUploadBlogAll;


//添加未发送的说说

+(int)addWeiBoContentWithInfo:(FBCircleModel *)info;

//根据时间删除数据

+(int)deleteBlogByDateLine:(NSString *)theDate;

//删除所有的未发送的说说

+(int)deleteAllNOSendBlog;




#pragma mark- 未发送的赞的内容

+(int)addNOSendPraiseWith:(FBCirclePraiseModel *)info;

//查找所有的未发送的赞

+(NSMutableArray *)findAllWaitingUploadPraise;

//删除发送成功的赞

+(int)deletePraiseByDateLine:(NSString *)theDate;

+(int)deleteAllNOPraiseBlog;

#pragma mark- 未发送的删除的内容
//添加未发送的删除（没有删除model，暂用praisemodel）
+(int)addNOSendDeleteWith:(FBCirclePraiseModel *)info;

//查找所有的未发送的删除

+(NSMutableArray *)findAllWaitingUploadDelete;

//删除发送成功的删除

+(int)deleteDeleteByDateLine:(NSString *)theDate;

+(int)deleteAllNODeleteBlog;



#pragma mark - 未发送的评论相关

//添加等待发送的评论内容

+(int)addNOSendCommentWith:(FBCircleCommentModel *)info;

//查找所有的未发送的评论

+(NSMutableArray *)findAllWaitingUploadComments;

//删除发送成功的评论

+(int)deleteCommentsByDateLine:(NSString *)theDate;

+(int)deleteAllNOComments;

#pragma mark - 未发送的转发相关

//添加等待发送的转发内容

+(int)addNOSendForwardWith:(FBCircleCommentModel *)info;

//查找所有的未发送的转发

+(NSMutableArray *)findAllWaitingUploadForward;

//删除发送成功的转发

+(int)deleteForwardByDateLine:(NSString *)theDate;

+(int)deleteAllNOForwardBlog;










//缓存微博数据

//添加数据

+(int)addBlogWith:(FBCircleModel *)info;


//查找所有数据

+(NSMutableArray *)findAll;

//删除所有微博数据

+(int)deleteAllBlog;

//删除微博数据通过tid

+(int)deleteBlogWithTid:(NSString *)tid;

//删除原微博时修改数据库原微博rtid

+(int)updateRfbTidid:(NSString *)theNewTid WithTid:(NSString *)theTid;



#pragma mark- 评论相关

//添加评论内容

+(int)addCommentWith:(FBCircleCommentModel *)info withtid:(NSString *)tid;

+(int)deleteCommentByTid:(NSString *)theTid;

//删除所有评论内容

+(int)deleteallComments;

//通过tid查找评论内容

+(NSMutableArray *)findAllCommentByTid:(NSString *)theTid;


#pragma mark-赞相关

//添加赞内容

+(int)addPraiseWith:(FBCirclePraiseModel *)info withtid:(NSString *)tid;

//删除赞通过tid

+(int)deletePraiseByTid:(NSString *)theTid;

//删除所有赞内容

+(int)deleteallPraises;

//通过tid查找赞内容

+(NSMutableArray *)findAllPraiseByTid:(NSString *)theTid;


//返回图片url数组

+(NSMutableArray *)returnImageUrlWith:(NSString *)fb_images;





//缓存个人微博数据

//添加数据

+(int)addGzuji:(FBCircleModel *)info;


//查找所有数据

+(NSMutableArray *)findGzuji;

//删除所有微博数据

+(int)deleteAllGzuji;



@end






















