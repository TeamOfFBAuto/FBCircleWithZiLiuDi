//
//  LActionSheet.h
//  FBCircle
//
//  Created by lichaowei on 14-8-11.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  弹出窗口--指定、删除
 */

typedef enum {
    Style_Normal = 0, //上下行格式
    Style_SideBySide, //一行并排
    Style_Bottom //底部,类似系统 actionSheet
    
}SHEET_STYLE;

typedef void(^ ActionBlock) (NSInteger buttonIndex);

@interface LActionSheet : UIView

{
    ActionBlock actionBlock;
    UIView *bgView;
    SHEET_STYLE aStyle;
    CGFloat _sumHeight;
}

- (id)initWithTitles:(NSArray *)titles images:(NSArray *)images sheetStyle:(SHEET_STYLE)style action:(ActionBlock)aBlock;
- (void)showFromView:(UIView *)aView;

@end
