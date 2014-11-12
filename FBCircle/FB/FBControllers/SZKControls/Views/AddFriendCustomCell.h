//
//  AddFriendCustomCell.h
//  FBCircle
//
//  Created by 史忠坤 on 14-5-21.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    //以下是枚举成员 TestA = 0,
    AddFriendCustomCellTypeone=0,
    FBQuanAlertViewTypeother=1,
    
}AddFriendCustomCellType;//枚举名称




@interface AddFriendCustomCell : UITableViewCell

@property(nonatomic,strong)UIImageView *imglogo;

@property(nonatomic,strong)UILabel *labeltitle;

@property(nonatomic,strong)UIView *shortLine;

-(void)AddFriendCustomCellSetimg:(NSString *)str_img title:(NSString *)thetitle theAddFriendCustomCellType:(AddFriendCustomCellType)myrtpe;



@end
