//
//  FBCirclePicturesViews.h
//  FBCircle
//
//  Created by soulnear on 14-5-21.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FBCirclePicturesViewsBlocs)(NSInteger index);



@interface FBCirclePicturesViews : UIView
{
    
}

@property(nonatomic,assign)BOOL isReply;

@property(nonatomic,copy)FBCirclePicturesViewsBlocs mybloc;




-(void)setImageUrls:(NSString *)theUrl withSize:(int)size isjuzhong:(BOOL)juzhong;

-(void)setimageArr:(NSArray *)imgarr withSize:(int)size isjuzhong:(BOOL)juzhong;

-(void)setthebloc:(FBCirclePicturesViewsBlocs)thechuanbloc;





@end
