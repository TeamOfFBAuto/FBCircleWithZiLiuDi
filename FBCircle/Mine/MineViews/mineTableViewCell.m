//
//  mineTableViewCell.m
//  FBCircle
//
//  Created by 史忠坤 on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//


#define ICONLEFT 12 //图标距离左边的距离

#define ICONHIGH 9   //图标距离上面的距离


#define TITLELEFT 50

#import "mineTableViewCell.h"

@implementation mineTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.iconImageV=[[UIImageView alloc]initWithFrame:CGRectMake(ICONLEFT, ICONHIGH, 26, 26)];
        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(TITLELEFT, 14, 200, 16)];
        self.lineView=[[UIView alloc]init];
        self.whitView=[[UIView alloc]init];
        
        [self addSubview:self.whitView];
        [self.whitView addSubview:self.iconImageV];
        [self.whitView addSubview:self.titleLabel];
        [self.whitView addSubview:self.lineView];

        self.titleLabel.textAlignment=NSTextAlignmentLeft;
        self.titleLabel.font=[UIFont systemFontOfSize:15];
        self.whitView.backgroundColor=[UIColor whiteColor];
//        self.backgroundColor=RGBCOLOR(246, 247, 249);
        
        self.backgroundColor = COLOR_VIEW_BACKGROUND;
        
        
        CALayer *l = [self.iconImageV layer];   //获取ImageView的层
        [l setMasksToBounds:YES];
        [l setCornerRadius:2.0f];
//        self.iconImageV.backgroundColor=[UIColor redColor];
        
        self.selectionStyle=UITableViewCellSelectionStyleBlue;

        
    }
    return self;
}



-(void)setTitletext:(NSString *)thetitlestring iconstring:(NSString *)theiconstring type:(mineTableViewCellType)thetype{

    self.iconImageV.image=[UIImage imageNamed:theiconstring];
    
    self.titleLabel.text=thetitlestring;
    
    if (thetype==mineTableViewCellTypeFirst) {
        
        self.whitView.frame=CGRectMake(0, 32, 320, 44);
        
        self.lineView.frame=CGRectMake(0, 43, 320, 1);
        
        self.lineView.backgroundColor=RGBCOLOR(235, 235, 235);
        
        
    }else if(thetype==mineTableViewCellTypeSecond){
        
        self.whitView.frame=CGRectMake(0, 32, 320, 44);
        
        self.lineView.frame=CGRectMake(0, 43, 320, 1);
        
        self.lineView.backgroundColor=RGBCOLOR(235, 235, 235);

        
        
    }else if(thetype==FBQuanAlertViewTypeHaveOther){
        
        self.whitView.frame=CGRectMake(0, 0, 320, 44);
        
        self.lineView.frame=CGRectMake(44, 43.5, 320, 0.5);
        
        self.lineView.backgroundColor=RGBCOLOR(229, 232, 239);

    }else{
        
        self.whitView.frame=CGRectMake(0, 0, 320, 44);
        
        self.lineView.frame=CGRectMake(0, 43, 320, 1);
        
        self.lineView.backgroundColor=RGBCOLOR(235, 235, 235);

    }

    



}


+(CGFloat)mineTableViewCellGetCellHeightWithType:(mineTableViewCellType)thecellType{

    if (thecellType==mineTableViewCellTypeFirst) {
        
        return 76;
        
    }else if(thecellType==mineTableViewCellTypeSecond){
    
        return 108;
    
    
    }else if(thecellType==FBQuanAlertViewTypeHaveOther){
    
        return 44;
    
    }else{
    
        return 100;
    
    }

}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
