//
//  GcustomUseCarDownInfoCell.m
//  FBCircle
//
//  Created by gaomeng on 14-8-14.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GcustomUseCarDownInfoCell.h"
#import "GMAPI.h"

#import "UILabel+GautoMatchedText.h"

@implementation GcustomUseCarDownInfoCell

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





-(void)loadViewWithIndexPath:(NSIndexPath*)theIndexPath{
    
    self.titielImav  = [[UIImageView alloc]init];
    if (theIndexPath.row == 0) {
        self.titielImav.frame = CGRectMake(18, 15, 15, 15);
        [self.titielImav setImage:[UIImage imageNamed:@"fhome.png"]];
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    }else if (theIndexPath.row == 1){
        self.titielImav.frame = CGRectMake(18, 15, 15, 15);
        [self.titielImav setImage:[UIImage imageNamed:@"fearth.png"]];
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    }else if (theIndexPath.row == 2){
        self.titielImav.frame = CGRectMake(18, 15, 15, 15);
        [self.titielImav setImage:[UIImage imageNamed:@"ftel.png"]];
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    }
    
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    
    
    [self.contentView addSubview:self.titielImav];
    [self.contentView addSubview:self.contentLabel];
    
}





//填充数据
-(CGFloat)configWithDataModel:(BMKPoiInfo*)poiModel indexPath:(NSIndexPath*)TheIndexPath{
    
    CGFloat cellHeight = 0.0f;
    
    
    if (TheIndexPath.row == 0) {
        self.contentLabel.text = [GMAPI exchangeStringForDeleteNULL:poiModel.name];
        [self.contentLabel setMatchedFrame4LabelWithOrigin:CGPointMake(52, 14) width:187];
    }else if (TheIndexPath.row == 1){
        self.contentLabel.text = [GMAPI exchangeStringForDeleteNULL:poiModel.address];
        [self.contentLabel setMatchedFrame4LabelWithOrigin:CGPointMake(52, 14) width:187];
    }else if (TheIndexPath.row == 2){
        self.contentLabel.text = [GMAPI exchangeStringForDeleteNULL:poiModel.phone];
        [self.contentLabel setMatchedFrame4LabelWithOrigin:CGPointMake(52, 14) width:187];
        
    }
    
    NSLog(@"contentLabel.text = %@",self.contentLabel.text);
    
    NSLog(@"自适应label高度%f",self.contentLabel.frame.size.height);
    
    cellHeight = 15+self.contentLabel.frame.size.height+15;
    
    NSLog(@"%s 单元格cellheight高度%f",__FUNCTION__,cellHeight);
    
    return cellHeight;
}


@end
