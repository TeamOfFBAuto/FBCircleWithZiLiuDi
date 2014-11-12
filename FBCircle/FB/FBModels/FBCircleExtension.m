//
//  FBCircleExtension.m
//  FBCircle
//
//  Created by soulnear on 14-6-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBCircleExtension.h"

@implementation FBCircleExtension
@synthesize extentsion_content = _extentsion_content;
@synthesize extentsion_image = _extentsion_image;
@synthesize extentsion_link = _extentsion_link;
@synthesize extentsion_title = _extentsion_title;



-(FBCircleExtension *)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    
    if (self)
    {
        self.extentsion_title = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ext_title"]];
                
        self.extentsion_content = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ext_content"]];
        
        self.extentsion_link = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ext_link"]];
        
        self.extentsion_image = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ext_image"]];
    }
    
    return self;
}




@end
