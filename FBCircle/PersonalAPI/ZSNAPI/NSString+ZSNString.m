//
//  NSString+ZSNString.m
//  FBCircle
//
//  Created by soulnear on 14-11-12.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "NSString+ZSNString.h"
#import <objc/runtime.h>
static const void *IndieBandNameKey = &IndieBandNameKey;

@implementation NSString (ZSNString)
@dynamic myDic;


- (NSMutableDictionary *)myDic {
    return objc_getAssociatedObject(self,IndieBandNameKey);
}

- (void)setMyDic:(NSMutableDictionary *)myDic
{
    objc_setAssociatedObject(self, IndieBandNameKey,myDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
