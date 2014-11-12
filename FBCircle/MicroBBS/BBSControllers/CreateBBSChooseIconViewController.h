//
//  CreateBBSChooseIconViewController.h
//  FBCircle
//
//  Created by soulnear on 14-8-13.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CreateBBSChooseIconViewControllerDelegate <NSObject>

-(void)completeChooseIconWithImageName:(NSString *)imageName;

@end

@interface CreateBBSChooseIconViewController : MyViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}


@property(nonatomic,strong)UITableView * myTableView;

@property(nonatomic,weak)id<CreateBBSChooseIconViewControllerDelegate>delegate;


@end
