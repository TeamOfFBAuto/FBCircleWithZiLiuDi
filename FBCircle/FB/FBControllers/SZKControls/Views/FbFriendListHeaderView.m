//
//  FbFriendListHeaderView.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-16.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FbFriendListHeaderView.h"

@implementation FbFriendListHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor=[UIColor whiteColor];
        
        for (int i=0; i<2; i++) {
            UIView *lingV=[[UIView alloc]initWithFrame:CGRectMake(12, 24.5*i, 320-24, 0.5)];
            lingV.backgroundColor=RGBCOLOR(225, 225, 225);
            [self addSubview:lingV];
            
        }
        
        
        _Alabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 0.5, 320-24, 24)];
        
//        _label.text=[NSString stringWithFormat:@"%c",'A'+section];
        
        _Alabel.backgroundColor=[UIColor grayColor];
        
        _Alabel.backgroundColor=RGBCOLOR(250, 250, 250);
        
        [self addSubview:_Alabel];

        
    }
    return self;
}


-(void)setsection:(int)sectionofrow{

    _Alabel.text=[NSString stringWithFormat:@"    %c",'A'+sectionofrow];

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
