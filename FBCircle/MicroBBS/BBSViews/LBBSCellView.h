//
//  LBBSCellView.h
//  FBCircle
//
//  Created by lichaowei on 14-8-11.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopicModel;

@interface LBBSCellView : UIView
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *aImageView;
@property (strong, nonatomic) IBOutlet UILabel *aTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;

- (id)initWithFrame:(CGRect)frame
             target:(id)target
             action:(SEL)action;
-(void)setCellWithModel:(TopicModel *)aModel;

@end
