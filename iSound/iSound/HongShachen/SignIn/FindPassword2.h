//
//  FindPassword2.h
//  iSound
//
//  Created by Jumax.R on 13-12-11.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLoginTag 2389
#define kResetPsd 12378

@interface FindPassword2 : UIViewController<RequestDelegate,UIAlertViewDelegate>
{
    IBOutlet UITextField *psdField;
}

@property (nonatomic, copy) NSString *user_name;

@end
