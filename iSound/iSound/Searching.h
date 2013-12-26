//
//  Searching.h
//  iSound
//
//  Created by Jumax.R on 13-9-28.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RenqiWang.h"
#import "Sound.h"
#import "GroupRanking.h"

#define kUPHeightTag 23479

@interface Searching : UIViewController <UITableViewDelegate,UITextFieldDelegate, UIActionSheetDelegate>
{
    UIView *indexView;
    NSArray *titleArray;
    UITextField *search;
    
    NSInteger selectedType;
    
    IBOutlet UIScrollView *mainTableView;
}

@end
