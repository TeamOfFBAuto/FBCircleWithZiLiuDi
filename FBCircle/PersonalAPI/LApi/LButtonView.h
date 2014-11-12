//
//  LButtonView.h
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  自定义可点击 横条
 */
typedef enum {
    Line_No = 0, //没有
    Line_Up, //线在上
    Line_Down //线在下
}Line_Direction;

@interface LButtonView : UIView

@property(nonatomic,retain)UIImageView *imageView;

@property(nonatomic,retain)UIImageView *rightImageView;

@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,retain)UIColor *selcted_TitleColor;

@property(nonatomic,retain)UIImageView *line_horizon;

@property(nonatomic,weak)id target;


- (id)initWithFrame:(CGRect)frame
           imageUrl:(NSString *)url
   placeHolderImage:(UIImage *)defaulImage
              title:(NSString *)title
             target:(id)target
             action:(SEL)action;

- (id)initWithFrame:(CGRect)frame
           leftImage:(UIImage*)aImage
              title:(NSString *)title
             target:(id)target
             action:(SEL)action;

- (id)initWithFrame:(CGRect)frame
          leftImage:(UIImage *)leftImage
         rightImage:(UIImage *)rightImage
              title:(NSString *)title
             target:(id)target
             action:(SEL)action
      lineDirection:(Line_Direction)direction;

@end
