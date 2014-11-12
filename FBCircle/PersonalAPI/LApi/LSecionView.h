//
//  LSecionView.h
//  FBCircle
//
//  Created by lichaowei on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSecionView : UIView

@property(nonatomic,retain)UIButton *rightBtn;
-(id)initWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;
@end
