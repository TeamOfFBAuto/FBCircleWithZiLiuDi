//
//  FbmessageinvitationCell.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-14.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FbmessageinvitationCell.h"

@implementation FbmessageinvitationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _selected_button=[[UIButton alloc]init];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
