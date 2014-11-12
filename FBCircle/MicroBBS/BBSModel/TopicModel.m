//
//  TopicModel.m
//  FBCircle
//
//  Created by lichaowei on 14-8-15.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "TopicModel.h"

@implementation TopicModel
-(id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [self setValuesForKeysWithDictionary:dic];
            
            if (self.title) {
                self.title = [ZSNApi decodeSpecialCharactersString:self.title];
            }
            
            if (self.sub_content) {
                self.sub_content = [ZSNApi decodeSpecialCharactersString:self.sub_content];
            }
            
            if (self.content) {
                self.content = [ZSNApi decodeSpecialCharactersString:self.content];
            }
            
        }
    }
    return self;
}
@end
