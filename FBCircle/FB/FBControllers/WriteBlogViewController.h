//
//  WriteBlogViewController.h
//  FBCircle
//
//  Created by soulnear on 14-5-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"
#import "ChooseCountryViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AFNetworking/AFNetworking.h>
#import <UIKit+AFNetworking.h>
#import <CoreLocation/CoreLocation.h>
#import "WritePreviewDeleteViewController.h"
#import "ASIFormDataRequest.h"
#import "FBCircleModel.h"
#import "FBQuanAlertView.h"
#import "WeiBoFaceScrollView.h"

typedef enum{
    WriteBlogWithImagesAndContent = 0,
    WriteBlogWithContent = 1
}WriteBlogType;


@protocol WriteBlogViewControllerDelegate <NSObject>

-(void)upLoadBlogWith:(FBCircleModel *)model;

@end




@interface WriteBlogViewController : MyViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,ASIHTTPRequestDelegate,expressionDelegate,ZActionSheetDelegate>
{
    UILabel * placeHolderLable;
    
    UIView * picturesView;
    
    CLLocationManager *locationManager;
    
    CLLocation *checkinLocation;
    
    float longitude;
    
    float lattitude;
    
    BOOL isShowLocation;
    
    NSString * area_string;
    
    
    
    UIAlertView *_alerSending;//发送中提示框
    
    UIAlertView * _alertSendError;//发送失败提示框
    
    FBQuanAlertView * myAlertView;
    
}

@property(nonatomic,assign)id<WriteBlogViewControllerDelegate>delegate;

@property(nonatomic,strong)NSString * titleName;

@property(nonatomic,strong)UITableView * myTableView;

@property(nonatomic,strong)NSMutableArray * selectedImageArray;

@property(nonatomic,strong)UITextView * myTextView;

@property(nonatomic,assign)BOOL isShowLocation;

@property(nonatomic,strong)UILabel * locationLabel;

@property(nonatomic,strong)NSMutableArray * allImageArray;

@property(nonatomic,strong)NSMutableArray * allAssesters;

@property(nonatomic,strong)NSMutableArray * TempAllImageArray;

@property(nonatomic,strong)NSMutableArray * TempAllAssesters;

@property(nonatomic,assign)WriteBlogType theType;

@end
