//
//  FBCircleDetailCommentsView.h
//  FBCircle
//
//  Created by soulnear on 14-5-22.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "FBCircleCommentModel.h"

@protocol FBCircleDetailCommentsViewDelegate <NSObject>

-(void)clickHeaderWith:(NSString *)theUid;

@end



@interface FBCircleDetailCommentsView : UIView
{
    FBCircleCommentModel * myModel;
}

@property(nonatomic,assign)id<FBCircleDetailCommentsViewDelegate>delegate;


@property(nonatomic,strong)AsyncImageView * headerImageView;

@property(nonatomic,strong)UILabel * userName_label;

@property(nonatomic,strong)UILabel * dateLine_label;

@property(nonatomic,strong)OHAttributedLabel * content_label;

@property(nonatomic,strong)UIImageView * upLine_view;

@property(nonatomic,strong)UIView * bottomLine_view;

@property(nonatomic,strong)UIImageView * pinglun_logo;



-(float)setInfomationWith:(FBCircleCommentModel *)model isFirst:(BOOL)isfirst;



@end
