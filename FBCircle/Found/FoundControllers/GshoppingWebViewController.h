//
//  GshoppingWebViewController.h
//  FBCircle
//
//  Created by gaomeng on 14-8-27.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GshoppingWebViewController : MyViewController<UIWebViewDelegate>
{
    UIWebView *awebview;
    UIButton *button_comment;
    UILabel *titleview;
    
    NSMutableArray *my_array;
    NSString *string_title;
}
@property(nonatomic,strong) NSString * urlstring;

@end
