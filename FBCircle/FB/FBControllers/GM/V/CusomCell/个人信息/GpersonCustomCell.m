//
//  GpersonCustomCell.m
//  FBCircle
//
//  Created by gaomeng on 14-5-26.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GpersonCustomCell.h"

#import "GlocalUserImage.h"
#import "GupData.h"

@implementation GpersonCustomCell

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



-(void)loadCustomViewWithIndexPath:(NSIndexPath *)theIndexPath model:(FBCirclePersonalModel*)theModel GRXX:(GRXX)theGRXXtype wenzhangArray:(NSMutableArray*)wenzhangArray{
    
    
    
    //左边标题label
    UILabel *titel = [[UILabel alloc]init];
    titel.font = [UIFont systemFontOfSize:14];
    titel.textColor = RGBCOLOR(134, 134, 134);
    [self.contentView addSubview:titel];
    
    //右边内容label
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.textColor = RGBCOLOR(38, 38, 38);
    [self.contentView addSubview:contentLabel];
    
    
    //如果是跟人设置界面的话有后面的箭头===================================================================
    if (theGRXXtype == GRXX1) {
        //后面的箭头
        if (theIndexPath.row == 3 ||theIndexPath.row == 4||theIndexPath.row == 5) {
            NSLog(@" section:%d   row :%d",theIndexPath.section, theIndexPath.row);
            
            UIImageView *jiantou = [[UIImageView alloc]init];
            
            if (theIndexPath.row == 3){//地区
                jiantou.frame = CGRectMake(DEVICE_WIDTH-17, 14, 8, 13);
            }else if (theIndexPath.row == 4){//个性签名
                jiantou.frame = CGRectMake(DEVICE_WIDTH-17, 20, 8, 13);
            }else if (theIndexPath.row == 5){//足迹
                jiantou.frame = CGRectMake(DEVICE_WIDTH-17, 35, 8, 13);
            }
            
            [jiantou setImage:[UIImage imageNamed:@"tixiang-jiantou-16_26.png"]];
            
            
            [self.contentView addSubview:jiantou];
        }
    }
    
    
    
    //根据row来判断左边titleLabel的内容显示==============================================
    if (theIndexPath.row == 0) {//头像
        titel.frame = CGRectMake(17, 23, 35, 30);
        titel.text = @"头像";
        self.touxiangImaView = [[GavatarView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH-12-64, 8, 64, 64)];
        self.touxiangImaView.layer.cornerRadius = 5;
        self.touxiangImaView.layer.borderWidth = 0.5;
        self.touxiangImaView.layer.borderColor = [RGBCOLOR(196, 196, 196) CGColor];
        self.touxiangImaView.layer.masksToBounds = YES;
        
        if (theGRXXtype == GRXX1) {
            //给头像图片填充数据
            if ([GlocalUserImage getUserFaceImage]) {//有缓存
                [self.touxiangImaView setImage:[GlocalUserImage getUserFaceImage]];
            }else{//没有缓存
                //请求网络数据
                @try {
                    NSString *str = theModel.person_face;
                    
                    str=[str stringByReplacingOccurrencesOfString:@"middle" withString:@"big"];
                    str=[str stringByReplacingOccurrencesOfString:@"small" withString:@"big"];
                    
                    [self.touxiangImaView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"headimg150_150.png"]];
                    
                    [GlocalUserImage setUserFaceImageWithData:UIImageJPEGRepresentation(self.touxiangImaView.image, 0.5)];
                    GupData *up = [GupData alloc];
                    [up upUserFace];
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
            }
        }else{
            //请求网络数据

            @try {
                
                NSString *str = theModel.person_face;
                
                str=[str stringByReplacingOccurrencesOfString:@"middle" withString:@"big"];
                str=[str stringByReplacingOccurrencesOfString:@"small" withString:@"big"];
                
                [self.touxiangImaView setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"headimg150_150.png"]];
                
                
                
                
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            
        }
        
        
        
        
        self.touxiangImaView.userInteractionEnabled = YES;
        
        [self.contentView addSubview:self.touxiangImaView];
        
    }else if (theIndexPath.row == 4){//个性签名
        
        titel.frame = CGRectMake(17, 10, 70, 30);
        titel.text = @"个性签名";
        contentLabel.numberOfLines = 2;
        contentLabel.frame = CGRectMake(95, 5, 190, 40);
        contentLabel.font = [UIFont systemFontOfSize:12];
        if (self.ischangeUserQm) {
            contentLabel.text = self.changeQM;//
        }else{
            
            
            if (theModel.person_words.length == 0 || [theModel.person_words isEqualToString:@"<null>"]) {
                contentLabel.text = @"未填写";
                contentLabel.font = [UIFont systemFontOfSize:14];
                
            }else{
                contentLabel.text = theModel.person_words;
            }
            
        }
        self.ischangeUserQm = NO;
        
        
        
    }else if(theIndexPath.row == 5){//个人足迹
        titel.frame = CGRectMake(17, 27, 70, 30);
        if (theGRXXtype == GRXX1) {
            titel.text = @"我的足迹";
        }else if(theGRXXtype == GRXX2){
            titel.text = @"好友足迹";
        }else if(theGRXXtype == GRXX3||theGRXXtype == GRXX4||theGRXXtype == GRXX5){
            titel.text = @"足迹";
        }
        
        //展示图片的view
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(91, 7, 200, 70)];
        //view.backgroundColor = [UIColor redColor];
        
        //足迹展示图片的数组
        NSMutableArray *imavMutableArray = [NSMutableArray arrayWithCapacity:1];
        
        //文章对象
        FBCircleModel *wenzhang = [[FBCircleModel alloc]init];
        
        NSLog(@"%d",wenzhangArray.count);
        
        int count = wenzhangArray.count;
        
        //解决wenzhangArray.count等于0崩溃问题
        for (int i =0; i<count; i++) {
            //获得文章对象
            wenzhang = wenzhangArray[i];
            
            //获取文章对象中图片的数组
            NSMutableArray *imageArr =wenzhang.fb_image;
            
            //初始化一个dic 里面存图片地址
//            NSDictionary*dic = [[NSDictionary alloc]init];
            
            NSLog(@"wenzhang.fb_image.count = %d",imageArr.count);
            
            
            if (imageArr.count>0) {//图片数组里有东西
                //取出第一张图片
//                dic = imageArr[0];
                self.imaCount++;
                
                NSLog(@"_imaCount = %d",self.imaCount);
                
//                NSString *str = [dic objectForKey:@"link"];
//                NSString *str = imageArr[0];
//                NSLog(@"图片地址%@",str);
                
                id temp = wenzhang.fb_image[0];
                NSString *str;
                if ([temp isKindOfClass:[NSString class]]) {
                    str = temp;
                }else if ([temp isKindOfClass:[NSDictionary class]]){
                    str = temp[@"link"];
                }
                
                //UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(200-self.imaCount*65, 5, 60, 60)];
                //创建展示图片iamge
                UIImageView *imv = [[UIImageView alloc]init];
                
                @try {
                    [imv setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
                
                
                //imv.backgroundColor = [UIColor purpleColor];
                
                //把需要展示的图片view放到数组中
                [imavMutableArray addObject:imv];
                
            }
            
            if (self.imaCount == 3) {
                break;//图片数量等于3的时候跳出循环 最多展示3张图片 break跳出for循环走下面的遍历数组 return 直接跳到最后
            }
            
            
        }
        
        //遍历数组 倒着放图片
        
        NSLog(@"%d",self.imaCount);
        
        for (int i = 0; i<self.imaCount; i++) {
            UIImageView *imv = imavMutableArray[self.imaCount-i-1];
            imv.frame = CGRectMake(200-(i+1)*65, 5, 60, 60);
            [view addSubview:imv];
        }
        //view.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:view];
        
    }else if(theIndexPath.row == 1){//用户名
        
        titel.frame = CGRectMake(17, 10, 60, 30);
        titel.text = @"用户名";
        
        NSLog(@"用户名 ： %@",theModel.person_username);
        
        if (theModel.person_username.length != 0) {
            
            contentLabel.text = theModel.person_username;
            
            
        }
        
        if (theModel.person_username.length == 0 || [theModel.person_username isEqualToString:@"<null>"]){
            
            contentLabel.text = @"未填写";
            
            
        }
        
        contentLabel.frame = CGRectMake(95, 10, 200, 30);
        
    }else if (theIndexPath.row == 2){//性别
        titel.frame = CGRectMake(17, 10, 60, 30);
        titel.text = @"性别";
        contentLabel.frame = CGRectMake(95, 10, 200, 30);
        if (theGRXXtype == GRXX1) {//个人设置界面
            if ([theModel.person_gender isEqualToString:@"1"]) {
                contentLabel.text = @"男";
            }else if([theModel.person_gender isEqualToString:@"2"]){
                contentLabel.text = @"女";
            }else if([theModel.person_gender isEqualToString:@"0"]){
                contentLabel.text = @"请选择";
            }
        }else{//不是个人设置界面
            if ([theModel.person_gender isEqualToString:@"1"]) {
                contentLabel.text = @"男";
            }else if([theModel.person_gender isEqualToString:@"2"]){
                contentLabel.text = @"女";
            }else if ([contentLabel.text isEqualToString:@"<null>"] || contentLabel.text.length == 0){
                contentLabel.text = @"未填写";
            }
            
        }
        contentLabel.font = [UIFont systemFontOfSize:15];
            
    }else if(theIndexPath.row == 3){//地区
        titel.frame = CGRectMake(17, 10, 60, 30);
        titel.text = @"地区";
        NSString *p = theModel.person_province;
        NSString *c = theModel.person_city;
        
        
        if (p.length != 0 && c.length != 0) {
            
            NSString *area = [NSString stringWithFormat:@"%@ %@",p,c];
            contentLabel.text = area;
            
        }
        if ([p isEqualToString:@"<null>"] && [c isEqualToString:@"<null>"]){
            contentLabel.text = @"未填写";
            
        }
        if (p.length == 0 && c.length == 0){
            contentLabel.text = @"未填写";
        }
        contentLabel.frame = CGRectMake(95, 10, 200, 30);
        contentLabel.font = [UIFont systemFontOfSize:14];
    }
    
    
    
    
    //根据grxx类型判断最下面btn的样式================================================================
    
    if (theGRXXtype == GRXX1) {//自己
        if (theIndexPath.row == 6) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10, DEVICE_WIDTH>480?23:10, DEVICE_WIDTH-20, 42);
            
//            btn.layer.cornerRadius = 5;//设置那个圆角的有多圆
//            btn.layer.borderWidth = 0.5;//设置边框的宽度，当然可以不要
//            btn.layer.borderColor = [RGBCOLOR(196, 196, 196) CGColor];//设置边框的颜色
//            btn.layer.masksToBounds = NO;
            
            [btn setBackgroundImage:[UIImage imageNamed:@"tuichudenglu_up_532_80.png"] forState:UIControlStateNormal];
            [btn setTitle:@"退出登录" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            [btn setBackgroundImage:[UIImage imageNamed:@"tuichudenglu_down_532_80.png"] forState:UIControlStateHighlighted];
            [btn setTitle:@"退出登录" forState:UIControlStateHighlighted];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            
            
            
            [btn addTarget: self action:@selector(tuichudenglu) forControlEvents:UIControlEventTouchUpInside];
            
            self.tuichudengluBtn = btn;
            
            [self.contentView addSubview:btn];
            

        }
        
    }else  if (theGRXXtype == GRXX2) {//好友 接口返回0
        if (theIndexPath.row == 6) {
            
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"发消息" forState:UIControlStateNormal];
            btn.frame = CGRectMake(10, DEVICE_WIDTH>480?23:10, DEVICE_WIDTH-20, 42);
            [btn addTarget:self action:@selector(faxiaoxi) forControlEvents:UIControlEventTouchUpInside];
            self.faxiaoxiBtn = btn;
            
            [btn setBackgroundImage:[UIImage imageNamed:@"geren-button532_80.png"] forState:UIControlStateNormal];
            [self.contentView addSubview:btn];
        }
    }else if (theGRXXtype == GRXX3){//非好友 接口返回3
        if (theIndexPath.row == 6) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"添加为好友" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(jiahaoyou) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(10, DEVICE_WIDTH>480?23:10, DEVICE_WIDTH-20, 42);
            
            self.jiahaoyouBtn = btn;
            
            
           [btn setBackgroundImage:[UIImage imageNamed:@"geren-button532_80.png"] forState:UIControlStateNormal];
            [self.contentView addSubview:btn];
        }
        
    }else if(theGRXXtype == GRXX4){//非好友 正在添加中 接口返回1
        if (theIndexPath.row == 6) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"正在添加中" forState:UIControlStateNormal];
            btn.frame = CGRectMake(10, DEVICE_WIDTH>480?23:10, DEVICE_WIDTH-20, 42);
            
            self.jiahaoyouBtn = btn;
            self.jiahaoyouBtn.userInteractionEnabled = NO;
            [btn setBackgroundImage:[UIImage imageNamed:@"geren-button532_80.png"] forState:UIControlStateNormal];
            [self.contentView addSubview:btn];
        }
    }else if (theGRXXtype == GRXX5){//接到邀请  接口返回2
        if (theIndexPath.row == 6) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"接受" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(yaoqing) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(10, DEVICE_WIDTH>480?23:10, DEVICE_WIDTH-20, 42);
            
            self.yaoqingBtn = btn;
            
            [btn setBackgroundImage:[UIImage imageNamed:@"geren-button532_80.png"] forState:UIControlStateNormal];
            [self.contentView addSubview:btn];
        }
        
    }
    
    
    
    
    
    

    
    
    
}


//set方法

-(void)setfaxiaoxiClickedBlock:(faxiaoxiClickedBlock)faxiaoxiClickedBlock{
    _faxiaoxiClickedBlock = faxiaoxiClickedBlock;
}

-(void)setJiahaoyouClickedBlock:(JiahaoyouClickedBlock)JiahaoyouClickedBlock{
    _JiahaoyouClickedBlock = JiahaoyouClickedBlock;
}


-(void)setTuichudengluClickedBlock:(tuichudengluClickedBlock)tuichudengluClickedBlock{
    _tuichudengluClickedBlock = tuichudengluClickedBlock;
}

-(void)setYaoqingClickedBlock:(yaoqingClickedBlock)yaoqingClickedBlock{
    _yaoqingClickedBlock = yaoqingClickedBlock;
}



//执行block
//发消息
-(void)faxiaoxi{
    if (self.faxiaoxiClickedBlock) {
        self.faxiaoxiClickedBlock();
    }
}

//加好友
-(void)jiahaoyou{
    if (self.JiahaoyouClickedBlock) {
        self.JiahaoyouClickedBlock();
    }
}

//退出登录
-(void)tuichudenglu{
    if (self.tuichudengluClickedBlock) {
        self.tuichudengluClickedBlock();
    }
}

//接受邀请
-(void)yaoqing{
    if (self.yaoqingClickedBlock) {
        self.yaoqingClickedBlock();
    }
}




////自定义分割线
//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextFillRect(context, rect);
//    
//    //下分割线
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//    
//    CGContextStrokeRect(context, CGRectMake(17, rect.size.height-1, rect.size.width - 17, 1));
//    
//    
//}








@end
