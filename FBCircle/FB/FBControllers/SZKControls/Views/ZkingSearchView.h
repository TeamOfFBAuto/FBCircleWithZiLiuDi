//
//  ZkingSearchView.h
//  FBCircle
//
//  Created by 史忠坤 on 14-5-16.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZkingSearchViewBloc)(NSString *strSearchText,int tag);


@interface ZkingSearchView : UIView<UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic,strong)UITextField *aSearchField;

@property(nonatomic,strong)UIImageView *searchLogo;

@property(nonatomic,strong)UIImageView *searchBG;

@property(nonatomic,strong)UIImage *imgshortbg;

@property(nonatomic,strong)UIImage *imglongbg;


@property(nonatomic,strong)UIButton *cancelButton;



@property(nonatomic,copy)ZkingSearchViewBloc mybloc;


- (id)initWithFrame:(CGRect)frame imgBG:(UIImage *) bgimg shortimgbg:(UIImage*)theimgShort imgLogo:(UIImage *)logoimg  placeholder:(NSString *)_placeholder ZkingSearchViewBlocs:(ZkingSearchViewBloc)_bloc;

@end
