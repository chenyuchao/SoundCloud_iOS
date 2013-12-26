//
//  UIAddDescription.h
//  iSound
//
//  Created by Jumax.R on 13-11-13.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoSelector.h"
#import "ADLabelView.h"

enum {
    
    UpLoadHeader = 10,
    GetCityList,
    EditBaseInfo,
    UpdateBaseInfo,
    GetUserDescription
};

@interface UIAddDescription : UIViewController < UITextFieldDelegate,
                                                 UITableViewDataSource,
                                                 UITableViewDelegate,
                                                 UIImagePickerControllerDelegate,
                                                 UINavigationControllerDelegate,
                                                 UIActionSheetDelegate,
                                                 RequestDelegate,
                                                 DownloaderDelegate,
                                                 InfoSelectorDelegate,
                                                 ADLabelViewDelegate > {

    UITableView *tableView;
    UITextField *nameField;
    UITextField *signField;
    UIImageView *headView;
    BOOL isMySelf;
}

@property (nonatomic, copy) NSArray  *cityList;
@property (nonatomic, copy) NSString *shi;
@property (nonatomic, copy) NSString *sheng;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *tagText;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *userhead;
@property (nonatomic, retain) UIButton *rightButton;


- (void)setHeadWithUrl:(NSString *)url;
- (void)popViewController;
- (void)didFinish;

@end
