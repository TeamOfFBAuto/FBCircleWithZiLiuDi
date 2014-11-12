//
//  SendPostsViewController.m
//  FBCircle
//zz
//  Created by soulnear on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "SendPostsViewController.h"
#import "SendPostsBottomView.h"
#import "SendPostsImageScrollView.h"
#import "TakePhotoView.h"
#import "MyImagePickViewController.h"
#import "TakePhotoPreViewController.h"
#import "WritePreviewDeleteViewController.h"///图片预览类
#import "CreateNewBBSViewController.h"
#import "ShowImagesViewController.h"

#define INPUT_HEIGHT 40.5

#define MAX_SHARE_WORD_NUMBER 30


@interface SendPostsViewController ()<UIScrollViewDelegate>
{
    UILabel * title_place_label;//标题框默认文字
    
    UILabel * content_place_label;//内容框默认字
    
    SendPostsBottomView * bottom_view;//底部视图 相机 相册
    
    QBImagePickerController * imagePickerC;//选取本地照片类
    
    SendPostsImageScrollView * imageScrollView;//显示图片
    
    NSMutableArray * allImageArray;//存放图片数据
    
    NSMutableArray * allAssesters;
    
    ///上传图片请求
    ASIFormDataRequest * image_request;
    ///发表帖子请求
    AFHTTPRequestOperation * posts_request;
    ///地理位置
    CLLocationManager * locationManager;
    
    ///提示
    MBProgressHUD * hud;
    
    UIScrollView * myScrollView;
}

@end

@implementation SendPostsViewController
@synthesize title_textView = _title_textView;
@synthesize content_textView = _content_textView;
@synthesize fid = _fid;
@synthesize location_string = _location_string;


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
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}


-(void)viewWillDisappear:(BOOL)animated
{

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel.text = @"新帖子";
    
    self.rightString = @"发表";
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    
    [self.my_right_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
//    self.my_right_button.userInteractionEnabled = NO;
    
    
    allImageArray = [NSMutableArray array];
    
    allAssesters = [NSMutableArray array];
    
    [self ShowLocation];
    
    
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT-64-40.5)];
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    
    
    _title_textView = [[UITextView alloc] initWithFrame:CGRectMake(10,5,300,35)];
    _title_textView.textAlignment = NSTextAlignmentLeft;
    _title_textView.textColor = [UIColor blackColor];
    _title_textView.scrollEnabled = YES;
    _title_textView.backgroundColor = [UIColor clearColor];
    _title_textView.returnKeyType = UIReturnKeyDone;
    _title_textView.delegate = self;
    _title_textView.font = [UIFont systemFontOfSize:15];
    [myScrollView addSubview:_title_textView];

    
    title_place_label = [[UILabel alloc] initWithFrame:CGRectMake(10,0,300,33)];
    title_place_label.font = [UIFont systemFontOfSize:15];
    title_place_label.textColor = RGBCOLOR(173,173,173);
    title_place_label.text = @"输入标题(必填)不超过30个字";
    title_place_label.textAlignment = NSTextAlignmentLeft;
    title_place_label.backgroundColor = [UIColor clearColor];
    title_place_label.userInteractionEnabled = NO;
    [_title_textView addSubview:title_place_label];
    
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15.5,43,320,0.5)];
    lineView.backgroundColor = RGBCOLOR(188,191,195);
    [myScrollView addSubview:lineView];
    
    _content_textView = [[UITextView alloc] initWithFrame:CGRectMake(10,50.5,300,65)];
    _content_textView.textAlignment = NSTextAlignmentLeft;
    _content_textView.textColor = RGBCOLOR(3,3,3);
    _content_textView.delegate = self;
    _content_textView.scrollEnabled = NO;
    _content_textView.returnKeyType = UIReturnKeyDone;
    _content_textView.backgroundColor = [UIColor clearColor];
    _content_textView.delegate = self;
    _content_textView.font = [UIFont systemFontOfSize:15];
    [myScrollView addSubview:_content_textView];
    
    content_place_label = [[UILabel alloc] initWithFrame:CGRectMake(10,0,300,33)];
    content_place_label.font = [UIFont systemFontOfSize:15];
    content_place_label.textColor = RGBCOLOR(173,173,173);
    content_place_label.text = @"输入正文";
    content_place_label.textAlignment = NSTextAlignmentLeft;
    content_place_label.backgroundColor = [UIColor clearColor];
    content_place_label.userInteractionEnabled = NO;
    [_content_textView addSubview:content_place_label];
    
    imageScrollView = [[SendPostsImageScrollView alloc] initWithFrame:CGRectMake(0,content_place_label.bottom + 30 + 25,320,150)];//lcw
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.showsVerticalScrollIndicator = NO;
    
    [myScrollView addSubview:imageScrollView];
    
    __weak typeof(self) bself = self;
    
    //选择相册 或是 相机
    bottom_view = [[SendPostsBottomView alloc] initWithFrame:CGRectMake(0,(iPhone5?568:480)-40.5-64,320,40.5) WithBlock:^(int index) {
        
        switch (index) {
            case 0://相机
            {
                [bself takePhotos];
            }
                break;
            case 1://相册
            {
                [bself localPhotos];
            }
                break;
                
            default:
                break;
        }
        
    }];

    
    [self.view addSubview:bottom_view];
    
    [self addNotificationObserVer];
    
}

#pragma mark - 发表帖子

-(void)submitData:(UIButton *)sender
{
    [_title_textView resignFirstResponder];
    [_content_textView resignFirstResponder];
    
    NSString * titleString = [_title_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (titleString.length == 0)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"请输入标题" message:@""delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
        [alertView show];
        
        return;
    }
    
    
    
    if (allImageArray.count > 0)
    {
        hud = [ZSNApi showMBProgressWithText:@"正在发送" addToView:self.navigationController.view];
        [self upDataImages];
    }else
    {
        NSString * contentString = [_content_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (contentString.length == 0)
        {
            [ZSNApi showAutoHiddenMBProgressWithText:@"图片跟内容不能同时为空" addToView:self.view];
            return;
        }
        hud = [ZSNApi showMBProgressWithText:@"正在发送" addToView:self.navigationController.view];
        
        [self uploadNewBBSPostsHaveImages:NO WithImageID:@""];
    }
}

///上传图片
#define TT_CACHE_EXPIRATION_AGE_NEVER     (1.0 / 0.0)   // inf

-(void)upDataImages
{
    NSString* fullURL = [NSString stringWithFormat:BBS_UPLOAD_IMAGES_URL,[SzkAPI getAuthkey]];
    
    NSLog(@"上传图片的url  ——--  %@",fullURL);
    
    image_request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:fullURL]];
    //    request.delegate = self;
    image_request.tag = 1;
    
    [image_request setRequestMethod:@"POST"];
    image_request.timeOutSeconds = 45;
    image_request.cachePolicy = TT_CACHE_EXPIRATION_AGE_NEVER;
    image_request.cacheStoragePolicy = ASICacheForSessionDurationCacheStoragePolicy;
    [image_request setPostFormat:ASIMultipartFormDataPostFormat];
    
    NSLog(@"imagearray -----  %@",allImageArray);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        //得到图片的data
        NSData* data;
        //获取图片质量
        //  NSString *tupianzhiliang=[[NSUserDefaults standardUserDefaults] objectForKey:TUPIANZHILIANG];
        
        NSMutableData *myRequestData=[NSMutableData data];
        
        for (int i = 0;i < allImageArray.count; i++)
        {
            UIImage *image=[allImageArray objectAtIndex:i];
            
            //  UIImage * newImage = [SzkAPI scaleToSizeWithImage:image size:CGSizeMake(image.size.width>1024?1024:image.size.width,image.size.width>1024?image.size.height*1024/image.size.width:image.size.height)];
            
            data = UIImageJPEGRepresentation(image,0.5);
            
            [image_request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [myRequestData length]]];
            
            //设置http body
            
            [image_request addData:data withFileName:[NSString stringWithFormat:@"forum_img[%d].png",i] andContentType:@"image/PNG" forKey:@"forum_img[]"];
            
            //  [request addData:myRequestData forKey:[NSString stringWithFormat:@"boris%d",i]];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            
            [image_request startAsynchronous];
        });
    });
    
    
    __block ASIHTTPRequest * finishedRequest = image_request;
    
    [finishedRequest setCompletionBlock:^{
        
        @try {
            __weak typeof(self) bself=self;
            
            NSDictionary * allDic = [image_request.responseString objectFromJSONString];
            
            NSLog(@"allDic ----   %@",allDic);
            
                if ([[allDic objectForKey:@"errcode"] intValue] == 0) {
                    
                    NSArray * imageArray = [allDic objectForKey:@"datainfo"];
                    
                    NSMutableArray * id_array = [NSMutableArray array];
                    
                    for (NSDictionary * dic in imageArray) {
                        [id_array addObject:[dic objectForKey:@"imageid"]];
                    }
                    
                    NSString * ids = [id_array componentsJoinedByString:@","];
                    
                    [bself uploadNewBBSPostsHaveImages:YES WithImageID:ids];
                    
                }else
                {
                    //                [bself sendErrorWith:[allDic objectForKey:@"errinfo"]];
                    hud.labelText = [allDic objectForKey:@"errinfo"];
                    [hud hide:YES afterDelay:1.5];
                }
        }
        @catch (NSException *exception) {
            NSLog(@"exception -----  %@",exception);
        }
        @finally {
            
        }
    }];
    
    [finishedRequest setFailedBlock:^{
        hud.labelText = @"发送失败,请重试";
        [hud hide:YES afterDelay:1.5];
    }];
}

///发表帖子

-(void)uploadNewBBSPostsHaveImages:(BOOL)haveImage WithImageID:(NSString *)images
{
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:BBS_UPLOAD_POSTS_URL]];
    [request setPostValue:self.fid forKey:@"fid"];
    [request setPostValue:[SzkAPI getAuthkey] forKey:@"authkey"];
    [request setPostValue:[_title_textView.text stringByReplacingEmojiUnicodeWithCheatCodes] forKey:@"title"];
    [request setPostValue:[_content_textView.text stringByReplacingEmojiUnicodeWithCheatCodes] forKey:@"content"];
    [request setPostValue:images forKey:@"imgid"];
    [request setPostValue:_location_string forKey:@"address"];
    
    __weak typeof(request)arequest = request;
    __weak typeof(self)bself = self;
    __weak typeof(hud)bhud = hud;
    [request setCompletionBlock:^{
        
        @try {
            NSDictionary * allDic = [arequest.responseString objectFromJSONString];
            if ([[allDic objectForKey:@"errcode"] intValue] == 0)
            {
                bhud.labelText = @"发送成功";
                [bhud hide:YES afterDelay:1.5];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UPDATE_TOPICLIST object:nil];
                
                [bself performSelector:@selector(comeBack) withObject:nil afterDelay:1.5];
                
                
            }else
            {
                NSLog(@"error ---  %@",[allDic objectForKey:@"errinfo"]);
                bhud.labelText = [allDic objectForKey:@"errinfo"];
                [bhud hide:YES afterDelay:1.5];
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }];
    
    [request setFailedBlock:^{
        bhud.labelText = @"发送失败,请重试";
        [bhud hide:YES afterDelay:1.5];
    }];
    
    [request startAsynchronous];
    
    
    
    /*
    NSString * fullUrl = [NSString stringWithFormat:BBS_UPLOAD_POSTS_URL,[SzkAPI getAuthkey],self.fid,_title_textView.text,_content_textView.text,images,_location_string];
    NSLog(@"发表帖子接口 -- %@",fullUrl);
    
    NSURL * url = [NSURL URLWithString:[fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    posts_request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url]];
    
    __weak typeof(self)bself = self;
    __weak typeof(hud)bhud = hud;
    
    [posts_request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        NSLog(@"发表帖子 ---- %@",allDic);
        
        @try {
            
            if ([[allDic objectForKey:@"errcode"] intValue] == 0)
            {
                bhud.labelText = @"发送成功";
                [bhud hide:YES afterDelay:1.5];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UPDATE_TOPICLIST object:nil];
                
                [bself performSelector:@selector(comeBack) withObject:nil afterDelay:1.5];
                
                
            }else
            {
                NSLog(@"error ---  %@",[allDic objectForKey:@"errinfo"]);
                bhud.labelText = [allDic objectForKey:@"errinfo"];
                [bhud hide:YES afterDelay:1.5];
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        bhud.labelText = @"发送失败,请重试";
        [bhud hide:YES afterDelay:1.5];
    }];
    
    [posts_request start];
     */
}

-(void)comeBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

//添加观察者
-(void)addNotificationObserVer
{
    //弹出键盘
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //隐藏键盘
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//删除观察者
-(void)deleteNotificationObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - 弹出收回键盘

-(void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
    
}

-(void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[ZSNApi animationOptionsForCurve:curve]
                     animations:^{
                         
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = bottom_view.frame;
                         
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;
                         if(inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;
                         
                         bottom_view.frame = CGRectMake(inputViewFrame.origin.x,
                                                                  inputViewFrameY,
                                                                  inputViewFrame.size.width,
                                                                  inputViewFrame.size.height);
                     }
                     completion:^(BOOL finished) {
                     }];
}


#pragma mark - 拍照

-(void)takePhotos
{
    
    UIImagePickerController * pickerC = [[UIImagePickerController alloc] init];
    
//    __weak typeof(self) bself = self;
    
//    TakePhotoView * view = [[TakePhotoView alloc] initWithFrame:CGRectMake(0,0,320,(iPhone5?568:480)) WithBlock:^(int index) {
//        
//        switch (index) {
//            case 0://拍照
//            {
//                [pickerC takePicture];
//            }
//                break;
//            case 1://关闭相机
//            {
//                [pickerC dismissViewControllerAnimated:YES completion:NULL];
//            }
//                break;
//                
//            default:
//                break;
//        }
//        
//    }];
    
//    view.backgroundColor = [UIColor clearColor];
    
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
//        pickerC.modalPresentationStyle = UIModalPresentationFullScreen;
        pickerC.delegate = self;
        pickerC.allowsEditing = YES;
        pickerC.sourceType = sourceType;
//        pickerC.showsCameraControls = NO;
//        pickerC.cameraOverlayView = view;
        
        [self presentViewController:pickerC animated:YES completion:nil];
    }
    else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}



#pragma mark - 从相册选取


-(void)localPhotos
{
    if (!imagePickerC)
    {
        imagePickerC = nil;
    }
    
    imagePickerC = [[QBImagePickerController alloc] init];
    imagePickerC.delegate = self;
    imagePickerC.allowsMultipleSelection = YES;
    
    imagePickerC.assters = allAssesters;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerC];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}


#pragma mark-QBImagePickerControllerDelegate

-(void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
}


-(void)imagePickerController1:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    NSArray *mediaInfoArray = (NSArray *)info;

    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
    
    
    for (int i = 0;i < mediaInfoArray.count;i++)
    {
        UIImage * image = [[mediaInfoArray objectAtIndex:i] objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        [allImageArray addObject:image];
        
        [allAssesters addObject:[[mediaInfoArray objectAtIndex:i] objectForKey:@"UIImagePickerControllerReferenceURL"]];
    }
    
    [self loadSelectedImages];
}

-(void)imagePickerControllerWillFinishPickingMedia:(QBImagePickerController *)imagePickerController
{
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak typeof(self) bself = self;
    
    TakePhotoPreViewController * previewC = [[TakePhotoPreViewController alloc] initWithBlock:^{
        
        UIImage *image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        UIImage * newImage = [ZSNApi scaleToSizeWithImage:image1 size:CGSizeMake(720,960)];
        
        [allImageArray addObject:newImage];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:image1.CGImage orientation:(ALAssetOrientation)image1.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error )
         {
             //here is your URL : assetURL
             [allAssesters addObject:assetURL];
         }];
        
        [bself loadSelectedImages];
        
        [picker dismissViewControllerAnimated:NO completion:NULL];
    }];
    
    previewC.theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker pushViewController:previewC animated:YES];
}


#pragma mark - 获取地理位置

-(void)ShowLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
}

-(void)loadLocationDataWith:(CLLocation *)newLocation With:(NSArray *)array
{
    if (array.count > 0)
    {
        CLPlacemark *placemark = [array objectAtIndex:0];
        NSString * country = placemark.administrativeArea;
        NSString * city = placemark.subLocality;
        
        _location_string = [NSString stringWithFormat:@"%@ %@",country,city];

    }
}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    [manager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    __weak typeof(self) bself = self;
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error)
     {
         [bself loadLocationDataWith:newLocation With:array];
         
     }];
}


#pragma mark - 加载选择的图片


-(void)loadSelectedImages
{    
    [imageScrollView loadAllViewsWith:allImageArray WithBlock:^(int index,int preViewPage) {
        
        switch (preViewPage) {
            case 0://删除某张图片
            {
                [allImageArray removeObjectAtIndex:index];
                
                [allAssesters removeObjectAtIndex:index];
            }
                break;
            case 1://预览图片
            {
//                WritePreviewDeleteViewController * preViewVC = [[WritePreviewDeleteViewController alloc] init];
//                preViewVC.AllImagesArray = allImageArray;
//                preViewVC.currentPage = index;
//                [self presentViewController:preViewVC animated:YES completion:NULL];
                
                
                ShowImagesViewController * showImage = [[ShowImagesViewController alloc] init];
                showImage.allImagesUrlArray = allImageArray;
                showImage.currentPage = index;
//                [self presentViewController:showImage animated:YES completion:NULL];
                [self PushToViewController:showImage WithAnimation:YES];
                
                
            }
                break;
                
            default:
                break;
        }
    }];
    
}



-(UIView *)findView:(UIView *)aView withName:(NSString *)name{
    Class cl = [aView class];
    NSString *desc = [cl description];
    
    if ([name isEqualToString:desc])
        return aView;
    
    for (NSUInteger i = 0; i < [aView.subviews count]; i++)
    {
        UIView *subView = [aView.subviews objectAtIndex:i];
        subView = [self findView:subView withName:name];
        if (subView)
            return subView;
    }
    return nil;
}
-(void)addSomeElements:(UIViewController *)viewController
{
    UIView *PLCameraView=[self findView:viewController.view withName:@"PLCameraView"];
    UIView *bottomBar=[self findView:PLCameraView withName:@"PLCropOverlayBottomBar"];
    UIImageView *bottomBarImageForSave = [bottomBar.subviews objectAtIndex:0];
    UIButton *retakeButton=[bottomBarImageForSave.subviews objectAtIndex:0];
    [retakeButton setTitle:@"重拍" forState:UIControlStateNormal];  //左下角按钮
    UIButton *useButton=[bottomBarImageForSave.subviews objectAtIndex:1];
    [useButton setTitle:@"上传" forState:UIControlStateNormal];  //右下角按钮
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    [self addSomeElements:viewController];
}



#pragma mark - UITextView Delegate

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == _title_textView)
    {
        if (textView.text.length == 0)
        {
            title_place_label.text = @"输入标题(必填)不超过30个字";
        }else
        {
            title_place_label.text = @"";
            self.my_right_button.userInteractionEnabled = YES;
            [self.my_right_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
                if (toBeString.length > 30)
                {
                    textView.text = [toBeString substringToIndex:30];
                }
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
                
            }
        }
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else
        {
            if (toBeString.length > 30)
            {
                textView.text = [toBeString substringToIndex:30];
            }
        }
        
    }else
    {
        if (textView.text.length == 0)
        {
            content_place_label.text = @"输入正文";
        }else
        {
            content_place_label.text = @"";
        }
        [self resetViews];
    }
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


-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


#pragma mark - 计算帖子内容高度
-(void)resetViews
{
    ///初始化为40，标题占位
    float height = 40;
    
    float content_height = [ZSNApi returnLabelHeightForIos7:_content_textView.text WIthFont:15 WithWidth:_content_textView.frame.size.width];
    CGRect contentF = _content_textView.frame;
    contentF.size.height = content_height+20;
    _content_textView.frame = contentF;
    
    
    height += content_height + 10 + 10 + 10;//lcw 修改
    
    CGRect imageF = imageScrollView.frame;
    imageF.origin.y = height;
    imageScrollView.frame = imageF;
    
    height+=imageScrollView.frame.size.height;
    
    myScrollView.contentSize = CGSizeMake(0,height);
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


-(void)dealloc
{
    [self deleteNotificationObserver];
    
    for (int i = 0;i < imageScrollView.subviews.count;i++) {
        UIButton * button = [imageScrollView.subviews objectAtIndex:i];
        [button setImage:nil forState:UIControlStateNormal];
        button = nil;
    }
    
    imageScrollView = nil;
    
    for (int i = 0;i < allImageArray.count;i++) {
        UIImage * image = [allImageArray objectAtIndex:i];
        image = nil;
    }
    allImageArray = nil;
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
