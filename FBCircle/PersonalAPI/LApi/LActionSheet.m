//
//  LActionSheet.m
//  FBCircle
//
//  Created by lichaowei on 14-8-11.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "LActionSheet.h"
#define KLEFT 20
#define KTOP 20
#define DIS_SMALL 10
#define DIS_BIG 22

@implementation LActionSheet

- (id)initWithTitles:(NSArray *)titles images:(NSArray *)images sheetStyle:(SHEET_STYLE)style action:(ActionBlock)aBlock
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // Initialization code
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.window.windowLevel = UIWindowLevelAlert;
        
        bgView = [[UIView alloc]init];
        [self addSubview:bgView];
        
        actionBlock = aBlock;
        
        aStyle = style;
        
        if (style == Style_Normal) {
            
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            
            self.alpha = 0.0;
            
            bgView.backgroundColor = [UIColor clearColor];
            bgView.autoresizesSubviews = YES;
            bgView.clipsToBounds = YES;
            
            UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(572/2.f + 2, 0, 11, 5)];
            arrow.image = [UIImage imageNamed:@"zhankaijiantou22_10"];
            [bgView addSubview:arrow];
            
            UIView *section_bgview = [[UIView alloc]init];
            section_bgview.backgroundColor = [UIColor whiteColor];
            section_bgview.layer.cornerRadius = 3.f;
            
            section_bgview.autoresizesSubviews = YES;
            section_bgview.clipsToBounds = YES;
            [bgView addSubview:section_bgview];
            
            for (int i = 0; i < titles.count; i ++) {
                UIImage *aImage = [images objectAtIndex:i];
                NSString *title = [titles objectAtIndex:i];
                
                LButtonView *btn = [[LButtonView alloc]initWithFrame:CGRectMake(0, 50 * i, DEVICE_WIDTH, 50) leftImage:aImage rightImage:nil title:title target:self action:@selector(actionToDo:) lineDirection:Line_No];
                btn.tag = 100 + i;
                [section_bgview addSubview:btn];
                
                if (i < titles.count - 1) {
                    UIImageView *line_h = [[UIImageView alloc]initWithFrame:CGRectMake(15, btn.bottom - 1, self.width - 30, 0.5f)];
                    line_h.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
                    [section_bgview addSubview:line_h];
                }
                
            }
            
            section_bgview.frame = CGRectMake(0, 5, DEVICE_WIDTH, 50 * titles.count);
            
            _sumHeight = 50 * titles.count + 5;
            bgView.frame = CGRectMake(0, 0, DEVICE_WIDTH, 0);
            
            
        }else if (style == Style_SideBySide)
        {
            
            bgView.backgroundColor = [UIColor colorWithHexString:@"575757"];
            bgView.layer.cornerRadius = 3.f;
//            bgView.autoresizesSubviews = YES;
            bgView.clipsToBounds = YES;
            
            for (int i = 0; i < titles.count; i ++) {
                
                UIImage *aImage = [images objectAtIndex:i];
                NSString *title = [titles objectAtIndex:i];
                
                LButtonView *btn = [[LButtonView alloc]initWithFrame:CGRectMake(5 + 70 * i, 0, 72, 75/2.f) leftImage:aImage rightImage:nil title:title target:self action:@selector(actionToDo:) lineDirection:Line_No];
                btn.backgroundColor = [UIColor colorWithHexString:@"575757"];
                btn.tag = 100 + i;
                btn.titleLabel.textColor = [UIColor whiteColor];
                [bgView addSubview:btn];
                btn.imageView.left += 3.f;
            }
            
                UIImageView *line_h = [[UIImageView alloc]initWithFrame:CGRectMake(0, 13, 1, 13)];
//                line_h.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
            line_h.backgroundColor = [UIColor lightGrayColor];
                [bgView addSubview:line_h];
        
            
            bgView.frame = CGRectMake(0, 0, 0, 75/2.f);
            
            _sumHeight = 10 + 70 * titles.count + 10;
            
            line_h.center = CGPointMake(_sumHeight / 2.f - 3, line_h.center.y);
            
        }else if (style == Style_Bottom)
        {
            for (int i = 0; i < titles.count; i ++) {
                NSString *title = [titles objectAtIndex:i];
                UIImage *aImage = [images objectAtIndex:i];
                if (i == 0) {
                    UILabel *titleL = [LTools createLabelFrame:CGRectMake(0, 10, self.width, 45) title:title font:14 align:NSTextAlignmentCenter textColor:[UIColor blackColor]];
                    [bgView addSubview:titleL];
                }else
                {
                    UIButton *btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(22, 10 + 45 + 10 + (15 + 45) * (i - 1), self.width - 22 * 2, 45) normalTitle:title image:nil backgroudImage:aImage superView:bgView target:self action:@selector(actionToDo:)];
                    btn.layer.cornerRadius = 3.f;
                    btn.tag = 100 + i;
                    
                    if (i == 1) {
                        btn.backgroundColor = [UIColor colorWithHexString:@"06be04"];
                    }else if (i == 2)
                    {
                        btn.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        btn.layer.borderWidth = 0.5f;
                        btn.layer.borderColor = [UIColor colorWithHexString:@"aaaaaa"].CGColor;
                        
                    }
                }
                
                self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
                self.alpha = 0.0;
                bgView.backgroundColor = [UIColor colorWithHexString:@"edecf1"];
                bgView.frame = CGRectMake(0, [UIApplication sharedApplication].keyWindow.bottom, DEVICE_WIDTH, 10 + 60 * titles.count + 10);
            }
        }
        
        [self addSubview:bgView];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
    }
    return self;
}


- (void)showFromView:(UIView *)aView
{
    //相对于屏幕坐标
    CGRect newFrame = [aView.superview convertRect:aView.frame toView:[UIApplication sharedApplication].keyWindow];

    CGRect aFrame = bgView.frame;
    
    
    if (aStyle == Style_Normal) {
        
        bgView.top = newFrame.origin.y + newFrame.size.height - 5;
    
        aFrame = bgView.frame;
        aFrame.size.height = _sumHeight;
        
    }else if (aStyle == Style_SideBySide){
        
        bgView.top = newFrame.origin.y - 5 + 1;
        bgView.left = newFrame.origin.x - 5;
//
//        aFrame = bgView.frame;
//        aFrame.size.width = _sumHeight - 5;
////        aFrame.origin.x = _sumHeight - 5;
//        
//        aFrame.origin.x = _sumHeight;
        
    }else if (aStyle == Style_Bottom)
    {
        aFrame.origin.y = [UIApplication sharedApplication].keyWindow.bottom - aFrame.size.height;
    }
    self.alpha = 1.0;
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        bgView.frame = aFrame;
//    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        if (aStyle == Style_SideBySide) {
            
            CGFloat aLeft = DEVICE_WIDTH - (320 - (_sumHeight - 5 - 10 - 30));
            
            bgView.frame = CGRectMake(aLeft, newFrame.origin.y - 5 + 1, _sumHeight - 5, bgView.height);
            
        }else
        {
           bgView.frame = aFrame;
        }
        
    } completion:^(BOOL finished) {
        
        if (aStyle == Style_SideBySide){
            
            if (finished) {
                
                [UIView animateWithDuration:0.1 animations:^{
//                    bgView.left -= 5;
                    
                    CGFloat aLeft = DEVICE_WIDTH - (320 - (_sumHeight - 5 - 10 - 30));
                    
                    bgView.frame = CGRectMake(aLeft, newFrame.origin.y - 5 + 1, _sumHeight - 5, bgView.height);

                }];
                
            }
        }
        
    }];
}

- (void)actionToDo:(LButtonView *)button
{
    //0,1,2
    actionBlock(button.tag - 100);
    [self hidden];
}

- (void)hidden
{
    if (aStyle == Style_Bottom) {
       CGRect aFrame = bgView.frame;
        
        [UIView animateWithDuration:2 animations:^{
            
//            aFrame.size.height = 0;
            
            bgView.frame = aFrame;
            
            self.alpha = 0.0;
            
        }];
        
    }
    
    [self removeFromSuperview];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hidden];
}
@end
