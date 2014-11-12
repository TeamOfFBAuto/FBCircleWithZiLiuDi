//
//  MyImagePickViewController.m
//  FBCircle
//
//  Created by soulnear on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "MyImagePickViewController.h"
#import "TakePhotoView.h"

@interface MyImagePickViewController ()

@end

@implementation MyImagePickViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    self.navigationController.navigationBarHidden = YES;
    
//    self.sourceType = UIImagePickerControllerSourceTypeCamera;
//    
//    self.showsCameraControls = NO;
//    
//    self.allowsEditing = YES;
    
    
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    UIImagePickerController * pickerC = [[UIImagePickerController alloc] init];
    
    __weak typeof(self) bself = self;
    
    TakePhotoView * view = [[TakePhotoView alloc] initWithFrame:CGRectMake(0,0,320,(iPhone5?568:480)) WithBlock:^(int index) {
        
        switch (index) {
            case 0://拍照
            {
                
                [pickerC takePicture];
            }
                break;
            case 1://关闭相机
            {
                
                [pickerC dismissViewControllerAnimated:YES completion:NULL];
            }
                break;
                
            default:
                break;
        }
        
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        pickerC.modalPresentationStyle = UIModalPresentationFullScreen;
        pickerC.delegate = self;
        pickerC.allowsEditing = YES;
        pickerC.sourceType = sourceType;
        pickerC.showsCameraControls = NO;
        pickerC.cameraOverlayView = view;
        
        self.navigationController.navigationBarHidden = YES;
        
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        
        [self presentViewController:pickerC animated:NO completion:nil];
    }
    else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}


-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    
    
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    
    
    
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
