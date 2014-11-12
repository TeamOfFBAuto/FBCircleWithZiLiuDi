//
//  ZKingLoadingView.h
//  FBCircle
//
//  Created by 史忠坤 on 14-6-3.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKingLoadingView : UIView
+ (ZKingLoadingView *)sharedManager;

-(void)startLoading;
@end
