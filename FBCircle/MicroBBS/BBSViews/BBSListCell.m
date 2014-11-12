//
//  BBSListCell.m
//  FBCircle
//
//  Created by lichaowei on 14-8-7.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BBSListCell.h"
#import "TopicModel.h"

@implementation BBSListCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellDataWithModel:(TopicModel *)aModel
{
    self.aTitleLabel.text = aModel.title;
    
//    self.aTitleLabel.text = @"标题就是那么短那么长开始交按揭贷款阿克苏加打卡机SD卡阿卡撒娇的卡撒娇的卡阿克苏的就卡机是阿达见刷卡机";
    
    _aTitleLabel.font = [UIFont systemFontOfSize:14];
    
    NSString *address = [LTools NSStringNotNull:aModel.address];
    
    NSString *str = [address isEqualToString:@""] ? [NSString stringWithFormat:@"%@",aModel.username] : [NSString stringWithFormat:@"%@  |  %@",aModel.username,aModel.address];
    
    self.nameAndAddressLabel.text = str;
    _nameAndAddressLabel.textColor = [UIColor colorWithHexString:@"959595"];
    
    self.timeAndCommentLabel.text = [NSString stringWithFormat:@"%@  |   %@评论",[ZSNApi timestamp:aModel.time],aModel.comment_num];
    _timeAndCommentLabel.textColor = [UIColor colorWithHexString:@"959595"];
//    小野人  |  广东 佛山
//    13分钟前  |   10评论
    
//    [self updateFrame:aModel.title];

}
//
//+ (CGFloat)heightForText:(NSString *)text
//{
//    
////    text = @"标题就是那么短那么长开始交按揭贷款阿克苏加打卡机SD卡阿卡撒娇的卡撒娇的卡阿克苏的就卡机是阿达见刷卡机";
//    CGFloat aHeight = [LTools heightForText:text width:280 font:14.f];
//    NSLog(@"---> %f",aHeight);
//    if (aHeight < 20.f) {
//        
//        return 75 - 19.f;
//    }
//    
//    return 75;
//}

//- (void)updateFrame:(NSString *)text
//{
//    CGFloat aHeight = [LTools heightForText:text width:280 font:14.f];
////    NSLog(@"---> %f",aHeight);
////    if (aHeight < 20.f) {
////        
////        return 75 - 19.f;
////    }
//    
//    CGFloat sumH = aHeight < 20.f ? (75 - 19.f) : 75.f;
//    self.timeAndCommentLabel.top = sumH - 10.f - self.timeAndCommentLabel.height;
//    self.nameAndAddressLabel.top = self.timeAndCommentLabel.top;
//
//    
//    aHeight = (aHeight < 20.f) ? 19.f : 38.f;
//
//    self.aTitleLabel.top = 10.f;
//    self.aTitleLabel.height = aHeight;
//}

@end
