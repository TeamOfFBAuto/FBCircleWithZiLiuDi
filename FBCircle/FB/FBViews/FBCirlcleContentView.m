//
//  FBCirlcleContentView.m
//  FBCircle
//
//  Created by soulnear on 14-5-23.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBCirlcleContentView.h"

#define IMAGE_WIDHT 18
#define IMAGE_HEIGHT 18


@implementation FBCirlcleContentView
@synthesize delegate = _delegate;
@synthesize theFBModel = _theFBModel;
@synthesize headerImageView = _headerImageView;
@synthesize userName_label = _userName_label;
@synthesize date_label = _date_label;
@synthesize menu_button = _menu_button;
@synthesize content_label = _content_label;
@synthesize PictureViews = _PictureViews;

@synthesize forwardBackGroundImageView = _forwardBackGroundImageView;
@synthesize rUserName_label = _rUserName_label;
@synthesize rContent_label = _rContent_label;
@synthesize rPictuteViews = _rPictuteViews;
@synthesize rContentImageView = _rContentImageView;
@synthesize menu_background_view = _menu_background_view;
@synthesize jiantou_imageView = _jiantou_imageView;
@synthesize sep_line_view = _sep_line_view;

//新版设计

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = YES;
        
        if (!_headerImageView) {
            
            _headerImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(12,11,40,40)];
            _headerImageView.layer.masksToBounds = YES;
            _headerImageView.layer.cornerRadius = 5;
            [self addSubview:_headerImageView];
        }else
        {
            _headerImageView.image = nil;
        }
        
        
        if (!_userName_label) {
            _userName_label = [[UILabel alloc] initWithFrame:CGRectMake(64,11,DEVICE_WIDTH-120,18)];
            _userName_label.textAlignment = NSTextAlignmentLeft;
            _userName_label.textColor = RGBCOLOR(3,3,3);
            _userName_label.font = [UIFont boldSystemFontOfSize:15];
            _userName_label.backgroundColor = [UIColor clearColor];
            [self addSubview:_userName_label];
        }else
        {
            _userName_label.text = @"";
        }
        
        
        if (!_content_label) {
            _content_label = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(64,36,DEVICE_WIDTH-73,13)];
            _content_label.textAlignment = NSTextAlignmentLeft;
            _content_label.textColor = RGBCOLOR(4,4,4);
            _content_label.backgroundColor = [UIColor clearColor];
            _content_label.font = [UIFont systemFontOfSize:14];
            [self addSubview:_content_label];
        }else
        {
            _content_label.text = @"";
        }
        
        
        
        
        if (!_PictureViews) {
            _PictureViews = [[FBCirclePicturesViews alloc]  initWithFrame:CGRectMake(64,0,DEVICE_WIDTH-89,0)];
            
            [self addSubview:_PictureViews];
        }else
        {
            for (UIView * view in _PictureViews.subviews) {
                [view removeFromSuperview];
            }
            
            _PictureViews.frame = CGRectMake(64,0,DEVICE_WIDTH-89,0);
        }
        
        
        if (!_forwardBackGroundImageView) {
            
            _forwardBackGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(64,0,DEVICE_WIDTH-75,51)];
            
            _forwardBackGroundImageView.layer.borderWidth = 0.5;
            
            _forwardBackGroundImageView.layer.borderColor = [RGBCOLOR(229,229,229) CGColor];
            
            _forwardBackGroundImageView.userInteractionEnabled = YES;
            
            _forwardBackGroundImageView.backgroundColor = RGBCOLOR(247,247,247);
            
            [self addSubview:_forwardBackGroundImageView];
            
            
            UITapGestureRecognizer * aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOriginBlog)];
            
            [_forwardBackGroundImageView addGestureRecognizer:aTap];
            
        }else
        {
            _forwardBackGroundImageView.frame = CGRectMake(0,0,0,0);
        }
        
        
        if (!_rUserName_label) {
            _rUserName_label = [[UILabel alloc] initWithFrame:CGRectMake(54,5.5,DEVICE_WIDTH-140,20)];
            
            _rUserName_label.textAlignment = NSTextAlignmentLeft;
            
            _rUserName_label.textColor = RGBCOLOR(88,106,152);
            
            _rUserName_label.font = [UIFont systemFontOfSize:13];
            
            _rUserName_label.backgroundColor = [UIColor clearColor];
            
            [_forwardBackGroundImageView addSubview:_rUserName_label];
        }else
        {
            _rUserName_label.text = @"";
        }
        
        
        if (!_rContent_label) {
            _rContent_label = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(54,28,DEVICE_WIDTH-85,21)];
            _rContent_label.textAlignment = NSTextAlignmentLeft;
            _rContent_label.textColor = RGBCOLOR(3,3,3);
            _rContent_label.backgroundColor = [UIColor clearColor];
            _rContent_label.font = [UIFont systemFontOfSize:13];
            [_forwardBackGroundImageView addSubview:_rContent_label];
        }else
        {
            _rContent_label.text = @"";
        }
        
        
        if (!_rContentImageView) {
            _rContentImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(5,5.5,40,40)];
            _rContentImageView.clipsToBounds = YES;
            _rContentImageView.contentMode = UIViewContentModeScaleAspectFill;
            [_forwardBackGroundImageView addSubview:_rContentImageView];
        }else
        {
            _rContentImageView.image = nil;
        }
        
        
        
        if (!_date_label) {
            _date_label = [[UILabel alloc]  initWithFrame:CGRectMake(64,0,DEVICE_WIDTH-120,15)];
            _date_label.textColor = RGBCOLOR(120,120,120);
            _date_label.textAlignment = NSTextAlignmentLeft;
            _date_label.backgroundColor = [UIColor clearColor];
            _date_label.font = [UIFont systemFontOfSize:13];
            [self addSubview:_date_label];
        }else
        {
            _date_label.text = @"";
        }
        
        
        if (!_menu_button) {
            _menu_button = [UIButton buttonWithType:UIButtonTypeCustom];
            _menu_button.frame = CGRectMake(DEVICE_WIDTH-41,0,40,20);
            [_menu_button setImage:[UIImage imageNamed:@"pinglun-icon-66_24.png"] forState:UIControlStateNormal];
            [_menu_button addTarget:self action:@selector(clickMenuTap:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_menu_button];
        }
        
        
        if (!_menu_background_view) {
            _menu_background_view = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,0)];
            _menu_background_view.userInteractionEnabled = YES;
            [self addSubview:_menu_background_view];
        }else
        {
            _menu_background_view.frame = CGRectMake(0,0,DEVICE_WIDTH,0);
            
            for (UIView * view in _menu_background_view.subviews) {
                if (![view isKindOfClass:[FBCircleMenuView class]] && ![view isKindOfClass:[RTLabel class]])
                {
                    [view removeFromSuperview];
                }
            }
        }
        
        if (!_menu_view) {
            _menu_view = [[FBCircleMenuView alloc] initWithFrame:CGRectMake(0,10,DEVICE_WIDTH,0)];
            _menu_view.backgroundColor = RGBCOLOR(144,144,144);
            _menu_view.delegate = self;
            _menu_button.clipsToBounds = YES;
            [_menu_background_view addSubview:_menu_view];
        }else
        {
            _menu_view.frame = CGRectMake(0,0,DEVICE_WIDTH,0);
        }
    }
    
    
    if (!_sep_line_view) {
        _sep_line_view = [[UIImageView alloc] initWithFrame:CGRectMake(11,0,DEVICE_WIDTH-22.5,5)];
        _sep_line_view.backgroundColor = RGBCOLOR(221,221,221);
        
        //  [self addSubview:_sep_line_view];
    }
    
    return self;
}


-(float)setInfoWith:(FBCircleModel *)theInfo
{
    _theFBModel = theInfo;
    
    float cellHeight = 30;
    
    if ([theInfo.fb_uid isEqualToString:[SzkAPI getUid]])
    {
        [_headerImageView loadImageFromURL:[SzkAPI getUserFace] withPlaceholdImage:PERSONAL_DEFAULTS_IMAGE];
    }else
    {
        [_headerImageView loadImageFromURL:theInfo.fb_face withPlaceholdImage:PERSONAL_DEFAULTS_IMAGE];
    }
    
    _userName_label.text = theInfo.fb_username;
 
    
    /*
    _content_label.text = [[ZSNApi decodeSpecialCharactersString:theInfo.fb_content] stringByReplacingEmojiCheatCodesWithUnicode];
    CGRect contentFrame = _content_label.frame;
    CGSize optimumsSize = [_content_label optimumSize];
    cellHeight = cellHeight + 10 + optimumsSize.height;
    contentFrame.size.height = optimumsSize.height+3;
    _content_label.frame = contentFrame;
    */
    
    NSString * content = [[ZSNApi decodeSpecialCharactersString:theInfo.fb_content] stringByReplacingEmojiCheatCodesWithUnicode];
    
    [OHLableHelper creatAttributedText:content Label:_content_label OHDelegate:self WithWidht:IMAGE_WIDHT WithHeight:IMAGE_HEIGHT WithLineBreak:NO];
    cellHeight += _content_label.frame.size.height;
    
    
    if (theInfo.fb_imageid.length > 0)
    {
        
        NSMutableArray *arry_url=[NSMutableArray array];
        
        if ([theInfo.fb_imageid rangeOfString:@"assets"].length)
        {
            arry_url = theInfo.fb_image;
        }else
        {
            for (int i=0; i<theInfo.fb_image.count; i++)
            {
                [arry_url addObject:[theInfo.fb_image objectAtIndex:i]];
            }
        }
        
        int i = arry_url.count/3;
        
        int j = arry_url.count%3?1:0;
        
        float height = 75*(i+j)+2.5*(j + i - 1);
        
        _PictureViews.frame = CGRectMake(64,cellHeight+10,DEVICE_WIDTH-89,height);
        
        [_PictureViews setimageArr:arry_url withSize:75 isjuzhong:NO];
        
        
        [_PictureViews setthebloc:^(NSInteger index) {
            
            ShowImagesViewController * showImages = [[ShowImagesViewController alloc]init];
            showImages.allImagesUrlArray = arry_url;
            showImages.currentPage = index - 1;
            [[(UIViewController *)self.delegate navigationController] pushViewController:showImages animated:YES];
        }];
        
        cellHeight = cellHeight + 10 + height;
    }
    
    
    float forwardHeight = 0;
    
    if ([theInfo.fb_sort isEqualToString:@"1"])
    {
        forwardHeight = 51;
        
        _forwardBackGroundImageView.userInteractionEnabled = YES;
        
        _rUserName_label.hidden = YES;
        
        [OHLableHelper creatAttributedText:[theInfo.rfb_username stringByReplacingEmojiCheatCodesWithUnicode] Label:_rContent_label OHDelegate:self WithWidht:IMAGE_WIDHT WithHeight:IMAGE_HEIGHT WithLineBreak:YES];
        
        if (theInfo.rfb_face.length > 0 && ![theInfo.rfb_face isEqualToString:@"(null)"] && ![theInfo.rfb_face isKindOfClass:[NSNull class]])
        {
            [_rContentImageView loadImageFromURL:theInfo.rfb_face withPlaceholdImage:FBCIRCLE_DEFAULT_IMAGE];
            
            _rContent_label.frame = CGRectMake(54,5.5,DEVICE_WIDTH-140,40);
        }else
        {
            _rContent_label.frame = CGRectMake(5,5.5,(DEVICE_WIDTH-140)+49,_rContent_label.frame.size.height);
        }
        
        _forwardBackGroundImageView.frame = CGRectMake(64,cellHeight + 8,DEVICE_WIDTH-75,51);
        
        forwardHeight += 5;
        
    }else if ([theInfo.fb_topic_type isEqualToString:@"2"])
    {
        
        if (theInfo.rfb_username.length == 0 || [theInfo.rfb_username isEqualToString:@"(null)"] || [theInfo.rfb_username isKindOfClass:[NSNull class]])
        {
            forwardHeight = 30;
            
            _forwardBackGroundImageView.userInteractionEnabled = NO;
            
            _rUserName_label.hidden = YES;
            
            _forwardBackGroundImageView.frame = CGRectMake(64,cellHeight + 8,DEVICE_WIDTH-75,30);
            
            _rContent_label.frame = CGRectMake(5,8,DEVICE_WIDTH-85,_rContent_label.frame.size.height);
            
        }else
        {
            forwardHeight = 51;
            
            _forwardBackGroundImageView.userInteractionEnabled = YES;
            
            _rUserName_label.text = theInfo.rfb_username;
            _rUserName_label.hidden = NO;
                        
            _rUserName_label.frame = CGRectMake(54,5,DEVICE_WIDTH-140,20);
            
            [OHLableHelper creatAttributedText:[[ZSNApi decodeSpecialCharactersString:theInfo.rfb_content] stringByReplacingEmojiCheatCodesWithUnicode] Label:_rContent_label OHDelegate:self WithWidht:IMAGE_WIDHT WithHeight:IMAGE_HEIGHT WithLineBreak:YES];
            
            _rContent_label.frame = CGRectMake(54,28,DEVICE_WIDTH-140,_rContent_label.frame.size.height);
            
            if (theInfo.rfb_imageid.length > 0)
            {
                NSString * urlImage = @"";
                if (theInfo.rfb_image.count > 0) {
                    urlImage = [theInfo.rfb_image objectAtIndex:0];
                }
                [_rContentImageView loadImageFromURL:urlImage withPlaceholdImage:FBCIRCLE_DEFAULT_IMAGE];
                _rContent_label.frame = CGRectMake(54,28,DEVICE_WIDTH-140,20);
                
            }else
            {
                _rUserName_label.frame = CGRectMake(5,5,(DEVICE_WIDTH-140)+49,20);
                
                _rContent_label.frame = CGRectMake(5,28,(DEVICE_WIDTH-140)+49,20);
            }
            
            _forwardBackGroundImageView.frame = CGRectMake(64,cellHeight + 10,DEVICE_WIDTH-75,51);
            
        }
        
        forwardHeight += 10;
    }else
    {
        _forwardBackGroundImageView.frame = CGRectMake(0,0,0,0);
    }
    
    CGRect dateFrame = _date_label.frame;
    
    dateFrame.origin.y = cellHeight + forwardHeight + 10;
    
    _date_label.frame = dateFrame;
    
    //张少南 地理位置
    
    if ([theInfo.fb_area isEqualToString:@"(null)"] || theInfo.fb_area.length == 0)
    {
        _date_label.text = [ZSNApi timestamp:theInfo.fb_deteline];
    }else
    {
        _date_label.text = [NSString stringWithFormat:@"%@    %@",[ZSNApi timestamp:theInfo.fb_deteline],theInfo.fb_area];
    }
    
    
    if (theInfo.fb_tid.length > 0)
    {
        _menu_button.userInteractionEnabled = YES;
    }else
    {
        _menu_button.userInteractionEnabled = NO;
    }
    
    
    CGRect menubuttonFrame = self.menu_button.frame;
    
    menubuttonFrame.origin.y = _date_label.frame.origin.y;
    
    self.menu_button.frame = menubuttonFrame;
    
    
    cellHeight += 25;
    
    
    float menu_background_height = 0;
    
    if (theInfo.isShowMenuView)
    {
        _menu_view.frame = CGRectMake(0,menu_background_height + 5,DEVICE_WIDTH,38);
        
        menu_background_height += 40;
        
        _menu_background_view.frame = CGRectMake(0,menubuttonFrame.origin.y + menubuttonFrame.size.height,DEVICE_WIDTH,menu_background_height);
        
        _menu_background_view.image = [[UIImage imageNamed:@"FBCircle_menu_background_image.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:5];
        
        menu_background_height += 10;
    }
    
    
    _sep_line_view.frame = CGRectMake(_sep_line_view.frame.origin.x,cellHeight + forwardHeight + menu_background_height + 10,_sep_line_view.frame.size.width,_sep_line_view.frame.size.height);
    
    return cellHeight + forwardHeight + menu_background_height + 10;
    
}





//老版设计
/*
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self)
//    {
//        self.clipsToBounds = YES;
//        
//        if (!_headerImageView) {
//            
//            _headerImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(12,11,40,40)];
//            
//            _headerImageView.layer.masksToBounds = NO;
//            
//            _headerImageView.layer.cornerRadius = 5;
//            
//            [self addSubview:_headerImageView];
//        }else
//        {
//            _headerImageView.image = nil;
//        }
//        
//        
//        if (!_userName_label) {
//            _userName_label = [[UILabel alloc] initWithFrame:CGRectMake(64,15,200,15)];
//            
//            _userName_label.textAlignment = NSTextAlignmentLeft;
//            
//            _userName_label.textColor = RGBCOLOR(59,167,30);
//            
//            _userName_label.font = [UIFont systemFontOfSize:15];
//            
//            _userName_label.backgroundColor = [UIColor clearColor];
//            
//            [self addSubview:_userName_label];
//        }else
//        {
//            _userName_label.text = @"";
//        }
//        
//        
//        if (!_content_label) {
//            _content_label = [[RTLabel alloc] initWithFrame:CGRectMake(64,40,247,13)];
//            
//            _content_label.textAlignment = NSTextAlignmentLeft;
//            
//            _content_label.textColor = RGBCOLOR(4,4,4);
//            
//            _content_label.backgroundColor = [UIColor clearColor];
//            
//            _content_label.font = [UIFont systemFontOfSize:14];
//            
//            [self addSubview:_content_label];
//        }else
//        {
//            _content_label.text = @"";
//        }
//        
//        
//        
//        
//        if (!_PictureViews) {
//            _PictureViews = [[FBCirclePicturesViews alloc]  initWithFrame:CGRectMake(64,0,231,0)];
//            
//            [self addSubview:_PictureViews];
//        }else
//        {
//            for (UIView * view in _PictureViews.subviews) {
//                [view removeFromSuperview];
//            }
//            
//            _PictureViews.frame = CGRectMake(64,0,231,0);
//        }
//        
//        
//        if (!_forwardBackGroundImageView) {
//            
//            _forwardBackGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(64,0,245,0)];
//            
//            _forwardBackGroundImageView.userInteractionEnabled = YES;
//            
//            _forwardBackGroundImageView.backgroundColor = RGBCOLOR(247,247,247);
//            
//            [self addSubview:_forwardBackGroundImageView];
//            
//        }else
//        {
//            _forwardBackGroundImageView.frame = CGRectMake(64,0,245,0);
//        }
//        
//        
//        if (!_rUserName_label) {
//            _rUserName_label = [[UILabel alloc] initWithFrame:CGRectMake(5.5,10,235,15)];
//            
//            _rUserName_label.textAlignment = NSTextAlignmentLeft;
//            
//            _rUserName_label.textColor = RGBCOLOR(59,167,30);
//            
//            _rUserName_label.font = [UIFont systemFontOfSize:15];
//            
//            _rUserName_label.backgroundColor = [UIColor clearColor];
//            
//            [_forwardBackGroundImageView addSubview:_rUserName_label];
//        }else
//        {
//            _rUserName_label.text = @"";
//        }
//        
//        
//        if (!_rContent_label) {
//            _rContent_label = [[RTLabel alloc] initWithFrame:CGRectMake(5.5,35,235,13)];
//            
//            _rContent_label.textAlignment = NSTextAlignmentLeft;
//            
//            _rContent_label.textColor = RGBCOLOR(4,4,4);
//            
//            _rContent_label.backgroundColor = [UIColor clearColor];
//            
//            _rContent_label.font = [UIFont systemFontOfSize:14];
//            
//            [_forwardBackGroundImageView addSubview:_rContent_label];
//        }else
//        {
//            _rContent_label.text = @"";
//        }
//        
//        
//        if (!_rPictuteViews) {
//            
//            _rPictuteViews = [[FBCirclePicturesViews alloc] initWithFrame:CGRectMake(5.5,0,231,0)];
//            
//            [_forwardBackGroundImageView addSubview:_rPictuteViews];
//        }else
//        {
//            for (UIView * view in _rPictuteViews.subviews) {
//                [view removeFromSuperview];
//            }
//            
//            _rPictuteViews.frame = CGRectMake(5.5,0,231,0);
//        }
//        
//        
//        
//        if (!_date_label) {
//            _date_label = [[UILabel alloc]  initWithFrame:CGRectMake(64,0,200,15)];
//            
//            _date_label.textColor = RGBCOLOR(114,114,114);
//            
//            _date_label.textAlignment = NSTextAlignmentLeft;
//            
//            _date_label.backgroundColor = [UIColor clearColor];
//            
//            _date_label.font = [UIFont systemFontOfSize:13];
//            
//            [self addSubview:_date_label];
//        }else
//        {
//            _date_label.text = @"";
//        }
//        
//        
//        if (!_menu_button) {
//            _menu_button = [UIButton buttonWithType:UIButtonTypeCustom];
//            
//            _menu_button.frame = CGRectMake(272,0,33,15);
//            
//            [_menu_button setImage:[UIImage imageNamed:@"pinglun-icon-66_24.png"] forState:UIControlStateNormal];
//            
//            [_menu_button addTarget:self action:@selector(clickMenuTap:) forControlEvents:UIControlEventTouchUpInside];
//            
//            [self addSubview:_menu_button];
//        }
//        
//        
//        
//        if (!_menu_background_view) {
//            
//            _menu_background_view = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,0)];
//            
//            _menu_background_view.userInteractionEnabled = YES;
//            
//            [self addSubview:_menu_background_view];
//        }else
//        {
//            _menu_background_view.frame = CGRectMake(0,0,320,0);
//            
//            for (UIView * view in _menu_background_view.subviews) {
//                if (![view isKindOfClass:[FBCircleMenuView class]] && ![view isKindOfClass:[RTLabel class]])
//                {
//                    [view removeFromSuperview];
//                }
//            }
//        }
//        
//        
//        
//        if (!_menu_view) {
//            _menu_view = [[FBCircleMenuView alloc] initWithFrame:CGRectMake(0,10,320,0)];
//            
//            _menu_view.backgroundColor = RGBCOLOR(144,144,144);
//            
//            _menu_view.delegate = self;
//            
//            _menu_button.clipsToBounds = YES;
//            
//            [_menu_background_view addSubview:_menu_view];
//        }else
//        {
//            _menu_view.frame = CGRectMake(0,0,320,0);
//        }
//    }
//    
//    
//    if (!_sep_line_view) {
//        _sep_line_view = [[UIImageView alloc] initWithFrame:CGRectMake(11,0,297.5,5)];
//        
//        _sep_line_view.backgroundColor = RGBCOLOR(221,221,221);
//        
//      //  [self addSubview:_sep_line_view];
//    }
//    
//    
//    
//    return self;
//}
//
//
//-(float)setInfoWith:(FBCircleModel *)theInfo
//{
//    float cellHeight = 30;
//    
//    [_headerImageView loadImageFromURL:theInfo.fb_face withPlaceholdImage:PERSONAL_DEFAULTS_IMAGE];
//    
//    _userName_label.text = theInfo.fb_username;
//    
//    _content_label.text = theInfo.fb_content;
//    
//    CGRect contentFrame = _content_label.frame;
//    
//    CGSize optimumsSize = [_content_label optimumSize];
//    
//    cellHeight = cellHeight + 10 + optimumsSize.height;
//    
//    contentFrame.size.height = optimumsSize.height;
//    
//    _content_label.frame = contentFrame;
//    
//    if (theInfo.fb_imageid.length > 0)
//    {
//        NSArray * array = [theInfo.fb_imageid componentsSeparatedByString:@","];
//        
//        int i = array.count/3;
//        
//        int j = array.count%3?1:0;
//        
//        float height = 75*(i+j)+2.5*(j + i - 1);
//        
//        _PictureViews.frame = CGRectMake(64,cellHeight+10,231,height);
//        
//        
//   //   [_PictureViews setImageUrls:theInfo.fb_imageid withSize:75 isjuzhong:NO];
//        
//        NSMutableArray *arry_url=[NSMutableArray array];
//        for (int i=0; i<theInfo.fb_image.count; i++) {
//            NSDictionary *dicimgurl=[theInfo.fb_image objectAtIndex:i];
//            [arry_url addObject:[dicimgurl objectForKey:@"link"]];
//        }
//        
//        
//        
//        NSLog(@"arr_url===%@",arry_url);
//        
//        
//        
//        [_PictureViews setimageArr:arry_url withSize:75 isjuzhong:NO];
//        
//        
//        [_PictureViews setthebloc:^(NSInteger index) {
//           
//            ShowImagesViewController * showImages = [[ShowImagesViewController alloc]init];
//            
//            showImages.allImagesUrlArray = arry_url;
//            
//            showImages.currentPage = index - 1;
//            
//            [[(UIViewController *)self.delegate navigationController] pushViewController:showImages animated:YES];
//        }];
//
//        
//        cellHeight = cellHeight + 10 + height;
//    }
//    
//    
//    float forwardHeight = 0;
//    
//    
//    if ([theInfo.fb_topic_type isEqualToString:@"2"])
//    {
//        
//        _rUserName_label.text = theInfo.rfb_username;
//        
//        forwardHeight = forwardHeight + 25;
//        
//        _rContent_label.text = theInfo.rfb_content;
//        
//        CGSize rOptimumsSize = [_rContent_label optimumSize];
//        
//        CGRect rContentFrame = _rContent_label.frame;
//        
//        rContentFrame.size.height = rOptimumsSize.height;
//        
//        _rContent_label.frame = rContentFrame;
//        
//        forwardHeight = forwardHeight + 10 + rOptimumsSize.height;
//        
//        if (theInfo.rfb_imageid.length > 0)
//        {
//            NSArray * array = [theInfo.rfb_imageid componentsSeparatedByString:@","];
//            
//            int i = array.count/3;
//            
//            int j = array.count%3?1:0;
//            
//            float height = 75*(i+j)+3*(j + i - 1);
//            
//            _rPictuteViews.frame = CGRectMake(5,forwardHeight+10,231,height);
//            
//           // [_rPictuteViews setImageUrls:theInfo.rfb_imageid withSize:75 isjuzhong:NO];
//            
//           // [_rPictuteViews setImageUrls:theInfo.rfb_imageid withSize:75 isjuzhong:NO];
//            NSMutableArray *arry_url=[NSMutableArray array];
//            for (int i=0; i<theInfo.rfb_image.count; i++) {
//                NSDictionary *dicimgurl=[theInfo.rfb_image objectAtIndex:i];
//                [arry_url addObject:[dicimgurl objectForKey:@"link"]];
//            }
//            
//            
//            [_rPictuteViews setimageArr:arry_url withSize:75 isjuzhong:NO];
//            
//            [_rPictuteViews setthebloc:^(NSInteger index) {
//                
//                ShowImagesViewController * showImages = [[ShowImagesViewController alloc]init];
//                
//                showImages.allImagesUrlArray = arry_url;
//                
//                showImages.currentPage = index - 1;
//                
//                [[(UIViewController *)self.delegate navigationController] pushViewController:showImages animated:YES];
//            }];
//            
//            forwardHeight = forwardHeight + 10 + height;
//        }
//        
//        
//        CGRect forwardFrame = _forwardBackGroundImageView.frame;
//        
//        forwardFrame.origin.y = cellHeight + 10;
//        
//        forwardFrame.size.height = forwardHeight + 10;
//        
//        _forwardBackGroundImageView.frame = forwardFrame;
//        
//        forwardHeight += 20;
//    }
//    
//    CGRect dateFrame = _date_label.frame;
//    
//    dateFrame.origin.y = cellHeight + forwardHeight + 10;
//    
//    _date_label.frame = dateFrame;
//    
//    //张少南 地理位置
//    _date_label.text = [NSString stringWithFormat:@"%@    %@",[ZSNApi timestamp:theInfo.fb_deteline],theInfo.fb_area];
//    
//    
//    CGRect menubuttonFrame = self.menu_button.frame;
//    
//    menubuttonFrame.origin.y = _date_label.frame.origin.y;
//    
//    self.menu_button.frame = menubuttonFrame;
//    
//    
//    cellHeight += 25;
//    
//    
//    float menu_background_height = 0;
//    
//    if (theInfo.isShowMenuView)
//    {
//        _menu_view.frame = CGRectMake(0,menu_background_height + 10,320,38);
//        
//        UIView * uilineview = [[UIView alloc] initWithFrame:CGRectMake(0,53,320,0.5)];
//        
//        uilineview.backgroundColor = RGBCOLOR(229,229,229);
//        
//        [_menu_background_view addSubview:uilineview];
//        
//        menu_background_height += 48.5;
//        
//        
//        _menu_background_view.frame = CGRectMake(0,menubuttonFrame.origin.y + menubuttonFrame.size.height + 10,320,menu_background_height);
//        
//        _menu_background_view.image = [[UIImage imageNamed:@"FBCircle_menu_background_image.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:5];
//        
//        menu_background_height += 15;
//    }
//    
//    
//    _sep_line_view.frame = CGRectMake(_sep_line_view.frame.origin.x,cellHeight + forwardHeight + menu_background_height + 10,_sep_line_view.frame.size.width,_sep_line_view.frame.size.height);
//    
//    return cellHeight + forwardHeight + menu_background_height + 15;
//
//}

*/


-(void)clickMenuTap:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickToShowMenu)])
    {
        [_delegate clickToShowMenu];
    }
}


-(void)clickButtonWithMenuType:(FBCircleMenuType)theType
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectedButtonWithType:)]) {
        [_delegate selectedButtonWithType:theType];
    }
}


-(void)showOriginBlog
{    
    if (_delegate && [_delegate respondsToSelector:@selector(clickToShowOriginalBlogWith:)])
    {
        [_delegate clickToShowOriginalBlogWith:_theFBModel];
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
