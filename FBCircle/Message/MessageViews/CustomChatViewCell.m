//
//  CustomChatViewCell.m
//  FBCircle
//
//  Created by soulnear on 14-5-20.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "CustomChatViewCell.h"



#define kMarginTop 8.0f
#define kMarginBottom 4.0f
#define kPaddingTop 4.0f
#define kPaddingBottom 8.0f
#define kBubblePaddingRight 35.0f
#define image_width 81.0f
#define image_height 70.0f
#define kJSAvatarSize 35.0f




@implementation CustomChatViewCell
@synthesize timestampLabel = _timestampLabel;
@synthesize avatarImageView = _avatarImageView;
@synthesize background_imageView = _background_imageView;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)loadAllViewsWith:(ChatModel *)theModel WithType:(MyChatViewCellType)theType WithOtherHeaderImage:(NSString *)theImage
{
    CGPoint point = [self returnHeightWithArray:[ZSNApi stringExchange:theModel.msg_message] WithType:theType];
    
    UIImage * image = [UIImage imageNamed:theType == MyChatViewCellTypeOutgoing ?@"duihua2-66_82.png":@"duihua1-66_82.png"];
    
    _background_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(theType == MyChatViewCellTypeOutgoing?(320 - point.x - 75):55,34,point.x+20,point.y+8)];
    _background_imageView.userInteractionEnabled = YES;
    _background_imageView.image = [image stretchableImageWithLeftCapWidth:30.f topCapHeight:30.f];
    [self.contentView addSubview:_background_imageView];
    
    
    self.timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(105,5,110,16)];
    self.timestampLabel.textAlignment = NSTextAlignmentCenter;
    self.timestampLabel.backgroundColor = [UIColor clearColor];
    self.timestampLabel.layer.cornerRadius = 8;
    self.timestampLabel.backgroundColor = [RGBCOLOR(245,245,245) colorWithAlphaComponent:0.8];
    self.timestampLabel.textAlignment = NSTextAlignmentCenter;
    self.timestampLabel.textColor = RGBCOLOR(125,123,124);
    
    
    NSString *str___=[NSString stringWithFormat:@"%@",theModel.date_now];
    
    if (str___.length==0||[str___ isEqualToString:@"(null)"]) {
        self.timestampLabel.text=[ZSNApi timechange1:theModel.date_now];
    }else{
        self.timestampLabel.text = [ZSNApi timechange1:theModel.date_now];
        
    }
    self.timestampLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.timestampLabel];
    
    [self loadHeadImageViewWithUrl:theType==MyChatViewCellTypeIncoming?theImage:[SzkAPI getUserFace] Style:theType];
    [self loadContentViewWithArray:[ZSNApi stringExchange:theModel.msg_message] WithType:theType];
}


-(void)loadHeadImageViewWithUrl:(NSString *)url Style:(MyChatViewCellType)type
{
    CGFloat avatarX = 10; //0.5f +5.5;
    
    if(type == MyChatViewCellTypeOutgoing)
    {
        avatarX = (self.contentView.frame.size.width - kJSAvatarSize - 10);
    }
    
    self.avatarImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(avatarX,
                                                                            33,
                                                                            kJSAvatarSize,
                                                                            kJSAvatarSize)];
    
    
    self.avatarImageView.layer.cornerRadius = 5;
    self.avatarImageView.layer.borderColor = (__bridge  CGColorRef)([UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1]);
    self.avatarImageView.layer.borderWidth =1.0;
    self.avatarImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.avatarImageView];
    
    [self.avatarImageView loadImageFromURL:url withPlaceholdImage:PERSONAL_DEFAULTS_IMAGE];
}



-(void)loadContentViewWithArray:(NSArray *)array WithType:(MyChatViewCellType)theType
{
    
    float theHeight = 0;
    
    float distance = 10;
    
    for (NSString * string in array)
    {
        if (string.length > 0)
        {
            if ([string rangeOfString:@"[img]"].length && [string rangeOfString:@"[/img]"].length)
            {
                NSString * url = [string stringByReplacingOccurrencesOfString:@"[img]" withString:@""];
                
                url = [url stringByReplacingOccurrencesOfString:@"[/img]" withString:@""];
                
                AsyncImageView * imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(theType ==MyChatViewCellTypeIncoming?12:7,theHeight?theHeight+distance:8,image_width,image_height)];
                
                imageView.delegate = self;
                
                imageView.backgroundColor = [UIColor clearColor];
                
                [imageView loadImageFromURL:url withPlaceholdImage:[UIImage imageNamed:@"url_image_loading.png"]];
                
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
                
                [_background_imageView addSubview:imageView];
                
                imageView.userInteractionEnabled = YES;
                
                theHeight += image_height;
                
            }else
            {
                
            /*
                NSString * clean_string = string;
                
                while ([clean_string rangeOfString:@"[url]"].length && [clean_string rangeOfString:@"[/url]"].length)
                {
                    NSString * theurl = [[clean_string substringToIndex:[clean_string rangeOfString:@"[/url]"].location] substringFromIndex:[clean_string rangeOfString:@"[url]"].location+5];
                    
                    clean_string = [clean_string stringByReplacingOccurrencesOfString:@"[url]" withString:[NSString stringWithFormat:@"<a href=\"%@\">",theurl]];
                    clean_string = [clean_string stringByReplacingOccurrencesOfString:@"[/url]" withString:@"</a>"];
                }
                
                
                CGRect content_frame = CGRectMake(theType ==MyChatViewCellTypeIncoming?12:7,theHeight?theHeight:6,200,50);
                
                RTLabel * content_label = [[RTLabel alloc] initWithFrame:content_frame];
                
                content_label.text = @"不错<>&";//[[ZSNApi FBImageChange:clean_string] stringByReplacingEmojiCheatCodesWithUnicode];
                
                content_label.textColor = theType==MyChatViewCellTypeIncoming?[UIColor whiteColor]:RGBCOLOR(3,3,3);
                
                content_label.font = [UIFont systemFontOfSize:14];
                
                content_label.lineBreakMode = NSLineBreakByCharWrapping;
                
                
                CGSize optimumSize = [content_label optimumSize];
                content_frame.size.height = optimumSize.height + 10;
                content_label.frame = content_frame;
                content_label.backgroundColor = [UIColor clearColor];
                [_background_imageView addSubview:content_label];
                theHeight = theHeight + optimumSize.height;
             */
                
                CGRect content_frame = CGRectMake(theType ==MyChatViewCellTypeIncoming?12:7,theHeight?theHeight:6,200,50);
                OHAttributedLabel * content_label = [[OHAttributedLabel alloc] initWithFrame:content_frame];
                content_label.textColor = theType==MyChatViewCellTypeIncoming?[UIColor whiteColor]:RGBCOLOR(3,3,3);
                content_label.font = [UIFont systemFontOfSize:14];
                [_background_imageView addSubview:content_label];
                
                [OHLableHelper creatAttributedText:[[ZSNApi decodeSpecialCharactersString:string] stringByReplacingEmojiCheatCodesWithUnicode] Label:content_label OHDelegate:self WithWidht:16 WithHeight:18 WithLineBreak:NO];
                
                theHeight = theHeight + content_label.frame.size.height;
            }
        }
    }
}



#pragma mark-计算高度


-(CGPoint)returnHeightWithArray:(NSArray *)array WithType:(MyChatViewCellType)theType
{
    float theWidth = 0;
    
    float theHeight = 0;
    
    for (NSString * string in array)
    {
        if (string.length > 0)
        {
            if ([string rangeOfString:@"[img]"].length && [string rangeOfString:@"[/img]"].length)
            {
                theWidth = theWidth>image_width+5?theWidth:image_width+5;
                
                theHeight = theHeight + image_height+5;
            }else
            {
                
                /*
                NSString * clean_string = string;
                
                while ([clean_string rangeOfString:@"[url]"].length && [clean_string rangeOfString:@"[/url]"].length)
                {
                    NSString * theurl = [[clean_string substringToIndex:[clean_string rangeOfString:@"[/url]"].location] substringFromIndex:[clean_string rangeOfString:@"[url]"].location+5];
                    
                    clean_string = [clean_string stringByReplacingOccurrencesOfString:@"[url]" withString:[NSString stringWithFormat:@"<a href=\"%@\">",theurl]];
                    clean_string = [clean_string stringByReplacingOccurrencesOfString:@"[/url]" withString:@"</a>"];
                }
                
                
                
                CGRect content_frame = CGRectMake(theType ==MyChatViewCellTypeIncoming?10:5,theHeight?theHeight:6,200,50);
                
                RTLabel * content_label = [[RTLabel alloc] initWithFrame:content_frame];
                
                content_label.text = [[ZSNApi FBImageChange:clean_string] stringByReplacingEmojiCheatCodesWithUnicode];
                                
                content_label.font = [UIFont systemFontOfSize:14];
                
                content_label.lineBreakMode = NSLineBreakByCharWrapping;
                
                CGSize optimumSize = [content_label optimumSize];
                
                content_frame.size.height = optimumSize.height + 10;
                
                content_label.frame = content_frame;
                
                theHeight = theHeight + optimumSize.height + 5;
                
                theWidth = optimumSize.width>theWidth?optimumSize.width:theWidth;
                if (optimumSize.width >= 190 || optimumSize.width == 0)
                {
                    theWidth = 200;
                }
                 */
                
                
                CGRect content_frame = CGRectMake(theType ==MyChatViewCellTypeIncoming?10:5,theHeight?theHeight:6,200,50);
                OHAttributedLabel * content_label = [[OHAttributedLabel alloc] initWithFrame:content_frame];
                content_label.textColor = theType==MyChatViewCellTypeIncoming?[UIColor whiteColor]:RGBCOLOR(3,3,3);
                content_label.font = [UIFont systemFontOfSize:14];
                
                [OHLableHelper creatAttributedText:[[ZSNApi decodeSpecialCharactersString:string] stringByReplacingEmojiCheatCodesWithUnicode] Label:content_label OHDelegate:self WithWidht:16 WithHeight:18 WithLineBreak:NO];
                
                theHeight = theHeight + content_label.frame.size.height;
                
                theWidth = content_label.frame.size.width>theWidth?content_label.frame.size.width:theWidth;
                if (content_label.frame.size.width >= 190 || content_label.frame.size.width == 0) {
                    theWidth = 200;
                }
            }
        }
    }
    if (theHeight>50&&theHeight<120)
    {
        theHeight=theHeight;
    }
    return CGPointMake(theWidth,theHeight+5);
}


-(NSString *)exchangeString:(NSString *)theString
{
    NSString * _text = [theString stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    RTLabelExtractedComponent *component = [RTLabel extractTextStyleFromText:_text paragraphReplacement:@"\n"];
    
    return component.plainText;
}


-(NSString *)replaceSpaceWithString:(NSString *)thestring
{
    
    while ([thestring rangeOfString:@"<img src="].length && [thestring rangeOfString:@"</img>"].length)
    {
        NSRange range1 = [thestring rangeOfString:@"<img src="];
        
        NSRange range2 = [thestring rangeOfString:@"</img>"];
        
        thestring = [thestring stringByReplacingCharactersInRange:NSMakeRange(range1.location,range2.location+6-range1.location) withString:@"n i"];
    }
        
    return thestring;
}


-(void)handleImageLayout:(AsyncImageView *)tag
{
    
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end





























