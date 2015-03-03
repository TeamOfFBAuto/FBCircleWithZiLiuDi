//
//  FBCircleDetailViewController.m
//  FBCircle
//
//  Created by soulnear on 14-5-22.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBCircleDetailViewController.h"


#define INPUT_HEIGHT 44



@interface FBCircleDetailViewController ()

@end

@implementation FBCircleDetailViewController
@synthesize myTableView = _myTableView;
@synthesize theModel = _theModel;
@synthesize commentModel = _commentModel;
@synthesize data_array = _data_array;
@synthesize currentPage = _currentPage;
@synthesize inputToolBarView = _inputToolBarView;
@synthesize theTouchView = _theTouchView;
@synthesize isForward = _isForward;
@synthesize gmyMessagePassBlock = _gmyMessagePassBlock;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)back
{
    [self.inputToolBarView.myTextView resignFirstResponder];
    
    isMyTextView = NO;
    
    _theModel.isShowMenuView = NO;
    
    if (fbcircledetailviewblock)
    {
        fbcircledetailviewblock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}





-(void)loadCommentsWithPage:(int)thePage
{
    __weak typeof(self) bself = self;
    
    [_commentModel loadCommentsWithTid:_theModel.fb_tid Page:thePage WithCommentBlock:^(NSMutableArray *array)
     {
         [loadview stopLoading:1];
         
         if (array.count%10 != 0)
         {
             loadview.normalLabel.text = @"没有更多数据了";
         }else if (array.count == 0)
         {
             loadview.normalLabel.text = @"";
         }
         
         if (thePage == 1 && array.count < 10) {
             loadview.hidden = YES;
         }
         
        bself.data_array = [NSMutableArray arrayWithArray:array];
        [bself.myTableView reloadData];
         
    } WithFailedBlock:^(AFHTTPRequestOperation *opration) {
        [loadview stopLoading:1];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(FBCircleDetailhandleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(FBCircleDetailhandleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self.inputToolBarView.myTextView resignFirstResponder];
    
    isMyTextView = NO;
    
    _theModel.isShowMenuView = NO;
    
    if (fbcircledetailviewblock)
    {
        fbcircledetailviewblock();
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //执行我的消息界面设置的block 用于请求单个文章数据
    if (self.gmyMessagePassBlock) {
        
        self.gmyMessagePassBlock();
        
    }
 
    self.titleLabel.text = @"详情";
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    if (_isForward)
    {
       self.theModel = [self forwardToOriginWith:_theModel];
    }
    
    
    _commentModel = [[FBCircleCommentModel alloc] init];
    
    _currentPage = 1;
    
    temp_count = 1;
    
    isFace = YES;

    [self loadCommentsWithPage:_currentPage];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT-64-44) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];

    loadview=[[LoadingIndicatorView alloc]initWithFrame:CGRectMake(0, 900, DEVICE_WIDTH, 40)];
    _myTableView.tableFooterView = loadview;
    
    faceScrollView = [[WeiBoFaceScrollView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,215) target:self];
    faceScrollView.delegate = self;
    faceScrollView.bounces = NO;
    faceScrollView.contentSize = CGSizeMake(320*3,0);

    
    _inputToolBarView = [[ChatInputView alloc] initWithFrame:CGRectMake(0,DEVICE_HEIGHT-20-44-44,DEVICE_WIDTH,44)];
    _inputToolBarView.myTextView.delegate = self;
    _inputToolBarView.delegate = self;
    _inputToolBarView.myTextView.returnKeyType = UIReturnKeySend;
    _inputToolBarView.myTextView.textColor = RGBCOLOR(153,153,153);
    [self.view addSubview:_inputToolBarView];
    
    [_inputToolBarView.sendButton setTitle:nil forState:UIControlStateNormal];
    
    [_inputToolBarView.sendButton setImage:[UIImage imageNamed:isFace?@"biaoqing-icon-56_56.png":@"jianpan-icon-56_56.png"] forState:UIControlStateNormal];
    

    if ((_theModel.fb_tid.length == 0 || [_theModel.fb_tid isEqualToString:@"(null)"] || [_theModel isKindOfClass:[NSNull class]])&&![_flag isEqualToString:@"test"])
    {
        UIAlertView *a = [[UIAlertView alloc]initWithTitle:@"该文章不存在或已被删除" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [a show];
        
        return;
    }

    ///test
    if ([_flag isEqualToString:@"test"]) {
        [self testqushuju];
        
    }
}

-(void)testqushuju{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=getsingletopic&tid=%@&frm=%@&fbtype=json",self.wenzhangid,self.xiaoxiid]];
    
    NSLog(@"%@",url);
    
    __weak typeof(self) bself = self;
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         //接口返回数据 格式有时不对
         @try {
             //解析数据
             NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
             if ([[dataDic objectForKey:@"errcode"]intValue] == 1)
             {
                 UIAlertView *a = [[UIAlertView alloc]initWithTitle:@"该文章不存在或已被删除" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [a show];
                 return;
             }
             
             NSArray *dataInfoArray = [dataDic objectForKey:@"datainfo"];
             NSDictionary *wenzhangDic = dataInfoArray[0];
             bself.theModel = [[FBCircleModel alloc]initWithDictionary:wenzhangDic];
             [bself loadCommentsWithPage:_currentPage];
         }
         @catch (NSException *exception) {
             
         }
         @finally {
             
         }
     }];
}



#pragma mark - UIScrollViewDelegate


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height+40) && scrollView.contentOffset.y > 0)
    {
        if (loadview.normalLabel.hidden || [loadview.normalLabel.text isEqualToString:@"没有更多数据了"])
        {
            return;
        }
        
        [loadview startLoading];
        
        _currentPage++;
        
        [self loadCommentsWithPage:_currentPage];
    }
    
}



#pragma mark-UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_theModel.fb_tid.length == 0 || [_theModel.fb_tid isEqualToString:@"(null)"] || [_theModel isKindOfClass:[NSNull class]])
    {
        return 0;
    }
    
    
    int zan = _theModel.fb_praise_array.count;
    //szk修改
    // int pinglun = [_theModel.fb_reply_num intValue];
    int pinglun = _data_array.count;
    
    if (zan == 0 && pinglun == 0)
    {
        return _data_array.count + 1;
    }else
    {
        
        return _data_array.count + 2;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0;
    
    if (indexPath.row == 0)
    {
        if (!contentView) {
            contentView = [[FBCirlcleContentView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,0)];
        }
        
        height = [contentView setInfoWith:_theModel]-6;
        
        contentView.frame = CGRectMake(0,0,DEVICE_WIDTH,height);
        
    }else if (indexPath.row == 1)
    {
        if (_theModel.fb_praise_array.count == 0)
        {
            height = 5;
        }else
        {
            int rows = _theModel.fb_praise_array.count%6?1:0 + _theModel.fb_praise_array.count/6;
            
            height = 16+rows*40;
        }
    }else
    {
        FBCircleCommentModel * model = [self.data_array objectAtIndex:indexPath.row - 2];
        
        if (!fbCircleDetailCommentsView) {
            fbCircleDetailCommentsView = [[FBCircleDetailCommentsView alloc] init];
        }
        
        height = [fbCircleDetailCommentsView setInfomationWith:model isFirst:indexPath.row==2?YES:NO];
        
    }
    
    return height;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    
    if (indexPath.row == 0) {
    
        FBCirlcleContentView * contentView1 = [[FBCirlcleContentView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,0)];
        contentView1.delegate = self;
        
        contentView1.frame = CGRectMake(0,0,DEVICE_WIDTH,[contentView1 setInfoWith:_theModel]);
        NSLog(@"theContent ---  %@",_theModel.fb_face);
        [cell.contentView addSubview:contentView1];
        
        
        
    }else if (indexPath.row == 1)
    {
        FBCircleDetailPraiseView * thePraiseView = [[FBCircleDetailPraiseView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,[tableView rectForRowAtIndexPath:indexPath].size.height)];
        thePraiseView.delegate = self;
        [thePraiseView loadAllUserImagesWith:_theModel.fb_praise_array];
        [cell.contentView addSubview:thePraiseView];
    }else
    {
        
        FBCircleCommentModel * model = [self.data_array objectAtIndex:indexPath.row-2];
        
        FBCircleDetailCommentsView * commentsView = [[FBCircleDetailCommentsView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,[tableView rectForRowAtIndexPath:indexPath].size.height)];
        
        commentsView.delegate = self;
        
        [commentsView setInfomationWith:model isFirst:indexPath.row==2?YES:NO];
        
        [cell.contentView addSubview:commentsView];
        
        if (indexPath.row == self.data_array.count+1)
        {
            commentsView.bottomLine_view.hidden = NO;
        }else if (indexPath.row == 2)
        {
            commentsView.upLine_view.hidden = YES;
        }
        
        
        if (indexPath.row == 2) {
            commentsView.pinglun_logo.hidden = NO;
        }else
        {
            commentsView.pinglun_logo.hidden = YES;
        }
        
    }
    
    return cell;
}


-(void)reloadDataWhenBackWith:(FBCircleDetailViewControllerBlock)theBlock
{
    fbcircledetailviewblock = theBlock;
}


#pragma mark-FBCircleContentViewDelegate

-(void)clickToShowOriginalBlogWith:(FBCircleModel *)model
{
    
    if ([model.fb_sort isEqualToString:@"1"])//分享类型，跳到浏览器
    {
        FBCircleWebViewController * webVC = [[FBCircleWebViewController alloc] init];
        
        webVC.web_url = model.rfb_zan_num;
        
        [self.navigationController pushViewController:webVC animated:YES];
        
    }else//普通微博，跳到详情页
    {
        FBCircleModel * aModel = [self forwardToOriginWith:model];
        
        FBCircleDetailViewController * detailVC = [[FBCircleDetailViewController alloc] init];
        
        detailVC.theModel = aModel;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    
}


-(void)clickToShowMenu
{
    _theModel.isShowMenuView = !_theModel.isShowMenuView;
    
    [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)selectedButtonWithType:(FBCircleMenuType)theType
{
    [self clickToShowMenu];
    
    switch (theType) {
        case FBCircleMenuZan:
            [self praiseRequestWith];
            break;
        case FBCircleMenuPinglun:
            [self.inputToolBarView.myTextView becomeFirstResponder];
            
            break;
        case FBCircleMenuZhuanFa:
        {
            if ([_theModel.fb_uid isEqualToString:[SzkAPI getUid]])
            {
                [ZSNApi showAutoHiddenMBProgressWithText:@"不能转发自己的文章" addToView:self.view];
                return;
            }
            
            if ((_theModel.rfb_tid.length == 0 || [_theModel.rfb_tid isEqualToString:@"(null)"] || [_theModel.rfb_tid isKindOfClass:[NSNull class]]) && [_theModel.rfb_content isEqualToString:@"此内容已删除"])
            {
                myAlertView = [[FBQuanAlertView alloc]  initWithFrame:CGRectMake(0,0,138,50)];
                myAlertView.center = CGPointMake(DEVICE_WIDTH/2,DEVICE_HEIGHT/2-70);
                [myAlertView setType:FBQuanAlertViewTypeNoJuhua thetext:@"此内容已删除"];
                [self.view addSubview:myAlertView];
                [self performSelector:@selector(dismissPromptView) withObject:nil afterDelay:1];
                return;
            }
            
            __weak typeof(self) bself = self;
            
            ZSNAlertView * alertView = [[ZSNAlertView alloc] init];
            
            BOOL isForward = NO;
            
            if ([_theModel.fb_topic_type intValue] == 2)
            {
                isForward = YES;
            }
            
            
            [alertView setInformationWithUrl:isForward?_theModel.rfb_face:_theModel.fb_face WithUserName:isForward?_theModel.rfb_username:_theModel.fb_username WithContent:isForward?_theModel.rfb_content:_theModel.fb_content WithBlock:^(NSString *theString) {
                [bself ForwardBlogRequestWith:isForward WithMode:_theModel WithContent:theString];
            }];
            
            [alertView show];
            
        }
            
            break;
            
        default:
            break;
    }
}


-(void)dismissPromptView
{
    [myAlertView removeFromSuperview];
    
    myAlertView = nil;
}


-(void)praiseRequestWith
{
    
    FBCirclePraiseModel * praiseModel = [[FBCirclePraiseModel alloc] init];
    
    
    for (FBCirclePraiseModel * praiseModel in _theModel.fb_praise_array)
    {
        if ([praiseModel.praise_username isEqualToString:[SzkAPI getUsername]])
        {
            myAlertView = [[FBQuanAlertView alloc]  initWithFrame:CGRectMake(0,0,138,50)];
            myAlertView.center = CGPointMake(DEVICE_WIDTH/2,DEVICE_HEIGHT/2-70);
            [myAlertView setType:FBQuanAlertViewTypeNoJuhua thetext:@"您已经赞过了"];
            [self.view addSubview:myAlertView];
            [self performSelector:@selector(dismissPromptView) withObject:nil afterDelay:0.7];
            return;
        }
    }
    
    praiseModel.praise_image_url = [SzkAPI getUid];
    praiseModel.praise_uid = [SzkAPI getUid];
    praiseModel.praise_image_url = [SzkAPI getUserFace];
    praiseModel.praise_username = [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME];
    [_theModel.fb_praise_array insertObject:praiseModel atIndex:0];
    
    _theModel.fb_zan_num = [NSString stringWithFormat:@"%d",([_theModel.fb_zan_num intValue]+1)];
    
    [self.myTableView reloadData];
    
    
    NSString * fullUrl = [NSString stringWithFormat:FBCIRCLE_PRAISE_URL,[SzkAPI getAuthkeyGBK],_theModel.fb_tid];
    
    self.inputToolBarView.myTextView.text = @"";
    
    NSURLRequest * UrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:UrlRequest];
    
    __block AFHTTPRequestOperation * request = operation;
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        
        if ([[allDic objectForKey:@"errcode"] intValue] == 0) {
            NSLog(@"点赞成功");
        }else
        {
            NSLog(@"点赞失败保存到待发送事件");
            [FBCircleModel addNOSendPraiseWith:praiseModel];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"点赞失败保存到待发送事件");
        [FBCircleModel addNOSendPraiseWith:praiseModel];
    }];
    
    [operation start];
}


#pragma mark-ChatInputViewDelegate

-(void)sendMessageToSomeBodyWith:(NSString *)content
{
    isFace = !isFace;
    
    [_inputToolBarView.sendButton setImage:[UIImage imageNamed:isFace?@"biaoqing-icon-56_56.png":@"jianpan-icon-56_56.png"] forState:UIControlStateNormal];
    
    
    [self.inputToolBarView.myTextView resignFirstResponder];
    if (isFace)
    {
        self.inputToolBarView.myTextView.inputView = nil;
    }else
    {
        self.inputToolBarView.myTextView.inputView = faceScrollView;
    }
    
    [self.inputToolBarView.myTextView becomeFirstResponder];
    
}


#pragma mark-选择表情


-(void)expressionClickWith:(NewFaceView *)faceView faceName:(NSString *)name
{
    self.inputToolBarView.myTextView.text = [self.inputToolBarView.myTextView.text stringByAppendingString:name];
    [self textViewDidChange:self.inputToolBarView.myTextView];
}


#pragma mark-键盘弹出收起


- (void)FBCircleDetailhandleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
    
}

- (void)FBCircleDetailhandleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}


- (void)keyboardWillShowHide:(NSNotification *)notification
{
    if (!isMyTextView) {
        return;
    }
    
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
//	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:0.3
                          delay:0.0f
                        options:[ZSNApi animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = self.inputToolBarView.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;
                         if(inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;
                         
                         self.inputToolBarView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                  inputViewFrameY,
                                                                  inputViewFrame.size.width,
                                                                  inputViewFrame.size.height);
                         
                         
                         _theTouchView.frame = CGRectMake(0,0,DEVICE_WIDTH,self.inputToolBarView.frame.origin.y);
                     }
                     completion:^(BOOL finished) {
                     }];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _theTouchView.hidden = YES;
    self.inputToolBarView.frame = CGRectMake(0,DEVICE_HEIGHT-20-44-44,DEVICE_WIDTH,44);
    temp_count = 1;
    [self.inputToolBarView resetInputView];
    isMyTextView = NO;
}


#pragma mark - Text view delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    if (_theModel.fb_tid.length == 0) {
        return NO;
    }else
    {
        isMyTextView = YES;
        
        return YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    
    if (!_theTouchView)
    {
        _theTouchView = [[UIView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,self.inputToolBarView.frame.origin.y)];
        
        _theTouchView.backgroundColor = [UIColor clearColor];
        
        [self.view bringSubviewToFront:_theTouchView];
        
        [self.view addSubview:_theTouchView];
    }else
    {
        _theTouchView.hidden = NO;
    }
    
    //    if(!self.previousTextViewContentHeight)
    //		self.previousTextViewContentHeight = textView.contentSize.height;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    
    isMyTextView = NO;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (!temp_textView)
    {
        temp_textView = [[UITextView alloc] initWithFrame:CGRectMake(0,0,textView.frame.size.width,textView.frame.size.height)];
        
        temp_textView.font = [UIFont systemFontOfSize:15];
    }
    
    temp_textView.text = textView.text;
    
    CGFloat height = [temp_textView sizeThatFits:CGSizeMake(textView.frame.size.width,CGFLOAT_MAX)].height;
    
//    CGFloat textViewContentHeight = textView.contentSize.height;
    
    //    self.previousTextViewContentHeight = height - textViewContentHeight;
    
    int count = 1;
    
    if (height > 34)
    {
        count = ((height-34)/18)+1;
    }
    
    
    float theheight = (count-temp_count)*18;
    
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         
                         if (count > 6)
                         {
                             [self.inputToolBarView adjustTextViewHeightBy:count WihtHeight:0];
                             
                             return ;
                         }else
                         {
                             if (count == 6 && theheight < 0)
                             {
                                 return;
                             }
                             
                             CGRect inputViewFrame = self.inputToolBarView.frame;
                             
                             self.inputToolBarView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - theheight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + theheight);
                             
                             [self.inputToolBarView adjustTextViewHeightBy:count WihtHeight:theheight];
                             _theTouchView.frame = CGRectMake(0,0,DEVICE_WIDTH,self.inputToolBarView.frame.origin.y);
                         }
                     }
                     completion:^(BOOL finished) {
                         
                         
                     }];
    
    
    temp_count = count;
    
    
    self.inputToolBarView.sendButton.enabled = ([textView.text trimWhitespace].length > 0);
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound )
    {
        return YES;
    }
    
    [self sendPinglun];
    
    [txtView resignFirstResponder];
    isMyTextView = NO;
    
    return NO;
}

#pragma mark-转发

-(void)ForwardBlogRequestWith:(BOOL)isForward WithMode:(FBCircleModel *)model WithContent:(NSString *)string
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"正在发送" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    [alert show];
    
    
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_FORWARD]];
    [request setPostValue:[string stringByReplacingEmojiUnicodeWithCheatCodes] forKey:@"content"];
    [request setPostValue:[SzkAPI getAuthkey] forKey:@"authkey"];
    [request setPostValue:isForward?model.rfb_tid:model.fb_tid forKey:@"forwardtid"];
    
    __weak typeof(request)arequest = request;
    __weak typeof(self) bself = self;
    [request setCompletionBlock:^{
        @try {
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            
            NSDictionary * allDic = [arequest.responseString objectFromJSONString];
            
            if ([[allDic objectForKey:@"errcode"] intValue] == 0) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"转发成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
                [alertView show];
                
                bself.inputToolBarView.myTextView.text = @"";
            }else
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"转发失败" message:[allDic objectForKey:@"errinfo"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
                [alertView show];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }];
    
    [request setFailedBlock:^{
        
    }];
    
    [request startAsynchronous];
    
}


#pragma mark-发表评论


-(void)sendPinglun
{
    NSString * myTextString = [self.inputToolBarView.myTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (myTextString.length == 0)
    {
        myAlertView = [[FBQuanAlertView alloc]  initWithFrame:CGRectMake(0,0,138,50)];
        myAlertView.center = CGPointMake(DEVICE_WIDTH/2,DEVICE_HEIGHT/2-20);
        [myAlertView setType:FBQuanAlertViewTypeNoJuhua thetext:@"发送内容不能为空"];
        [self.view addSubview:myAlertView];
        [self performSelector:@selector(dismissPromptView) withObject:nil afterDelay:1];
        
        return;
    }
    
    NSString * content = self.inputToolBarView.myTextView.text;
    
    FBCircleCommentModel * commentModel = [[FBCircleCommentModel alloc] init];
    commentModel.comment_content = content;
    commentModel.comment_uid = [SzkAPI getUid];
    commentModel.comment_username = [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME];
    commentModel.comment_face = [ZSNApi returnUrl:[SzkAPI getUid]];
    
    //             [_theModel.fb_comment_array addObject:commentModel];
    
    [_theModel.fb_comment_array insertObject:commentModel atIndex:0];
    
    _theModel.fb_reply_num = [NSString stringWithFormat:@"%d",([_theModel.fb_reply_num intValue]+1)];
    
    [self.myTableView reloadData];
    
    __weak typeof(self) bself = self;
    [UIView animateWithDuration:0.4 animations:^{
        _theTouchView.hidden = YES;
        bself.inputToolBarView.frame = CGRectMake(0,DEVICE_HEIGHT-20-44-44,DEVICE_WIDTH,44);
        temp_count = 1;
        [bself.inputToolBarView resetInputView];
        isMyTextView = NO;
    } completion:^(BOOL finished) {
        
    }];
    
    
    ASIFormDataRequest * comment_request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_REPLY]];
    [comment_request setPostValue:[SzkAPI getAuthkey] forKey:@"authkey"];
    [comment_request setPostValue:_theModel.fb_tid forKey:@"tid"];
    [comment_request setPostValue:[content stringByReplacingEmojiUnicodeWithCheatCodes] forKey:@"content"];
    __weak typeof(comment_request)brequest = comment_request;
    
    [brequest setCompletionBlock:^{
        @try {
            NSDictionary * allDic = [comment_request.responseString objectFromJSONString];
            
            [bself loadCommentsWithPage:1];
            
            if ([[allDic objectForKey:@"errcode"] intValue] == 0) {
                
            }else
            {
                //             UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[allDic objectForKey:@"errinfo"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
                //             [alertView show];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }];
    
    [brequest setFailedBlock:^{
        
    }];
    
    [comment_request startAsynchronous];
    
    
    
    /*
     
     NSString * fullUrl = [NSString stringWithFormat:FBCIRCLE_COMMENT_URL,[[NSUserDefaults standardUserDefaults] objectForKey:@"autherkey"],_theModel.fb_tid,_theModel.fb_uid,[[content stringByReplacingEmojiUnicodeWithCheatCodes] stringByAddingPercentEscapesUsingEncoding:  NSUTF8StringEncoding]];
    
    NSLog(@"发表评论接口 ----   %@",fullUrl);
    
    NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:fullUrl]];
    
    AFHTTPRequestOperation * requestOpration = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    
    __block AFHTTPRequestOperation * request = requestOpration;
    
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * allDic = [operation.responseString objectFromJSONString];
         
         [self loadCommentsWithPage:1];
         
         if ([[allDic objectForKey:@"errcode"] intValue] == 0) {
             
         }else
         {
//             UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[allDic objectForKey:@"errinfo"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
//             [alertView show];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];
    
    [requestOpration start];
     
     */
}



-(void)clickHeaderWith:(NSString *)theUid
{
    GRXX4ViewController * friendView = [[GRXX4ViewController alloc] init];
    friendView.passUserid = theUid;
    [[self navigationController] pushViewController:friendView animated:YES];
}


-(void)clickHeaderShowInfomationWith:(NSString *)theUid
{
    GRXX4ViewController * friendView = [[GRXX4ViewController alloc] init];
    friendView.passUserid = theUid;
    [[self navigationController] pushViewController:friendView animated:YES];
}


//原文转发转换


-(FBCircleModel *)forwardToOriginWith:(FBCircleModel *)forward_model
{
    
    FBCircleModel * aModel = [[FBCircleModel alloc] init];
    aModel.fb_tid = forward_model.rfb_tid;
    aModel.fb_uid = forward_model.rfb_uid;
    aModel.fb_username = forward_model.rfb_username;
    aModel.fb_content = forward_model.rfb_content;
    aModel.fb_imageid = forward_model.rfb_imageid;
    aModel.fb_topic_type = forward_model.rfb_topic_type;
    aModel.fb_zan_num = forward_model.rfb_zan_num;
    aModel.fb_reply_num = forward_model.rfb_reply_num;
    aModel.fb_forward_num = forward_model.rfb_forward_num;
    aModel.fb_replyid = forward_model.rfb_replyid;
    aModel.fb_rootid = forward_model.rfb_rootid;
    aModel.fb_ip = forward_model.rfb_ip;
    aModel.fb_lng = forward_model.rfb_lng;
    aModel.fb_lat = forward_model.rfb_lat;
    aModel.fb_area = forward_model.rfb_area;
    aModel.fb_status = forward_model.rfb_status;
    aModel.fb_deteline = forward_model.rfb_deteline;
    aModel.fb_image = forward_model.rfb_image;
    aModel.fb_praise_array = forward_model.rfb_praise_array;
    aModel.fb_face = forward_model.rfb_face;
    
    if ([forward_model.fb_sort isEqualToString:@"1"])
    {
        aModel.fb_sort = @"1";
        
        aModel.fb_topic_type = @"1";
        
        aModel.rfb_face = forward_model.rfb_face;
    }
    
    return aModel;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
