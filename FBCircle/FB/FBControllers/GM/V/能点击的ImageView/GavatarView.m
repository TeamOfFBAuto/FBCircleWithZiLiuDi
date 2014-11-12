//
//  GavatarView.m
//  FBCircle
//
//  Created by gaomeng on 14-5-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GavatarView.h"

@implementation GavatarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
        
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)doTap:(UITapGestureRecognizer *)sender
{
    if (self.avatarClickedBlock) {
        self.avatarClickedBlock();
    }
}


-(void)setAvatarClickedBlock:(AvatarClickedBlock)avatarClickedBlock{
    _avatarClickedBlock = avatarClickedBlock;
}




@end
