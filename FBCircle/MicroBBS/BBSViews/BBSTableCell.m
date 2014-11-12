//
//  BBSTableCell.m
//  FBCircle
//
//  Created by lichaowei on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BBSTableCell.h"
#import "TopicModel.h"

@implementation BBSTableCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"BBSTableCell" owner:self options:nil]objectAtIndex:0];
    }
    return self;
}

-(void)setCellWithModel:(TopicModel *)aModel
{
    NSString *imageUrl;
    if ([aModel.img count] > 0) {
        imageUrl = [aModel.img objectAtIndex:0];
    }
    
    imageUrl = aModel.forumpic ? aModel.forumpic : imageUrl;
    
    [self.aImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:FBCIRCLE_DEFAULT_IMAGE];
    self.aTitleLabel.text = aModel.title;
    self.aTitleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MID];
    _aTitleLabel.textColor = [UIColor colorWithHexString:@"1d222b"];
    
    NSString *sub = aModel.sub_content ? aModel.sub_content : aModel.content;
    self.subTitleLabel.text = [LTools stringHeadNoSpace:sub];
    
    
    self.subTitleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_SMALL];
    _subTitleLabel.textColor = [UIColor colorWithHexString:@"9197a3"];
    
}

@end
