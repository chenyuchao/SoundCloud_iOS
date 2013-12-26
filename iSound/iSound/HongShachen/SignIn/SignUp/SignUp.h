//
//  SignUp.h
//  iSound
//
//  Created by MaoHeng Zhang on 13-10-24.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBaseController.h"

#define kSigninTag 234
#define kSignupTag 442

@interface SignUp : MBaseController
{
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *psdField;
    
    IBOutlet UIView *controlView;
}
@end
