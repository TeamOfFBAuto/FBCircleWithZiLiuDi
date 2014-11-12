//
//  GmyFootCustomTableViewCell.h
//  FBCircle
//
//  Created by gaomeng on 14-5-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GavatarView.h"
#import "FBCircleModel.h"//单个文章对象
#import "FBCirclePersonalModel.h"//用户对象
#import "UIImageView+AFNetworking.h"

#import "UILabel+GautoMatchedText.h"

#import "LoadingIndicatorView.h"


#import "RTLabel.h"




@interface GmyFootCustomTableViewCell : UITableViewCell
{
    BOOL _isChangeTopView;//是否更改了topView
    CGFloat _cellHeight;//自定义单元格高度
}
//view
@property(nonatomic,strong)GavatarView *topImageView;//topImageView
@property(nonatomic,strong)GavatarView *userFaceView;//头像
@property(nonatomic,strong)UIView *picsView;//文章图片View
@property(nonatomic,strong)UIView *zhuanWenzhangView;//转载文章的灰色View
@property(nonatomic,strong)UIView *zhuanPicsView;//转载文章的图片的View
/**
 zking
 */
@property(nonatomic,strong)UIImageView *tempImageView;

/**
end
 */

//label
@property(nonatomic,strong)UILabel *gexinglabel;//个性签名
@property(nonatomic,strong)UILabel *nameLabel;//用户名
@property(nonatomic,strong)UILabel *MonthTimeLabel;//时间月
@property(nonatomic,strong)UILabel *DayTimeLabel;//时间日
@property(nonatomic,strong)UILabel *DayTimeLabel1;//时间日1
@property(nonatomic,strong)UILabel *WenZhangContent;//文章内容

//判断
@property(nonatomic,assign)BOOL isChangeTopViewImage;//是否更改了顶部背景图
@property(nonatomic,strong)UIImage *changeTopImage;//用户修改后的topImage



//好友的足迹
@property(nonatomic,assign)BOOL isHaoyou;//好友的足迹






//加载 row = 0 View
-(CGFloat)loadRow0CutomViewWithModel:(FBCirclePersonalModel*)theModel;

//加载从 row = 1开始的动态文章视图
-(CGFloat)loadCutomViewWithNetData:(NSArray *)sameTimeWenZhangArray indexPath:(NSIndexPath*)theIndexPath;




@end
