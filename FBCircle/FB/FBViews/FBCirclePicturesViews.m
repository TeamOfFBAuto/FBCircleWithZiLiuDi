//
//  FBCirclePicturesViews.m
//  FBCircle
//
//  Created by soulnear on 14-5-21.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBCirclePicturesViews.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation FBCirclePicturesViews
@synthesize isReply = _isReply;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setImageUrls:(NSString *)theUrl withSize:(int)size isjuzhong:(BOOL)juzhong
{
    NSArray * array = [[NSArray alloc] init];
    
    array = [theUrl componentsSeparatedByString:@"|"];
    
    int row = 0;
    
    int number = 0;
    
    
    int iii = 9;
    
    if (array.count < 9)
    {
        iii = array.count;
    }
    
    for (int i = 0;i < array.count;i++)
    {
        AsyncImageView * imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake((size+3)*number,(size + 3)*row,size,size)];
        
        if (juzhong)
        {
            if (array.count == 1)
            {
                imageView.frame = CGRectMake(self.frame.size.width/2-size/2,(size + 3)*row,size,size);
            }else if(array.count == 2)
            {
                imageView.frame = CGRectMake((self.frame.size.width-size*2-4)/2 + (size+3)*number,(size + 3)*row,size,size);
            }
        }
        
        imageView.tag = i+1;
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        NSMutableString * urlString = [NSMutableString stringWithFormat:@"%@",[array objectAtIndex:i]];
        
        NSLog(@"urlString ----  %@",urlString);
        
        [imageView loadImageFromURL:urlString withPlaceholdImage:[UIImage imageNamed:@"bigImagesPlaceHolder.png"]];
        
        [self addSubview:imageView];
        number++;
        
        if (i%3 >= 2)
        {
            row++;
            number = 0;
        }
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
        [imageView addGestureRecognizer:tap];
    }
    
}



-(void)setthebloc:(FBCirclePicturesViewsBlocs)thechuanbloc{

    _mybloc=thechuanbloc;
}


-(void)doTap:(UITapGestureRecognizer *)sender
{
    
    _mybloc(sender.view.tag);

    
}

#pragma mark-zkingChangge
-(void)setimageArr:(NSArray *)imgarr withSize:(int)size isjuzhong:(BOOL)juzhong
{
    NSArray * array = [[NSArray alloc] init];
    
    array = imgarr;
    
    int row = 0;
    
    int number = 0;
    
    
    int iii = 9;
    
    if (array.count < 9)
    {
        iii = array.count;
    }
    
    
    for (int i = 0;i < array.count;i++)
    {
        AsyncImageView * imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake((size+3)*number,(size + 3)*row,size,size)];
        
        if (juzhong)
        {
            if (array.count == 1)
            {
                imageView.frame = CGRectMake(self.frame.size.width/2-size/2,(size + 3)*row,size,size);
            }else if(array.count == 2)
            {
                imageView.frame = CGRectMake((self.frame.size.width-size*2-4)/2 + (size+3)*number,(size + 3)*row,size,size);
            }
        }
        
        imageView.tag = i+1;
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor clearColor];
        
        
        if ([[array objectAtIndex:i] isKindOfClass:[UIImage class]])
        {
            imageView.image = [array objectAtIndex:i];
        }else
        {            
            NSMutableString * urlString = [NSMutableString stringWithFormat:@"%@",[array objectAtIndex:i]];
            [imageView loadImageFromURL:urlString withPlaceholdImage:FBCIRCLE_DEFAULT_IMAGE];
        }
        
        [self addSubview:imageView];
        
        number++;
        
        if (i%3 >= 2)
        {
            row++;
            number = 0;
        }
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
        [imageView addGestureRecognizer:tap];
    }    
}




//转换本地图片

-(void)exchangeLocationImageWith:(NSString *)url WithImageView:(AsyncImageView *)theImageView
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    NSURL *referenceURL = [NSURL URLWithString:url];
    __block UIImage *returnValue = nil;
    [library assetForURL:referenceURL resultBlock:^(ALAsset *asset)
     {
         //returnValue = [UIImage imageWithCGImage:[asset thumbnail]]; //Retain Added
         
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
             ALAssetRepresentation *assetRep = [asset defaultRepresentation];
             
             CGImageRef imgRef = [assetRep fullScreenImage];
             
             returnValue=[UIImage imageWithCGImage:imgRef
                                             scale:assetRep.scale
                                       orientation:(UIImageOrientation)assetRep.orientation];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 theImageView.image = returnValue;
             });
         });
     } failureBlock:^(NSError *error)
     {
         // error handling
     }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
