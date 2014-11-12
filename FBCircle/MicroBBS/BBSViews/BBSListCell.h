//
//  BBSListCell.h
//  FBCircle
//
//  Created by lichaowei on 14-8-7.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  论坛 帖子列表
 */
@class TopicModel;
@interface BBSListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *aTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameAndAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeAndCommentLabel;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *downMask;
@property (strong, nonatomic) IBOutlet UIView *upMask;
@property (strong, nonatomic) IBOutlet UIView *bottomLine;

- (void)setCellDataWithModel:(TopicModel *)aModel;

+ (CGFloat)heightForText:(NSString *)text;

@end
