//
//  GavatarView.h
//  FBCircle
//
//  Created by gaomeng on 14-5-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//头像能触摸点击的imageview
#import <UIKit/UIKit.h>
@class GavatarView;

typedef void (^AvatarClickedBlock)();
@interface GavatarView : AsyncImageView

@property(nonatomic,copy)AvatarClickedBlock avatarClickedBlock;


-(void)setAvatarClickedBlock:(AvatarClickedBlock)avatarClickedBlock;




@end
