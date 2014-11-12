//
//  LSecionView.m
//  FBCircle
//
//  Created by lichaowei on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "LSecionView.h"
#import "UIView+Frame.h"
#import "UIColor+ConvertColor.h"

@implementation LSecionView

-(id)initWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action
{
    self = [super init];
    if (self) {
        
        CGRect aFrame = frame;
        aFrame.size.width = 304;
        self.frame = aFrame;
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 40 - 1)];
        leftLabel.text = title;
        leftLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MID];
        leftLabel.textColor = [UIColor colorWithHexString:@"141a23"];
        [self addSubview:leftLabel];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_rightBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_rightBtn setTitleColor:[UIColor colorWithHexString:@"7f7f7f"] forState:UIControlStateNormal];
        _rightBtn.frame = CGRectMake(self.width - 100, 0, 90, self.height);
        [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:FONT_SIZE_MID]];
        [_rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, leftLabel.bottom, 304, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
        [self addSubview:line];
    }
    return self;
}
@end
