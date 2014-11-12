//
//  GJiuYuanCell.m
//  FBCircle
//
//  Created by gaomeng on 14-8-15.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GJiuYuanCell.h"
#import "UILabel+GautoMatchedText.h"


@implementation GJiuYuanCell

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
    
    self.titielImav  = [[UIImageView alloc]init];
    if (theIndexPath.row == 0) {
        self.titielImav.frame = CGRectMake(18, 15, 15, 15);
        [self.titielImav setImage:[UIImage imageNamed:@"fhome.png"]];
    }else if (theIndexPath.row == 1){
        self.titielImav.frame = CGRectMake(18, 15, 15, 15);
        [self.titielImav setImage:[UIImage imageNamed:@"fearth.png"]];
    }else if (theIndexPath.row == 2){
        self.titielImav.frame = CGRectMake(18, 15, 15, 15);
        [self.titielImav setImage:[UIImage imageNamed:@"fgeren.png"]];
    }else if (theIndexPath.row == 3){
        self.titielImav.frame = CGRectMake(18, 15, 15, 15);
        [self.titielImav setImage:[UIImage imageNamed:@"ftel.png"]];
        
    }
    
    [self.contentView addSubview:self.titielImav];
    [self.contentView addSubview:self.contentLabel];
    
}


//填充数据
-(CGFloat)configWithDataModel:(BMKPoiInfo*)poiModel indexPath:(NSIndexPath*)TheIndexPath{
    
    float cellHeight = 0.0f;
    
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    
    NSLog(@"%@",poiModel.postcode);
    if (TheIndexPath.row == 0) {
        self.contentLabel.text = poiModel.name;
        [self.contentLabel setMatchedFrame4LabelWithOrigin:CGPointMake(52, 14) width:187];
    }else if (TheIndexPath.row == 1){
        self.contentLabel.text = poiModel.address;
        [self.contentLabel setMatchedFrame4LabelWithOrigin:CGPointMake(52, 14) width:187];
    }else if (TheIndexPath.row == 2){
        self.contentLabel.text = poiModel.postcode;
        [self.contentLabel setMatchedFrame4LabelWithOrigin:CGPointMake(52, 14) width:187];
    }else if (TheIndexPath.row == 3){
        self.contentLabel.text = poiModel.phone;
        [self.contentLabel setMatchedFrame4LabelWithOrigin:CGPointMake(52, 14) width:187];
    }
    
    
    [self.contentView addSubview:self.contentLabel];
    
    cellHeight = 15+self.contentLabel.frame.size.height +15;
    
    return cellHeight;
    
}


@end
