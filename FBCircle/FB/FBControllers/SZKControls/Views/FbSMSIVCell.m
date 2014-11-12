//
//  FbSMSIVCell.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FbSMSIVCell.h"

@implementation FbSMSIVCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle=UITableViewCellSelectionStyleBlue;
        
//        _selectButton=[[UIButton alloc]init];
//        [_selectButton setImage:[UIImage imageNamed:@"unaccept38_38.png"] forState:UIControlStateNormal];
//        [_selectButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 240)];
       // [_selectButton addTarget:self action:@selector(changeSelectStyle:) forControlEvents:UIControlEventTouchUpInside];
       // [self.contentView addSubview:_selectButton];
        
        _selectimV=[[UIImageView alloc]initWithFrame:CGRectMake(26,( 45-19)/2, 19, 19)];
        _selectimV.image=[UIImage imageNamed:@"jieshoukuang-38_38.png"];
        [self.contentView addSubview:_selectimV];
        
        _nameLabel=[[UILabel alloc]init];
        _nameLabel.font=[UIFont systemFontOfSize:13];
        _nameLabel.textColor=[UIColor blackColor];
        [self.contentView addSubview:_nameLabel];
        
        _isSelected=NO;
        
        _rowOfpath=0;
        
    }
    return self;
}


-(void)layoutSubviews{

    [super layoutSubviews];
    
 
    _selectimV.frame=CGRectMake(26,( 45-19)/2, 19, 19);
    _selectButton.frame=CGRectMake(0, 0, 320, 45);
    _nameLabel.frame=CGRectMake(65, 15, 200, 15);
    
    
    
}
-(void)setNameStr:(NSString*)strName row:(NSInteger)theRowOfPath FriendAttributes:(FriendAttribute *)theModel  fbsmsbloc:(FbSMSIVCellBloc)thebloc{
    
  


    _mybloc=thebloc;
    _rowOfpath=theRowOfPath;
    _nameLabel.text=strName;
    _FbSMSIVCellModel=theModel;
}

-(void)setSelect{
    
  
  

}

-(void)changeSelectStyle:(UIButton *)sender{
//    _isSelected=!_isSelected;
//    
//    if (_isSelected) {
//        
//        [_selectButton setImage:[UIImage imageNamed:@"accept38_38.png"] forState:UIControlStateNormal];
//
//    }else{
//        [_selectButton setImage:[UIImage imageNamed:@"unaccept38_38.png"] forState:UIControlStateNormal];
//        
//    }
//
//    
//    _mybloc(_rowOfpath,_isSelected,_FbSMSIVCellModel);
//    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
