//
//  SoundSaved.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-3.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "SoundSaved.h"
#import "AppDelegate.h"
@interface SoundSaved ()

@end

@implementation SoundSaved

@synthesize recordPath;
@synthesize group_id;
@synthesize curCity;
@synthesize delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imageBtnArray = [[NSMutableArray alloc] init];
    imagesArray   = [[NSMutableArray alloc] init];
    
    if (!IOS7)
    {
        CGRect frame = bgView.frame;
        frame.origin.y = -20;
        bgView.frame = frame;
    }
    self.title = @"发布";
    self.group_id = @"";
    self.curCity = @"未知";
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(0, 0, 28, 28);
    [returnButton addTarget:self
                     action:@selector(popViewController)
           forControlEvents:UIControlEventTouchUpInside];
    [returnButton setImage:[UIImage imageNamed:@"return"]
                  forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = CUSTOMVIEW(returnButton);
    
    finishButton = [[UIButton alloc] init];
    finishButton.frame = CGRectMake(0, 0, 28, 28);
    [finishButton addTarget:self
                     action:@selector(save)
           forControlEvents:UIControlEventTouchUpInside];
    [finishButton setImage:[UIImage imageNamed:@"finishBtn"]
                  forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = CUSTOMVIEW(finishButton);
    
    playTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f
                                                 target:self
                                               selector:@selector(updatePlayState)
                                               userInfo:nil
                                                repeats:YES];
    
    [playTimer setFireDate:[NSDate distantFuture]];

    // 初始化位置管理器
    if (![CLLocationManager locationServicesEnabled])
    {
        UIAlertView *locationServiceAlert = [[UIAlertView alloc] initWithTitle:nil message:@"定位不可用" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [locationServiceAlert show];
    }
    else
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (bgView.frame.origin.y != 0)
    {
        [UIView animateWithDuration:0.3 animations:^
         {
             CGRect frame = bgView.frame;
             frame.origin.y = 0;
             bgView.frame = frame;
         }];
    }
}

- (void)startShiting
{
    [playTimer setFireDate:[NSDate distantPast]];
    [palyBtn setImage:LoadImage(@"SoundSavedZT", @"png") forState:UIControlStateNormal];
}

- (void)stopShiting
{
    
    [playTimer setFireDate:[NSDate distantFuture]];
    [palyBtn setImage:LoadImage(@"SoundSavedST", @"png") forState:UIControlStateNormal];
}

#pragma mark - MKReverseGeocoderDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             self.curCity = placemark.administrativeArea;
             [locationBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
             [locationBtn setTitle:curCity forState:UIControlStateNormal];
             [locationBtn setImage:nil forState:UIControlStateNormal];
         }
         else if (error == nil && [array count] == 0)
         {
             [locationBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
             [locationBtn setTitle:@"未知" forState:UIControlStateNormal];
             [locationBtn setImage:nil forState:UIControlStateNormal];
             
             [MTool showAlertViewWithMessage:@"定位失败"];
         }
         else if (error != nil)
         {
             [locationBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
             [locationBtn setTitle:@"未知" forState:UIControlStateNormal];
             [locationBtn setImage:nil forState:UIControlStateNormal];
             
             [MTool showAlertViewWithMessage:@"定位失败"];
         }
     }];
}


#pragma mark - xib

- (IBAction)dingwei
{
    locationBtn.selected = !locationBtn.selected;
    
    if (locationBtn.selected)
    {
        [locationManager startUpdatingLocation];
        
        if (![curCity isEqualToString:@"未知"])
        {
            [locationBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [locationBtn setTitle:curCity forState:UIControlStateNormal];
            [locationBtn setImage:nil forState:UIControlStateNormal];
        }
    }
    else
    {
        [locationBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [locationBtn setTitle:nil forState:UIControlStateNormal];
        [locationBtn setImage:LoadImage(@"SoundSavedTJDD", @"png") forState:UIControlStateNormal];
    }
    
    
}

- (IBAction)gotoGroup
{
    UserGroup *userGroup = [[UserGroup alloc] init];
    userGroup.ids = [group_id componentsSeparatedByString:@","];
    userGroup.userid = [[UserInfo standardUserInfo] user_id];
    userGroup.delegate = self;
    [self.navigationController pushViewController:userGroup animated:YES];
}

- (void)updatePlayState
{
    if (audioPlayer.currentTime >= audioPlayer.duration)
    {
        [audioPlayer stop];
        [self stopShiting];
    }
}

- (IBAction)gotoADLabel
{
    ADLabelView *adView = [[ADLabelView alloc] initWithNibName:@"AddTagForUser" bundle:nil];
    adView.aDelegate = self;
    [self.navigationController pushViewController:adView animated:YES];
}

- (IBAction)shiting:(UIButton *)button
{
    button.selected = !button.selected;
    NSLog(@"button = %@",button);
    if (button.selected)
    {
        
        if (!audioPlayer)
        {
            NSError *error = nil;
            
            
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:recordPath] error:&error];
            audioPlayer.delegate = self;
            audioPlayer.currentTime = 0.0f;
            NSLog(@"error = %@",error);
        }
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        [audioPlayer play];
        [self startShiting];
    }
    else
    {
        [audioPlayer pause];
        [self stopShiting];
    }
}

- (IBAction)gongkai:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (button.selected)
    {
        [button setImage:LoadImage(@"SoundSavedBGK", @"png") forState:UIControlStateNormal];
    }
    else
    {
        [button setImage:LoadImage(@"SoundSavedGK", @"png") forState:UIControlStateNormal];
    }
    
    if (pubBtn.selected && group_id.length < 1)
    {
        finishButton.enabled = NO;
    }
    else
    {
        finishButton.enabled = YES;
    }
    
    gongkaiView.hidden = button.selected;
}

- (IBAction)save
{
    if (biaotiField.text.length < 1)
    {
        [MTool showAlertViewWithMessage:@"您还没有填写标题"];
        return;
    }
    
    if (biaotiField.text.length > 12)
    {
        [MTool showAlertViewWithMessage:@"标题请勿超过12个字"];
        return;
    }
    
    if (pubBtn.selected && group_id.length < 1)
    {
        [MTool showAlertViewWithMessage:@"请选择群组"];
        return;
    }

   [[Request request] snedAudioWithTitle:biaotiField.text
                                    city:locationBtn.selected ? curCity : @"未知"
                                group_id:group_id
                               is_public:pubBtn.selected ? @"0" : @"1"
                               voice_tag:self.tagsSelected
                              imageArray:imagesArray
                               voicePath:recordPath
                                delegate:self];
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activity.frame = CGRectMake(0, 0, 30, 30);
    [activity startAnimating];
    self.navigationItem.rightBarButtonItem = CUSTOMVIEW(activity);
}

- (IBAction)popViewController
{
    
    if (self.comeFromUserCenter)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(backToRecord)])
        {
            [delegate backToRecord];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)downloadDidFail:(Request *)request WithError:(NSError *)error {

    [Custom messageWithString:@"网络连接超时"];
    self.navigationItem.rightBarButtonItem = CUSTOMVIEW(finishButton);
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result {

    if ([[result valueForKey:@"code"] intValue] != 200)
    {
        return;
    }
    
    if (self.comeFromUserCenter)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FABUAUDIO" object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadTableViewOfHome"
                                                        object:[NSString stringWithFormat:@"%d",self.willFabuIndex]];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UserGroupDelegate

- (void)didSelectedGroups:(NSString *)titles groupIDs:(NSString *)gids
{
    finishButton.enabled = YES;
    self.group_id = gids;
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    palyBtn.selected = NO;
    [self stopShiting];
    [playTimer setFireDate:[NSDate distantFuture]];
}

#pragma mark - ADLabelViewDelegate

- (void)backWithTags:(NSString *)tags names:(NSString *)names
{
    self.tagsSelected = tags;
    NSArray *array = [names componentsSeparatedByString:@","];
    [tagScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (names.length > 1)
    {
        for (NSInteger i = 0; i < [array count]; i ++)
        {
            CGFloat width  = 54*0.6;
            CGFloat height = 29*0.6;
            UIButton *tagBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * (width + 10) + 10, 6, width, height)];
            tagBtn.userInteractionEnabled = NO;
            [tagBtn setBackgroundImage:[UIImage imageNamed:@"selectedTag"] forState:UIControlStateNormal];
            [tagBtn setTitleColor:MainColor forState:UIControlStateNormal];
            tagBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
            [tagBtn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
            
            [tagScrollView addSubview:tagBtn];
            
            if (i == [array count] - 1)
            {
                tagScrollView.contentSize = CGSizeMake(tagBtn.frame.origin.x + tagBtn.frame.size.width,
                                                       tagScrollView.frame.size.height);
            }
        }
    }    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (iPhone5)
    {
        
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^
        {
            CGRect frame = bgView.frame;
            
            if (textField.tag == 100)
            {
                frame.origin.y = -65;
            }
            else if (textField.tag == 120)
            {
                frame.origin.y = -180;
            }
            bgView.frame = frame;
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^
     {
         CGRect frame = bgView.frame;
         frame.origin.y = 0;
         bgView.frame = frame;
     }];
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - PreViewControllerDelegate

- (void)preViewDeleteImageAtIndex:(NSInteger)deleteIndex
{
    [imagesArray removeObjectAtIndex:deleteIndex];
    
    UIButton *deleteBtn = (UIButton *)[imageBtnArray objectAtIndex:deleteIndex];
    [deleteBtn removeFromSuperview];
    
    [imageBtnArray removeObjectAtIndex:deleteIndex];
    
    for (NSInteger i = 0; i < [imageBtnArray count]; i ++)
    {
        UIButton *btn = [imageBtnArray objectAtIndex:i];
        btn.tag   = i;
        btn.frame = CGRectMake(72*i + 22, 71, 60, 60);
    }
    
    if ([imageBtnArray count] < 4)
    {
        cameraBtn.center = CGPointMake(72*[imageBtnArray count] + 22 + 30, cameraBtn.center.y);
        cameraBtn.hidden = NO;
    }
    else
    {
        cameraBtn.hidden = YES;
    }
}

#pragma mark -

#pragma mark --从手机相册读取图片或者拍照--

- (IBAction)changeUserHead
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选取图片来源.."
                                                             delegate:nil
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"相册",@"拍照", nil];
    
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
            
        case 0:
            [self setUserheadWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
            
        case 1:
            [self setUserheadWithSourceType:UIImagePickerControllerSourceTypeCamera];
            break;
 
        default:
            
            break;
    }
}


- (void)setUserheadWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if (sourceType == UIImagePickerControllerSourceTypeCamera &&
        
        ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"没有发现摄像头哦,亲,是否从相册选取照片"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消", nil];
        alert.tag = 101;
        [alert show];
        
        return;
    }

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate      = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType    = sourceType;
    [self presentModalViewController:imagePicker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image.size.width > 640 && image.size.height > 640)
    {
        image = [Custom scaleToSize:[info objectForKey:UIImagePickerControllerEditedImage]
                         targetSize:CGSizeMake(640, 640)];
    }
    UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(72*[imageBtnArray count] + 22, 10, 60, 60)];
    imageBtn.tag = [imageBtnArray count];
    imageBtn.layer.borderWidth = 1;
    imageBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [imageBtn setImage:image forState:UIControlStateNormal];
    [imageBtn addTarget:self
                 action:@selector(imageBtnPressed:)
       forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:imageBtn];
    
    [imageBtnArray addObject:imageBtn];
    [imagesArray addObject:image];

    if ([imageBtnArray count] < 4)
    {
        cameraBtn.center = CGPointMake(72*[imageBtnArray count] + 22 + 30, cameraBtn.center.y);
        cameraBtn.hidden = NO;
    }
    else
    {
        cameraBtn.hidden = YES;
    }
    
//    [self performSelector:@selector(saveImage:)
//               withObject:info
//               afterDelay:0.5];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}
/*
- (void)saveImage:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if(image)
    {
        NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/tmp"];
        
        filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.png",(long)[[NSDate date] timeIntervalSince1970]]];
        BOOL state = [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];

        if (state)
        {
//            for (NSInteger i = 0; i < 4; i ++)
            {
                UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(72*[imageBtnArray count] + 22, 10, 60, 60)];
                imageBtn.tag = [imageBtnArray count];
                imageBtn.layer.borderWidth = 1;
                imageBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
                [imageBtn setImage:image forState:UIControlStateNormal];
                [imageBtn addTarget:self
                             action:@selector(imageBtnPressed:)
                   forControlEvents:UIControlEventTouchUpInside];
                [bgView addSubview:imageBtn];
                
                [imageBtnArray addObject:imageBtn];
                [imagesArray addObject:filePath];
                
                if ([imageBtnArray count] < 4)
                {
                    cameraBtn.center = CGPointMake(72*[imageBtnArray count] + 22 + 30, cameraBtn.center.y);
                    cameraBtn.hidden = NO;
                }
                else
                {
                    cameraBtn.hidden = YES;
                }
            }
        }
    }
}
*/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101)
    {
        if (buttonIndex == 0)
        {
            [self setUserheadWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }
}

- (void)imageBtnPressed:(UIButton *)button
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [imagesArray count]; i ++)
    {
        UIImage *image = [[imagesArray objectAtIndex:i] imageForState:UIControlStateNormal];

        if (image)
        {
            [tmpArray addObject:image];
        }
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    PreViewController *preViewController = [[PreViewController alloc] init];
    preViewController.pDelegate  = self;
    preViewController.shotImage  = [appDelegate.window screenshot];
    preViewController.showIndex  = button.tag;
    preViewController.imageArray = tmpArray;
    
    [self presentViewController:preViewController animated:NO completion:nil];
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
