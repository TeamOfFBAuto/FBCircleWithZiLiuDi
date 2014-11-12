//
//  CreateBBSChooseIconCell.h
//  FBCircle
//
//  Created by soulnear on 14-8-13.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CreateBBSChooseIconCellBlock)(int index);

@interface CreateBBSChooseIconCell : UITableViewCell
{
    CreateBBSChooseIconCellBlock choose_icon_block;
}



///加载所有标题   row:当前行数  theIndex:当前被选中图标
-(void)setAllImagesWithArray:(NSMutableArray *)array WithRow:(int)theRow WithSelectedIndex:(int)theIndex WithBlock:(CreateBBSChooseIconCellBlock)theBlock;





@end
