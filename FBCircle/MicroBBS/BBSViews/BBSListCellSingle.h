//
//  BBSListCellSingle.h
//  FBCircle
//
//  Created by lichaowei on 14/10/31.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopicModel;
@interface BBSListCellSingle : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *aTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameAndAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeAndCommentLabel;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *downMask;
@property (strong, nonatomic) IBOutlet UIView *upMask;
@property (strong, nonatomic) IBOutlet UIView *bottomLine;

- (void)setCellDataWithModel:(TopicModel *)aModel;

@end
