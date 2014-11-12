//
//  SendPostsImageScrollView.m
//  FBCircle
//
//  Created by soulnear on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "SendPostsImageScrollView.h"

@implementation SendPostsImageScrollView
@synthesize data_array = _data_array;
@synthesize imageView_array = _imageView_array;




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _imageView_array = [NSMutableArray array];
    }
    return self;
}


//208  274
-(void)loadAllViewsWith:(NSMutableArray *)array WithBlock:(SendPostsImageScrollViewBlock)theBlock
{
    self.data_array = array;
    
    sendImage_block = theBlock;
    
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0;i < self.data_array.count;i++)
    {
        UIImage * image = [self.data_array objectAtIndex:i];
        
        CGRect rect = CGRectMake(15.5+114*i,6.5,104,137);
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:rect];
        
        imageView.image = image;
        
        imageView.tag = 100 + i;
        
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleToFill;
        
        [self addSubview:imageView];
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(preViewTap:)];
        [imageView addGestureRecognizer:tap];
            
        
        UIButton * close_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        close_button.frame = CGRectMake(82,-10,30,30);
        
        close_button.tag = 1000 + i;
        
        [close_button addTarget:self action:@selector(deleteImageTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [close_button setImage:[UIImage imageNamed:@"Send_Image_close.png"] forState:UIControlStateNormal];
        
        [imageView addSubview:close_button];
        
        [_imageView_array addObject:imageView];
    }
    
    self.contentSize = CGSizeMake(15.5+114*self.data_array.count,0);
}


-(void)deleteImageTap:(UIButton *)sender
{
    NSLog(@"button tap");
    
    if (sendImage_block)
    {
        sendImage_block(sender.tag-1000,0);
    }
    
    
    NSMutableArray * temp_array = [NSMutableArray arrayWithArray:_imageView_array];
    
    
    for (int i = 0;i < temp_array.count;i++)
    {
        UIImageView * imageView = (UIImageView *)[self viewWithTag:i+100];
        
        UIButton * button = (UIButton *)[imageView viewWithTag:1000+i];
        
        if (i == sender.tag - 1000)
        {
            [_imageView_array removeObjectAtIndex:sender.tag-1000];
            
            [imageView removeFromSuperview];
        }
        
        if (sender.tag-1000 < i)
        {
            imageView.tag = 100+i-1;
            
            button.tag = 1000 + i -1;
            
            CGRect frame = imageView.frame;
            
            frame.origin.x = 15.5+114*(i-1);
            
            [UIView animateWithDuration:0.3 animations:^{
                imageView.frame = frame;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    
//    
//    UIImageView * imageV = (UIImageView *)[_imageView_array objectAtIndex:sender.tag-1000];
//   
//    [_imageView_array removeObjectAtIndex:sender.tag-1000];
//    
//    [imageV removeFromSuperview];
    
    
    self.contentSize = CGSizeMake(15.5+114*self.imageView_array.count,0);
    
    
    
 /*
    
    UIImageView * current_imageview = (UIImageView *)[self viewWithTag:sender.tag-1000+100];
    
    [current_imageview removeFromSuperview];
    
    
    for (int i = sender.tag-1000 + 1;i < self.data_array.count;i++)
    {
        
        NSLog(@"iiiiiii -----   %d",i);
        
        UIImageView * imageview = (UIImageView *)[self viewWithTag:i+100];
        
        imageview.tag = i+100-1;
        
        CGRect rect = imageview.frame;
        
        rect.origin.x = 15.5+114*(i-1);
        
        imageview.frame = rect;
        
        UIButton * button = (UIButton *)[self viewWithTag:i+1000];
        
        button.tag = i+1000-1;
    }
    
    [self.data_array removeObjectAtIndex:sender.tag-1000];
    
    self.contentSize = CGSizeMake(15.5+114*self.data_array.count,0);
  
  */
}




#pragma mark - 跳到预览界面


-(void)preViewTap:(UITapGestureRecognizer *)sender
{
    if (sendImage_block) {
        sendImage_block(sender.view.tag-100,1);
    }
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












