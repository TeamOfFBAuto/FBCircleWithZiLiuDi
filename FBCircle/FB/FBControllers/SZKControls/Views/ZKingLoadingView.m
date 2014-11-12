//
//  ZKingLoadingView.m
//  FBCircle
//
//  Created by 史忠坤 on 14-6-3.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "ZKingLoadingView.h"

@implementation ZKingLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        
    }
    return self;
}

+ (ZKingLoadingView *)sharedManager
{
    static ZKingLoadingView *sharedLoadingView = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedLoadingView = [[self alloc] init];
    });
    return sharedLoadingView;
}


-(void)startLoading{



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
