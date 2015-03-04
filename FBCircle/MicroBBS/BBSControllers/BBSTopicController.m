//
//  BBSTopicController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-7.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BBSTopicController.h"
#import "MyBBSViewController.h"
#import "HotTopicViewController.h"
#import "ClassifyBBSController.h"
#import "PraiseMemberController.h"
#import "ShowImagesViewController.h"
#import "BBSListViewController.h"

#import "LTools.h"
#import "LSecionView.h"
#import "BBSRecommendCell.h"
#import "SendPostsViewController.h"
#import "TopicCommentModel.h"
#import "BBSInfoModel.h"
#import "TopicModel.h"

#define LL_LEFT_X 13

typedef enum{
    Action_Topic_Info = 0,//帖子基本信息
    Action_Topic_Zan,//赞帖
    Action_Topic_Top,//置顶
    Action_Topic_Top_Cancel,//取消顶
    Action_Topic_Del//删除帖子
}Network_ACTION;

typedef enum{
    
    Inforum_Creater = 3,//帖子创建者
    Inforum_BBSOwner = 1, //坛主
    Inforum_Others = 2, //普通用户
    Inforum_Outer = 0 //不在论坛
    
}USER_INFORUM;

@interface BBSTopicController ()<UITableViewDataSource,UITableViewDelegate,OHAttributedLabelDelegate>
{
    UITableView *_table;
    int _pageNum;//评论页数
    
    LInputView *inputView;
    NSMutableArray *_dataArray;
    
    NSMutableArray *rowHeights;//所有高度
    NSDictionary *emojiDic;//所有表情
    NSMutableArray *labelArr;//所有label
    
    UIButton *moreBtn;//点击加载更多
    
    TopicModel *aTopicModel;//帖子
    BBSInfoModel *infoModel;//论坛
    
    NSString *zan_String;//赞人员
    UILabel *zan_names_label;//称赞人员label
    UILabel *zan_num_label;//赞个数
    UIImageView *zanImage;//赞 小图标(没有赞的时候 不限赞图标及赞数)
    
    USER_INFORUM user_Inform;//用户身份
    
    MBProgressHUD *_loading;
    
    LButtonView *bbs_nameLabel;
    UILabel *bbs_numLabel;
    
    BBSRecommendCell *temp_Cell;
    
}

@end

@implementation BBSTopicController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"主题帖";
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    [self.my_right_button addTarget:self action:@selector(clickToAddBBS) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *head = [self createHeadView];
    [self.view addSubview:head];
    
    //数据展示table
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, head.bottom, DEVICE_WIDTH, self.view.height - 44 - 20 - 45-head.height) style:UITableViewStylePlain];
    _table.backgroundColor = [UIColor clearColor];
    _table.delegate = self;
    _table.dataSource = self;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _table.separatorColor = COLOR_TABLE_LINE;
    [self.view addSubview:_table];
    
    
    [self createInputView];
    
    labelArr = [NSMutableArray array];
    rowHeights = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    
    
    // 加载提示
    
    _loading = [LTools MBProgressWithText:@"加载中..." addToView:self.view];
    
    _pageNum = 1;//从第二页开始
    
    //帖子信息
    
    [self networdAction:Action_Topic_Info];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _table.delegate = nil;
    _table.dataSource = nil;
    _table = nil;
    
    inputView = nil;
    moreBtn = nil;
    
    labelArr = nil;
    
    _dataArray = nil;
    
    rowHeights = nil;//所有高度
    emojiDic = nil;//所有表情
    
    aTopicModel = nil;
    
    temp_Cell = nil;
}

#pragma mark - 事件处理

- (void)updateBlock:(UpdateBlock)aBlock
{
    updateBlock = aBlock;
}

//进入称赞者页
- (void)clickTOPraiseMember:(UIGestureRecognizer *)tap
{
    PraiseMemberController *praise = [[PraiseMemberController alloc]init];
    self.title = @"";
    praise.tid = self.tid;
    [self PushToViewController:praise WithAnimation:YES];
}

//弹出赞视图
- (void)clickToZan:(UIButton *)sender
{
    NSLog(@"zan");
    
    LActionSheet *sheet = [[LActionSheet alloc]initWithTitles:@[@"赞",@"评论"] images:@[[UIImage imageNamed:@"add_zan-1"],[UIImage imageNamed:@"add_talk"]] sheetStyle:Style_SideBySide action:^(NSInteger buttonIndex) {
        
        if (buttonIndex == 0) {
            NSLog(@"赞");
            
            [self networdAction:Action_Topic_Zan];
            
        }else if (buttonIndex == 1)
        {
            NSLog(@"评论");
            
            [inputView.textView becomeFirstResponder];
        }
    }];
    [sheet showFromView:sender];
}
//进入我的论坛

- (void)clickToMyBBS:(UIButton *)sender
{
    MyBBSViewController *myBBS = [[MyBBSViewController alloc]init];
    myBBS.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myBBS animated:YES];
}

- (void)clickToMore:(UIButton *)sender
{
    [self getCommentList];
}
/**
 *  进入分类论坛
 */
- (void)clickToClassifyBBS
{
    ClassifyBBSController *classify = [[ClassifyBBSController alloc]init];
    classify.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:classify animated:YES];
}

/**
 *  添加论坛
 */
- (void)clickToAddBBS
{
    SendPostsViewController * sendPostVC = [[SendPostsViewController alloc] init];
    [self PushToViewController:sendPostVC WithAnimation:YES];
}

/**
 *  进入置顶帖子\删除
 */
- (void)clickToRecommend:(LButtonView *)btn
{
    BOOL ding = YES;//是否需要顶
    
    if ([aTopicModel.status integerValue] == 9)
    {
        ding = NO;
    }
    
    NSArray *titles;
    NSArray *images;
    if (user_Inform == Inforum_BBSOwner) {
        
        if (ding) {
            titles = @[@"置顶",@"删除"];
            images = @[[UIImage imageNamed:@"zhiding"],[UIImage imageNamed:@"dele"]];
        }else
        {
            titles = @[@"取消置顶",@"删除"];
            images = @[[UIImage imageNamed:@"quxiao"],[UIImage imageNamed:@"dele"]];
        }
        
        
    }else if (user_Inform == Inforum_Creater){
        
       titles = @[@"删除"];
        
    }else if (user_Inform == Inforum_Others || user_Inform == Inforum_Outer){
        
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    if (titles.count == 1) {
        
        LActionSheet *sheet = [[LActionSheet alloc]initWithTitles:titles images:@[[UIImage imageNamed:@"dele"]] sheetStyle:Style_Normal action:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                
                NSLog(@"删除");
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"删除帖子" message:@"确定从FB永久删除该帖子？" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
            
        }];
        
        [sheet showFromView:btn];
        return;
    }
    
    LActionSheet *sheet = [[LActionSheet alloc]initWithTitles:titles images:images sheetStyle:Style_Normal action:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            
            if (ding) {
                
                [weakSelf networdAction:Action_Topic_Top];
                NSLog(@"置顶");

            }else
            {
                [weakSelf networdAction:Action_Topic_Top_Cancel];
                NSLog(@"取消置顶");

            }
            
        }else if (buttonIndex == 1)
        {
            NSLog(@"删除");
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"删除帖子" message:@"确定从FB永久删除该帖子？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }

    }];
    
    [sheet showFromView:btn];
}

- (void)clickJoinBBS:(UIButton *)sender
{
   
}

/**
 *  进入帖子列表
 *
 *  @param sender
 */
- (void)clickToBBSList:(id)sender
{
    BBSListViewController *list = [[BBSListViewController alloc]init];
    list.bbsId = self.fid;
    [self PushToViewController:list WithAnimation:YES];
}

#pragma mark - 数据解析
/**
 *  评论数据解析
 */
- (void)parseComment:(NSDictionary *)comment
{
    
    if ([comment isKindOfClass:[NSDictionary class]]) {
        NSArray *data = [comment objectForKey:@"data"];
        for (NSDictionary *aDic in data) {
            
            TopicCommentModel *aModel = [[TopicCommentModel alloc]initWithDictionary:aDic];
            NSString *content = [NSString stringWithFormat:@"%@",aModel.content];
            content = [ZSNApi decodeSpecialCharactersString:content];
            
            aModel.content = [content stringByReplacingEmojiCheatCodesWithUnicode];
            
            [_dataArray addObject:aModel];
            aModel = nil;
        }
        [_table reloadData];
        
        int total = [[comment objectForKey:@"total"]integerValue];
        if (total > _pageNum) {
            
            _pageNum ++;
            
        }else
        {
//            [moreBtn setTitle:@"" forState:UIControlStateNormal];
//            moreBtn.userInteractionEnabled = NO;
            
            _table.tableFooterView = [self noMoreCommentFooter];
        }
    }

}

#pragma mark - 网络请求

- (void)sendComment:(NSString *)text
{
    [inputView clearContent];
    
    TopicCommentModel *aModel = [[TopicCommentModel alloc]init];
    aModel.username = [SzkAPI getUsername];
    aModel.content = text;
    aModel.time = [LTools timechangeToDateline];
    aModel.userface = [SzkAPI getUserFace];
    aModel.uid = [SzkAPI getUid];
    
    [self createRichLabelWithMessage:text isInsert:YES];
    [_dataArray insertObject:aModel atIndex:0];
    [_table reloadData];
    
//    inputView.textView.text = @"<#string#>";
}

/**
 *  添加评论
 */
- (void)addComment:(NSString *)text
{
    __weak typeof(self)weakSelf = self;
    
    text = [text stringByReplacingEmojiUnicodeWithCheatCodes];
    
    NSLog(@"comment2 %@",text);
    
    NSString *url = [NSString stringWithFormat:FBCIRCLE_COMMENT_ADD,[SzkAPI getAuthkey],text,self.fid,self.tid];
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            int errcode = [[result objectForKey:@"errcode"]integerValue];
            
            if (errcode == 0) {
                
                [weakSelf sendComment:text];
            }else
            {
                [LTools showMBProgressWithText:[dataInfo objectForKey:@"errinfo"] addToView:weakSelf.view];
            }
            
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        [LTools showMBProgressWithText:[failDic objectForKey:@"errinfo"] addToView:weakSelf.view];
    }];
}

/**
 *  添加评论
 */
- (void)networdAction:(Network_ACTION)action
{    
    NSString *url;
    if (action == Action_Topic_Zan) {
        
        url = [NSString stringWithFormat:FBCIRCLE_TOPIC_ZAN,[SzkAPI getAuthkey],self.tid];
        
    }else if (action == Action_Topic_Top)
    {
        url = [NSString stringWithFormat:FBCIRCLE_TOPIC_TOP,[SzkAPI getAuthkey],self.fid,self.tid];
        
    }else if (action == Action_Topic_Top_Cancel)
    {
        url = [NSString stringWithFormat:FBCIRCLE_TOPIC_TRIPTOP,[SzkAPI getAuthkey],self.fid,self.tid];
    }else if (action == Action_Topic_Info)
    {
        [_loading show:YES];
        
        url = [NSString stringWithFormat:FBCIRCLE_TOPIC_INFO,self.tid,1,L_PAGE_SIZE,[SzkAPI getUid]];
    }else if (action == Action_Topic_Del)
    {
        url = [NSString stringWithFormat:FBCIRCLE_TOPIC_DELETE,[SzkAPI getAuthkey],self.fid,self.tid];
    }
    
    __weak typeof(UITableView *)weakTable = _table;
    __weak typeof(self) weakSelf = self;
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        
        //帖子详情
        if (action == Action_Topic_Info) {
            
            [_loading hide:YES];
            
            NSDictionary *datainfo = [result objectForKey:@"datainfo"];
            if ([datainfo isKindOfClass:[NSDictionary class]]) {
                
                //帖子详情
                
                NSDictionary *thread = [datainfo objectForKey:@"thread"];
                if ([thread isKindOfClass:[NSDictionary class]]) {
                    
                    NSLog(@"topic info %@",thread);
                    
                    aTopicModel = [[TopicModel alloc]initWithDictionary:thread];
                }
                
                //用户是否在论坛中(决定用户权限) 0-不在，1-创建者，2-普通用户
                
                int inforum = [[datainfo objectForKey:@"inforum"]intValue];
                
                if (inforum == 0) {
                    
//                    [LTools showMBProgressWithText:@"当前用户不在该论坛" addToView:self.view];
                    
                    user_Inform = Inforum_Outer;
                    
                }else if (inforum == 1)
                {
                    NSLog(@"创建者--坛主");
                    
                    user_Inform = Inforum_BBSOwner;
                    
                }else if (inforum == 2)
                {
                    NSLog(@"普通用户");
                    
                    //判断和本帖子关系
                    
                    if ([aTopicModel.uid isEqualToString:[SzkAPI getUid]]) {
                        //是本帖子创建者,可以删除,不可以置顶
                        user_Inform = Inforum_Creater;
                        
                    }else
                    {
                        user_Inform = Inforum_Others;
                    }
                }
                
                //赞 人员
                
                NSDictionary *zan = [datainfo objectForKey:@"zan"];
                if ([zan isKindOfClass:[NSDictionary class]]) {
                    NSArray *data = [zan objectForKey:@"data"];
                    
                    NSMutableArray *arr = [NSMutableArray array];
                    for (NSDictionary *aDic in data) {
                        NSString *zan_name = [aDic objectForKey:@"username"];
                        [arr addObject:zan_name];
                    }
                    
                    zan_String = [arr componentsJoinedByString:@"、"];
                }

                
                //帖子所在论坛信息
                
                NSDictionary *foruminfo = [datainfo objectForKey:@"foruminfo"];
                
                infoModel = [[BBSInfoModel alloc]initWithDictionary:foruminfo];
                
                [weakSelf updateBBSInfo:infoModel.name bbsNum:infoModel.thread_num];
                
                weakTable.tableHeaderView = [weakSelf createTableHeaderView];
                weakTable.tableFooterView = [weakSelf createTableFooterView];
                
                //帖子评论
                
                NSDictionary *comment = [datainfo objectForKey:@"comment"];
                
                [weakSelf parseComment:comment];
            }
        }else
        {
            if ([result isKindOfClass:[NSDictionary class]]) {
                
                [LTools showMBProgressWithText:[result objectForKey:@"errinfo"] addToView:weakSelf.view];
                
            }
            
            //添加 赞 人员name
            if (action == Action_Topic_Zan)
            {
                NSMutableString *zan = [NSMutableString stringWithString:zan_names_label.text];
                
                if (zan.length == 0) {
                    
                    [zan appendString:[SzkAPI getUsername]];
                    
                }else
                {
                    [zan appendString:[NSString stringWithFormat:@"、%@",[SzkAPI getUsername]]];
                }
                
                zan_names_label.text = zan;
                zan_num_label.text = [NSString stringWithFormat:@"%d",[zan componentsSeparatedByString:@"、"].count];
                
                if ([zan_num_label.text intValue] > 0) {
                    
                        
                        zanImage.hidden = NO;
                        zan_num_label.hidden = NO;
                
                }
                
            }
            
            if (action == Action_Topic_Del)
            {
                if (updateBlock) {
                    updateBlock(YES,@{@"action": @"delete"});
                }
                
                [self popViewControllerDelay:1.5];
            }
            
            if (action == Action_Topic_Top) {
                
                aTopicModel.status = @"9";
            }
            
            if (action == Action_Topic_Top_Cancel) {
                aTopicModel.status = @"2";
            }
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"fail result %@",failDic);
        
        [_loading hide:YES];
        
        if (action == Action_Topic_Top) {
            
            int errcode = [[failDic objectForKey:@"errcode"]intValue];
            if (errcode == 2) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"置顶帖子过多" message:@"你只能最多置顶2个帖子,若想置顶本帖,请先取消其他已置顶帖子。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                return ;
            }
        }
        
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:weakSelf.view];
    }];
}


/**
 *  评论列表
 */
- (void)getCommentList
{
    __weak typeof(UITableView *)weakTable = _table;
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:FBCIRCLE_COMMENT_LIST,self.tid,_pageNum,L_PAGE_SIZE];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        [weakSelf parseComment:dataInfo];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic result %@",failDic);
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:weakSelf.view];
        int erroCode = [[failDic objectForKey:@"errcode"]integerValue];
        if (erroCode == 2) {
//            [moreBtn setTitle:@"没有更多评论" forState:UIControlStateNormal];
//            moreBtn.userInteractionEnabled = NO;
            
            weakTable.tableFooterView = [weakSelf noMoreCommentFooter];
        }
    }];
}

- (void)getBBSInfoId:(NSString *)bbsId
{
    __weak typeof(self)weakSelf = self;
    __weak typeof(UITableView *)weakTable = _table;
    
    NSString *url = [NSString stringWithFormat:FBCIRCLE_BBS_INFO,bbsId,[SzkAPI getUid]];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
        
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            
            BBSInfoModel *aBBSModel = [[BBSInfoModel alloc]initWithDictionary:dataInfo];
            
            [weakSelf updateBBSInfo:aBBSModel.name bbsNum:aBBSModel.thread_num];
            
            weakTable.tableHeaderView = [weakSelf createTableHeaderView];
            
            weakSelf.titleLabel.text = aBBSModel.name;
            
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [LTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:weakSelf.view];
        
    }];
}

#pragma mark - 视图创建
- (CGFloat)createRichLabelWithMessage:(NSString *)text isInsert:(BOOL)isInsert
{
    OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];

//    label.backgroundColor = [UIColor redColor];
    
    label.lineBreakMode = NSLineBreakByCharWrapping;
    
    text = [text stringByReplacingEmojiCheatCodesWithUnicode];
    
    [FBHelper creatAttributedText:text Label:label OHDelegate:self];
    
    NSNumber *heightNum = [[NSNumber alloc] initWithFloat:label.frame.size.height];
    
    if (isInsert) {
        [labelArr insertObject:label atIndex:0];
        label = nil;
    }else
    {
        [labelArr addObject:label];
        label = nil;
    }
    
    if (isInsert) {
        [rowHeights insertObject:heightNum atIndex:0];
    }else
    {
        [rowHeights addObject:heightNum];
        
    }
    
    return [heightNum floatValue];
}

- (void)createInputView
{
    __weak typeof(self) weakSelf = self;
    inputView = [[LInputView alloc]initWithFrame:CGRectMake(0, self.view.height - 45 - 20 - 44, DEVICE_WIDTH, 45)inView:self.view inputText:^(NSString *inputText) {

        NSLog(@"inputText %@",inputText);
        
        if ([LTools NSStringIsNull:inputText] == NO) {
            
            [weakSelf addComment:inputText];
            
        }else
        {
            [LTools showMBProgressWithText:@"评论内容不可以为空" addToView:weakSelf.view];
        }
        
    }];
    inputView.clearInputWhenSend = NO;;
    inputView.resignFirstResponderWhenSend = YES;
    
    [self.view addSubview:inputView];
}

//顶部论坛信息部分

- (UIView *)createHeadView
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    header.backgroundColor = [UIColor whiteColor];
    
    //论坛name
    
    bbs_nameLabel = [[LButtonView alloc]initWithFrame:CGRectMake(8, 0, 220, 40) leftImage:nil rightImage:nil title:infoModel.name target:self action:@selector(clickToBBSList:) lineDirection:Line_No];
    [header addSubview:bbs_nameLabel];
    
    //帖子数
//    NSString *title = [NSString stringWithFormat:@"%@帖子",infoModel.thread_num];
    bbs_numLabel = [LTools createLabelFrame:CGRectMake(bbs_nameLabel.right, 0, header.width - bbs_nameLabel.width - 13 - 8 - 8, 40-1 - 0.5) title:nil font:FONT_SIZE_SMALL align:NSTextAlignmentRight textColor:[UIColor colorWithHexString:@"627cbd"]];
    [header addSubview:bbs_numLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 40 - 0.5f, self.view.width,0.5f)];
    line.backgroundColor = RGBACOLOR(173.f, 176.f, 182.f,0.5);
    [header addSubview:line];
    
    return header;
}

//更新论坛信息

- (void)updateBBSInfo:(NSString *)bbsName bbsNum:(NSString *)number
{
    bbs_nameLabel.titleLabel.text = bbsName;
    NSString *title = [NSString stringWithFormat:@"%@帖子",number.length == 0 ? @"" : number];
    bbs_numLabel.text = title;
}

/**
 *  论坛基本信息部分
 */
- (UIView *)createBBSInfoViewFrame:(CGRect)aFrame
{
    UIView *basic_view = [[UIView alloc]initWithFrame:aFrame];
    basic_view.layer.cornerRadius = 3.f;
//    basic_view.layer.borderWidth = 0.5f;
//    basic_view.layer.borderColor = RGBCOLOR(182, 183, 189).CGColor;
    
//    //论坛name
//    
//    LButtonView *nameLabel = [[LButtonView alloc]initWithFrame:CGRectMake(0, 0, 220, 40) leftImage:nil rightImage:nil title:infoModel.name target:self action:@selector(clickToBBSList:) lineDirection:Line_No];
//    [basic_view addSubview:nameLabel];
    
//    //帖子数
//    NSString *title = [NSString stringWithFormat:@"%@帖子",infoModel.thread_num];
//    UILabel *numLabel = [LTools createLabelFrame:CGRectMake(nameLabel.right, 0, aFrame.size.width - nameLabel.width - 10 - 8, 40-1 - 0.5) title:title font:FONT_SIZE_SMALL align:NSTextAlignmentRight textColor:[UIColor colorWithHexString:@"627cbd"]];
//    [basic_view addSubview:numLabel];
    
    //精 帖

    UIImage *rightImage = [UIImage imageNamed:@"jiantou_down"];
    if (user_Inform == Inforum_Others || user_Inform == Inforum_Outer) {
        rightImage = nil;
    }
    
    UIImage *aImage = nil;
    
    if ([aTopicModel.status integerValue] == 1) { //精
        
        aImage = [UIImage imageNamed:@"jing"];
        
    }else if ([aTopicModel.status integerValue] == 9){ //顶
        
        aImage = [UIImage imageNamed:@"qi"];
        
    }else //正常
    {
        
    }
    //帖子名称
    
    NSString *title = [NSString stringWithString:aTopicModel.title];
    
    LButtonView *btnV = [[LButtonView alloc]initWithFrame:CGRectMake(0, 0, aFrame.size.width, 0) leftImage:aImage rightImage:rightImage title:title target:self action:@selector(clickToRecommend:) lineDirection:Line_No];
    [basic_view addSubview:btnV];
    
    btnV.titleLabel.numberOfLines = 0;
    btnV.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    btnV.titleLabel.font = [UIFont boldSystemFontOfSize:16];

    
    //调整高度
    
    CGFloat aWidth = btnV.titleLabel.width;
    
    if (rightImage && aImage) {
        
        aWidth = btnV.width - (btnV.imageView.right + 13) * 2;
        btnV.titleLabel.width = aWidth;
    }
    
    CGFloat aHeight = [LTools heightForText:title width:aWidth Boldfont:16];
    
    aHeight += 20.f;
    
    btnV.height = aHeight;
    btnV.titleLabel.height = aHeight;
    btnV.imageView.top = 12.f;
    btnV.rightImageView.top = 15.f;

    
    btnV.layer.cornerRadius = 3.f;
    
    basic_view.backgroundColor = [UIColor whiteColor];
    aFrame.size.height = aHeight;
    basic_view.frame = aFrame;
    
    
    return basic_view;
}

/**
 *  置顶帖子部分
 */
- (UIView *)createRecommendViewFrame:(CGRect)aFrame bgView:(UIView *)bgview
{
    CGFloat aWidth = aFrame.size.width - 8;
    
    UIView *recommed_view = [[UIView alloc]init];
    recommed_view.clipsToBounds = YES;
    
    
    bgview.backgroundColor = [UIColor whiteColor];
    bgview.clipsToBounds = YES;
    
    //头像
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(13, 15, 40, 40)];
    [headImage sd_setImageWithURL:[NSURL URLWithString:aTopicModel.authorhead] placeholderImage:[UIImage imageNamed:@"Picture_default_image"]];
    [recommed_view addSubview:headImage];
    
    //楼主
    NSString *name = aTopicModel.username;
    
    UILabel *nameLabel = [LTools createLabelFrame:CGRectMake(headImage.right + 11, headImage.top, [LTools widthForText:name boldFont:15], 18) title:name font:15 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"1b1b1d"]];
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    [recommed_view addSubview:nameLabel];
    
    UIButton *hintBtn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(nameLabel.right + 5, headImage.top, 35, 18) normalTitle:@"楼主" image:nil backgroudImage:nil superView:recommed_view target:nil action:nil];
    hintBtn.backgroundColor = [UIColor colorWithHexString:@"5c7bbe"];
    hintBtn.layer.cornerRadius = 3.f;
    [hintBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    //时间
    NSString *time = [LTools timechange:aTopicModel.time];
    UILabel *timeLabel = [LTools createLabelFrame:CGRectMake(aWidth - 13 - [LTools widthForText:time font:12], nameLabel.top, [LTools widthForText:time font:FONT_SIZE_SMALL], nameLabel.height) title:time font:12 align:NSTextAlignmentRight textColor:[UIColor lightGrayColor]];
    [recommed_view addSubview:timeLabel];
    
    //正文
    
    NSString *text = aTopicModel.content;
    UILabel *textLabel = [LTools createLabelFrame:CGRectMake(nameLabel.left, nameLabel.bottom + 5, aWidth - headImage.right - 20, [LTools heightForText:text width:aWidth - headImage.right - 20 font:15]) title:nil font:15 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"212226"]];
    textLabel.numberOfLines = 0;
    textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [recommed_view addSubview:textLabel];
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:4];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
    [textLabel setAttributedText:attributedString1];
    [textLabel sizeToFit];
    
    //图片
    
    NSArray *imageUrls = aTopicModel.img;
    
    __weak typeof(self)weakSelf = self;
    
    LNineImagesView *nineView = [[LNineImagesView alloc]initWithFrame:CGRectMake(textLabel.left, textLabel.bottom + 10, aWidth - headImage.right - 20 - 5, 0) images:imageUrls imageIndex:^(int index) {
        NSLog(@"slectIndex %d",index);
        
        ShowImagesViewController *showBigVC=[[ShowImagesViewController alloc]init];
        showBigVC.allImagesUrlArray= [NSMutableArray arrayWithArray:imageUrls];
        showBigVC.currentPage = index ;
        [weakSelf PushToViewController:showBigVC WithAnimation:YES];
    }];
    [recommed_view addSubview:nineView];
    
    //赞 图标、赞数、赞人员
    
    UIView *zan_view = [[UIView alloc]initWithFrame:CGRectMake(-0.5, nineView.bottom + 10, aWidth+0.7, 40)];
    zan_view.backgroundColor = [UIColor orangeColor];
//    zan_view.layer.borderWidth = 1.f;
//    zan_view.layer.borderColor = COLOR_TABLE_LINE.CGColor;
    zan_view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    [recommed_view addSubview:zan_view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTOPraiseMember:)];
    [zan_view addGestureRecognizer:tap];
    
    zanImage = [[UIImageView alloc]initWithFrame:CGRectMake(13, (40 - 16)/2.0 - 3, 16, 16)];
    zanImage.image = [UIImage imageNamed:@"add_zan"];
    [zan_view addSubview:zanImage];
    
    NSString *numberSter = [NSString stringWithFormat:@"%@",aTopicModel.zan_num];
    zan_num_label = [LTools createLabelFrame:CGRectMake(zanImage.right + 5, 0, [LTools widthForText:numberSter font:12], zan_view.height) title:numberSter font:FONT_SIZE_SMALL align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"596d96"]];
    zan_num_label.font = [UIFont systemFontOfSize:14.f];
    [zan_view addSubview:zan_num_label];
    
    
    if ([aTopicModel.zan_num intValue] == 0) {
        
        zanImage.hidden = YES;
        zan_num_label.hidden = YES;
    }
    
    
    NSString *names = zan_String;
    zan_names_label = [LTools createLabelFrame:CGRectMake(zan_num_label.right + 5, 0, 240 - 30, zan_view.height) title:names font:FONT_SIZE_SMALL align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"596d96"]];
    [zan_view addSubview:zan_names_label];
    
//    zan_names_label.backgroundColor = [UIColor orangeColor];
    
    //赞、评论按钮 上提到赞人员后面
    
    UIButton *zan_btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(zan_view.width - 10 - 30 - 10 - 5 + 1, 5, 30 + 20 + 10, 30) normalTitle:nil image:[UIImage imageNamed:@"add_fenlei"] backgroudImage:nil superView:nil target:self action:@selector(clickToZan:)];
    [zan_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    zan_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    zan_btn.backgroundColor = [UIColor redColor];
    
    [zan_view addSubview:zan_btn];
    
    //zan_view上边线
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, zan_view.width, 1)];
    line.backgroundColor = COLOR_TABLE_LINE;
    [zan_view addSubview:line];
    
    //时间view
    
//    UIView *time_view = [[UIView alloc]initWithFrame:CGRectMake(-1, zan_view.bottom, aWidth + 1, 40)];
//    time_view.backgroundColor = [UIColor whiteColor];
////    time_view.layer.borderWidth = 0.5f;
//    time_view.layer.borderColor = [UIColor colorWithHexString:@"f0f0f0"].CGColor;
//    [recommed_view addSubview:time_view];
//    
//    NSString *time_str = [LTools timestamp:aTopicModel.time];
//    UILabel *time_Label = [LTools createLabelFrame:CGRectMake(13, 0, 100, time_view.height) title:time_str font:15 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
//    [time_view addSubview:time_Label];
//    time_Label.font = [UIFont boldSystemFontOfSize:15];
    
//    UIButton *zan_btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(time_view.width - 10 - 30 - 10 - 5 + 1, zan_view.bottom + 5, 30 + 20 + 10, 30) normalTitle:nil image:[UIImage imageNamed:@"add_fenlei"] backgroudImage:nil superView:recommed_view target:self action:@selector(clickToZan:)];
//    [zan_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    zan_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    zan_btn.backgroundColor = [UIColor redColor];
    
    

    
    aFrame.size.height = zan_view.bottom;
    recommed_view.frame = aFrame;
    
    //b背景view
    aFrame.size.width -= 8;
    bgview.frame = aFrame;
    
    return recommed_view;
}

/**
 *  创建tableView的 headerView
 */
- (UIView *)createTableHeaderView
{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor clearColor];
    //基本信息部分
    
    UIView *basic_view = [self createBBSInfoViewFrame:CGRectMake(8, 15, DEVICE_WIDTH - 16, 0)];
    [headerView addSubview:basic_view];
    
    //遮盖圆角
    UIView *basic_bottom = [[UIView alloc]initWithFrame:CGRectMake(8, basic_view.bottom - 3, DEVICE_WIDTH - 16, 3)];
    basic_bottom.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:basic_bottom];
    
    UIView *basic_line = [[UIView alloc]initWithFrame:CGRectMake(8, basic_view.bottom - 1, DEVICE_WIDTH - 16, 1)];
    basic_line.backgroundColor = COLOR_TABLE_LINE;
    [headerView addSubview:basic_line];
    
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectZero];
    [headerView addSubview:bgview];
    
    UIView *recommed_view = [self createRecommendViewFrame:CGRectMake(8, basic_view.bottom, DEVICE_WIDTH - 16 + 8, 0) bgView:bgview];
    [headerView addSubview:recommed_view];
    
//    UIView *mask_view = [[UIView alloc]initWithFrame:CGRectMake(8, basic_view.bottom, 304, 3)];
//    mask_view.backgroundColor = [UIColor whiteColor];
//    [headerView addSubview:mask_view];
    
    
    headerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, basic_view.height + recommed_view.height + 15);
    
//    UIView *hh_view = [[UIView alloc]initWithFrame:CGRectMake(8, headerView.height - 10, 304, 10)];
//    hh_view.backgroundColor = [UIColor whiteColor];
//    [headerView addSubview:hh_view];
//
    
//    UIView *line_view = [[UIView alloc]initWithFrame:CGRectMake(8, headerView.height - 1, 304, 1)];
//    line_view.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
//    [headerView addSubview:line_view];

    
    return headerView;
}

- (UIView *)createTableFooterView
{
    UIView *footer_view = [[UIView alloc]initWithFrame:CGRectMake(8, 0, DEVICE_WIDTH - 16, 45 + 15)];
    footer_view.backgroundColor = [UIColor clearColor];
    
    UIView *bg_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH - 16, 45)];
    bg_view.backgroundColor = [UIColor whiteColor];
    bg_view.layer.cornerRadius = 3.f;
    [footer_view addSubview:bg_view];
    
    UIView *hh_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH - 16, 10)];
    hh_view.backgroundColor = [UIColor whiteColor];
    [footer_view addSubview:hh_view];
    
    UIView *line_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH - 16, 1)];
    line_view.backgroundColor = COLOR_TABLE_LINE;
    [footer_view addSubview:line_view];
    
    moreBtn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(12, 0, 150, footer_view.height - 15) normalTitle:@"查看更多评论..." image:nil backgroudImage:nil superView:footer_view target:self action:@selector(clickToMore:)];
    [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    moreBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    return footer_view;
}

//没有更多评论时的 footerView
- (UIView *)noMoreCommentFooter
{
    UIView *footer_view = [[UIView alloc]initWithFrame:CGRectMake(8, 0, DEVICE_WIDTH - 16, 15)];
    footer_view.backgroundColor = [UIColor clearColor];
    return footer_view;
}


#pragma mark - delegate


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [inputView resignFirstResponder];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self networdAction:Action_Topic_Del];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicCommentModel *aModel = [_dataArray objectAtIndex:indexPath.row];
    NSString *text = aModel.content;
    
    CGFloat labelHeight = 0.0;
    if (rowHeights.count > indexPath.row && [rowHeights objectAtIndex:indexPath.row]) {
        
        labelHeight = [[rowHeights objectAtIndex:indexPath.row] floatValue];
        
    }else
    {
        labelHeight = [self createRichLabelWithMessage:text isInsert:NO];
    }
    
//    NSLog(@"rowHeight %f",labelHeight);
    
    if (!temp_Cell) {
        temp_Cell = [[BBSRecommendCell alloc]init];
    }
    UIView *label = (UIView *)[labelArr objectAtIndex:indexPath.row];
    
    return [temp_Cell heightForCellData:text OHLabel:label];
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0)
{
    BBSRecommendCell *aCell =(BBSRecommendCell *)cell;
    if (aCell.content_label) {
        [aCell.content_label removeFromSuperview];//防止重绘
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier3 = @"BBSRecommendCell";
    
    BBSRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
    if (cell == nil) {
        cell = [[BBSRecommendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier3];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    TopicCommentModel *aModel = [_dataArray objectAtIndex:indexPath.row];
    NSString *text = aModel.content;
    
    if (labelArr.count > indexPath.row && [labelArr objectAtIndex:indexPath.row]) {
        
    }else
    {
        //否则没有,需要新创建
        [self createRichLabelWithMessage:text isInsert:NO];
        
    }
    
    UIView *label = (UIView *)[labelArr objectAtIndex:indexPath.row];
    
    [cell setCellData:text OHLabel:label];
    
    if ([aModel.userface isKindOfClass:[UIImage class]]) {
        cell.aImageView.image = (UIImage *)aModel.userface;
    }else
    {
    
        [cell.aImageView sd_setImageWithURL:[NSURL URLWithString:aModel.userface] placeholderImage:[UIImage imageNamed:@"Picture_default_image"]];
        
    }
    
    cell.nameLabel.text = aModel.username;
    cell.timeLabel.text = [LTools timechange:aModel.time];
    
    return cell;
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return footer_view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 45;
//}

@end
