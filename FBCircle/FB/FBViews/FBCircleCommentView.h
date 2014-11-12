//
//  FBCircleCommentView.h
//  FBCircle
//
//  Created by soulnear on 14-5-21.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "FBCircleCommentModel.h"


@protocol FBCircleCommentViewDelegate <NSObject>

-(void)clickUserNameWithUid:(NSString *)theUid;

@end



@interface FBCircleCommentView : UIView<RTLabelDelegate,OHAttributedLabelDelegate>
{
    
}


@property(nonatomic,assign)id<FBCircleCommentViewDelegate>delegate;



-(float)setAllViewsWith:(NSMutableArray *)dataArray;



@end
