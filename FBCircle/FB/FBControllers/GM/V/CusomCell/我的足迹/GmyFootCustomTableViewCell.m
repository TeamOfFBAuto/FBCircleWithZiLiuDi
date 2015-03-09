//
//  GmyFootCustomTableViewCell.m
//  FBCircle
//
//  Created by gaomeng on 14-5-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GmyFootCustomTableViewCell.h"

#import "UIImageView+WebCache.h"

#import "GlocalUserImage.h"

#define MONTH_FONT 12 //月份字体大小
#define DAY_FONT 25 //天 字体大小

#define TITLE_FONT 14 //标题大小
#define SUBTEXT_FONT 13 //摘要大小


@implementation GmyFootCustomTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
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



#pragma mark - 加载控件

//加载row=0
-(CGFloat)loadRow0CutomViewWithModel:(FBCirclePersonalModel*)theModel{
    
    CGFloat height = 0;
    
    //顶部view
    self.topImageView = [[GavatarView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 256)];
    self.topImageView.backgroundColor = [UIColor grayColor];
    
    
    //非自己足迹取网络数据
    if (self.isHaoyou) {
        
        
        //请求网路数据
        if ([theModel.person_frontpic isEqualToString:@"http://quan.fblife.com/resource/front//"]) {
            [self.topImageView setImage:[UIImage imageNamed:@"fengmian_640_512.png"]];
        }else{
            [self.topImageView setImageWithURL:[NSURL URLWithString:theModel.person_frontpic] placeholderImage:[UIImage imageNamed:@"gfengmian_loading_640_512.png"]];
        }
    }else{//自己足迹取本地数据
        
        
        //加载banner数据
        if ([GlocalUserImage getUserBannerImage]) {
            [self.topImageView setImage:[GlocalUserImage getUserBannerImage]];
            
        }else{
            //请求网路数据
            if ([theModel.person_frontpic isEqualToString:@"http://quan.fblife.com/resource/front//"]) {
                [self.topImageView setImage:[UIImage imageNamed:@"fengmian_640_512.png"]];
            }else{
                [self.topImageView setImageWithURL:[NSURL URLWithString:theModel.person_frontpic] placeholderImage:[UIImage imageNamed:@"gfengmian_loading_640_512.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    [GlocalUserImage setUserBannerImageWithData:UIImageJPEGRepresentation(image, 0.5)];
                }];
            }
            
        }
        
        self.topImageView.userInteractionEnabled = YES;
    }
    
    
    
    
    [self.contentView addSubview:self.topImageView];
    
    
    
    
    //头像下面带边框的view
    UIView *backUserFaceView = [[UIView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH-10-75, 205.5, 75, 75)];
    backUserFaceView.layer.cornerRadius = 5;
    backUserFaceView.backgroundColor = [UIColor whiteColor];
    backUserFaceView.layer.borderWidth = 0.5;
    backUserFaceView.layer.borderColor = [RGBACOLOR(198, 196, 196, 0.75) CGColor];
    
    
    
    //头像
    self.userFaceView = [[GavatarView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    self.userFaceView.center = backUserFaceView.center;
    
    self.userFaceView.layer.cornerRadius = 4;//设置那个圆角的有多圆
    
    self.userFaceView.layer.masksToBounds = YES;
    
    
    //非自己足迹取网络数据
    if (self.isHaoyou) {
        [self.userFaceView setImageWithURL:[NSURL URLWithString:theModel.person_face] placeholderImage:[UIImage imageNamed:@"gtouxiangHolderImage.png"]];
    }else{//自己足迹
        //加载头像数据
        if ([GlocalUserImage getUserFaceImage] != nil) {//判断本地是否有缓存
            [self.userFaceView setImage:[GlocalUserImage getUserFaceImage]];
            
        }else{//自己足迹
            [self.userFaceView setImageWithURL:[NSURL URLWithString:theModel.person_face] placeholderImage:[UIImage imageNamed:@"gtouxiangHolderImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                [GlocalUserImage setUserFaceImageWithData:UIImageJPEGRepresentation(image, 0.5)];
            }];
            
        }
        self.userFaceView.userInteractionEnabled = YES;
    }
    
    
    
    
    
    [self.contentView addSubview:backUserFaceView];
    
    [self.contentView addSubview:self.userFaceView];
    
    //个性签名
    //self.gexinglabel = [[UILabel alloc]initWithFrame:CGRectMake(104, CGRectGetMaxY(self.userFaceView.frame)+8, 205, 30)];
    self.gexinglabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.gexinglabel.font = [UIFont systemFontOfSize:12];
    
    
    NSLog(@"%@",NSStringFromCGRect(self.gexinglabel.frame));
    
    
    self.gexinglabel.text = theModel.person_words;
    //self.gexinglabel.backgroundColor = [UIColor orangeColor];
    if ([self.gexinglabel.text isEqualToString:@"(null)"]) {
        self.gexinglabel.text =@"";
    }
    
    [self.gexinglabel setMatchedFrame4LabelWithOrigin:CGPointMake(76, CGRectGetMaxY(self.userFaceView.frame)+15) width:205+21];
    CGRect r = self.gexinglabel.frame;
    r.size.width = 205+22+6;
    self.gexinglabel.frame = r;
    self.gexinglabel.textAlignment = NSTextAlignmentRight;
    self.gexinglabel.numberOfLines = 2;
    self.gexinglabel.textColor = RGBCOLOR(110, 111, 106);
    [self.contentView addSubview:self.gexinglabel];
    
    //用户名
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.userFaceView.frame)-10-200, 225, 190, 20)];
    self.nameLabel.font = [UIFont systemFontOfSize:18];
    NSLog(@"%@",NSStringFromCGRect(self.nameLabel.frame));
    
    self.nameLabel.textAlignment = NSTextAlignmentRight;
    
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.text = theModel.person_username;
    
    if ([self.nameLabel.text isEqualToString:@"(null)"]) {
        self.nameLabel.text =@"";
    }
    //self.nameLabel.shadowColor = [UIColor blackColor];//设置阴影颜色
    self.nameLabel.layer.shadowOffset = CGSizeMake(0, 1);//shadowOffset阴影偏移,x向右偏移0，y向下偏移1，默认(0, -3),这个跟shadowRadius配合使用
    self.nameLabel.layer.shadowRadius = 0.5;//阴影半径默认3
    self.nameLabel.layer.shadowOpacity = 0.8;//阴影透明度 默认0
    [self.contentView addSubview:self.nameLabel];
    
    
    if (self.gexinglabel.text.length>0) {
        height = CGRectGetMaxY(self.gexinglabel.frame)+32;
    }else{
        height = CGRectGetMaxY(self.topImageView.frame)+84;
    }
    
    
    return height;
    
}



//根据文章内容加载控件
-(CGFloat)loadCutomViewWithNetData:(NSArray *)sameTimeWenZhangArray indexPath:(NSIndexPath*)theIndexPath{
    
    NSLog(@"section = %d row = %d",theIndexPath.section,theIndexPath.row);
    
    if (theIndexPath.row == 0) {
        //日
        self.DayTimeLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 16, 24)];
        self.DayTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.DayTimeLabel1.frame)-1.5, 0, 16, 24)];
        _DayTimeLabel1.backgroundColor = [UIColor whiteColor];
        _DayTimeLabel.backgroundColor = [UIColor whiteColor];
        [self.DayTimeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:DAY_FONT]];
        [self.DayTimeLabel1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:DAY_FONT]];

        //月
        self.MonthTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.DayTimeLabel.frame)+3, 8, 31, 15)];
        self.MonthTimeLabel.font = [UIFont systemFontOfSize:MONTH_FONT];
        //self.MonthTimeLabel.backgroundColor = [UIColor blueColor];
        
        [self.contentView addSubview:self.DayTimeLabel1];
        [self.contentView addSubview:self.DayTimeLabel];
        [self.contentView addSubview:self.MonthTimeLabel];
    }
    
    //今天 还是 日月
    if (theIndexPath.row == 0 && theIndexPath.section ==1) {
        //获取当天时间
        NSDate *senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        NSString *  locationString=[dateformatter stringFromDate:senddate];

        //获取文章时间
        FBCircleModel *wenzhang = sameTimeWenZhangArray[0];
        NSMutableString *time = [NSMutableString stringWithFormat:@"%@",wenzhang.timeStr];
        
        //判断是否为今天的文章
        if ([locationString isEqualToString:time] && !self.isHaoyou) {//文章时间就是今天 并且不是好友足迹
            //隐藏月日
            self.MonthTimeLabel.hidden = YES;
            self.DayTimeLabel1.hidden = YES;
            self.DayTimeLabel.hidden = YES;
        }
    }
    
    
    //根据数据加载视图=====================
    
    NSLog(@"%d",theIndexPath.row);
    
    FBCircleModel *wenzhang = sameTimeWenZhangArray[theIndexPath.row];
    
    
    
    self.DayTimeLabel1.text = [wenzhang.timeStr substringWithRange:NSMakeRange(8, 1)];
    //self.DayTimeLabel1.backgroundColor = [UIColor redColor];
    self.DayTimeLabel1.textAlignment = NSTextAlignmentCenter;
    
    self.DayTimeLabel.text = [wenzhang.timeStr substringWithRange:NSMakeRange(9, 1)];
    //self.DayTimeLabel.backgroundColor = [UIColor redColor];
    self.DayTimeLabel.textAlignment = NSTextAlignmentCenter;
    
    
    NSString *month = [wenzhang.timeStr substringWithRange:NSMakeRange(5, 2)];
    if ([month isEqualToString:@"01"]) {
        month = @"一";
    }else if ([month isEqualToString:@"02"]){
        month = @"二";
    }else if ([month isEqualToString:@"03"]){
        month = @"三";
    }else if ([month isEqualToString:@"04"]){
        month = @"四";
    }else if ([month isEqualToString:@"05"]){
        month = @"五";
    }else if ([month isEqualToString:@"06"]){
        month = @"六";
    }else if ([month isEqualToString:@"07"]){
        month = @"七";
    }else if ([month isEqualToString:@"08"]){
        month = @"八";
    }else if ([month isEqualToString:@"09"]){
        month = @"九";
    }else if ([month isEqualToString:@"10"]){
        month = @"十";
    }else if ([month isEqualToString:@"11"]){
        month = @"十一";
    }else if ([month isEqualToString:@"12"]){
        month = @"十二";
    }
    self.MonthTimeLabel.text = [NSString stringWithFormat:@"%@月",month];
    
    
    
    //判断文章类型  fb_sort  0为普通微博  1 分享微博
    //如果是普通微博在判断是原创还是转发
    
    
    if ([wenzhang.fb_sort intValue]==1) {//分享微博
        //分享的灰色背景view
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor = RGBCOLOR(240, 241, 243);
        [self.contentView addSubview:view];
        //分享的图片view
        UIView *picsView = [[UIView alloc]initWithFrame:CGRectZero];
        [view addSubview:picsView];
        
        //分享文章是用户说的话
        RTLabel *fb_content = [[RTLabel alloc]init];
        fb_content.text = [ZSNApi FBImageChange:[wenzhang.fb_content stringByReplacingEmojiCheatCodesWithUnicode]];
        CGRect contentFrame = fb_content.frame;
        
        
        CGSize optimumsSize = [fb_content optimumSize];
        contentFrame.size.height = optimumsSize.height+3;
        fb_content.frame = contentFrame;
        //xxxxxxxxxxx
        
        fb_content.font = [UIFont boldSystemFontOfSize:14];
        if (fb_content.text.length>0) {
            fb_content.frame = CGRectMake(5, 5, 192, 17);
        }else{
            fb_content.frame = CGRectZero;
        }
//        fb_content.numberOfLines = 1;
        fb_content.backgroundColor = [UIColor clearColor];
        fb_content.userInteractionEnabled = NO;
        [view addSubview:fb_content];
        //判断有几张图片
        if (![wenzhang.rfb_face isEqualToString:@"(null)"]) {
            picsView.frame = CGRectMake(5, CGRectGetMaxY(fb_content.frame)+5, 40, 40);
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, picsView.frame.size.width, picsView.frame.size.height)];
            NSString *link = wenzhang.rfb_face;
            [imv setImageWithURL:[NSURL URLWithString:link] placeholderImage:nil];
            [picsView addSubview:imv];
        }else{
            picsView.frame = CGRectZero;
        }
        //分享文章的标题
        UILabel *rfb_content = [[UILabel alloc]init];
        rfb_content.font = [UIFont systemFontOfSize:13];
        rfb_content.textColor = RGBCOLOR(71, 72, 74);
        rfb_content.text = wenzhang.rfb_username;
        NSString *fenxiang = @"分享：";
        
        rfb_content.text = [fenxiang stringByAppendingString:rfb_content.text];
        
        
        NSLog(@"-----------------------------%@",wenzhang.rfb_face);
        
        //根据有没图片判断文字的宽度
        if (![wenzhang.rfb_face isEqualToString:@"(null)"]) {
            rfb_content.frame = CGRectMake(CGRectGetMaxX(picsView.frame)+6, CGRectGetMaxY(fb_content.frame)+5, 165, 40);
            rfb_content.numberOfLines = 2;
            
        }else{
            rfb_content.frame = CGRectMake(CGRectGetMaxX(picsView.frame)+5, CGRectGetMaxY(fb_content.frame)+5, 196, 40);
            rfb_content.numberOfLines = 2;
        }
        [view addSubview:rfb_content];
        
        //计算高度
        float gao = MAX(CGRectGetMaxY(rfb_content.frame), CGRectGetMaxY(picsView.frame)+5);
        CGFloat left = 83.f;
        CGFloat right = 12.f;
        CGFloat aWidth = DEVICE_WIDTH - right - left;
        view.frame = CGRectMake(left, 0, aWidth, gao);
        _cellHeight = gao+4;
    }else{
        if ([wenzhang.fb_topic_type intValue] == 2) {//是转发
            //转发的灰色背景view
            UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
            view.backgroundColor = RGBCOLOR(240, 241, 243);
            [self.contentView addSubview:view];
            
            //转发的图片view
            UIView *picsView = [[UIView alloc]initWithFrame:CGRectZero];
            [view addSubview:picsView];
            
            //自己写的内容
            //xxxxxxxx
            RTLabel *fb_content = [[RTLabel alloc]initWithFrame:CGRectMake(5, 5, 192, 0)];
            fb_content.textColor = [UIColor blackColor];
            
            fb_content.text =  [ZSNApi FBImageChange:[wenzhang.fb_content stringByReplacingEmojiCheatCodesWithUnicode]];
            
            fb_content.font = [UIFont boldSystemFontOfSize:13];
            fb_content.frame = CGRectMake(5, 5, 192, 18);//原来是高度是16但是g这个字符显示不全所以加了两个像素高度
            fb_content.backgroundColor = [UIColor clearColor];
            
            
            fb_content.userInteractionEnabled = NO;
            [view addSubview:fb_content];
            
            //判断有几张图片
            if (wenzhang.rfb_image.count >0) {
                picsView.frame = CGRectMake(5, CGRectGetMaxY(fb_content.frame)+9, 40, 40);
                UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, picsView.frame.size.width, picsView.frame.size.height)];
                
                id temp = wenzhang.rfb_image[0];
                NSString *link;
                if ([temp isKindOfClass:[NSString class]]) {
                    link = temp;
                }else if ([temp isKindOfClass:[NSDictionary class]]){
                    link = temp[@"link"];
                }
                [imv setImageWithURL:[NSURL URLWithString:link] placeholderImage:nil];
                [picsView addSubview:imv];
                
            }else{
                picsView.frame = CGRectZero;
            }
            
            //转发的文章的内容
            //xxxxxxx
            RTLabel *rfb_content = [[RTLabel alloc]init];
            rfb_content.font = [UIFont systemFontOfSize:13];
            rfb_content.textColor = RGBCOLOR(66, 66, 66);
            rfb_content.text = [ZSNApi FBImageChange:[wenzhang.rfb_content stringByReplacingEmojiCheatCodesWithUnicode]];
            CGRect contentFrame1 = rfb_content.frame;
            CGSize optimumsSize1 = [rfb_content optimumSize];
            contentFrame1.size.height = optimumsSize1.height+6;
            rfb_content.frame = contentFrame1;
//            rfb_content.backgroundColor = [UIColor purpleColor];
            
            //根据有没图片判断文字的宽度
            if (wenzhang.rfb_image.count>0) {
                rfb_content.frame = CGRectMake(CGRectGetMaxX(picsView.frame)+6, CGRectGetMaxY(fb_content.frame)+5, 165, 40);
//                rfb_content.numberOfLines = 2;
                
            }else{
                rfb_content.frame = CGRectMake(CGRectGetMaxX(picsView.frame)+5, CGRectGetMaxY(fb_content.frame)+5, 196, 40);
//                rfb_content.numberOfLines = 2;
            }
            
            [view addSubview:rfb_content];
            
            //计算高度
            float gao = MAX(CGRectGetMaxY(rfb_content.frame), CGRectGetMaxY(picsView.frame)+5);
            
            CGFloat left = 83.f;
            CGFloat right = 12.f;
            CGFloat aWidth = DEVICE_WIDTH - right - left;
            
            view.frame = CGRectMake(left, 0, aWidth, gao);
            _cellHeight = gao+4;
            
        }else{//是原创
            
            //原创的灰色背景view
            UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
            [self.contentView addSubview:view];
            view.backgroundColor=RGBCOLOR(248, 248, 248);
//            view.backgroundColor = [UIColor whiteColor];
            
            //图片View
            UIView *picsView = [[UIView alloc]initWithFrame:CGRectZero];
            
            [view addSubview:picsView];
            
            //判断有几张图片
            if (wenzhang.fb_image.count >0) {
                picsView.frame = CGRectMake(0, 0, 75, 75);
                UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, picsView.frame.size.width, picsView.frame.size.height)];
//                NSDictionary *dic = wenzhang.fb_image[0];
//                NSString *link = [dic objectForKey:@"link"];
                
                id temp = wenzhang.fb_image[0];
                
                NSString *link;
                if ([temp isKindOfClass:[NSString class]]) {
                    link = temp;
                }else if ([temp isKindOfClass:[NSDictionary class]]){
                    link = temp[@"link"];
                }

                
                
                [imv setImageWithURL:[NSURL URLWithString:link] placeholderImage:nil];
                [picsView addSubview:imv];
                //picsView.backgroundColor = [UIColor orangeColor];
                
                
                //共几张的label
                UILabel *countNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(picsView.frame)+5, 64, 40, 11)];
                
                countNum.font = [UIFont systemFontOfSize:11];
                countNum.text = [NSString stringWithFormat:@"共%d张",wenzhang.fb_image.count];
                countNum.textColor = RGBCOLOR(153, 153, 153);
                [view addSubview:countNum];
                if (wenzhang.fb_image.count == 1) {
                    countNum.hidden = YES;
                }
                
                view.backgroundColor = [UIColor whiteColor];
                
            }else{
                view.backgroundColor = [UIColor whiteColor];
                picsView.frame = CGRectZero;
            }
            
            //文章内容
            //xxxxxxxxxx
            RTLabel *fb_content = [[RTLabel alloc]init];
            fb_content.font = [UIFont systemFontOfSize:14];
//            fb_content.backgroundColor = [UIColor redColor];
            fb_content.text =  [ZSNApi FBImageChange:[wenzhang.fb_content stringByReplacingEmojiCheatCodesWithUnicode]];
            //xxxxxxxxx
            
            NSLog(@"__%@",fb_content.text);
            
            
            //根据有没有图片判断文字宽度
            if (wenzhang.fb_image.count > 0) {//有图片
                fb_content.frame = CGRectMake(CGRectGetMaxX(picsView.frame)+5, -3, 145, 0);
                CGRect contentFrame = fb_content.frame;
                CGSize optimumsSize = [fb_content optimumSize];
                contentFrame.size.height = optimumsSize.height+3;
                fb_content.frame = contentFrame;
                if (fb_content.frame.size.height >48) {
                    CGRect r = fb_content.frame;
                    r.size.height = 48 + 10;
                    fb_content.frame = r;
                    
                }
//                fb_content.numberOfLines = 3;
                
            }else{//没图片
                view.backgroundColor = [UIColor whiteColor];
                
//                fb_content.numberOfLines = 4;
                fb_content.frame = CGRectMake(8.5, 0, 215, 0);
                CGRect contentFrame = fb_content.frame;
                CGSize optimumsSize = [fb_content optimumSize];
                contentFrame.size.height = optimumsSize.height+3;
                fb_content.frame = contentFrame;
                
                float height = fb_content.frame.size.height;
                float height1 = 0.0f;
                
                if (height<68) {//小于4行
                    height1 = fb_content.frame.size.height+3;
                    
                    NSLog(@"%f",height1);
                    
                    CGRect r = fb_content.frame;
                    r.size.height = height1;
                    fb_content.frame = r;
                }else{//大于4行
                    CGRect r = fb_content.frame;
                    r.size.height = 60;
                    fb_content.frame = r;
                }
                
                
                
            }
            
            [view addSubview:fb_content];
            
            
            float gao = MAX(CGRectGetMaxY(fb_content.frame), CGRectGetMaxY(picsView.frame));
            
            NSLog(@"%f",gao);
            
            
            CGFloat left = 83.f;
            CGFloat right = 12.f;
            CGFloat aWidth = DEVICE_WIDTH - right - left;
            if (wenzhang.fb_image.count>0) {
                view.frame = CGRectMake(left, 0, aWidth, gao);
            }else{
                view.frame = CGRectMake(left, 0, aWidth, gao);
                view.backgroundColor = RGBCOLOR(240, 241, 243);
            }
            
            
            
            _cellHeight = gao+4;
        }
    }
    
    
    
    
    
    return _cellHeight;
}








@end
