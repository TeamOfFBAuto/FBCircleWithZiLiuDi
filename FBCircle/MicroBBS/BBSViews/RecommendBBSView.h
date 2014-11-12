//
//  RecommendBBSView.h
//  FBCircle
//
//  Created by lichaowei on 14/10/30.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendBBSView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *dataArray;
    NSString *_title;
}

-(instancetype)initWithFrame:(CGRect)frame
                       title:(NSString *)title
                     dataArr:(NSArray *)dataArr;

@end
