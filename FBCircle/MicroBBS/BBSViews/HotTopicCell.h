//
//  HotTopicCell.h
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  热门推荐帖子
 */
@class TopicModel;
@interface HotTopicCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *aImageView;
@property (strong, nonatomic) IBOutlet UILabel *aTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *bottomLine;

-(void)setCellWithModel:(TopicModel *)aModel;

@end
