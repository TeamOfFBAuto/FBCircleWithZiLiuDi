//
//  GmyMessageTableViewCell.m
//  FBCircle
//
//  Created by gaomeng on 14-5-28.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GmyMessageTableViewCell.h"

#import "GMAPI.h"

@implementation GmyMessageTableViewCell

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



//加载控件
-(void)loadView{
    //头像
    self.faceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, 48, 48)];
    self.faceImageView.layer.cornerRadius = 5;
    self.faceImageView.layer.masksToBounds = YES;
    
    
    //用户名
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.faceImageView.frame)+10, self.faceImageView.frame.origin.y, 160, 18)];
    //self.nameLabel.font = [UIFont  fontWithName:@"Helvetica-Bold"  size:15];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textColor = RGBCOLOR(94, 157, 45);
    //self.nameLabel.backgroundColor = [UIColor lightGrayColor];
    
    
    
    //原文内容
    self.yuanwenContentView  = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.faceImageView.frame)+192, self.nameLabel.frame.origin.y, 60, 60)];
    
    
    NSLog(@"%@",NSStringFromCGRect(self.yuanwenContentView.frame));
    
    
    
    
    
    //内容
//    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.frame.origin.x, CGRectGetMaxY(self.nameLabel.frame)+8, 240, 15)];
    
    self.contentLabel = [[RTLabel alloc]initWithFrame:CGRectZero];
    
    self.contentLabel.font = [UIFont systemFontOfSize:13];
    
    
    
    //时间
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.timeLabel.textColor = [UIColor grayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    //self.timeLabel.backgroundColor = [UIColor redColor];
    
    
    
    //添加视图
    [self.contentView addSubview:self.faceImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.yuanwenContentView];
    
    //调试颜色
    //        self.faceImageView.backgroundColor = [UIColor redColor];
    //        self.nameLabel.backgroundColor = [UIColor orangeColor];
    //        self.contentLabel.backgroundColor = [UIColor purpleColor];
    //        self.timeLabel.backgroundColor = [UIColor grayColor];
    //        self.yuanwenContentView.backgroundColor = [UIColor redColor];
}






//填充数据
-(CGFloat)dataForCellWithModel:(FBQuanMessageModel *)messageModel{
    
    CGFloat height = 0;
    
    [self.faceImageView setImageWithURL:[NSURL URLWithString:messageModel.fromuface] placeholderImage:nil];
    self.nameLabel.text = messageModel.fromuname;
    if ([messageModel.optype isEqual: @"3"]) {
        self.contentLabel.hidden = YES;
        self.zhanView = [[UIImageView alloc]initWithFrame:CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y + 24, 12, 12)];
        [self.zhanView setImage:[UIImage imageNamed:@"fbquanzan.png"]];
        [self.contentView addSubview:self.zhanView];
        
    }else{
        //转码解码
        
        self.contentLabel.text = [[ZSNApi FBImageChange:[ZSNApi decodeSpecialCharactersString:messageModel.recontent]] stringByReplacingEmojiCheatCodesWithUnicode];
        NSLog(@"%@",self.contentLabel.text);
    }
    NSString *timeFromNow = [GTimeSwitch timeWithDayHourMin:messageModel.dateline];
    
    //调整内容label大小位置

    [self.contentLabel setFrame:CGRectMake(self.nameLabel.frame.origin.x, CGRectGetMaxY(self.nameLabel.frame)+8, 160, 0)];
    CGRect contentFrame = self.contentLabel.frame;
    CGSize optimumsSize = [self.contentLabel optimumSize];
    contentFrame.size.height = optimumsSize.height+5;
    self.contentLabel.frame = contentFrame;
    
    
    if (self.contentLabel.frame.size.height >48) {
        CGRect r = CGRectZero;
        r.size.height = 48;
        self.contentLabel.frame = r;
    }
    
    
    
    self.timeLabel.text = timeFromNow;
    
    if (self.contentLabel.text.length>0) {//有评论
        self.timeLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, CGRectGetMaxY(self.contentLabel.frame)+8, 180, 15);
    }else{//有赞
        self.timeLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, CGRectGetMaxY(self.nameLabel.frame)+30, 180, 15);
    }
    
    
    
    
    
    //判断原文是否有图片
    
    
    if (messageModel.frontimg.length > 0) {//有图片
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        
        [imv setImageWithURL:[NSURL URLWithString:messageModel.frontimg] placeholderImage:nil];
        
        [self.yuanwenContentView addSubview:imv];
    }else{
        RTLabel *contentLabel = [[RTLabel alloc]initWithFrame:CGRectZero];
        contentLabel.font = [UIFont systemFontOfSize:13];
        
        NSString *yuanwenNeirong = [ZSNApi FBImageChange:[messageModel.maincontent stringByReplacingEmojiCheatCodesWithUnicode]];
        
        contentLabel.text = [GMAPI exchangeStringForYuanwenDelete:contentLabel contentText:yuanwenNeirong];
        contentLabel.frame = CGRectMake(0, 0, 60, 0);
        CGRect contentFrame = contentLabel.frame;
        CGSize optimumsSize = [contentLabel optimumSize];
        contentFrame.size.height = optimumsSize.height+3;
        contentLabel.frame = contentFrame;
        
        
        if ([contentLabel.text isEqualToString:@"原文已删除"]) {
            contentLabel.textColor = [UIColor grayColor];
        }
        

        
        NSLog(@"原文内容%@",messageModel.maincontent);
        
        if (contentLabel.frame.size.height>55) {//最多3行
            CGRect r = contentLabel.frame;
            r.size.height = 55;
            contentLabel.frame = r;
        }
        
        [self.yuanwenContentView addSubview:contentLabel];
//        原文内容%E4%B8%AD%
    }
    
    
    height = CGRectGetMaxY(self.timeLabel.frame)+12;
    
    
    return height;
    
}

//清除数据
-(void)clearDataOfCell{
    self.faceImageView.image = nil;
    self.nameLabel.text = nil;
    self.contentLabel.text = nil;
    for (UIView *view in self.yuanwenContentView.subviews) {
        [view removeFromSuperview];
    }
    self.zhanView.image = nil;
    
}


@end
