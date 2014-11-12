//
//  FBCircleDetailPraiseView.h
//  FBCircle
//
//  Created by soulnear on 14-5-23.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AsyncImageView.h"
#import "FBCirclePraiseModel.h"
#import "RTLabel.h"


@protocol FBCircleDetailPraiseViewDelegate <NSObject>

-(void)clickHeaderShowInfomationWith:(NSString *)theUid;

@end


@interface FBCircleDetailPraiseView : UIView
{
    NSMutableArray * data_array;
}

@property(nonatomic,assign)id<FBCircleDetailPraiseViewDelegate>delegate;


@property(nonatomic,strong)UIImageView * praise_imageView;

@property(nonatomic,strong)UIImageView * up_line_view;

@property(nonatomic,strong)UIView * bottom_line_view;

@property(nonatomic,strong)UIView * aView;

@property(nonatomic,strong)UIView * left_view;

@property(nonatomic,strong)UIView * right_view;


-(float)loadAllUserImagesWith:(NSMutableArray *)array;

-(float)loadAllUserNameWith:(NSMutableArray *)theNameString;



@end
