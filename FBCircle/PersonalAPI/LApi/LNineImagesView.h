//
//  LNineImagesView.h
//  FBCircle
//
//  Created by lichaowei on 14-8-8.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  九宫格图片
 */

typedef void(^ImageIndexBlock)(int index);
@interface LNineImagesView : UIView
{
    ImageIndexBlock _imageIndexBlock;
}
- (id)initWithFrame:(CGRect)frame images:(NSArray *)imageUrls imageIndex:(ImageIndexBlock)imageIndexBLock;
@end
