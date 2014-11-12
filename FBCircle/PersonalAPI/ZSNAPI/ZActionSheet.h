//
//  ZActionSheet.h
//  FBCircle
//
//  Created by soulnear on 14-8-19.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZActionSheet;
@protocol ZActionSheetDelegate <NSObject>

-(void)zactionSheet:(ZActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


@interface ZActionSheet : UIView
{
    
}

///标题
@property(nonatomic,strong)UILabel * title_label;

///内容
@property(nonatomic,strong)UIView * content_view;

///代理
@property(nonatomic,assign)id<ZActionSheetDelegate>delegate;

/**
 @param aTitle 标题
 @param buttonTitles 内容标题
 @param buttonColor 内容背景色
 @param canceTitle 取消按钮标题
 @param cancelColor 取消按钮背景色
 @param actionColor actionSheet背景色
 */

-(ZActionSheet *)initWithTitle:(NSString *)aTitle buttonTitles:(NSArray *)buttonTitles buttonColor:(UIColor *)buttonColor CancelTitle:(NSString *)canceTitle CancelColor:(UIColor *)cancelColor actionBackColor:(UIColor *)actionColor;



-(void)showInView:(UIView *)view WithAnimation:(BOOL)animatio;











@end























