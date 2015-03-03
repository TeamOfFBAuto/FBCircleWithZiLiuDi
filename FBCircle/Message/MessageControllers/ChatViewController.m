//
//  ChatViewController.m
//  FBCircle
//
//  Created by soulnear on 14-5-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "ChatViewController.h"

#define image_width 81.0f
#define image_height 70.0f
#define INPUT_HEIGHT 44.0f


@interface ChatViewController ()
{
    CustomChatViewCell * test_cell;
    
    BOOL isUpDate;
}

@end

@implementation ChatViewController
@synthesize mytableView = _mytableView;
@synthesize theModel = _theModel;
@synthesize allCount = _allCount;
@synthesize currentPage = _currentPage;
@synthesize messageInfo = _messageInfo;
@synthesize data_array = _data_array;
@synthesize inputToolBarView = _inputToolBarView;
@synthesize theTouchView = _theTouchView;
@synthesize previousTextViewContentHeight = _previousTextViewContentHeight;
@synthesize otherHeaderImage = _otherHeaderImage;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        theTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(checkHaveNewMessage) userInfo:nil repeats:YES];
    }
    return self;
}


-(void)checkHaveNewMessage
{
    typeof(self) bself = self;
        
    [_theModel initHttpWithPage:1 WithMaxId:@"" WithToUid:_messageInfo.otheruid WithBlock:^(NSMutableArray *array,int count) {
        
        ChatModel * model1 = [array objectAtIndex:(array.count-1)];
        
        ChatModel * model2 = [bself.data_array objectAtIndex:(bself.data_array.count - 1)];
        
        if ([model1.msg_id intValue] > [model2.msg_id intValue]) {
            [bself setupWith:array WithCount:count];
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [theTimer invalidate];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    isUpDate = NO;
    
    self.titleLabel.text = self.messageInfo.othername;
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    _theModel = [[ChatModel alloc] init];
    
    _data_array = [NSMutableArray array];
    
    temp_count = 1;
    
    _currentPage = 1;
    
    
    _mytableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT-20-44-44) style:UITableViewStylePlain];
    
    self.mytableView.delegate = self;
    
    self.mytableView.dataSource = self;
    
    self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.mytableView.separatorInset = UIEdgeInsetsZero;
    
    [self.view addSubview:self.mytableView];
    
    typeof(self) bself = self;
    
    self.isLoading = YES;
    
    [_theModel initHttpWithPage:_currentPage WithMaxId:@"" WithToUid:_messageInfo.otheruid WithBlock:^(NSMutableArray *array,int count) {
        
        [bself setupWith:array WithCount:count];
        
    }];
    
    
    _inputToolBarView = [[ChatInputView alloc] initWithFrame:CGRectMake(0,DEVICE_HEIGHT-20-44-44,DEVICE_WIDTH,44)];
        
    _inputToolBarView.myTextView.delegate = self;
    
    _inputToolBarView.delegate = self;
    
    [self.view addSubview:_inputToolBarView];
    
    [_inputToolBarView.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}



#pragma mark--请求完数据


-(void)setupWith:(NSMutableArray *)array WithCount:(int)count
{
    self.data_array = [NSMutableArray arrayWithArray:array];

    self.isLoading = NO;
    
    self.allCount = count;
    
    [self.mytableView reloadData];
    
    if (_currentPage == 1)
    {
        [self scrollToBottomAnimated:NO];
    }else
    {
        [self.mytableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.data_array.count-historyPage inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
    
    historyPage = self.data_array.count;
}



#pragma mark-显示收回键盘

- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
    
    [self scrollToBottomAnimated:YES];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}


- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[ZSNApi animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = self.inputToolBarView.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;
                         if(inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;
                         NSLog(@"made yaosi a  ----  %f",inputViewFrameY);
                         self.inputToolBarView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                  inputViewFrameY,
                                                                  inputViewFrame.size.width,
                                                                  inputViewFrame.size.height);
                         UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                0.0f,
                                                                self.view.frame.size.height - self.inputToolBarView.frame.origin.y - INPUT_HEIGHT,
                                                                0.0f);
                         
                         self.mytableView.contentInset = insets;
                         self.mytableView.scrollIndicatorInsets = insets;
                         
                         
                         _theTouchView.frame = CGRectMake(0,0,DEVICE_WIDTH,self.inputToolBarView.frame.origin.y);
                     }
                     completion:^(BOOL finished) {
                     }];
}




- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.mytableView numberOfRowsInSection:0];
    
    if(rows > 0)
    {
        [self.mytableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                atScrollPosition:UITableViewScrollPositionBottom
                                        animated:NO];
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
                theWidth = theWidth>140?theWidth:140;
                theHeight = theHeight + image_height + 5;
            }else
            {
                
                NSString * tempString = string;
                
                while ([tempString rangeOfString:@"&nbsp;"].length )
                {
                    tempString = [tempString stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
                }
                
                //去除[url] [b] [i] [u]
                
                
                NSString * clean_string = tempString;
                
                
                while ([clean_string rangeOfString:@"[b]"].length || [clean_string rangeOfString:@"[i]"].length || [clean_string rangeOfString:@"[u]"].length || [clean_string rangeOfString:@"[url]"].length|| [clean_string rangeOfString:@"[url="].length|| [clean_string rangeOfString:@"]"].length)
                {
                    clean_string = [clean_string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
                    
                    clean_string = [clean_string stringByReplacingOccurrencesOfString:@"[b]" withString:@""];
                    clean_string = [clean_string stringByReplacingOccurrencesOfString:@"[/b]" withString:@""];
                    
                    clean_string = [clean_string stringByReplacingOccurrencesOfString:@"[i]" withString:@""];
                    clean_string = [clean_string stringByReplacingOccurrencesOfString:@"[/i]" withString:@""];
                    
                    clean_string = [clean_string stringByReplacingOccurrencesOfString:@"[u]" withString:@""];
                    clean_string = [clean_string stringByReplacingOccurrencesOfString:@"[/u]" withString:@""];
                    
                    clean_string = [clean_string stringByReplacingOccurrencesOfString:@"[url]" withString:@""];
                    clean_string = [clean_string stringByReplacingOccurrencesOfString:@"[/url]" withString:@""];
                    clean_string = [clean_string stringByReplacingOccurrencesOfString:@"[url" withString:@""];
                    clean_string = [clean_string stringByReplacingOccurrencesOfString:@"]" withString:@""];
                }
                
                
                UILabel * tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(theType ==MyChatViewCellTypeIncoming?15:5,theHeight,250,50)];
                
                CGPoint thePoint = [self LinesWidth:clean_string Label:tempLabel];
                
                theWidth = thePoint.x>theWidth?thePoint.x:theWidth;
                
                
                while ([clean_string rangeOfString:@"&"].length)
                {
                    clean_string = [clean_string stringByReplacingOccurrencesOfString:@"&" withString:@""];
                }
                
                theHeight += [ZSNApi theHeight:clean_string withHeight:240 WidthFont:[UIFont systemFontOfSize:16]];
            }
        }
    }
    
    return CGPointMake(theWidth,theHeight);
}

-(CGPoint)LinesWidth:(NSString *)string Label:(UILabel *)label
{
    
    float theLastWidth = 0;
    NSArray * array = [string componentsSeparatedByString:@"\n"];
    
    for (NSString * str in array)
    {
        CGSize titleSize = [str sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(240, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        theLastWidth = titleSize.width>theLastWidth?titleSize.width:theLastWidth;
    }
    
    
    CGSize titleSize = [string sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(240, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGPoint lastPoint;
    CGSize sz = [string sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT,40)];
    CGSize linesSz = [string sizeWithFont:label.font constrainedToSize:CGSizeMake(240, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    
    if(sz.width <= linesSz.width) //判断是否折行
    {
        lastPoint = CGPointMake(label.frame.origin.x + sz.width,linesSz.height);
    }else
    {
        lastPoint = CGPointMake(label.frame.origin.x + (int)sz.width % (int)linesSz.width,titleSize.height+((titleSize.height/19)-1)*3);
    }
    
    lastPoint = CGPointMake(theLastWidth,lastPoint.y);
    
    return lastPoint;
}


-(float)returnCellHeightWith:(int)index
{
    ChatModel * info = [self.data_array objectAtIndex:index];
    
    MyChatViewCellType theType;
    if ([info.from_username isEqualToString:info.to_username])
    {
        theType = MyChatViewCellTypeOutgoing;
    }else
    {
        theType = MyChatViewCellTypeIncoming;
    }
    
    if (!test_cell)
    {
        test_cell = [[CustomChatViewCell alloc] init];
    }
    
    
    CGPoint point = [test_cell returnHeightWithArray:[ZSNApi stringExchange:info.msg_message] WithType:theType];
    
    return point.y < 40? 50+25:point.y + 50;
}


#pragma mark-UITableViewDelegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_data_array.count < self.allCount) {
        return _data_array.count + 1;
    }else
    {
        return _data_array.count;
    }
    
    return _data_array.count<self.allCount?(_data_array.count+1):_data_array.count;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.data_array.count < self.allCount) {
        if (indexPath.row == 0) {
            return 30;
        }else
        {
            return [self returnCellHeightWith:indexPath.row-1];
        }
    }else
    {
        return [self returnCellHeightWith:indexPath.row];
    }    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = @"cell";
    
    CustomChatViewCell * cell = (CustomChatViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[CustomChatViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //        cell.delegate = self;
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView * view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    BOOL isShow = self.data_array.count < self.allCount;
    
    
    if (indexPath.row==0 && isShow) {
        
        UIActivityIndicatorView * activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,30)];
        
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        [activityIndicatorView startAnimating];
        
        [cell addSubview:activityIndicatorView];
    }else
    {
        
        
        if (self.data_array.count>0)
        {
            ChatModel * info = [self.data_array objectAtIndex:isShow?(indexPath.row-1):indexPath.row];
            
            MyChatViewCellType theType;
            //张少南
            if ([info.from_uid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:USERID]])
            {
                theType = MyChatViewCellTypeOutgoing;
            }else
            {
                theType = MyChatViewCellTypeIncoming;
            }
            
            [cell loadAllViewsWith:info WithType:theType WithOtherHeaderImage:self.otherHeaderImage];
        }
    }
    return cell;
}


#pragma mark-UIScrollViewDelegate


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.mytableView && scrollView.contentOffset.y<30 && !self.isLoading && self.data_array.count != self.allCount)
    {
        _currentPage++;
        
        self.isLoading = YES;
        
        //        ChatModel * model = [self.data_array objectAtIndex:0];
        
        __weak typeof(self) bself = self;
        
        [_theModel initHttpWithPage:_currentPage WithMaxId:@"" WithToUid:_messageInfo.otheruid WithBlock:^(NSMutableArray *array, int count) {
            
            [bself setupWith:array WithCount:count];
            
        }];
    }
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}


#pragma mark-touches


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _theTouchView.hidden = YES;
    [self.inputToolBarView.myTextView resignFirstResponder];
}


#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    
    if (!_theTouchView)
    {
        _theTouchView = [[UIView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,self.inputToolBarView.frame.origin.y)];
        
        _theTouchView.backgroundColor = [UIColor clearColor];
        
        [self.view bringSubviewToFront:_theTouchView];
        
        [self.view addSubview:_theTouchView];
    }else
    {
        _theTouchView.hidden = NO;
    }
    
    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound )
    {
        return YES;
    }
    
    [self sendMessageToSomeBodyWith:txtView.text];
    
    [txtView resignFirstResponder];
    
    return NO;
}


- (void)textViewDidChange:(UITextView *)textView
{
    
    if (!temp_textView)
    {
        temp_textView = [[UITextView alloc] initWithFrame:CGRectMake(0,0,textView.frame.size.width,textView.frame.size.height)];
        
        temp_textView.font = [UIFont systemFontOfSize:15];
    }
    
    temp_textView.text = textView.text;
    
    CGFloat height = [temp_textView sizeThatFits:CGSizeMake(textView.frame.size.width,CGFLOAT_MAX)].height;
    CGFloat textViewContentHeight = textView.contentSize.height;
    
    self.previousTextViewContentHeight = height - textViewContentHeight;
    
    int count = 1;
    
    if (height > 34)
    {
        count = ((height-34)/18)+1;
    }
    
    
    float theheight = (count-temp_count)*18;
    
    if (textView.text.length == 0)
    {
        theheight = 0;
        count = 1;
    }
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         
                         if (count > 6)
                         {
                             [self.inputToolBarView adjustTextViewHeightBy:count WihtHeight:0];
                             
                             return ;
                         }else
                         {
                             if (count == 6 && theheight < 0)
                             {
                                 return;
                             }
                             
                             CGRect inputViewFrame = self.inputToolBarView.frame;
                             
                             self.inputToolBarView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - theheight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + theheight);
                             [self.inputToolBarView adjustTextViewHeightBy:count WihtHeight:theheight];
                         }
                     }
                     completion:^(BOOL finished) {
                         
                         
                     }];
    
    
    temp_count = count;
    
    
//    self.inputToolBarView.sendButton.enabled = ([textView.text trimWhitespace].length > 0);
}



#pragma mark-ChatInputViewDelegate

-(void)sendMessageToSomeBodyWith:(NSString *)content
{
    if (self.inputToolBarView.myTextView.text.length == 0)
    {
        return;
    }
    
    if (isUpDate)
    {
        return;
    }
    
    
    isUpDate = YES;
    
    self.inputToolBarView.sendButton.userInteractionEnabled = NO;
    
    ChatModel * info = [[ChatModel alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *string_date___=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
    
    info.date_now =string_date___ ;
    
    NSString * myUid = [NSString stringWithFormat:@"%@",[SzkAPI getUid]];
    
    if (![[NSString stringWithFormat:@"%@",self.messageInfo.to_uid] isEqualToString:myUid])
    {
        info.to_uid = self.messageInfo.to_uid;
        info.to_username = self.messageInfo.to_username;
        info.from_username = [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME];
        info.from_uid = myUid;
    }else
    {
        info.to_uid = self.messageInfo.from_uid;
        info.to_username = self.messageInfo.from_username;
        info.from_uid = myUid;
        info.from_username = [SzkAPI getUsername];
    }
    /**
     *  在这里改
     */
    info.msg_message = [content trimWhitespace];
    
    /**
     *  end
     */
    
    __weak typeof(self) bself = self;
    
    info.to_username=self.title;
    [_theModel sendMessageWith:info WithCompletionBlock:^(ASIFormDataRequest *operation) {
        
        [bself.data_array addObject:info];
        
        [bself finnishendsend2];
        
        bself.inputToolBarView.sendButton.userInteractionEnabled = YES;
        
        isUpDate = NO;
        
    } WithFaildBlock:^(ASIFormDataRequest *operation, NSString *error) {
        bself.inputToolBarView.sendButton.userInteractionEnabled = YES;
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:error message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alertView show];
        
        isUpDate = NO;
    }];
}

-(void)finnishendsend2{
    self.inputToolBarView.frame = CGRectMake(0,DEVICE_HEIGHT-20-44-44,DEVICE_WIDTH,44);
    self.inputToolBarView.myTextView.frame = CGRectMake(17,6,DEVICE_WIDTH-72,32);
    [self.inputToolBarView.myTextView setText:@""];
    [self textViewDidChange:self.inputToolBarView.myTextView];
    [self.mytableView reloadData];
    [self scrollToBottomAnimated:NO];
    
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
