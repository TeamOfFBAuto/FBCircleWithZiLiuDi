//
//  FBCircleMenuView.h
//  FBCircle
//
//  Created by soulnear on 14-5-21.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    FBCircleMenuZan = 0,
    FBCircleMenuPinglun = 1,
    FBCircleMenuZhuanFa = 2
}FBCircleMenuType;


@protocol FBCircleMenuViewDelegate <NSObject>

-(void)clickButtonWithMenuType:(FBCircleMenuType)theType;

@end


@interface FBCircleMenuView : UIView
{
    
}

@property(nonatomic,assign)id<FBCircleMenuViewDelegate>delegate;


-(void)setAllViewsWithZan:(BOOL)isZan;

@end
