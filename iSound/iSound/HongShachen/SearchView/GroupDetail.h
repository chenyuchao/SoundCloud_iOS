//
//  GroupDetail.h
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-17.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupMenber.h"

#define kGroupDetail 79824
#define kDeleteGroup 13726
#define kAppGroupTag 82734
#define kLogoutGroup 124387
#define kXXXXXTag 129467

@interface GroupDetail : UIViewController<RequestDelegate,DownloaderDelegate,UIAlertViewDelegate>
{
    IBOutlet UIImageView *headView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *peopleLabel;
    IBOutlet UILabel *masterLabel;
    IBOutlet UITextView *textView;
    IBOutlet UIButton *rqBtn;
}

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSDictionary *groupDict;

@end
