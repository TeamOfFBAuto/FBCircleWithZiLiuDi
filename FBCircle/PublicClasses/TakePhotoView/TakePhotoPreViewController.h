//
//  TakePhotoPreViewController.h
//  FBCircle
//
//  Created by soulnear on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^TakePhotoPreViewControllerBlock)(void);


@interface TakePhotoPreViewController : UIViewController
{
    TakePhotoPreViewControllerBlock take_preView_block;
}


@property(nonatomic,strong)UIImageView * imageView;

@property(nonatomic,weak)UIImage * theImage;


-(id)initWithBlock:(TakePhotoPreViewControllerBlock)theBlock;

@end
