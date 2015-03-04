//
//  CreateNewBBSViewController.m
//  FBCircle
//
//  Created by soulnear on 14-8-8.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "CreateNewBBSViewController.h"
#import "CreateBBSChooseTypeViewController.h"
#import "FBQuanAlertView.h"
#import "UIImageView+WebCache.h"

#define MAX_NAME_NUMBER 8
#define MAX_INTRODUCTION_NUMBWE 50


@interface CreateNewBBSViewController ()
{
    NSArray * content_array;
    
    ///填写名称
    UITextView * name_tf;
    
    ///填写简介
    UITextView * introduction_tf;
    
    ///简介默认文字
    UILabel * introduction_placeHolder;
    
    ///名称默认文字
    
    UILabel * name_placeHolder;
    
    ///展示图标
    UIImageView * iconImage;
    
    ///展示分类
    UILabel * sub_label;
    
    ///论坛图标对应的数字
    int icon_num;
    
    ///论坛分类对应的数字
    int type_num;
    
    ///创建请求
    AFHTTPRequestOperation * create_request;
    
    ///提示框
    FBQuanAlertView * myAlertView;
    
}

@end

@implementation CreateNewBBSViewController




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
    
    self.titleLabel.text = @"创建新论坛";
    
    self.rightString = @"创建";
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    [self.my_right_button addTarget:self action:@selector(createBBS:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = RGBCOLOR(240,241,243);
    
    icon_num = 1;
    type_num = 1;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
    UIView * inputView = [self loadInputViews];
    
    [self.view addSubview:inputView];
    
    NSArray * contentArray = [NSArray arrayWithObjects:@"微论坛分类",@"微论坛的图标",nil];
    
    for (int i = 0;i < 2;i++)
    {
        UIView * select_view = [self loadIconOrClassificationViewsWithType:i WithFrame:CGRectMake(0,230 + 79*i,DEVICE_WIDTH,44) WithContent:[contentArray objectAtIndex:i]];
        
        select_view.tag = 100 + i;
        
        [self.view addSubview:select_view];
    }
    
    
    myAlertView = [[FBQuanAlertView alloc]  initWithFrame:CGRectMake(0,0,138,50)];
    myAlertView.center = CGPointMake(DEVICE_WIDTH/2,DEVICE_HEIGHT/2-70);
    myAlertView.hidden = YES;
    [self.view addSubview:myAlertView];
    
    
    [self addNotification];

}


#pragma mark - 注册观察者

-(void)addNotification
{

}

#pragma mark - 删除观察者

-(void)deleteNotification
{
    
}


#pragma mark - 键盘消失方法

-(void)keyboardHide:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

#pragma mark - 创建

-(void)createBBS:(UIButton *)button
{
    [self.view endEditing:YES];
    
    NSString * nameString = [name_tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * introductionString = [introduction_tf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString * error_string = @"";
    
    if (nameString.length == 0)
    {
        error_string = @"微论坛名称不能为空";
    }else if (nameString.length > 8)
    {
        error_string = @"微论坛名称不能超过8个字";
    }else if (introductionString.length > 50)
    {
        error_string = @"论坛简介不能超过50个字";
    }
    
    if (error_string.length > 0)
    {
        [ZSNApi showAutoHiddenMBProgressWithText:error_string addToView:self.navigationController.view];
        return;
    }
    
    
    if ([sub_label.text isEqualToString:@"必选"])
    {
        [ZSNApi showAutoHiddenMBProgressWithText:@"请选择微论坛分类" addToView:self.navigationController.view];
        return;
    }
    
    MBProgressHUD * hud = [ZSNApi showMBProgressWithText:@"正在创建" addToView:self.navigationController.view];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    
    
    
//    &authkey=%@&name=%@&intro=%@&headpic=%d&forumclass=%d
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:CREATE_MICRO_BBS_URL]];
    [request setPostValue:[name_tf.text stringByReplacingEmojiUnicodeWithCheatCodes] forKey:@"name"];
    [request setPostValue:[SzkAPI getAuthkey] forKey:@"authkey"];
    [request setPostValue:[introduction_tf.text stringByReplacingEmojiUnicodeWithCheatCodes] forKey:@"intro"];
    [request setPostValue:[NSString stringWithFormat:@"%d",icon_num] forKey:@"headpic"];
    [request setPostValue:[NSString stringWithFormat:@"%d",type_num] forKey:@"forumclass"];
    
    __weak typeof(request)arequest = request;
    __weak typeof(self)bself = self;
    [request setCompletionBlock:^{
        
        @try {
            
            hud.mode = MBProgressHUDModeText;
            
            NSDictionary * allDic = [arequest.responseString objectFromJSONString];
            
            NSLog(@"创建微论坛 ---  %@ ----  %@",allDic,[allDic objectForKey:@"errinfo"]);
            
            if ([[allDic objectForKey:@"errcode"] intValue] == 0)//创建成功返回
            {
                hud.labelText = @"创建成功";
                [hud hide:YES afterDelay:1.5];
                
                [bself performSelector:@selector(comeBack) withObject:nil afterDelay:1.5];
            }else
            {
                hud.labelText = [allDic objectForKey:@"errinfo"];
                [hud hide:YES afterDelay:1.5];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }];
    
    [request setFailedBlock:^{
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"创建失败,请重试";
        [hud hide:YES afterDelay:1.5];
    }];
    
    [request startAsynchronous];

    
    
    /*
    NSString * fullUrl = [NSString stringWithFormat:CREATE_MICRO_BBS_URL,[SzkAPI getAuthkey],name_tf.text,introduction_tf.text,icon_num,type_num];
    NSLog(@"创建微论坛接口 ---  %@",fullUrl);
    NSURL * url = [NSURL URLWithString:[fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    
    create_request = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    
    __weak typeof(self) bself = self;
    
    [create_request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        hud.mode = MBProgressHUDModeText;
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        
        NSLog(@"创建微论坛 ---  %@ ----  %@",allDic,[allDic objectForKey:@"errinfo"]);
        
        if ([[allDic objectForKey:@"errcode"] intValue] == 0)//创建成功返回
        {
            hud.labelText = @"创建成功";
            [hud hide:YES afterDelay:1.5];
            
            [bself performSelector:@selector(comeBack) withObject:nil afterDelay:1.5];
        }else
        {
            hud.labelText = [allDic objectForKey:@"errinfo"];
            [hud hide:YES afterDelay:1.5];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"创建失败,请重试";
        [hud hide:YES afterDelay:1.5];
    }];
    
    [create_request start];
     */
}
-(void)comeBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 展示弹出框

-(void)showAlertViewWithText:(NSString *)text WithType:(FBQuanAlertViewType)theType
{
    [myAlertView setType:theType thetext:text];
    myAlertView.hidden = NO;
    
    [self performSelector:@selector(hiddenAlertView) withObject:self afterDelay:1];
}

#pragma mark - 消失弹出框

-(void)hiddenAlertView
{
    myAlertView.hidden = YES;
}



#pragma mark - 加载输入框视图


-(UIView *)loadInputViews
{
    UIView * inputView = [[UIView alloc] initWithFrame:CGRectMake(0,36,DEVICE_WIDTH,159)];
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.layer.borderColor = RGBCOLOR(200,198,204).CGColor;
    inputView.layer.borderWidth = 0.5;
    inputView.layer.shadowColor = [UIColor blackColor].CGColor;
    inputView.layer.shadowOffset = CGSizeMake(0,1);
    inputView.layer.shadowOpacity = 0.07;
    ///线
    UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(13,44,DEVICE_WIDTH,0.5)];
    line_view.backgroundColor = RGBCOLOR(200,198,204);
    [inputView addSubview:line_view];
    
///输入论坛名字
    name_tf = [[UITextView alloc] initWithFrame:CGRectMake(10,7,DEVICE_WIDTH-20,30)];
    name_tf.backgroundColor = [UIColor whiteColor];
    name_tf.delegate = self;
    name_tf.returnKeyType = UIReturnKeyDone;
    name_tf.textAlignment = NSTextAlignmentLeft;
    name_tf.textColor = RGBCOLOR(31,31,31);
    name_tf.font = [UIFont systemFontOfSize:16];
    [inputView addSubview:name_tf];
    
///名字默认字
    name_placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(5,2,name_tf.frame.size.width-10,30)];
    name_placeHolder.text = @"微论坛名称(必填)不超过8个字";
    name_placeHolder.font = [UIFont systemFontOfSize:16];
    name_placeHolder.textAlignment = NSTextAlignmentLeft;
    name_placeHolder.textColor = RGBCOLOR(152,152,152);
    name_placeHolder.backgroundColor = [UIColor clearColor];
    [name_tf addSubview:name_placeHolder];
    
///输入论坛简介
    introduction_tf = [[UITextView alloc] initWithFrame:CGRectMake(10,44.5,DEVICE_WIDTH-20,114)];
    introduction_tf.textColor = [UIColor blackColor];
    introduction_tf.delegate = self;
    introduction_tf.returnKeyType = UIReturnKeyDone;
    introduction_tf.font = [UIFont systemFontOfSize:16];
    introduction_tf.backgroundColor = [UIColor whiteColor];
    introduction_tf.textAlignment = NSTextAlignmentLeft;
    [inputView addSubview:introduction_tf];
    
///简介默字
    introduction_placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(5,5,introduction_tf.frame.size.width-10,25)];
    introduction_placeHolder.text = @"微论坛简介,不超过50个字";
    introduction_placeHolder.font = [UIFont systemFontOfSize:16];
    introduction_placeHolder.textAlignment = NSTextAlignmentLeft;
    introduction_placeHolder.textColor = RGBCOLOR(152,152,152);
    introduction_placeHolder.backgroundColor = [UIColor clearColor];
    [introduction_tf addSubview:introduction_placeHolder];
    return inputView;
}


#pragma mark - 加载图标 分类


-(UIView *)loadIconOrClassificationViewsWithType:(int)theType WithFrame:(CGRect)frame WithContent:(NSString *)content
{
    ///背景
    UIView * inputView = [[UIView alloc] initWithFrame:frame];
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.layer.borderColor = RGBCOLOR(200,198,204).CGColor;
    inputView.layer.borderWidth = 0.5;
    inputView.layer.shadowColor = [UIColor blackColor].CGColor;
    inputView.layer.shadowOffset = CGSizeMake(0,1);
    inputView.layer.shadowOpacity = 0.07;
    ///点击方法
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    [inputView addGestureRecognizer:tap];
    
    //内容
    UILabel * content_label = [[UILabel alloc] initWithFrame:CGRectMake(10,0,250,frame.size.height)];
    content_label.textAlignment = NSTextAlignmentLeft;
    content_label.text = content;
    content_label.textColor = RGBCOLOR(31,31,31);
    content_label.backgroundColor = [UIColor clearColor];
    [inputView addSubview:content_label];
    
    
    if (theType == 1)///加载图片icon
    {
        iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-40,9.5,25,25)];
//        iconImage.image = [UIImage imageNamed:@"defaultPlaceHolder.png"];//张少南  这里需要修改下默认图片
        [inputView addSubview:iconImage];
        inputView.hidden = YES;
    }else
    {
        sub_label = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-170,0,140,frame.size.height)];
        sub_label.text = @"必选";
        sub_label.textAlignment = NSTextAlignmentRight;
        sub_label.backgroundColor = [UIColor clearColor];
        sub_label.font = [UIFont systemFontOfSize:17];
        sub_label.textColor = RGBCOLOR(31,31,31);
        [inputView addSubview:sub_label];
        
        UIImageView * arrow_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablecell_acessory_image.png"]];
        arrow_imageView.center = CGPointMake(DEVICE_WIDTH-22,frame.size.height/2);
        [inputView addSubview:arrow_imageView];
    }
    
    
    return inputView;
}


#pragma mark - 跳转到选图标界面或分类界面


-(void)doTap:(UITapGestureRecognizer *)sender
{
    [self keyboardHide:nil];
    
    switch (sender.view.tag-100)
    {
        case 1://跳转到选择图标界面
        {
            NSLog(@"跳转到选择图标界面");
            
//            CreateBBSChooseIconViewController * chooseIcon = [[CreateBBSChooseIconViewController alloc] init];
//            
//            chooseIcon.delegate = self;
//            
//            [self PushToViewController:chooseIcon WithAnimation:YES];
            
        }
            break;
        case 0://跳转到选择分类界面
        {
            CreateBBSChooseTypeViewController * chooseType = [[CreateBBSChooseTypeViewController alloc] init];
            
            [chooseType chooseTypeBlock:^(BBSModel * model)
            {
                UIView * input_view = (UIView *)[self.view viewWithTag:101];
                input_view.hidden = NO;
                
                sub_label.text = model.classname;
                [iconImage sd_setImageWithURL:[NSURL URLWithString:model.classpic] placeholderImage:[UIImage imageNamed:@"defaultPlaceHolder"]];
                icon_num = [model.id intValue];
                type_num = [model.id intValue];
            }];
            
            [self PushToViewController:chooseType WithAnimation:YES];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - UITextViewDelegate


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //碰到换行，键盘消失
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    int max_input_number;
        
    if (textView == name_tf)
    {
        max_input_number = MAX_NAME_NUMBER;
        
        if (textView.text.length == 0)
        {
            name_placeHolder.text = @"微论坛名称(必填)不超过8个字";
        }else
        {
            name_placeHolder.text = @"";
        }
    }else
    {
        max_input_number = MAX_INTRODUCTION_NUMBWE;
        
        if (textView.text.length == 0)
        {
            introduction_placeHolder.text = @"微论坛简介,不超过50个字";
        }else
        {
            introduction_placeHolder.text = @"";
        }
    }
    
    
    NSString *toBeString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > max_input_number)
            {
                textView.text = [toBeString substringToIndex:max_input_number];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (toBeString.length > max_input_number)
        {
            textView.text = [toBeString substringToIndex:max_input_number];
        }
    }
}


#pragma mark - 字数超出提示

-(void)showAlertViewWith:(NSString *)title
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    
    [alert show];
}



#pragma mark - 选取图标 完成代理

-(void)completeChooseIconWithImageName:(NSString *)imageName
{
    iconImage.image = [UIImage imageNamed:imageName];
}





#pragma mark - dealloc


-(void)dealloc
{    
    [self deleteNotification];
    
    name_tf = nil;
    
    introduction_placeHolder = nil;
    
    introduction_tf = nil;
    
    name_placeHolder = nil;
    
    content_array = nil;
    
    myAlertView = nil;
    
    [create_request cancel];
    
    create_request = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end



















