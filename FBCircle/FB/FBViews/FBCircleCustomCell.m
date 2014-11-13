//
//  FBCircleCustomCell.m
//  FBCircle
//  fbcircle
//  Created by soulnear on 14-5-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBCircleCustomCell.h"
#import "GRXX4ViewController.h"

#define IMAGE_WIDHT 18
#define IMAGE_HEIGHT 18

@implementation FBCircleCustomCell
@synthesize delegate = _delegate;
@synthesize myModel = _myModel;
@synthesize headerImageView = _headerImageView;//头像
@synthesize userName_label = _userName_label;//用户名
@synthesize date_label = _date_label;//时间
@synthesize menu_button = _menu_button;
@synthesize content_label = _content_label;
@synthesize PictureViews = _PictureViews;//中间的图片
@synthesize forwardBackGroundImageView = _forwardBackGroundImageView;
@synthesize rUserName_label = _rUserName_label;
@synthesize rContent_label = _rContent_label;
@synthesize rPictuteViews = _rPictuteViews;
@synthesize menu_background_view = _menu_background_view;
@synthesize commentView = _commentView;
@synthesize menu_view = _menu_view;
@synthesize zan_label = _zan_label;
@synthesize PraiseView = _PraiseView;
@synthesize FBCircleDetailCommentView = _FBCircleDetailCommentView;
@synthesize deleteButton = _deleteButton;
@synthesize Menu_Line_view = _Menu_Line_view;
@synthesize jiantou_imageView = _jiantou_imageView;
@synthesize down_line_view = _down_line_view;
@synthesize comment_line_view = _comment_line_view;

@synthesize rContentImageView = _rContentImageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

//新版转发样式


-(void)setAllViews
{
    if (!_headerImageView)
    {
        _headerImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(12,13,40,40)];
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.userInteractionEnabled = YES;
        _headerImageView.layer.cornerRadius = 5;
        _headerImageView.image = PERSONAL_DEFAULTS_IMAGE;
        [self.contentView addSubview:_headerImageView];
        
        UITapGestureRecognizer * headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerClicked:)];
        [_headerImageView addGestureRecognizer:headerTap];
    }else
    {
        _headerImageView.image = nil;
    }
    
    if (!_userName_label) {
        _userName_label = [[UILabel alloc] initWithFrame:CGRectMake(64,13,200,20)];
        _userName_label.textAlignment = NSTextAlignmentLeft;
        _userName_label.textColor = RGBCOLOR(3,3,3);
        _userName_label.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:_userName_label];
    }else
    {
        _userName_label.text = @"";
    }
    
    
    if (!_content_label) {
        _content_label = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(64,36,245,0)];
        _content_label.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        _content_label.delegate = self;
        [self.contentView addSubview:_content_label];
    }else
    {
        [_content_label setAttString:[[NSAttributedString alloc] initWithString:@""] withImages:nil];
    }
    
    if (!_show_detail_content_button) {
        _show_detail_content_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _show_detail_content_button.frame = CGRectMake(60,0,60,20);
        _show_detail_content_button.backgroundColor = [UIColor clearColor];
        _show_detail_content_button.titleLabel.font = [UIFont systemFontOfSize:13];
        [_show_detail_content_button setTitle:@"查看全文" forState:UIControlStateNormal];
        _show_detail_content_button.userInteractionEnabled = NO;
        [_show_detail_content_button setTitleColor:RGBCOLOR(86,100,163) forState:UIControlStateNormal];
        _show_detail_content_button.hidden = YES;
        [self.contentView addSubview:_show_detail_content_button];
    }else
    {
        _show_detail_content_button.hidden = YES;
    }
    
    
    if (!_PictureViews) {
        _PictureViews = [[FBCirclePicturesViews alloc]  initWithFrame:CGRectMake(64,0,231,0)];
        [self.contentView addSubview:_PictureViews];
    }else
    {
        for (UIView * view in _PictureViews.subviews)
        {
            if ([view isKindOfClass:[AsyncImageView class]]) {
                [(AsyncImageView *)view setImage:nil];
            }
            
            [view removeFromSuperview];
        }
        
        _PictureViews.frame = CGRectMake(64,0,231,0);
    }
    
    
    if (!_forwardBackGroundImageView) {
        _forwardBackGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(64,0,245,51)];
        _forwardBackGroundImageView.layer.borderWidth = 0.5;
        _forwardBackGroundImageView.clipsToBounds = YES;
        _forwardBackGroundImageView.layer.borderColor = [RGBCOLOR(229,229,229) CGColor];
        _forwardBackGroundImageView.userInteractionEnabled = YES;
        _forwardBackGroundImageView.backgroundColor = RGBCOLOR(247,247,247);
        [self.contentView addSubview:_forwardBackGroundImageView];
        
        UITapGestureRecognizer * aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOriginBlog)];
        [_forwardBackGroundImageView addGestureRecognizer:aTap];
    }else
    {
        _forwardBackGroundImageView.frame = CGRectMake(0,0,0,0);
    }
    
    
    if (!_rUserName_label) {
        _rUserName_label = [[UILabel alloc] initWithFrame:CGRectMake(54,5.5,180,20)];
        _rUserName_label.textAlignment = NSTextAlignmentLeft;
        _rUserName_label.textColor = RGBCOLOR(88,105,152);
        _rUserName_label.font = [UIFont systemFontOfSize:13];
//        _rUserName_label.backgroundColor = [UIColor clearColor];
        [_forwardBackGroundImageView addSubview:_rUserName_label];
    }else
    {
        _rUserName_label.text = @"";
    }
    
    
    if (!_rContent_label) {
        _rContent_label = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(54,28,235,22)];
        _rContent_label.textAlignment = NSTextAlignmentLeft;
        _rContent_label.textColor = RGBCOLOR(3,3,3);
        _rContent_label.font = [UIFont systemFontOfSize:13];
        [_forwardBackGroundImageView addSubview:_rContent_label];
    }else
    {
        _rContent_label.frame = CGRectMake(54,28,235,18);
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
        _date_label = [[UILabel alloc]  initWithFrame:CGRectMake(64,0,200,15)];
        _date_label.textColor = RGBCOLOR(114,114,114);
        _date_label.textAlignment = NSTextAlignmentLeft;
        _date_label.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_date_label];
    }else
    {
        _date_label.text = @"";
    }
    
    if (!_deleteButton) {
        _deleteButton = [[UILabel alloc] initWithFrame:CGRectMake(0,0,40,20)];
        _deleteButton.text = @"删除";
        _deleteButton.userInteractionEnabled = YES;
        _deleteButton.textAlignment = NSTextAlignmentCenter;
        _deleteButton.textColor = RGBCOLOR(86,105,163);
        _deleteButton.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_deleteButton];
        
        UITapGestureRecognizer * deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteBlog:)];
        
        [_deleteButton addGestureRecognizer:deleteTap];
    }else
    {
        _deleteButton.frame = CGRectMake(0,0,0,0);
    }
    
    if (!_menu_button) {
        _menu_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _menu_button.frame = CGRectMake(276,0,45,30);
        [_menu_button setImage:[UIImage imageNamed:@"pinglun-icon-66_24.png"] forState:UIControlStateNormal];
        [_menu_button addTarget:self action:@selector(clickMenuTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_menu_button];
    }
    
    if (!_menu_background_view) {
        _menu_background_view = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,0)];
        _menu_background_view.userInteractionEnabled = YES;
        _menu_background_view.backgroundColor = RGBCOLOR(249,249,249);
        [self.contentView addSubview:_menu_background_view];
    }else
    {
        _menu_background_view.frame = CGRectMake(0,_menu_background_view.frame.origin.y,320,0);
    }
    
    if (!_menu_view) {
        _menu_view = [[FBCircleMenuView alloc] initWithFrame:CGRectMake(0,0.5,320,0)];
        _menu_view.backgroundColor = RGBCOLOR(144,144,144);
        _menu_view.delegate = self;
        [_menu_background_view addSubview:_menu_view];
    }else
    {
        _menu_view.frame = CGRectMake(0,_menu_view.frame.origin.y,320,0);
    }
    
    if (!_commentView) {
        _commentView = [[FBCircleCommentView alloc] initWithFrame:CGRectMake(64,0,247,0)];
        _commentView.delegate = self;
        [_menu_background_view addSubview:_commentView];
    }else
    {
        for (UIView * view in _commentView.subviews) {
            [view removeFromSuperview];
        }
        _commentView.frame = CGRectMake(64,0,247,0);
    }
    
    if (!_zan_label) {
        _zan_label = [[RTLabel alloc] initWithFrame:CGRectMake(64,0,247,0)];
        _zan_label.font = [UIFont systemFontOfSize:13];
        _zan_label.delegate = self;
        _zan_label.lineBreakMode = NSLineBreakByCharWrapping;
        _zan_label.lineSpacing = 3;
        _zan_label.imageWidth = 14;
        _zan_label.imageHeight = 14;
        _zan_label.rt_color = @"#030303";
        _zan_label.textColor = RGBCOLOR(3,3,3);
//        _zan_label.backgroundColor = [UIColor clearColor];
        [_menu_background_view addSubview:_zan_label];
    }else
    {
        _zan_label.frame = CGRectMake(64,0,247,0);
        _zan_label.text = @"";
    }
    
    if (!_jiantou_imageView) {
        _jiantou_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,-4.5,320,5)];
        _jiantou_imageView.image = [UIImage imageNamed:@"pinglun640_10.png"];
        _jiantou_imageView.hidden = YES;
        [_menu_background_view addSubview:_jiantou_imageView];
    }else
    {
        _jiantou_imageView.hidden = YES;
    }
    
    if (!_comment_line_view)
    {
        _comment_line_view = [[UIView alloc]  initWithFrame:CGRectMake(0,0,320,0.5)];
        _comment_line_view.backgroundColor = RGBCOLOR(237,237,237);
        _comment_line_view.hidden = YES;
        [_menu_background_view addSubview:_comment_line_view];
    }else
    {
        _comment_line_view.hidden = YES;
    }
    
    if (!_down_line_view)
    {
        _down_line_view = [[UIView alloc]  initWithFrame:CGRectMake(0,0,320,0.5)];
        _down_line_view.backgroundColor = RGBCOLOR(240,240,240);
        _down_line_view.hidden = YES;
        [_menu_background_view addSubview:_down_line_view];
    }else
    {
        _down_line_view.hidden = YES;
    }
}



-(float)setInfomationWith:(FBCircleModel *)theInfo
{
    _myModel = theInfo;
    
    float cellHeight = 30;
    
    if ([theInfo.fb_uid isEqualToString:[SzkAPI getUid]])
    {
        UIImage * headerImage = [GlocalUserImage getUserFaceImage];
        
        if (headerImage)
        {
            _headerImageView.image = headerImage;
        }else
        {
            [_headerImageView loadImageFromURL:[SzkAPI getUserFace] withPlaceholdImage:PERSONAL_DEFAULTS_IMAGE];
        }
    }else
    {
        [_headerImageView loadImageFromURL:theInfo.fb_face withPlaceholdImage:PERSONAL_DEFAULTS_IMAGE];
    }
    
    _userName_label.text = theInfo.fb_username;
    
    NSString * content_string = [[ZSNApi decodeSpecialCharactersString:theInfo.fb_content] stringByReplacingEmojiCheatCodesWithUnicode];
    BOOL isShowButton = NO;
    if (content_string.length > 100)
    {
        content_string = [self getContentWith:content_string];
        isShowButton = YES;
    }
    
    [OHLableHelper creatAttributedText:content_string Label:_content_label OHDelegate:self WithWidht:IMAGE_MIDDLE_WIDTH WithHeight:IMAGE_MIDDLE_HEIGHT WithLineBreak:NO];
    if (theInfo.fb_content.length == 0) {
        _content_label.frame = CGRectMake(_content_label.frame.origin.x,_content_label.frame.origin.y,_content_label.frame.size.width,0);
    }
    cellHeight += _content_label.frame.size.height;
    
    if (isShowButton)
    {
        CGRect button_frame = _show_detail_content_button.frame;
        button_frame.origin.y = cellHeight+10;
        _show_detail_content_button.frame = button_frame;
        _show_detail_content_button.hidden = NO;
        cellHeight += 30;
    }
    
    
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
//                NSDictionary *dicimgurl=[theInfo.fb_image objectAtIndex:i];
                [arry_url addObject:[theInfo.fb_image objectAtIndex:i]];
            }
        }
        
        int i = arry_url.count/3;
        
        int j = arry_url.count%3?1:0;
        
        float height = 75*(i+j)+2.5*(j + i - 1);
        
        _PictureViews.frame = CGRectMake(64,cellHeight+8,231,height);
        
        [_PictureViews setimageArr:arry_url withSize:75 isjuzhong:NO];
        
        [_PictureViews setthebloc:^(NSInteger index) {
            
            UIViewController *VCtest=(UIViewController *)self.delegate;
            ShowImagesViewController *showBigVC=[[ShowImagesViewController alloc]init];
            showBigVC.allImagesUrlArray=arry_url;
            showBigVC.currentPage = index-1;
            showBigVC.hidesBottomBarWhenPushed = YES;
            [VCtest.navigationController pushViewController:showBigVC animated:YES];
        }];
      
        cellHeight = cellHeight + 5 + height;
      
    }
    
    
    float forwardHeight = 0;
    
    
    if ([theInfo.fb_sort isEqualToString:@"1"])//sort==1为分享微博
    {
        forwardHeight = 51;
        
        _forwardBackGroundImageView.userInteractionEnabled = YES;
        
        _rUserName_label.hidden = YES;
        
        if (theInfo.rfb_face.length > 0 && ![theInfo.rfb_face isEqualToString:@"(null)"] && ![theInfo.rfb_face isKindOfClass:[NSNull class]])
        {
            NSString * image_url = theInfo.rfb_face;
            if ([theInfo.rfb_face rangeOfString:@"img10.fblife.com"].length) {
                image_url = [NSString stringWithFormat:@"%@.120x120.jpg",theInfo.rfb_face];
            }
            [_rContentImageView loadImageFromURL:image_url withPlaceholdImage:FBCIRCLE_DEFAULT_IMAGE];
            _rContent_label.frame = CGRectMake(54,5.5,180,40);
            
            _forwardBackGroundImageView.frame = CGRectMake(64,cellHeight + 8,245,51);
            
        }else
        {
            forwardHeight = _rContent_label.frame.size.height + 10;
            
            _forwardBackGroundImageView.frame = CGRectMake(64,cellHeight + 8,245,forwardHeight);
        }
        
        [OHLableHelper creatAttributedText:[theInfo.rfb_username stringByReplacingEmojiCheatCodesWithUnicode] Label:_rContent_label OHDelegate:self WithWidht:IMAGE_WIDHT WithHeight:IMAGE_HEIGHT WithLineBreak:YES];
        
        forwardHeight += 5;
        
    }else if ([theInfo.fb_topic_type isEqualToString:@"2"])//转发微博
    {
        forwardHeight = 51;
        
        if (theInfo.rfb_username.length == 0 || [theInfo.rfb_username isEqualToString:@"(null)"] || [theInfo.rfb_username isKindOfClass:[NSNull class]])
        {
            forwardHeight = 30;
            
            _rUserName_label.hidden = YES;
            
            _forwardBackGroundImageView.frame = CGRectMake(64,cellHeight + 8,245,30);
            
            _rContent_label.frame = CGRectMake(5,8,235,_rContent_label.frame.size.height);
            
            _forwardBackGroundImageView.userInteractionEnabled = NO;
            
        }else
        {
            _forwardBackGroundImageView.userInteractionEnabled = YES;
            
            _rUserName_label.text = theInfo.rfb_username;
            _rUserName_label.hidden = NO;
            
            _rContent_label.frame = CGRectMake(54,28,235,_rContent_label.frame.size.height);
            
            _forwardBackGroundImageView.frame = CGRectMake(64,cellHeight + 8,245,51);
            
            if (theInfo.rfb_image.count > 0)
            {
                _rUserName_label.frame = CGRectMake(54,5,180,20);
                _rContent_label.frame = CGRectMake(54,28,180,_rContent_label.frame.size.height);
//                NSDictionary *dicimgurl=[theInfo.rfb_image objectAtIndex:0];
                NSString * urlImage = [theInfo.rfb_image objectAtIndex:0];
                [_rContentImageView loadImageFromURL:urlImage withPlaceholdImage:FBCIRCLE_DEFAULT_IMAGE];
            }else
            {
                _rUserName_label.frame = CGRectMake(5,5,180+49,20);
                
                _rContent_label.frame = CGRectMake(5,28,180+49,_rContent_label.frame.size.height);
            }
        }
        
        [OHLableHelper creatAttributedText:[[ZSNApi decodeSpecialCharactersString:theInfo.rfb_content] stringByReplacingEmojiCheatCodesWithUnicode] Label:_rContent_label OHDelegate:nil WithWidht:IMAGE_MIDDLE_WIDTH WithHeight:IMAGE_MIDDLE_HEIGHT WithLineBreak:YES];
        
        forwardHeight += 5;
    }else
    {
        _rContentImageView.image = nil;
        _forwardBackGroundImageView.frame = CGRectMake(0,0,0,0);
    }
    
    
    
    CGRect dateFrame = _date_label.frame;
    
    dateFrame.origin.y = cellHeight + forwardHeight + 10;
    
    _date_label.frame = dateFrame;
    
    
    //张少南 地理位置
    
    if (theInfo.fb_area.length == 0)
    {
        _date_label.text = [ZSNApi timestamp:theInfo.fb_deteline];
    }else
    {
        _date_label.text = [NSString stringWithFormat:@"%@  %@",[ZSNApi timestamp:theInfo.fb_deteline],theInfo.fb_area];
    }
    
    
    if ([theInfo.fb_uid isEqualToString:[SzkAPI getUid]])
    {
        if (theInfo.fb_tid.length > 0)
        {
            _deleteButton.hidden = NO;
            
            CGPoint point = [ZSNApi LinesWidth:_date_label.text Label:_date_label font:[UIFont systemFontOfSize:13]];
            
            _deleteButton.frame = CGRectMake(point.x-2,dateFrame.origin.y,35,15);
            
            _menu_button.userInteractionEnabled = YES;
        }else
        {
            _menu_button.userInteractionEnabled = NO;
            
            _deleteButton.hidden = YES;
        }
        
    }else
    {
        _deleteButton.hidden = YES;
    }
    
    
    CGRect menubuttonFrame = self.menu_button.frame;
    
    menubuttonFrame.origin.y = _date_label.frame.origin.y-8;
    
    self.menu_button.frame = menubuttonFrame;
    
    cellHeight += 25;
    
    
    float menu_background_height = 0;
    
    
    if (theInfo.isShowMenuView)
    {
        _jiantou_imageView.hidden = NO;
        
        _Menu_Line_view.hidden = NO;
        
        _menu_view.frame = CGRectMake(0,_menu_view.frame.origin.y,320,37.5);
    
        menu_background_height += 38;
    }else
    {
        _menu_view.frame = CGRectMake(0,_menu_view.frame.origin.y,320,0);
    }
    
    
    if ([theInfo.fb_zan_num intValue] != 0)
    {
        _jiantou_imageView.hidden = NO;
        
        _down_line_view.hidden = NO;
        
        _zan_label.text = [self returnZanStringWith:theInfo.fb_praise_array WithTotalNum:theInfo.fb_zan_num];
        
        CGSize zanOptimusize = [_zan_label optimumSize];
        
        _zan_label.frame = CGRectMake(_zan_label.frame.origin.x,menu_background_height + 4,_zan_label.frame.size.width,zanOptimusize.height+10);
        menu_background_height += zanOptimusize.height + 12;
    }
    
    if ([theInfo.fb_reply_num intValue] != 0)
    {
        _jiantou_imageView.hidden = NO;
        
        if ([theInfo.fb_zan_num intValue] != 0)
        {
            _comment_line_view.hidden  = NO;
        }
        
        _down_line_view.hidden = NO;
        
        
        float commentHeight = [_commentView setAllViewsWith:theInfo.fb_comment_array];
        
        _commentView.frame = CGRectMake(_commentView.frame.origin.x,menu_background_height + 5,_commentView.frame.size.width,commentHeight);
        
        _comment_line_view.frame = CGRectMake(0,menu_background_height,320,0.5);
        
        menu_background_height += commentHeight + 7;
    }
    
    
    if (menu_background_height != 0)
    {
        _menu_background_view.frame = CGRectMake(0,menubuttonFrame.origin.y + menubuttonFrame.size.height - 5 + 2.5,320,menu_background_height);
        
        _down_line_view.frame = CGRectMake(0,menu_background_height,320,0.5);
        
        menu_background_height += 10;
    }

    
    return menu_background_height + cellHeight + forwardHeight + 6.5;
}



#pragma mark - 点击原内容，跳转到对应页

-(void)showOriginBlog
{
    UIViewController *VCtest=(UIViewController *)self.delegate;
    
    if ([_myModel.fb_sort isEqualToString:@"1"])//分享类型，跳转到浏览器
    {
        FBCircleWebViewController * webVC = [[FBCircleWebViewController alloc] init];
        webVC.web_url = _myModel.rfb_zan_num;
        NSLog(@"跳转的url:%@",_myModel.rfb_zan_num);
        webVC.hidesBottomBarWhenPushed = YES;
        [VCtest.navigationController pushViewController:webVC animated:YES];
        
    }else//普通类型，跳转到详情
    {
        FBCircleDetailViewController * detail = [[FBCircleDetailViewController alloc] init];
        detail.theModel = _myModel;
        detail.isForward = YES;
        detail.hidesBottomBarWhenPushed = YES;
        [VCtest.navigationController pushViewController:detail animated:YES];
    }
}


#pragma mark-点击头像

-(void)headerClicked:(UITapGestureRecognizer *)sender
{
    [self pushToPersonalWith:_myModel.fb_uid];
    
}

#pragma mark- 删除

-(void)deleteBlog:(UITapGestureRecognizer *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(deleteTheBlogWithCell:)]) {
        [_delegate deleteTheBlogWithCell:self];
    }
}


#pragma mark-点击菜单

-(void)clickMenuTap:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickMenuTapWith:)]) {
        [_delegate clickMenuTapWith:self];
    }
}



-(float)returnCellHeightWith:(FBCircleModel *)theInfo
{
    float cellHeight = 30;
    
    NSString * content_string = [[ZSNApi decodeSpecialCharactersString:theInfo.fb_content] stringByReplacingEmojiCheatCodesWithUnicode];
    if (content_string.length > 100)
    {
        content_string = [self getContentWith:content_string];
        cellHeight += 30;
    }
    
    if (theInfo.fb_content.length == 0) {
        _content_label.frame = CGRectMake(_content_label.frame.origin.x,_content_label.frame.origin.y,_content_label.frame.size.width,0);
    }else
    {
        [OHLableHelper returnHeightAttributedText:content_string Label:_content_label WithWidht:IMAGE_WIDHT WithHeight:IMAGE_HEIGHT];
    }
    
    cellHeight += _content_label.frame.size.height;
    
    if (theInfo.fb_imageid.length > 0)
    {
        int i = theInfo.fb_image.count/3;
        int j = theInfo.fb_image.count%3?1:0;
        float height = 75*(i+j)+2.5*(j + i - 1);
        cellHeight = cellHeight + 5 + height;
    }
    
    float forwardHeight = 0;
    
    if ([theInfo.fb_sort isEqualToString:@"1"])
    {
        forwardHeight = 51;
        
//        [OHLableHelper creatAttributedText:[theInfo.rfb_username stringByReplacingEmojiCheatCodesWithUnicode] Label:_rContent_label OHDelegate:self WithWidht:IMAGE_WIDHT WithHeight:IMAGE_HEIGHT WithLineBreak:YES];
        [OHLableHelper returnHeightAttributedText:[theInfo.rfb_username stringByReplacingEmojiCheatCodesWithUnicode] Label:_rContent_label WithWidht:IMAGE_WIDHT WithHeight:IMAGE_HEIGHT];
        
        if (theInfo.rfb_face.length > 0 && ![theInfo.rfb_face isEqualToString:@"(null)"] && ![theInfo.rfb_face isKindOfClass:[NSNull class]])
        {
            
        }else
        {
            forwardHeight = _rContent_label.frame.size.height + 10;
        }
        
        forwardHeight += 5;
    }
    
    
    if ([theInfo.fb_topic_type isEqualToString:@"2"])
    {
        
        if (theInfo.rfb_username.length == 0 || [theInfo.rfb_username isEqualToString:@"(null)"] || [theInfo.rfb_username isKindOfClass:[NSNull class]])
        {
            forwardHeight = 30;
        }else
        {
            forwardHeight = 51;
        }
        
        forwardHeight += 5;
    }
    
    
    CGRect dateFrame = _date_label.frame;
    
    dateFrame.origin.y = cellHeight + forwardHeight + 10;
    
    
    
    CGRect menubuttonFrame = self.menu_button.frame;
    
    menubuttonFrame.origin.y = _date_label.frame.origin.y-7;
    
    cellHeight += 25;
    
    float menu_background_height = 0;

    
    if ([theInfo.fb_zan_num intValue] != 0)
    {
        _zan_label.text = [self returnZanStringWith:theInfo.fb_praise_array WithTotalNum:theInfo.fb_zan_num];
        
        CGSize zanOptimusize = [_zan_label optimumSize];
        
        menu_background_height += zanOptimusize.height + 12;
    }
    
    if ([theInfo.fb_reply_num intValue] != 0)
    {
        float commentHeight = [_commentView setAllViewsWith:theInfo.fb_comment_array];
        
        menu_background_height += commentHeight + 7;
    }
    
    
    if (menu_background_height != 0)
    {        
        menu_background_height += 10;
    }
    
    return menu_background_height + cellHeight + forwardHeight + 6.5;
}


-(NSString *)returnZanStringWith:(NSMutableArray *)array WithTotalNum:(NSString *)theCount
{
    NSString * zanString = [NSString stringWithFormat:@"<img src=\"pinglun-xin-down-24_24.png\">     </img>%@  ",theCount];
    
    for (int i = 0;i < array.count;i++)
    {
        FBCirclePraiseModel * model = [array objectAtIndex:i];
        
        if (i == 0) {
            zanString = [zanString stringByAppendingFormat:@"<a href=\"fb://atSomeone@/%@\">%@</a>",model.praise_uid,model.praise_username];
        }else
        {
            zanString = [zanString stringByAppendingFormat:@"，<a href=\"fb://atSomeone@/%@\">%@</a>",model.praise_uid,model.praise_username];
        }
        
    }

    return zanString;
}

#pragma mark-FBCircleCommentViewDelegate
-(void)clickUserNameWithUid:(NSString *)theUid
{
    [self pushToPersonalWith:theUid];
}


#pragma mark-FBCircleMenuViewDelegate
-(void)clickButtonWithMenuType:(FBCircleMenuType)theType
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectedButtonWithType:With:WithCell:)]) {
        [_delegate selectedButtonWithType:theType With:_myModel WithCell:self];
    }
}
#pragma mark - OHLbaleDelegate
-(BOOL)attributedLabel:(OHAttributedLabel*)attributedLabel shouldFollowLink:(NSTextCheckingResult*)linkInfo
{
    NSString * url = [linkInfo.URL absoluteString];
    if ([ZSNApi matchURLWithString:url]) {
        UIViewController *VCtest=(UIViewController *)self.delegate;
        FBCircleWebViewController * webVC = [[FBCircleWebViewController alloc] init];
        webVC.web_url = [linkInfo.URL absoluteString];
        webVC.hidesBottomBarWhenPushed = YES;
        [VCtest.navigationController pushViewController:webVC animated:YES];
    }else if([ZSNApi matchIntWithString:url])
    {
        ///张少南 ，这里需要一个跳转方向，到个人信息的
        [ZSNApi showAutoHiddenMBProgressWithText:[NSString stringWithFormat:@"跳到个人信息的%@",url] addToView:self];
    }else
    {
        
    }
    
    return NO;
}

-(UIColor*)colorForLink:(NSTextCheckingResult*)linkInfo underlineStyle:(int32_t*)underlineStyle
{
    return RGBCOLOR(86,105,153);
}

#pragma mark-RTLabelDelegate

-(void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url
{
    NSString * urlString = [url absoluteString];
    
    NSString * myUid = [urlString stringByReplacingOccurrencesOfString:@"fb://atSomeone@/" withString:@""];
    
    [self pushToPersonalWith:myUid];
}


-(void)pushToPersonalWith:(NSString *)theUid
{
    UIViewController *VCtest=(UIViewController *)self.delegate;
    
    GRXX4ViewController * friendView = [[GRXX4ViewController alloc] init];
    
    friendView.passUserid = theUid;
    
    friendView.hidesBottomBarWhenPushed = YES;
    
    [VCtest.navigationController pushViewController:friendView animated:YES];
}


#pragma mark - 太长的字符串按字符数截取
-(NSString *)getContentWith:(NSString *)content_string
{
    if (content_string.length > 100)
    {
        ///按需要的字符长度截取字符串
        content_string = [content_string substringToIndex:100];
        ///读取截取后字符串后5为字符
        NSString * temp_string = [[content_string substringToIndex:content_string.length] substringFromIndex:content_string.length-5];
        ///按[符号读取字符串
        NSArray * array = [temp_string componentsSeparatedByString:@"["];
        ///第一组数据里面肯定没有表情
        NSString * first_string = [array objectAtIndex:0];
        content_string = [content_string stringByReplacingCharactersInRange:NSMakeRange(content_string.length-(5-first_string.length),5-first_string.length) withString:@"..."];
    }
    
    return content_string;
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
