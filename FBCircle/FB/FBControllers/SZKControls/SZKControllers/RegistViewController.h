//
//  RegistViewController.h
//  FBCircle
//
//  Created by 史忠坤 on 14-5-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistViewController : MyViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    
    
    
}

@property(nonatomic,strong)UITableView *mmainTabV;

@property(nonatomic,strong)UIButton  *bigNextButton;



@property(nonatomic,strong)NSArray *imgArr;

@property(nonatomic,strong)NSArray *placHolderTextArr;


@property(nonatomic,strong)NSString *userNameStr;
@property(nonatomic,strong)NSString *passWordStr;
@property(nonatomic,strong)NSString *phoneNumberStr;
@property(nonatomic,strong)NSString *vertificatinNumberStr;
@property(nonatomic,strong)NSString *emailStr;

@end
