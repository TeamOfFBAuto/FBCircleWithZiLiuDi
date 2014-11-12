//
//  GBMKPointAnnotation.h
//  FBCircle
//
//  Created by gaomeng on 14-8-20.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BMKShape.h"

@interface GBMKPointAnnotation : BMKShape
{
	@package
    CLLocationCoordinate2D _coordinate;
}
///该点的坐标
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property(nonatomic,strong)NSString *phone;//电话

@property(nonatomic,strong)NSString *owner;//救援队联系人

-(NSString *)phone;
-(NSString *)owner;

@end
