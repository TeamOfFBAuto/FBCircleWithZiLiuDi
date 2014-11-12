//
//  mineTableViewCell.h
//  FBCircle
//
//  Created by 史忠坤 on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//



#import <UIKit/UIKit.h>



typedef enum {
    //以下是枚举成员 TestA = 0,
    mineTableViewCellTypeFirst=0,
    
    mineTableViewCellTypeSecond=1,

    
    FBQuanAlertViewTypeHaveOther=2,
    
    FBQuanAlertViewTypeHaveLast=3,

    
}mineTableViewCellType;//枚举名称


@interface mineTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *iconImageV;//左边图标

@property(nonatomic,strong)UILabel *titleLabel;//文字描述

@property(nonatomic,strong)UIView *lineView;//分割线

@property(nonatomic,strong)UIView *whitView;//上面三个都放在这个view上


-(void)setTitletext:(NSString *)thetitlestring iconstring:(NSString *)theiconstring type:(mineTableViewCellType)thetype;



+(CGFloat)mineTableViewCellGetCellHeightWithType:(mineTableViewCellType)thecellType;


@end
