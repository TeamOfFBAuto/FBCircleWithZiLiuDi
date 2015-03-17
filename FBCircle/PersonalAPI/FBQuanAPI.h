//
//  Header.h
//  FBCircle
//
//  Created by 史忠坤 on 14-5-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//
#pragma mark--公共类
//#import "pinyin.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "ZSNApi.h"
#import "FBQuanAlertView.h"
#import "EGORefreshTableHeaderView.h"
#import <CoreLocation/CoreLocation.h>
#import "ZActionSheet.h"



#ifndef FBCircle_Header_h
#define FBCircle_Header_h
//颜色

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]



//判断屏幕
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//判断系统
#define MY_MACRO_NAME ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//推送的token
//#define DEVICETOKEN @"token"
//通讯录
#define ADDRESSBOOK @"addressbook"
//autherkey
#define AUTHERKEY @"autherkey"
///autherkey_gbk
#define AUTHERKEY_GBK @"authkey_gbk"
//用户名
#define USERNAME @"username"
//用户id
#define USERID @"userid"

//用户头像

#define USERFACE @"userface"

//发表成功，刷新数据,用于通知
#define SUCCESSUPDATA @"successupdata"
//修改信息后，个人页面和fb圈刷新数据
#define UPDATAPERSONALINFORMATION @"chagePersonalInformation"
//fb圈的token
#define DEVICETOKEN @"pushdevicetoken"
//来了消息之后进行通知进入消息页面,这个是应用内的
#define COMEMESSAGES @"commessage"

//退出登录通知

#define SUCCESSLOGOUT @"successlogout"

//登陆成功通知

#define SUCCESSLOGIN @"successlogin"

//应用外来了推送用这个
#define YINGYONGWAINOTIFICATION @"wainotification"
//这个是默认图
#define   IMAGE_DEFAULT [UIImage imageNamed:@"bigImagesPlaceHolder.png"]

//
#define FBCIRCLE_DEFAULT_IMAGE [UIImage imageNamed:@"FBCircle_picture_default_new_image.png"]

#define FBCIRCLE_BACK_IMAGE [UIImage imageNamed:@"fanhui-daohanglan-20_38.png"]

#define FBCIRCLE_NAVIGATION_IMAGE [UIImage imageNamed:@"add_beijing@2x.png"]
#define FBCIRCLE_TABBAR_BACK_IMAGE [UIImage imageNamed:@"tabbar_back_image.png"]


//朋友列表做个缓存

#define FRIENDLISTDOCUMENT @"friendlistdocumentarray"

//短信验证码

#define MSDSENDAPI @"http://quan.fblife.com/index.php?c=interface&a=phonecode&phonenum=%@"

//获取推荐好友的接口

#define GETSUGGESTFRIENDLISTAPI @"http://quan.fblife.com/index.php?c=interface&a=getbuddy&authkey=%@==&btype=1"


//登录相关的接口
#define LOGINAPI @"http://quan.fblife.com/index.php?c=interface&a=dologin&uname=%@&upass=%@&token=%@&logtype=%d"
//注册相关的接口
#define REGISTAPI @"http://quan.fblife.com/index.php?c=interface&a=register&uname=%@&upass=%@&phone=%@&pcode=%@&email=%@&token=%@&fbtype=json"
//获取用户列表

#define GETFRIENDLIST @"http://quan.fblife.com/index.php?c=interface&a=getbuddy&authkey=%@"

//匹配通讯录的接口

#define PIPEIADDRESSBOOK @"http://quan.fblife.com/index.php?c=interface&a=getphonemember&authkey=UGQBZgNgB2MDPFA8AnkKZFIgUSwPMVVpB2VTcVprAG9SPQ==&phone=18601901680,15552499996&rname=etsfs*~^sdfafa"
//添加好友的接口

#define ADDFRIENDAPI @"http://quan.fblife.com/index.php?c=interface&a=addbuddy&authkey=%@&uid=%@&uname=%@"
//接受好友的接口

#define ACCEPTAPI @"http://quan.fblife.com/index.php?c=interface&a=confirmbuddy&authkey=%@&uid=%@"


//发表接口

#define PUBLISH_IMAGE @"http://quan.fblife.com/index.php?c=interface&a=uploadpic&authkey=%@&fbtype=json"

#define PUBLISH_IMAGE_TEXT @"http://quan.fblife.com/index.php?c=interface&a=topicpost&authkey=%@&content=%@&imageid=%@&fbtype=json"



#define PUBLISH_TEXT @"http://quan.fblife.com/index.php?c=interface&a=topicpost&authkey=%@&content=%@&fbtype=json"

//带个都有1.text 2.图片，3.地理位置

#define PUBLISH_IMAGE_TEXT_LOCATION @"http://quan.fblife.com/index.php?c=interface&a=topicpost&authkey=%@&content=%@&imageid=%@&lng=%f&lat=%f&area=%@&fbtype=json"
#define PUBLISH_TEXT_LOCATION @"http://quan.fblife.com/index.php?c=interface&a=topicpost&authkey=%@&content=%@&lng=%f&lat=%f&area=%@&fbtype=json"


#endif




//私信接口


#define MESSAGE_LIST_URL @"http://msg.fblife.com/api.php?c=index&authcode=%@"

#define MESSAGE_CHAT_URL @"http://msg.fblife.com/api.php?c=talk&touid=%@&maxid=%@&page=%d&authcode=%@"

#define MESSAGE_CHAT_SEND_MESSAGE_URL @"http://msg.fblife.com/api.php?c=send&toname=%@&&content=%@&authcode=%@&isfbring=1"



#pragma mark-FB圈接口

#define FBCIRCLE_URL @"http://quan.fblife.com/index.php?c=interface&a=getfrontpage&uid=%@&page=%d&ps=20&type=%d&fbtype=json"
//老版点赞接口
//#define FBCIRCLE_PRAISE_URL @"http://quan.fblife.com/index.php?c=interface&a=dopraise&authkey=%@&tid=%@&fbtype=json"
//新版点赞接口，对自留地微博点赞
#define FBCIRCLE_PRAISE_URL @"http://t.fblife.com/openapi/index.php?mod=dotopic&code=dianzan&authkey=%@&tid=%@&fbtype=json"
//发表评论的接口
#define FBCIRCLE_COMMENT_URL @"http://quan.fblife.com/index.php?c=interface&a=doreply&fbtype=json"

//#define FBCIRCLE_FORWARD_URL @"http://quan.fblife.com/index.php?c=interface&a=doforward&authkey=%@&tid=%@&touid=%@&content=%@&fbtype=json"
#define FBCIRCLE_FORWARD_URL @"http://quan.fblife.com/index.php?c=interface&a=doforward&fbtype=json"

#define FBCIRCLE_GET_COMMENTS_URL @"http://quan.fblife.com/index.php?c=interface&a=getreplys&tid=%@&page=%d&ps=10&fbtype=json"


#define FBCIRCLE_PERSONAL_INFO_URL @"http://quan.fblife.com/index.php?c=interface&a=getuser&uid=%@&fbtype=json"


#define FBCIRCLE_SHARE_URL @"http://quan.fblife.com/index.php?c=interface&a=sharepost&content=%@&ext_title=%@&ext_image=%@&ext_link=%@&ext_content=%@&authkey=%@"


//获取头像接口

#define FBCIRCLE_PERSONAL_IMAGE_URL @"http://quan.fblife.com/index.php?c=interface&a=getuserhead&uid=%@&fbtype=json"

//微论坛接口

#define FBCIRCLE_MICROBBS_BBSCLASS @"http://quan.fblife.com/index.php?c=forum&a=getforumclass"//官方论坛分类

#define FBCIRCLE_CLSSIFYBBS_SUB @"http://quan.fblife.com/index.php?c=forum&a=getclassforum&authkey=%@&page=%d&ps=%d&class=%@" //单个分类下所有论坛

#define FBCIRCLE_BBS_MINE @"http://quan.fblife.com/index.php?c=forum&a=myjoinforum&authkey=%@&page=%d&ps=%d"//我的论坛(加入，创建)

#define FBCIRCLE_RECOMMENTED_BBS @"http://quan.fblife.com/index.php?c=forum&a=tuijianforum&uid=%@"//推荐论坛

#define FBCIRCLE_BBS_INFO @"http://quan.fblife.com/index.php?c=forum&a=getforum&fid=%@&uid=%@"//论坛基本信息

#pragma mark - 微论坛成员部分

#define FBCIRCLE_BBS_MEMBER_JOIN @"http://quan.fblife.com/index.php?c=forum&a=joinforum&authkey=%@&fid=%@"//加入论坛
#define FBCIRCLE_BBS_MEMBER_LEAVER @"http://quan.fblife.com/index.php?c=forum&a=quitforum&authkey=%@&fid=%@"//退出论坛
#define FBCIRCLE_BBS_MEMBER_NUMBER @"http://quan.fblife.com/index.php?c=forum&a=forumuser&fid=%@&page=%d&ps=%d"//论坛成员数

//
#pragma mark - 搜索

#define FBCIRCLE_SEARCH_BBS @"http://quan.fblife.com/index.php?c=forum&a=searchforum&keyword=%@&page=%d&ps=%d" //搜论坛
#define FBCIRCLE_SEARCH_TOPIC @"http://quan.fblife.com/index.php?c=forum&a=searchthread&keyword=%@&page=%d&ps=%d" //搜帖子

//
#pragma mark - 微论坛主页 -- 帖子

#define FBCIRCLE_TOPIC_LIST @"http://quan.fblife.com/index.php?c=forum&a=getthreads&fid=%@&uid=%@&page=%d&ps=%d" //帖子列表
#define FBCIRCLE_TOPIC_LIST_HOT @"http://quan.fblife.com/index.php?c=forum&a=topcomthreads&page=%d&ps=%d" //热门帖子列表
#define FBCIRCLE_TOPIC_LIST_MYJOIN @"http://quan.fblife.com/index.php?c=forum&a=topcommythreads&authkey=%@&page=%d&ps=%d" //我关注的热门帖子列表

#define FBCIRCLE_TOPIC_INFO @"http://quan.fblife.com/index.php?c=forum&a=viewthread&tid=%@&page=%d&ps=%d&uid=%@"//帖子详情
#define FBCIRCLE_TOPIC_ZAN @"http://quan.fblife.com/index.php?c=forum&a=zanthread&authkey=%@&tid=%@"//赞帖子
#define FBCIRCLE_TOPIC_TOP @"http://quan.fblife.com/index.php?c=forum&a=topthread&authkey=%@&fid=%@&tid=%@"//置顶帖子
#define FBCIRCLE_TOPIC_TRIPTOP @"http://quan.fblife.com/index.php?c=forum&a=triptopthread&authkey=%@&fid=%@&tid=%@"//取消帖子置顶

#define FBCIRCLE_TOPIC_DELETE @"http://quan.fblife.com/index.php?c=forum&a=delthread&authkey=%@&fid=%@&tid=%@"//删除帖子

#define FBCIRCLE_TOPIC_ZAN_LIST @"http://quan.fblife.com/index.php?c=forum&a=getzan&tid=%@&page=%d&ps=%d"//帖子赞列表

//
#pragma  mark -  评论

#define FBCIRCLE_COMMENT_ADD @"http://quan.fblife.com/index.php?c=forum&a=addcomment&authkey=%@&content=%@&fid=%@&tid=%@" //发表评论
#define FBCIRCLE_COMMENT_LIST @"http://quan.fblife.com/index.php?c=forum&a=getcomment&tid=%@&page=%d&ps=%d" //评论列表



#pragma mark - 创建论坛接口
//#define CREATE_MICRO_BBS_URL @"http://quan.fblife.com/index.php?c=forum&a=createforum&authkey=%@&name=%@&intro=%@&headpic=%d&forumclass=%d"
#define CREATE_MICRO_BBS_URL @"http://quan.fblife.com/index.php?c=forum&a=createforum"


#pragma mark - 微论坛添加成员接口

#define ADD_MEMBER_URL @"http://quan.fblife.com/index.php?c=forum&a=addforumuser&authkey=%@&fid=%@&uids=%@"

#pragma mark - 创建帖子，上传图片接口

#define BBS_UPLOAD_IMAGES_URL @"http://quan.fblife.com/index.php?c=forum&a=uploadpic&authkey=%@"

#pragma mark - 发帖子接口

//#define BBS_UPLOAD_POSTS_URL @"http://quan.fblife.com/index.php?c=forum&a=addthread&authkey=%@&fid=%@&title=%@&content=%@&imgid=%@&address=%@"
#define BBS_UPLOAD_POSTS_URL @"http://quan.fblife.com/index.php?c=forum&a=addthread"

#pragma - mark 发现部分的接口

//更新用户经纬度
#define FBFOUND_UPDATAUSERLOCAL @"http://quan.fblife.com/index.php?c=interface&a=updateuserposition&authkey=%@&jing_lng=%f&wei_lat=%f"

//附近的人得出按距离排序的整个数组
#define FBFOUND_NEARBYPERSON @"http://quan.fblife.com/index.php?c=interface&a=getuseraround&authkey=%@"

//根据坐标算出救援队位置距离列表
#define FBFOUND_HELPLOCAL @"http://quan.fblife.com/index.php?c=interface&a=getsosaround&authkey=%@&page=%d&ps=%d"

//获取救援队的详细信息
#define FBFOUND_HELPINFO @"http://quan.fblife.com/index.php?c=interface&a=getsos&authkey=%@&sid=%d"

//根据authkey获取二维码
#define FBFOUND_MYERWEIMA @"http://ucache.fblife.com/ucode/api.php?uid=%@"

//根据一组uid获取用户信息
#define FUFOUND_USERSID @"http://quan.fblife.com/index.php?c=interface&a=getusers&uids=%@"



















