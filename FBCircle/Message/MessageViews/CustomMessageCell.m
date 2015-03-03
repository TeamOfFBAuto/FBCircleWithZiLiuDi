//
//  CustomMessageCell.m
//  FBCircle
//
//  Created by soulnear on 14-5-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "CustomMessageCell.h"

@implementation CustomMessageCell
@synthesize headImageView = _headImageView;
@synthesize NameLabel = _NameLabel;
@synthesize timeLabel = _timeLabel;
@synthesize contentLabel = _contentLabel;
@synthesize tixing_label = _tixing_label;




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}


-(void)setAllViewWithType:(int)type
{
    
    if (!_headImageView)
    {
        _headImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(10,10,40,40)];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.image = PERSONAL_DEFAULTS_IMAGE;
        _headImageView.layer.cornerRadius = 2;
        [self.contentView addSubview:_headImageView];
    }
    
    
    if (type == 0)
    {
        if (!_NameLabel)
        {
            _NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,6,DEVICE_WIDTH-150,20)];
            _NameLabel.font = [UIFont boldSystemFontOfSize:15];
            _NameLabel.backgroundColor = [UIColor clearColor];
            _NameLabel.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:_NameLabel];
        }else
        {
            _NameLabel.text = @"";
        }
        
        
        if (!_timeLabel)
        {
            _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-100,6,90,20)];
            _timeLabel.textAlignment = NSTextAlignmentRight;
            _timeLabel.backgroundColor = [UIColor clearColor];
            _timeLabel.font = [UIFont systemFontOfSize:11];
            _timeLabel.textColor = RGBCOLOR(166,166,166);
            [self.contentView addSubview:_timeLabel];
        }else
        {
            _timeLabel.text = @"";
        }
        
        
        if (!_contentLabel1)
        {
            _contentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(60,30,DEVICE_WIDTH-80,20)];
            _contentLabel1.textColor = RGBCOLOR(79,79,79);
            _contentLabel1.backgroundColor = [UIColor clearColor];
            _contentLabel1.font = [UIFont systemFontOfSize:14];
            _contentLabel1.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:_contentLabel1];
        }else
        {
            _contentLabel1.text = @"";
        }
        
        if (!_tixing_label)
        {
            _tixing_label = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-90,8,7,7)];
            _tixing_label.hidden = YES;
            _tixing_label.backgroundColor = [UIColor redColor];
            _tixing_label.layer.cornerRadius = 7/2;
            _tixing_label.center = CGPointMake(50,10);
            [self.contentView addSubview:_tixing_label];
        }
    }else
    {
        if (!_contentLabel)
        {
            _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,15,DEVICE_WIDTH-60,30)];
            _contentLabel.textColor = RGBCOLOR(79,79,79);
            _contentLabel.backgroundColor = [UIColor clearColor];
            _contentLabel.font = [UIFont boldSystemFontOfSize:15];
            _contentLabel.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:_contentLabel];
        }else
        {
            _contentLabel.text = @"";
        }
    }
}



-(void)setInfoWithType:(int)type withMessageInfo:(MessageModel *)info
{
    if (type == 0)
    {
        NSString * to_uid;
        
        if ([info.from_uid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:USERID]])
        {
            to_uid = info.to_uid;
            _NameLabel.text = info.to_username;
        }else
        {
            to_uid = info.from_uid;
            _NameLabel.text = info.from_username;
        }
        
        if (info.otherFaceImage.length > 0)
        {
            [_headImageView loadImageFromURL:info.otherFaceImage withPlaceholdImage:PERSONAL_DEFAULTS_IMAGE];
        }else
        {
            [self loadImageUrlWith:to_uid With:info];
        }
        
        
        _timeLabel.text = [ZSNApi timechange:info.date_now];
        
        _contentLabel1.text = [[self eidtMessageContent:info.from_message] stringByReplacingEmojiCheatCodesWithUnicode];
        
        
        NSString * user = USERID;
        
        NSString * userName;
        
        if ([user isEqualToString:info.from_uid])
        {
            userName = info.to_username;
        }else
        {
            userName = info.from_username;
        }
        
        if ([info.selfunread intValue] !=0)
        {
            _tixing_label.hidden = NO;
        }else
        {
            _tixing_label.hidden = YES;
        }
    }
}



-(void)loadImageUrlWith:(NSString *)theUid With:(MessageModel *)info
{
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:FBCIRCLE_PERSONAL_IMAGE_URL,theUid]]]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        
        if ([[allDic objectForKey:@"errcode"] intValue]==0)
        {
            NSArray * array = [allDic objectForKey:@"datainfo"];
            
            NSString * face = [[array objectAtIndex:0] objectForKey:@"face"];
            
            info.otherFaceImage = face;
            
            [_headImageView loadImageFromURL:face withPlaceholdImage:PERSONAL_DEFAULTS_IMAGE];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        
    }];
    
    [operation start];
}




//-(void)setInfoWithMessageInfo:(MessageModel *)info
//{//张少南
//    if ([info.from_uid isEqualToString:@"967897"])
//    {
//        [_headImageView loadImageFromURL:[ZSNApi returnUrl:info.to_uid] withPlaceholdImage:[UIImage imageNamed:@"touxiang.png"]];
//        
//        _NameLabel.text = info.to_username;
//        
//    }else
//    {
//        [_headImageView loadImageFromURL:[ZSNApi returnUrl:info.from_uid] withPlaceholdImage:[UIImage imageNamed:@"touxiang.png"]];
//        
//        _NameLabel.text = info.from_username;
//    }
//    
//    _timeLabel.text = [ZSNApi timechange:info.date_now];
//    
//    _contentLabel.text = [self eidtMessageContent:info.from_message];
//    
//    
//    NSString * user = @"967897";
//    
//    NSString * userName;
//    
//    if ([user isEqualToString:info.from_uid])
//    {
//        userName = info.to_username;
//    }else
//    {
//        userName = info.from_username;
//    }
//    
//    
//    if ([info.selfunread intValue] !=0)
//    {
//        _tixing_label.hidden = NO;
//    }else
//    {
//        _tixing_label.hidden = YES;
//    }
//}


-(NSString *)eidtMessageContent:(NSString *)message
{
    if ([message rangeOfString:@"[img]"].length && [message rangeOfString:@"[/img]"].length)
    {
        return @"[图片]";
    }
    
    if ([message rangeOfString:@"[url]"].length && [message rangeOfString:@"[/url]"].length)
    {
        return @"[链接]";
    }
    
    
    while ([message rangeOfString:@"&amp;"].length)
    {
        message = [message stringByReplacingOccurrencesOfString:@"&amp;" withString:@""];
    }
    
    while ([message rangeOfString:@"nbsp;"].length)
    {
        message = [message stringByReplacingOccurrencesOfString:@"nbsp;" withString:@""];
    }
    
    while ([message rangeOfString:@" "].length)
    {
        message = [message stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    return message;
}


- (void) willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    
    
    if (MY_MACRO_NAME)
    {
        return;
    }
    
    //UITableViewCellStateShowingDeleteConfirmationMask
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask)//删除状态
    {
        
        [UIView animateWithDuration:0.5 animations:^{
            //            self.timeLabel.frame = CGRectMake(160,5,90,20);
            self.timeLabel.hidden = YES;
            self.contentLabel.frame = CGRectMake(50,30,DEVICE_WIDTH-140,20);
        } completion:^(BOOL finished)
         {
             
         }];
        
        for (UIView *subview in self.subviews)
        {
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"])
            {
                //this is delete button
            }
            
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellContentView"])
            {
                //this is contentView
                for (UIView *sub in subview.subviews) {
                    if ([NSStringFromClass([sub class]) isEqualToString:@"UILabel"])
                    {
                        UILabel *subLabel = (UILabel *)sub;
                        if (subLabel.tag == 8) {
                            subLabel.hidden = YES;
                        }
                    }
                    if ([NSStringFromClass([sub class]) isEqualToString:@"UIImageView"])
                    {
                        UILabel *subImageView = (UILabel *)sub;
                        if (subImageView.tag == 11)
                        {
                            subImageView.hidden = YES;
                        }
                    }
                }
            }
        }
    }
    //UITableViewCellStateDefaultMask
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateDefaultMask)//普通状态
    {
        [UIView animateWithDuration:0.3 animations:^{
            //            self.timeLabel.frame = CGRectMake(220,5,90,20);
            self.timeLabel.hidden = NO;
            self.contentLabel.frame = CGRectMake(50,30,DEVICE_WIDTH-80,20);
        } completion:^(BOOL finished)
         {
             
         }];
        
        for (UIView *subview in self.subviews)
        {
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"])
            {
                //this is delete button
            }
            
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellContentView"])
            {
                //this is contentView
                for (UIView *sub in subview.subviews)
                {
                    if ([NSStringFromClass([sub class]) isEqualToString:@"UILabel"])
                    {
                        UILabel *subLabel = (UILabel *)sub;
                        if (subLabel.tag == 8)
                        {
                            subLabel.hidden = NO;
                        }
                    }
                    if ([NSStringFromClass([sub class]) isEqualToString:@"UIImageView"])
                    {
                        UILabel *subImageView = (UILabel *)sub;
                        if (subImageView.tag == 11)
                        {
                            subImageView.hidden = NO;
                        }
                    }
                }
            }
        }
    }
    
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



























