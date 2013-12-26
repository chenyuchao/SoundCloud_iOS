//
//  SoundSaved.h
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-3.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADLabelView.h"
#import "UserGroup.h"
#import "PreViewController.h"
#import <AVFoundation/AVFoundation.h>

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@protocol SoundSavedDelegate <NSObject>

@optional

- (void)backToRecord;

@end

@interface SoundSaved : UIViewController<RequestDelegate,
                                        UIActionSheetDelegate,
                                        UINavigationControllerDelegate,
                                        UIImagePickerControllerDelegate,
                                        UIAlertViewDelegate,
                                        PreViewControllerDelegate,
                                        UITextFieldDelegate,
                                        ADLabelViewDelegate,
                                        AVAudioPlayerDelegate,
                                        UserGroupDelegate,CLLocationManagerDelegate,MKMapViewDelegate>
{
    IBOutlet UIButton *locationBtn;
    IBOutlet UIButton *cameraBtn;
    IBOutlet UIView   *bgView;
    IBOutlet UIButton *pubBtn;
    IBOutlet UITextField  *biaotiField;
    IBOutlet UITextField  *shareField;
    IBOutlet UIButton *palyBtn;
    IBOutlet UIScrollView *tagScrollView;
    
    UIButton *finishButton;
    //79 25
    NSInteger showIndex;
    NSMutableArray *imageBtnArray;
    NSMutableArray *imagesArray;
    
    IBOutlet UIView *gongkaiView;
    
    AVAudioPlayer *audioPlayer;
    
    NSTimer *playTimer;
    
    CLLocationManager *locationManager;
    CLGeocoder *myGeocoder;
}

@property (nonatomic, assign) id <SoundSavedDelegate> delegate;

@property (nonatomic) BOOL comeFromUserCenter;
@property (nonatomic) NSInteger willFabuIndex;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *recordPath;
@property (nonatomic, copy) NSString *curCity;

@property (nonatomic, copy) NSString *tagsSelected;

@end
