//
//  GallJiuyuanduiTableViewCell.m
//  FBCircle
//
//  Created by gaomeng on 14-8-27.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GallJiuyuanduiTableViewCell.h"

@implementation GallJiuyuanduiTableViewCell

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
-(void)loadViewWithIndexPath:(NSIndexPath*)theIndexPath{
    //头像
    self.faceImv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 46, 46)];
    [self.contentView addSubview:self.faceImv];
    self.faceImv.backgroundColor = [UIColor purpleColor];
    
    //名称
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.faceImv.frame)+11, 14, 204, 17)];
    self.nameLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.nameLabel];
    
}

//填充数据
-(void)configWithDataModel:(BMKPoiInfo*)poiModel indexPath:(NSIndexPath*)TheIndexPath{
    
}









@end
