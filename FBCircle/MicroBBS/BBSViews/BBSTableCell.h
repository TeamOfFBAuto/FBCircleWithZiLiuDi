//
//  BBSTableCell.h
//  FBCircle
//
//  Created by lichaowei on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopicModel;
@interface BBSTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *bottomLine;

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *aImageView;
@property (strong, nonatomic) IBOutlet UILabel *aTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
-(void)setCellWithModel:(TopicModel *)aModel;
@end
