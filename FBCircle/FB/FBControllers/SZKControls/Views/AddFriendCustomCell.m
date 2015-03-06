//
//  AddFriendCustomCell.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-21.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "AddFriendCustomCell.h"

@implementation AddFriendCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imglogo=[[UIImageView alloc]init];
        [self addSubview:_imglogo];
        _labeltitle=[[UILabel alloc]init];
        [self addSubview:_labeltitle];
        _labeltitle.font=[UIFont boldSystemFontOfSize:16];
        _labeltitle.textAlignment=NSTextAlignmentLeft;
        
        _shortLine=[[UIView alloc]init];
        _shortLine.backgroundColor=RGBCOLOR(223, 226, 235);
        [self addSubview:_shortLine];
        
        
        
    }
    return self;
}

-(void)AddFriendCustomCellSetimg:(NSString *)str_img title:(NSString *)thetitle theAddFriendCustomCellType:(AddFriendCustomCellType)myrtpe{


    _imglogo.image=[UIImage imageNamed:str_img];

    _labeltitle.text=thetitle;
    
    _shortLine.frame=CGRectMake(myrtpe?0:44, 45.5,DEVICE_WIDTH , 0.5);

}
-(void)layoutSubviews{
    [super layoutSubviews];
    _imglogo.frame=CGRectMake(12, 12, 21, 21);
    
    _labeltitle.frame=CGRectMake(50, 12, 200, 20);
    
    
    


}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
