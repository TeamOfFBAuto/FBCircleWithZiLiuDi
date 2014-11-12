//
//  FBCircleExtension.h
//  FBCircle
//
//  Created by soulnear on 14-6-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBCircleExtension : NSObject
{
    
}


@property(nonatomic,strong)NSString * extentsion_title;

@property(nonatomic,strong)NSString * extentsion_content;

@property(nonatomic,strong)NSString * extentsion_image;

@property(nonatomic,strong)NSString * extentsion_link;



-(FBCircleExtension *)initWithDictionary:(NSDictionary *)dic;




@end
