//
//  FBCirclePromptView.m
//  FBCircle
//
//  Created by soulnear on 14-6-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBCirclePromptView.h"

@implementation FBCirclePromptView
@synthesize prompt_label = _prompt_label;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        self.layer.masksToBounds = YES;
        
        self.layer.cornerRadius = 5;
        
        
        _prompt_label = [[UILabel alloc] initWithFrame:self.bounds];
        
        _prompt_label.font = [UIFont systemFontOfSize:15];
        
        _prompt_label.textAlignment = NSTextAlignmentCenter;
        
        _prompt_label.textColor = [UIColor whiteColor];

        _prompt_label.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_prompt_label];
        
    }
    return self;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
