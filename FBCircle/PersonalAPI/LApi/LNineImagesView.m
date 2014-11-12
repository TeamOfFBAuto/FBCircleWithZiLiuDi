//
//  LNineImagesView.m
//  FBCircle
//
//  Created by lichaowei on 14-8-8.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "LNineImagesView.h"

@implementation LNineImagesView

- (id)initWithFrame:(CGRect)frame images:(NSArray *)imageUrls imageIndex:(ImageIndexBlock)imageIndexBLock
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _imageIndexBlock = imageIndexBLock;
        int line = 0;//行
        int k = 0;//列
        
        if (imageUrls.count != 0) {
            CGFloat aWidth = (frame.size.width - 3 * 2)/3.f;//单个宽度
            
            for (int i = 0; i < imageUrls.count; i ++) {
                
                line = i / 3;
                k = i % 3;
                
                UIImageView *aImageView = [[UIImageView alloc]initWithFrame:CGRectMake((aWidth + 3) * k, (aWidth + 3) * line, aWidth, aWidth)];
                [aImageView sd_setImageWithURL:[NSURL URLWithString:[imageUrls objectAtIndex:i]] placeholderImage:FBCIRCLE_DEFAULT_IMAGE];
                aImageView.userInteractionEnabled = YES;
                [self addSubview:aImageView];
                
                aImageView.tag = 100 + i;
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage:)];
                [aImageView addGestureRecognizer:tap];
            }
            
            frame.size.height = (line + 1) * aWidth + line * 3;
            self.frame = frame;
        }
        
    }
    return self;
}

- (void)clickImage:(UIGestureRecognizer *)gesture
{
    int tag = gesture.view.tag;
    NSLog(@"%d",tag);
    
    if (_imageIndexBlock) {
        _imageIndexBlock(tag - 100);
    }
}


@end
