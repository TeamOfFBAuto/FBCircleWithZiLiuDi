//
//  ShowImagesViewController.h
//  FBCircle
//
//  Created by soulnear on 14-5-22.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "MyViewController.h"
#import "QBShowImagesScrollView.h"

#import "FBQuanAlertView.h"

@interface ShowImagesViewController : UIViewController<UIScrollViewDelegate,QBShowImagesScrollViewDelegate>
{
    UIView * navgationBar;
    
    UIView * bottomView;
    
    UIButton * chooseButton;
    
    char identifier[20];
    
    UILabel * title_label;
    
    UIView * navImageView;
    
    UIButton * finish_button;
    
    UILabel * selectedLabel;
    
    FBQuanAlertView * myAlertView;
    
}

@property(nonatomic,strong)NSMutableArray * allImagesUrlArray;

@property(nonatomic,strong)UIScrollView * myScrollView;

@property(nonatomic,assign)int currentPage;


@end
