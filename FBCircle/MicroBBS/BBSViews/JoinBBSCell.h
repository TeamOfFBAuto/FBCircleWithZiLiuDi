//
//  JoinBBSCell.h
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  分类论坛二级 （加入）
 */
typedef void(^CellBlock)(NSString *topicId);

@class BBSInfoModel;
@interface JoinBBSCell : UITableViewCell
{
    CellBlock cellBlock;
    NSString *topicId;
}

@property (strong, nonatomic) IBOutlet UIView *bottomLine;

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *aImageView;
@property (strong, nonatomic) IBOutlet UILabel *aTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *memberTitle;

@property (strong, nonatomic) IBOutlet UILabel *memeberLabel;

@property (strong, nonatomic) IBOutlet UIView *line;
@property (strong, nonatomic) IBOutlet UILabel *topicTitle;


@property (strong, nonatomic) IBOutlet UILabel *topicLabel;
@property (strong, nonatomic) IBOutlet UIButton *joinButton;


- (IBAction)clickToJoin:(id)sender;

- (void)setCellDataWithModel:(BBSInfoModel *)aModel cellBlock:(CellBlock)aBlock;

- (void)updateFrameWithModel:(BBSInfoModel *)aModel;

@end
