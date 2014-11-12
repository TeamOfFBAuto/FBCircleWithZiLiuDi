//
//  HotTopicCell.m
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "HotTopicCell.h"
#import "TopicModel.h"

@implementation HotTopicCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellWithModel:(TopicModel *)aModel
{
    NSString *imageUrl = aModel.forumpic;
    if ([aModel.img count] > 0) {
        imageUrl = [aModel.img objectAtIndex:0];
    }
    [self.aImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:FBCIRCLE_DEFAULT_IMAGE];
    
    aModel.title = aModel.title.length == 0 ? @"" : aModel.title;
    NSMutableString *title = [NSMutableString stringWithString:aModel.title];
    [title replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, title.length)];
    
    self.aTitleLabel.text = (NSString *)title;
    
    NSString *content = aModel.sub_content ? aModel.sub_content : aModel.content;
    content = content.length == 0 ? @"" : content;
    
    NSMutableString *mu_content = [NSMutableString stringWithString:content];
    
    [mu_content replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, mu_content.length)];
    
    self.subTitleLabel.text = mu_content;
}

@end
