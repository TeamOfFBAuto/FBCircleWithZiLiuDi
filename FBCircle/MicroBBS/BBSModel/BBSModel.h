//
//  BBSModel.h
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
/**
 *  论坛分类
 */
@interface BBSModel : BaseModel
@property(nonatomic,retain)NSString *id;
@property(nonatomic,retain)NSString *classname;
@property(nonatomic,retain)NSString *classpic;

@end
