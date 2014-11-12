//
//  NSString+MyChatViewCell.m
//  FBCircle
//
//  Created by soulnear on 14-5-20.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "NSString+MyChatViewCell.h"

@implementation NSString (MyChatViewCell)

- (NSString *)trimWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSUInteger)numberOfLines
{
    return [self componentsSeparatedByString:@"\n"].count + 1;
}

@end
